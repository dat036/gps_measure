import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/data/db/app_database.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:gps_measurement/data/repositories/photo_repository.dart';
import 'package:gps_measurement/data/storage/photo_storage.dart';
import 'package:gps_measurement/data/storage/thumbnail_storage.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/photo.dart';
import 'package:image_picker/image_picker.dart';

import '../../helpers/data.dart';

void main() {
  late AppDatabase db;
  late TempDirectories temp;
  late PhotoStorage storage;
  late DriftPhotoRepository photos;
  late String measurementId;

  setUp(() async {
    db = newTestDatabase();
    temp = TempDirectories();
    final clock = testClock();
    storage = PhotoStorage(
      directories: temp.dirs,
      compressor: FakeCompressor(),
      ids: SequentialIds('ph'),
      clock: clock,
    );
    photos = DriftPhotoRepository(db: db, storage: storage, clock: clock);
    final repo = DriftMeasurementRepository(
      db: db,
      photoStorage: storage,
      thumbnailStorage: ThumbnailStorage(directories: temp.dirs),
      clock: clock,
    );
    measurementId = (await repo.createDraft(
      MeasurementType.area,
      MapStyle.satellite,
    )).id;
  });

  tearDown(() async {
    await db.close();
    temp.dispose();
  });

  Future<Photo> addPhoto({String? pointId}) async {
    final src = File(
      '${temp.dirs.temporary.path}/${DateTime.now().microsecondsSinceEpoch}.jpg',
    )..writeAsBytesSync([1]);
    return photos.add(
      await storage.importFromGallery(
        XFile(src.path),
        measurementId,
        pointId: pointId,
      ),
    );
  }

  test('add assigns increasing sortIndex; watch is ordered', () async {
    final a = await addPhoto();
    final b = await addPhoto();
    expect((a.sortIndex, b.sortIndex), (0, 1));
    expect(await photos.count(measurementId), 2);
    final listed = await photos.watchForMeasurement(measurementId).first;
    expect(listed.map((p) => p.id), [a.id, b.id]);
  });

  test('reorder', () async {
    final a = await addPhoto();
    final b = await addPhoto();
    final c = await addPhoto();
    await photos.reorder(measurementId, [c.id, a.id, b.id]);
    final listed = await photos.watchForMeasurement(measurementId).first;
    expect(listed.map((p) => p.id), [c.id, a.id, b.id]);
  });

  test('caption and detachPoint', () async {
    final a = await addPhoto(pointId: 'pt1');
    final b = await addPhoto(pointId: 'pt2');
    await photos.setCaption(a.id, 'Cột mốc');
    await photos.detachPoint('pt1');
    final listed = await photos.watchForMeasurement(measurementId).first;
    expect(listed.first.caption, 'Cột mốc');
    expect(listed.first.pointId, isNull);
    expect(listed.last.id, b.id);
    expect(listed.last.pointId, 'pt2');
  });

  test('remove deletes the row and both files', () async {
    final a = await addPhoto();
    final b = await addPhoto();
    expect(temp.files(), hasLength(4));
    await photos.remove(a);
    expect(await photos.count(measurementId), 1);
    expect(temp.files(), [b.filePath, b.thumbPath]..sort());
  });
}
