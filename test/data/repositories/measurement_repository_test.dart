import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/data/db/app_database.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:gps_measurement/data/repositories/photo_repository.dart';
import 'package:gps_measurement/data/storage/photo_storage.dart';
import 'package:gps_measurement/data/storage/thumbnail_storage.dart';
import 'package:gps_measurement/domain/geo/stats_calculator.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';
import 'package:gps_measurement/domain/models/measurement_summary.dart';
import 'package:image_picker/image_picker.dart';

import '../../helpers/data.dart';

void main() {
  late AppDatabase db;
  late TempDirectories temp;
  late FixedClock clock;
  late PhotoStorage photoStorage;
  late ThumbnailStorage thumbs;
  late DriftMeasurementRepository repo;
  late DriftPhotoRepository photos;

  setUp(() {
    db = newTestDatabase();
    temp = TempDirectories();
    clock = testClock();
    photoStorage = PhotoStorage(
      directories: temp.dirs,
      compressor: FakeCompressor(),
      ids: SequentialIds('ph'),
      clock: clock,
    );
    thumbs = ThumbnailStorage(directories: temp.dirs);
    repo = DriftMeasurementRepository(
      db: db,
      photoStorage: photoStorage,
      thumbnailStorage: thumbs,
      ids: SequentialIds('m'),
      clock: clock,
    );
    photos = DriftPhotoRepository(db: db, storage: photoStorage, clock: clock);
  });

  tearDown(() async {
    await db.close();
    temp.dispose();
  });

  List<MeasurePoint> square({int segment = 0, String prefix = 'p'}) => [
    for (final (i, (lat, lng)) in [
      (21.0, 105.0),
      (21.0, 105.001),
      (21.001, 105.001),
      (21.001, 105.0),
    ].indexed)
      MeasurePoint(
        id: '$prefix$i',
        orderIndex: i,
        segmentIndex: segment,
        lat: lat,
        lng: lng,
        accuracy: 4,
        timestamp: DateTime.utc(2026, 9, 28, 8, 0, i, 250),
      ),
  ];

  Future<String> savedArea(String name) async {
    final m = await repo.createDraft(MeasurementType.area, MapStyle.satellite);
    await repo.updateMeta(m.id, name: Value(name));
    await repo.setStatus(m.id, MeasurementStatus.saved);
    clock.advance(const Duration(minutes: 1));
    return m.id;
  }

  group('drafts & points', () {
    test('createDraft stores a draft; walk starts idle', () async {
      final area = await repo.createDraft(
        MeasurementType.area,
        MapStyle.hybrid,
      );
      expect(area.status, MeasurementStatus.draft);
      expect(area.mapStyle, MapStyle.hybrid);
      expect(area.walkState, isNull);
      expect(area.createdAt, clock.nowUtc());
      expect(area.createdAt.isUtc, isTrue);

      final walk = await repo.createDraft(
        MeasurementType.walk,
        MapStyle.satellite,
      );
      expect(walk.walkState, WalkRunState.idle);
      expect(await repo.get('nope'), isNull);
    });

    test('replacePoints stores ordered points, stats, bounds', () async {
      final m = await repo.createDraft(
        MeasurementType.area,
        MapStyle.satellite,
      );
      final pts = square();
      final stats = StatsCalculator.compute(MeasurementType.area, pts);
      clock.advance(const Duration(seconds: 5));
      await repo.replacePoints(m.id, pts, stats);

      final stored = (await repo.get(m.id))!;
      expect(stored.points, pts); // incl. ms timestamps, UTC
      expect(stored.stats, stats);
      expect(stored.updatedAt, clock.nowUtc());
      final row = (await db.measurementDao.getById(m.id))!;
      expect(row.minLat, 21.0);
      expect(row.maxLng, 105.001);

      // Replace again with fewer points.
      await repo.replacePoints(m.id, pts.take(2).toList(), stats);
      expect((await repo.get(m.id))!.points, hasLength(2));
    });

    test('appendWalkPoints appends, merges bounds, stores elapsed', () async {
      final m = await repo.createDraft(
        MeasurementType.walk,
        MapStyle.satellite,
      );
      final first = square().take(2).toList();
      await repo.appendWalkPoints(
        m.id,
        first,
        StatsCalculator.compute(MeasurementType.walk, first),
        30,
      );
      final more = square(segment: 1, prefix: 'q').skip(2).toList();
      final all = [...first, ...more];
      await repo.appendWalkPoints(
        m.id,
        more,
        StatsCalculator.compute(MeasurementType.walk, all),
        75,
      );
      final stored = (await repo.get(m.id))!;
      expect(stored.points.map((p) => p.id), ['p0', 'p1', 'q2', 'q3']);
      expect(stored.walkElapsedSec, 75);
      expect(stored.stats.segmentCount, 2);
      final row = (await db.measurementDao.getById(m.id))!;
      expect((row.minLat, row.maxLat), (21.0, 21.001));
    });

    test('updateWalkState sets and clears fields', () async {
      final m = await repo.createDraft(
        MeasurementType.walk,
        MapStyle.satellite,
      );
      final start = DateTime.utc(2026, 9, 28, 7);
      await repo.updateWalkState(
        m.id,
        WalkRunState.recording,
        startedAt: Value(start),
        lastResumeAt: Value(start),
        elapsedSec: const Value(0),
      );
      var w = (await repo.get(m.id))!;
      expect(w.walkState, WalkRunState.recording);
      expect(w.walkStartedAt, start);
      await repo.updateWalkState(
        m.id,
        WalkRunState.paused,
        lastResumeAt: const Value(null),
        elapsedSec: const Value(120),
      );
      w = (await repo.get(m.id))!;
      expect(w.walkState, WalkRunState.paused);
      expect(w.walkStartedAt, start); // untouched
      expect(w.walkLastResumeAt, isNull);
      expect(w.walkElapsedSec, 120);
      expect(
        await db.measurementDao.walksInState(WalkRunState.paused),
        hasLength(1),
      );
    });

    test(
      'updateMeta: absent keeps, null clears, name gets a search key',
      () async {
        final m = await repo.createDraft(
          MeasurementType.area,
          MapStyle.satellite,
        );
        await repo.updateMeta(
          m.id,
          name: const Value('Ruộng Nhà Ông Tư'),
          notes: const Value('near the canal'),
          displayAreaUnit: const Value(AreaUnit.acre),
          unitPrice: const Value(350000000),
          unitPriceCurrency: const Value('VND'),
          unitPriceArea: const Value(AreaUnit.acre),
          mapStyle: const Value(MapStyle.terrain),
          thumbnailPath: const Value('thumbs/x.png'),
          displayDistanceUnit: const Value(DistanceUnit.kilometer),
        );
        final row = (await db.measurementDao.getById(m.id))!;
        expect(row.nameLower, 'ruong nha ong tu');
        await repo.updateMeta(m.id, notes: const Value(null));
        final stored = (await repo.get(m.id))!;
        expect(stored.name, 'Ruộng Nhà Ông Tư');
        expect(stored.notes, isNull);
        expect(stored.displayAreaUnit, AreaUnit.acre);
        expect(stored.unitPrice, 350000000);
        expect(stored.mapStyle, MapStyle.terrain);
        await repo.updateMeta(m.id, name: const Value(null));
        expect((await db.measurementDao.getById(m.id))!.nameLower, isNull);
      },
    );

    test('writes to a missing id throw StorageException', () {
      expect(
        repo.updateMeta('ghost', name: const Value('x')),
        throwsA(isA<StorageException>()),
      );
      expect(
        repo.appendWalkPoints('ghost', const [], MeasurementStats.empty, 0),
        throwsA(isA<StorageException>()),
      );
    });

    test('setStatus saved stamps savedAt; completed does not', () async {
      final m = await repo.createDraft(
        MeasurementType.walk,
        MapStyle.satellite,
      );
      await repo.setStatus(m.id, MeasurementStatus.completed);
      expect((await repo.get(m.id))!.savedAt, isNull);
      await repo.setStatus(m.id, MeasurementStatus.saved);
      final s = (await repo.get(m.id))!;
      expect(s.status, MeasurementStatus.saved);
      expect(s.savedAt, clock.nowUtc());
    });
  });

  group('lists', () {
    test('watchSaved: newest first, type filter, folded search', () async {
      await savedArea('Ruộng lúa');
      await savedArea('Vườn cà phê');
      final route = await repo.createDraft(
        MeasurementType.distance,
        MapStyle.satellite,
      );
      await repo.updateMeta(route.id, name: const Value('Đường ra ruộng'));
      await repo.setStatus(route.id, MeasurementStatus.saved);
      await repo.createDraft(MeasurementType.area, MapStyle.satellite);

      List<String?> names(List<MeasurementSummary> l) => [
        for (final s in l) s.name,
      ];

      expect(names(await repo.watchSaved().first), [
        'Đường ra ruộng',
        'Vườn cà phê',
        'Ruộng lúa',
      ]);
      expect(
        names(await repo.watchSaved(type: MeasurementType.area).first),
        ['Vườn cà phê', 'Ruộng lúa'],
      );
      expect(names(await repo.watchSaved(query: 'RUONG').first), [
        'Đường ra ruộng',
        'Ruộng lúa',
      ]);
      expect(names(await repo.watchSaved(query: 'duong').first), [
        'Đường ra ruộng',
      ]);
      // LIKE wildcards are literal.
      expect(await repo.watchSaved(query: '%').first, isEmpty);
      expect(await repo.watchSaved(query: '_').first, isEmpty);
    });

    test('drafts, recent, counts', () async {
      await savedArea('a');
      await savedArea('b');
      final walk = await repo.createDraft(
        MeasurementType.walk,
        MapStyle.satellite,
      );
      await repo.setStatus(walk.id, MeasurementStatus.completed);
      await repo.createDraft(MeasurementType.area, MapStyle.satellite);

      expect(await repo.watchDrafts().first, hasLength(2));
      expect(
        (await repo.watchRecent(1).first).single.name,
        'b',
      );
      expect(await repo.countSaved(), 2);
      expect(await repo.watchCountByType().first, {MeasurementType.area: 2});
    });

    test('summaries carry photo counts', () async {
      final id = await savedArea('with photos');
      for (var i = 0; i < 2; i++) {
        final src = File('${temp.dirs.temporary.path}/c$i.jpg')
          ..writeAsBytesSync([1]);
        await photos.add(
          await photoStorage.importFromGallery(XFile(src.path), id),
        );
      }
      expect((await repo.watchSaved().first).single.photoCount, 2);
    });

    test('watchSaved re-emits on rename and delete', () async {
      final id = await savedArea('Old');
      final emissions = <List<String?>>[];
      final sub = repo.watchSaved().listen(
        (l) => emissions.add([for (final s in l) s.name]),
      );
      await pumpEventQueue();
      await repo.updateMeta(id, name: const Value('New'));
      await pumpEventQueue();
      await repo.delete(id);
      await pumpEventQueue();
      await sub.cancel();
      expect(emissions, [
        ['Old'],
        ['New'],
        <String?>[],
      ]);
    });
  });

  test('watch(id) follows points/photos changes and ends with null', () async {
    final m = await repo.createDraft(MeasurementType.area, MapStyle.satellite);
    final counts = <int?>[];
    final sub = repo.watch(m.id).listen((x) => counts.add(x?.points.length));
    await pumpEventQueue();
    final pts = square();
    await repo.replacePoints(
      m.id,
      pts,
      StatsCalculator.compute(MeasurementType.area, pts),
    );
    await pumpEventQueue();
    await repo.delete(m.id);
    await pumpEventQueue();
    await sub.cancel();
    expect(counts.first, 0);
    expect(counts, contains(4));
    expect(counts.last, isNull);
  });

  test('delete removes rows, photo files and thumbnail', () async {
    final m = await repo.createDraft(MeasurementType.area, MapStyle.satellite);
    final pts = square();
    await repo.replacePoints(
      m.id,
      pts,
      StatsCalculator.compute(MeasurementType.area, pts),
    );
    final src = File('${temp.dirs.temporary.path}/cam.jpg')
      ..writeAsBytesSync([1, 2, 3]);
    await photos.add(
      await photoStorage.importFromCamera(XFile(src.path), m.id),
    );
    await thumbs.renderFallback((await repo.get(m.id))!);
    final keep = await repo.createDraft(
      MeasurementType.area,
      MapStyle.satellite,
    );
    await thumbs.renderFallback(keep);

    expect(temp.files(), hasLength(4)); // photo, photo thumb, 2 map thumbs

    await repo.delete(m.id);

    expect(await repo.get(m.id), isNull);
    expect(await db.pointDao.getForMeasurement(m.id), isEmpty);
    expect(await db.photoDao.getForMeasurement(m.id), isEmpty);
    expect(temp.files(), ['thumbs/${keep.id}.png']);
  });
}
