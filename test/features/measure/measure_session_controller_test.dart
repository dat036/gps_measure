import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/core/utils/id_generator.dart';
import 'package:gps_measurement/data/db/app_database.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';
import 'package:gps_measurement/features/measure/session/measure_session_controller.dart';
import 'package:gps_measurement/features/measure/session/measure_session_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/data.dart';

/// Fails `replacePoints` while [failing] is true.
class FlakyRepository extends DriftMeasurementRepository {
  FlakyRepository({
    required super.db,
    required super.photoStorage,
    required super.thumbnailStorage,
  });

  bool failing = false;

  @override
  Future<void> replacePoints(
    String id,
    List<MeasurePoint> points,
    MeasurementStats stats,
  ) async {
    if (failing) throw StateError('disk full');
    return super.replacePoints(id, points, stats);
  }
}

void main() {
  late AppDatabase db;
  late TempDirectories temp;
  late ProviderContainer container;
  late SharedPreferences prefs;

  const square = [
    GeoPoint(lat: 21, lng: 105),
    GeoPoint(lat: 21, lng: 105.001),
    GeoPoint(lat: 21.001, lng: 105.001),
    GeoPoint(lat: 21.001, lng: 105),
  ];

  ProviderContainer newContainer({List<Override> extra = const []}) {
    final c = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDirectoriesProvider.overrideWithValue(temp.dirs),
        appDatabaseProvider.overrideWithValue(db),
        imageCompressorProvider.overrideWithValue(FakeCompressor()),
        clockProvider.overrideWithValue(testClock()),
        idGeneratorProvider.overrideWithValue(SequentialIds()),
        ...extra,
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = newTestDatabase();
    temp = TempDirectories();
    container = newContainer();
  });

  tearDown(() async {
    await db.close();
    temp.dispose();
  });

  /// Opens a session and keeps it alive until the returned closer is called.
  Future<(MeasureSessionController, void Function())> open(
    ProviderContainer c, {
    MeasurementType type = MeasurementType.area,
    String? draftId,
  }) async {
    final provider = measureSessionControllerProvider(type, draftId);
    final sub = c.listen(provider, (_, _) {});
    await c.read(provider.future);
    return (c.read(provider.notifier), sub.close);
  }

  MeasureSessionState read(ProviderContainer c, {String? draftId}) => c
      .read(measureSessionControllerProvider(MeasurementType.area, draftId))
      .requireValue;

  Future<List<MeasurementSummaryLite>> drafts() async => [
    for (final s
        in await container
            .read(measurementRepositoryProvider)
            .watchDrafts()
            .first)
      (id: s.id, points: s.pointCount),
  ];

  test('no draft until the first point; autosave after 300 ms', () async {
    final (session, _) = await open(container);
    expect(await drafts(), isEmpty);

    session.addPointAt(square[0]);
    expect(read(container).pointCount, 1);
    expect(await drafts(), isEmpty); // debounced

    await Future<void>.delayed(const Duration(milliseconds: 400));
    final saved = await drafts();
    expect(saved, hasLength(1));
    expect(saved.single.points, 1);
    expect(read(container).measurementId, saved.single.id);
  });

  test(
    'a burst of edits creates one draft with every point in order',
    () async {
      final (session, _) = await open(container);
      square.forEach(session.addPointAt);
      await session.flushNow();
      final saved = await drafts();
      expect(saved, hasLength(1));
      final m = await container
          .read(measurementRepositoryProvider)
          .get(saved.single.id);
      expect(m!.points.map((p) => p.position), square);
      expect(m.stats.areaM2, closeTo(11570, 50));
    },
  );

  test('stats, close, undo and reset', () async {
    final (session, _) = await open(container);
    session
      ..addPointAt(square[0])
      ..addPointAt(square[1]);
    expect(read(container).hasResult, isFalse);
    expect(read(container).stats.areaM2, isNull);
    expect(read(container).canClose, isFalse);

    session.addPointAt(square[2]);
    expect(read(container).stats.areaM2, isNotNull);
    expect(read(container).canClose, isTrue);

    session.closeShape();
    expect(read(container).isClosed, isTrue);
    expect(read(container).canAddPoint, isFalse);
    expect(session.addPointAt(square[3]), isFalse);

    session.undo(); // reopens
    expect(read(container).isClosed, isFalse);
    expect(session.addPointAt(square[3]), isTrue);
    expect(read(container).pointCount, 4);

    session.reset();
    expect(read(container).pointCount, 0);
    expect(read(container).canUndo, isTrue);
    session.undo();
    expect(read(container).pointCount, 4);
  });

  test('select, move, delete', () async {
    final (session, _) = await open(container);
    square.forEach(session.addPointAt);
    final id = read(container).points[1].id;
    session.selectPoint(id);
    expect(read(container).selectedIndex, 1);
    session.movePoint(id, const GeoPoint(lat: 20.9995, lng: 105.001));
    expect(read(container).points[1].lat, 20.9995);
    expect(read(container).selectedPointId, id);
    session.selectPoint(id); // toggle off
    expect(read(container).selectedPointId, isNull);

    session
      ..selectPoint(id)
      ..deleteSelected();
    expect(read(container).pointCount, 3);
    expect(read(container).selectedPointId, isNull);
    session.deleteSelected(); // nothing selected: no-op
    expect(read(container).pointCount, 3);
  });

  test('distance sessions never close', () async {
    final (session, _) = await open(container, type: MeasurementType.distance);
    final provider = measureSessionControllerProvider(
      MeasurementType.distance,
      null,
    );
    square.forEach(session.addPointAt);
    session.closeShape();
    expect(container.read(provider).requireValue.isClosed, isFalse);
    expect(container.read(provider).requireValue.stats.distanceM, isNotNull);
  });

  test('leaving flushes pending edits; the draft restores fully', () async {
    final (session, close) = await open(container);
    square.forEach(session.addPointAt);
    session
      ..closeShape()
      ..setDisplayAreaUnit(AreaUnit.hectare);
    close(); // screen popped before the debounce fired
    await pumpEventQueue();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final saved = await drafts();
    expect(saved.single.points, 4);

    // "Kill + reopen": a fresh container resumes the draft.
    final restoredContainer = newContainer();
    await open(restoredContainer, draftId: saved.single.id);
    final restored = read(restoredContainer, draftId: saved.single.id);
    expect(restored.points.map((p) => p.position), square);
    expect(restored.isClosed, isTrue);
    expect(restored.displayAreaUnit, AreaUnit.hectare);
    expect(restored.canUndo, isFalse);
  });

  test('a draft emptied by Reset is deleted when leaving', () async {
    final (session, close) = await open(container);
    session.addPointAt(square[0]);
    await session.flushNow();
    expect(await drafts(), hasLength(1));
    session.reset();
    close();
    await pumpEventQueue();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(await drafts(), isEmpty);
  });

  test('map style is stored on the draft', () async {
    final (session, _) = await open(container);
    expect(read(container).mapStyle, MapStyle.standard); // settings default
    session.addPointAt(square[0]);
    await session.flushNow();
    session.setMapStyle(MapStyle.hybrid);
    await session.flushNow();
    final m = await container
        .read(measurementRepositoryProvider)
        .get(read(container).measurementId!);
    expect(m!.mapStyle, MapStyle.hybrid);
  });

  test('insert between points (tap on an edge chip)', () async {
    final (session, _) = await open(container);
    square.take(3).forEach(session.addPointAt);
    session.addPointAt(square[3], atIndex: 1);
    final pts = read(container).points;
    expect(pts.map((p) => p.position), [
      square[0],
      square[3],
      square[1],
      square[2],
    ]);
    expect(pts.map((p) => p.orderIndex), [0, 1, 2, 3]);
  });

  test('distance display unit is stored with the draft', () async {
    final provider = measureSessionControllerProvider(
      MeasurementType.distance,
      null,
    );
    final (session, _) = await open(container, type: MeasurementType.distance);
    session.setDisplayDistanceUnit(DistanceUnit.kilometer); // before draft
    square.take(2).forEach(session.addPointAt);
    await session.flushNow();
    final id = container.read(provider).requireValue.measurementId!;
    var m = await container.read(measurementRepositoryProvider).get(id);
    expect(m!.displayDistanceUnit, DistanceUnit.kilometer);
    session.setDisplayDistanceUnit(DistanceUnit.mile); // after draft
    await session.flushNow();
    m = await container.read(measurementRepositoryProvider).get(id);
    expect(m!.displayDistanceUnit, DistanceUnit.mile);
  });

  test('flushAndDescribe reports the draft left behind', () async {
    final (session, _) = await open(container);
    expect(await session.flushAndDescribe(), isNull); // nothing yet
    square.take(2).forEach(session.addPointAt);
    final draft = await session.flushAndDescribe();
    expect(draft!.pointCount, 2);
    expect(draft.id, read(container).measurementId);
    session.reset();
    expect(await session.flushAndDescribe(), isNull);
  });

  test('a failed autosave is flagged and retried on the next change', () async {
    final flaky = FlakyRepository(
      db: db,
      photoStorage: container.read(photoStorageProvider),
      thumbnailStorage: container.read(thumbnailStorageProvider),
    )..failing = true;
    final c = newContainer(
      extra: [measurementRepositoryProvider.overrideWithValue(flaky)],
    );
    final (session, _) = await open(c);
    session.addPointAt(square[0]);
    await session.flushNow();
    expect(read(c).saveFailed, isTrue);

    flaky.failing = false;
    session.addPointAt(square[1]);
    await session.flushNow();
    expect(read(c).saveFailed, isFalse);
    final m = await flaky.get(read(c).measurementId!);
    expect(m!.points, hasLength(2));
  });
}

typedef MeasurementSummaryLite = ({String id, int points});
