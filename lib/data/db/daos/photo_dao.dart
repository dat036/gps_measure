import 'package:drift/drift.dart';
import 'package:gps_measurement/data/db/app_database.dart';
import 'package:gps_measurement/data/db/tables.dart';

part 'photo_dao.g.dart';

@DriftAccessor(tables: [Photos])
class PhotoDao extends DatabaseAccessor<AppDatabase> with _$PhotoDaoMixin {
  PhotoDao(super.attachedDatabase);

  SimpleSelectStatement<$PhotosTable, PhotoRow> _forMeasurement(
    String measurementId,
  ) => select(photos)
    ..where((p) => p.measurementId.equals(measurementId))
    ..orderBy([(p) => OrderingTerm.asc(p.sortIndex)]);

  Future<List<PhotoRow>> getForMeasurement(String measurementId) =>
      _forMeasurement(measurementId).get();

  Stream<List<PhotoRow>> watchForMeasurement(String measurementId) =>
      _forMeasurement(measurementId).watch();

  Future<PhotoRow?> getById(String id) =>
      (select(photos)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<void> insertRow(PhotosCompanion row) => into(photos).insert(row);

  Future<int> deleteById(String id) =>
      (delete(photos)..where((p) => p.id.equals(id))).go();

  Future<int> updateFields(String id, PhotosCompanion fields) =>
      (update(photos)..where((p) => p.id.equals(id))).write(fields);

  /// Sets `point_id` to null for photos attached to [pointId].
  Future<int> detachPoint(String pointId) =>
      (update(photos)..where((p) => p.pointId.equals(pointId))).write(
        const PhotosCompanion(pointId: Value(null)),
      );

  Future<int> countForMeasurement(String measurementId) async {
    final count = photos.id.count();
    final row =
        await (selectOnly(photos)
              ..addColumns([count])
              ..where(photos.measurementId.equals(measurementId)))
            .getSingle();
    return row.read(count) ?? 0;
  }

  Future<int> maxSortIndex(String measurementId) async {
    final max = photos.sortIndex.max();
    final row =
        await (selectOnly(photos)
              ..addColumns([max])
              ..where(photos.measurementId.equals(measurementId)))
            .getSingle();
    return row.read(max) ?? -1;
  }

  /// Relative paths of every photo + thumbnail file (orphan cleanup).
  Future<Set<String>> allFilePaths() async {
    final rows = await (selectOnly(
      photos,
    )..addColumns([photos.filePath, photos.thumbPath])).get();
    return {
      for (final r in rows) ...[
        r.read(photos.filePath)!,
        r.read(photos.thumbPath)!,
      ],
    };
  }
}
