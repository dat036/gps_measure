import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/core/utils/id_generator.dart';
import 'package:gps_measurement/data/db/app_database.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:gps_measurement/data/repositories/photo_repository.dart';
import 'package:gps_measurement/domain/geo/stats_calculator.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/photo.dart';
import 'package:gps_measurement/domain/premium/feature_gate.dart';
import 'package:gps_measurement/features/edit/edit_controller.dart';
import 'package:gps_measurement/features/measure/session/measure_session_controller.dart';
import 'package:gps_measurement/features/photos/photo_actions.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:gps_measurement/features/save/save_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/data.dart';

void main() {
  late AppDatabase db;
  late TempDirectories temp;
  late Directory picks;
  late SharedPreferences prefs;
  late ProviderContainer container;

  const undo = Duration(milliseconds: 60);

  ProviderContainer newContainer({List<Override> extra = const []}) {
    final c = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDirectoriesProvider.overrideWithValue(temp.dirs),
        appDatabaseProvider.overrideWithValue(db),
        imageCompressorProvider.overrideWithValue(FakeCompressor()),
        clockProvider.overrideWithValue(testClock()),
        idGeneratorProvider.overrideWithValue(SequentialIds()),
        photoActionsProvider.overrideWith(
          (ref) => PhotoActions(
            repository: ref.watch(photoRepositoryProvider),
            storage: ref.watch(photoStorageProvider),
            gate: ref.watch(featureGateProvider),
            imports: ref.watch(photoImportsProvider.notifier),
            undoWindow: undo,
          ),
        ),
        ...extra,
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  MeasurementRepository repo() => container.read(measurementRepositoryProvider);
  PhotoRepository photos() => container.read(photoRepositoryProvider);
  PhotoActions actions() => container.read(photoActionsProvider);

  XFile pick(String name) {
    final f = File('${picks.path}/$name')..writeAsBytesSync(List.filled(64, 1));
    return XFile(f.path);
  }

  List<MeasurePoint> square(String prefix) => [
    for (final (i, (lat, lng)) in [
      (21.0, 105.0),
      (21.0, 105.001),
      (21.001, 105.001),
      (21.001, 105.0),
    ].indexed)
      MeasurePoint(
        id: '$prefix-p$i',
        orderIndex: i,
        lat: lat,
        lng: lng,
        timestamp: DateTime.utc(2026, 9, 28),
      ),
  ];

  /// A saved Area square named "Farm".
  Future<String> savedArea() async {
    final m = await repo().createDraft(
      MeasurementType.area,
      MapStyle.satellite,
    );
    final pts = square(m.id);
    await repo().replacePoints(
      m.id,
      pts,
      StatsCalculator.compute(MeasurementType.area, pts, closed: true),
    );
    await repo().markSaved(m.id, name: 'Farm', notes: 'old notes');
    return m.id;
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = newTestDatabase();
    temp = TempDirectories();
    picks = Directory.systemTemp.createTempSync('picks_');
    container = newContainer();
  });

  tearDown(() async {
    await db.close();
    temp.dispose();
    if (picks.existsSync()) picks.deleteSync(recursive: true);
  });

  group('PhotoActions', () {
    test(
      'camera import: stored copy + thumb, picker temp file removed',
      () async {
        final id = await savedArea();
        final shot = pick('cam.jpg');
        final photo = await actions().addFromCamera(
          shot,
          id,
          pointId: '$id-p2',
          location: const GeoPoint(lat: 21, lng: 105),
        );
        expect(photo.pointId, '$id-p2');
        expect(photo.lat, 21);
        expect(temp.files(), containsAll([photo.filePath, photo.thumbPath]));
        expect(File(shot.path).existsSync(), isFalse);
        expect(container.read(photoImportsProvider), 0);
      },
    );

    test('gallery originals are never touched, even on delete', () async {
      final id = await savedArea();
      final a = pick('a.jpg');
      final b = pick('b.jpg');
      final added = await actions().addFromGallery([a, b], id);
      expect(added.map((p) => p.sortIndex), [0, 1]);
      await repo().delete(id);
      expect(File(a.path).existsSync(), isTrue);
      expect(File(b.path).existsSync(), isTrue);
      expect(temp.files().where((f) => f.startsWith('photos/')), isEmpty);
    });

    test('remove with undo keeps files until the window ends', () async {
      final id = await savedArea();
      final photo = await actions().addFromCamera(pick('c.jpg'), id);

      await actions().removeWithUndo(photo);
      expect(await photos().count(id), 0);
      expect(temp.files(), contains(photo.filePath));

      await actions().undoRemove(photo);
      expect(await photos().count(id), 1);
      await Future<void>.delayed(undo * 3);
      expect(temp.files(), contains(photo.filePath)); // undone: kept

      await actions().removeWithUndo(photo);
      await Future<void>.delayed(undo * 3);
      expect(await photos().count(id), 0);
      expect(temp.files(), isNot(contains(photo.filePath)));
    });

    test('free limit caps the photos', () async {
      container = newContainer(
        extra: [
          featureGateProvider.overrideWithValue(
            const FeatureGate(isPremium: false),
          ),
        ],
      );
      final id = await savedArea();
      expect(await actions().remaining(id), 2);
      await actions().addFromGallery([pick('1.jpg')], id);
      expect(await actions().remaining(id), 1);
      // More picked than allowed: only what fits is kept.
      await actions().addFromGallery([pick('2.jpg'), pick('3.jpg')], id);
      expect(await actions().remaining(id), 0);
    });
  });

  group('measuring session', () {
    MeasureSessionControllerProvider areaSession([String? id]) =>
        measureSessionControllerProvider(MeasurementType.area, id);

    test('a photo before any point creates the draft and keeps it', () async {
      final sub = container.listen(areaSession(), (_, _) {});
      await container.read(areaSession().future);
      final id = await container.read(areaSession().notifier).ensureDraft();
      await actions().addFromCamera(pick('x.jpg'), id);
      sub.close();
      await container.pump();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(await repo().get(id), isNotNull);
    });

    test('an empty draft without photos is still deleted', () async {
      final sub = container.listen(areaSession(), (_, _) {});
      await container.read(areaSession().future);
      final id = await container.read(areaSession().notifier).ensureDraft();
      sub.close();
      await container.pump();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(await repo().get(id), isNull);
    });

    test('deleting a point detaches its photos', () async {
      final id = await savedArea();
      final photo = await actions().addFromCamera(
        pick('p.jpg'),
        id,
        pointId: '$id-p1',
      );
      final session = areaSession(id);
      final sub = container.listen(session, (_, _) {});
      addTearDown(sub.close);
      await container.read(session.future);
      container.read(session.notifier)
        ..selectPoint('$id-p1')
        ..deleteSelected();
      await container.read(session.notifier).flushNow();
      final stored = await photos().watchForMeasurement(id).first;
      expect(stored.single.id, photo.id);
      expect(stored.single.pointId, isNull);
    });
  });

  group('Edit', () {
    MeasureSessionControllerProvider editSession(String id) =>
        measureSessionControllerProvider(
          MeasurementType.area,
          id,
          editing: true,
        );

    test('editing writes nothing until Save Changes', () async {
      final id = await savedArea();
      final session = editSession(id);
      final sub = container.listen(session, (_, _) {});
      final editSub = container.listen(editControllerProvider(id), (_, _) {});
      addTearDown(editSub.close);
      await container.read(session.future);
      await container.read(editControllerProvider(id).future);

      final notifier = container.read(session.notifier)
        ..selectPoint('$id-p0')
        ..deleteSelected();
      expect(container.read(session).value!.geometryChanged, isTrue);
      await notifier.flushNow();
      await Future<void>.delayed(
        MeasureSessionController.autosaveDelay * 2,
      );
      final stored = (await repo().get(id))!;
      expect(stored.points, hasLength(4));

      container.read(editControllerProvider(id).notifier)
        ..setName('Changed')
        ..setNotes('changed');
      expect(
        container.read(editControllerProvider(id)).value!.detailsChanged,
        isTrue,
      );
      sub.close(); // leaving without saving
      await container.pump();
      final after = (await repo().get(id))!;
      expect(after.name, 'Farm');
      expect(after.notes, 'old notes');
      expect(after.points, hasLength(4));
    });

    test('Save Changes: geometry, details, photos in one go', () async {
      final id = await savedArea();
      final keep = await actions().addFromCamera(pick('k.jpg'), id);
      final onDeleted = await actions().addFromCamera(
        pick('d.jpg'),
        id,
        pointId: '$id-p0',
      );
      final gone = await actions().addFromCamera(pick('g.jpg'), id);

      final session = editSession(id);
      final sub = container.listen(session, (_, _) {});
      final editSub = container.listen(editControllerProvider(id), (_, _) {});
      addTearDown(sub.close);
      addTearDown(editSub.close);
      await container.read(session.future);
      await container.read(editControllerProvider(id).future);

      container.read(session.notifier)
        ..selectPoint('$id-p0')
        ..deleteSelected();
      final edit = container.read(editControllerProvider(id).notifier)
        ..setName('  Farm 2 ')
        ..setNotes('')
        ..removePhoto(gone);
      final s = container.read(session).value!;
      expect(
        await edit.saveChanges(points: s.points, stats: s.stats),
        isTrue,
      );

      final m = (await repo().get(id))!;
      expect(m.name, 'Farm 2');
      expect(m.notes, isNull);
      expect(m.points, hasLength(3));
      expect(m.stats.pointCount, 3);
      expect(m.photos.map((p) => p.id), [keep.id, onDeleted.id]);
      expect(m.photos.last.pointId, isNull); // its point was deleted
      expect(temp.files(), isNot(contains(gone.filePath)));
      expect(m.thumbnailPath, isNotNull);
    });

    test('Discard removes photos added during the edit only', () async {
      final id = await savedArea();
      final before = await actions().addFromCamera(pick('b.jpg'), id);
      final editSub = container.listen(editControllerProvider(id), (_, _) {});
      addTearDown(editSub.close);
      await container.read(editControllerProvider(id).future);
      final edit = container.read(editControllerProvider(id).notifier);

      final added = await actions().addFromCamera(pick('n.jpg'), id);
      edit
        ..photosAdded([added])
        ..removePhoto(before);
      await edit.discard();

      final stored = await photos().watchForMeasurement(id).first;
      expect(stored.map((p) => p.id), [before.id]);
      expect(temp.files(), contains(before.filePath));
      expect(temp.files(), isNot(contains(added.filePath)));
    });

    test('visible() hides removed photos', () async {
      final id = await savedArea();
      final a = await actions().addFromCamera(pick('a.jpg'), id);
      final b = await actions().addFromCamera(pick('b.jpg'), id);
      final editSub = container.listen(editControllerProvider(id), (_, _) {});
      addTearDown(editSub.close);
      await container.read(editControllerProvider(id).future);
      final edit = container.read(editControllerProvider(id).notifier)
        ..removePhoto(a);
      expect(edit.visible(<Photo>[a, b]), [b]);
      edit.undoRemovePhoto(a);
      expect(edit.visible(<Photo>[a, b]), [a, b]);
    });
  });

  test('Save notes autosave into the draft after 500 ms', () async {
    final m = await repo().createDraft(
      MeasurementType.distance,
      MapStyle.satellite,
    );
    final sub = container.listen(saveControllerProvider(m.id), (_, _) {});
    addTearDown(sub.close);
    await container.read(saveControllerProvider(m.id).future);
    container.read(saveControllerProvider(m.id).notifier)
      ..autosaveNotes('North')
      ..autosaveNotes('North edge');
    expect((await repo().get(m.id))!.notes, isNull);
    await Future<void>.delayed(
      SaveController.notesAutosaveDelay + const Duration(milliseconds: 100),
    );
    expect((await repo().get(m.id))!.notes, 'North edge');
  });
}
