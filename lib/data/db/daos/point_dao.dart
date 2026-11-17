import 'package:drift/drift.dart';
import 'package:gps_measurement/data/db/app_database.dart';
import 'package:gps_measurement/data/db/tables.dart';

part 'point_dao.g.dart';

@DriftAccessor(tables: [MeasurePoints])
class PointDao extends DatabaseAccessor<AppDatabase> with _$PointDaoMixin {
  PointDao(super.attachedDatabase);

  SimpleSelectStatement<$MeasurePointsTable, PointRow> _forMeasurement(
    String measurementId,
  ) => select(measurePoints)
    ..where((p) => p.measurementId.equals(measurementId))
    ..orderBy([(p) => OrderingTerm.asc(p.orderIndex)]);

  Future<List<PointRow>> getForMeasurement(String measurementId) =>
      _forMeasurement(measurementId).get();

  Stream<List<PointRow>> watchForMeasurement(String measurementId) =>
      _forMeasurement(measurementId).watch();

  Future<void> insertAll(List<MeasurePointsCompanion> rows) =>
      batch((b) => b.insertAll(measurePoints, rows));

  Future<int> deleteForMeasurement(String measurementId) => (delete(
    measurePoints,
  )..where((p) => p.measurementId.equals(measurementId))).go();

  /// Highest `order_index`, or -1 when there are no points.
  Future<int> maxOrderIndex(String measurementId) async {
    final max = measurePoints.orderIndex.max();
    final row =
        await (selectOnly(measurePoints)
              ..addColumns([max])
              ..where(measurePoints.measurementId.equals(measurementId)))
            .getSingle();
    return row.read(max) ?? -1;
  }
}
