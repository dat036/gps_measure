import 'package:drift/drift.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/data/db/app_database.dart';
import 'package:gps_measurement/data/db/converters.dart';
import 'package:gps_measurement/data/storage/photo_storage.dart';
import 'package:gps_measurement/domain/models/photo.dart';

/// Photo rows of a measurement. Files are imported/deleted by
/// [PhotoStorage]; this keeps the DB in sync with them.
abstract interface class PhotoRepository {
  /// Inserts an imported photo at the end (sortIndex assigned here).
  Future<Photo> add(Photo photo);

  /// Deletes the row and its files.
  Future<void> remove(Photo photo);

  /// Deletes only the row; the files stay so [restore] can undo it. The
  /// caller deletes the files later (`PhotoStorage.delete`) — or the orphan
  /// cleaner does if the app dies first.
  Future<void> removeRow(Photo photo);

  /// Re-inserts a row removed by [removeRow], unchanged.
  Future<void> restore(Photo photo);

  Stream<List<Photo>> watchForMeasurement(String measurementId);

  Future<int> count(String measurementId);

  /// Sets sortIndex from the order of [orderedIds].
  Future<void> reorder(String measurementId, List<String> orderedIds);

  Future<void> setCaption(String photoId, String? caption);

  /// Called when a point is deleted: its photos stay, unattached.
  Future<void> detachPoint(String pointId);
}

class DriftPhotoRepository implements PhotoRepository {
  DriftPhotoRepository({
    required AppDatabase db,
    required PhotoStorage storage,
    Clock clock = const Clock(),
  }) : _db = db,
       _storage = storage,
       _clock = clock;

  final AppDatabase _db;
  final PhotoStorage _storage;
  final Clock _clock;

  @override
  Future<Photo> add(Photo photo) => _guard('add', () {
    return _db.transaction(() async {
      final next = await _db.photoDao.maxSortIndex(photo.measurementId) + 1;
      final stored = photo.copyWith(sortIndex: next);
      await _db.photoDao.insertRow(stored.toCompanion());
      await _touch(photo.measurementId);
      return stored;
    });
  });

  @override
  Future<void> remove(Photo photo) => _guard('remove', () async {
    await _db.transaction(() async {
      await _db.photoDao.deleteById(photo.id);
      await _touch(photo.measurementId);
    });
    await _storage.delete(photo);
  });

  @override
  Future<void> removeRow(Photo photo) => _guard('removeRow', () {
    return _db.transaction(() async {
      await _db.photoDao.deleteById(photo.id);
      await _touch(photo.measurementId);
    });
  });

  @override
  Future<void> restore(Photo photo) => _guard('restore', () {
    return _db.transaction(() async {
      await _db.photoDao.insertRow(photo.toCompanion());
      await _touch(photo.measurementId);
    });
  });

  @override
  Stream<List<Photo>> watchForMeasurement(String measurementId) => _db.photoDao
      .watchForMeasurement(measurementId)
      .map((rows) => [for (final r in rows) r.toDomain()]);

  @override
  Future<int> count(String measurementId) =>
      _guard('count', () => _db.photoDao.countForMeasurement(measurementId));

  @override
  Future<void> reorder(String measurementId, List<String> orderedIds) =>
      _guard('reorder', () {
        return _db.transaction(() async {
          for (final (i, id) in orderedIds.indexed) {
            await _db.photoDao.updateFields(
              id,
              PhotosCompanion(sortIndex: Value(i)),
            );
          }
          await _touch(measurementId);
        });
      });

  @override
  Future<void> setCaption(String photoId, String? caption) => _guard(
    'setCaption',
    () => _db.photoDao.updateFields(
      photoId,
      PhotosCompanion(caption: Value(caption)),
    ),
  );

  @override
  Future<void> detachPoint(String pointId) =>
      _guard('detachPoint', () => _db.photoDao.detachPoint(pointId));

  Future<void> _touch(String measurementId) => _db.measurementDao.updateFields(
    measurementId,
    MeasurementsCompanion(updatedAt: Value(_clock.nowUtc())),
  );

  Future<T> _guard<T>(String op, Future<T> Function() body) async {
    try {
      return await body();
    } on AppException {
      rethrow;
    } on Object catch (e, st) {
      throw StorageException('PhotoRepository.$op', cause: e, stackTrace: st);
    }
  }
}
