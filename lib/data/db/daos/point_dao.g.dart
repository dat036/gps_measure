// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_dao.dart';

// ignore_for_file: type=lint
mixin _$PointDaoMixin on DatabaseAccessor<AppDatabase> {
  $MeasurementsTable get measurements => attachedDatabase.measurements;
  $MeasurePointsTable get measurePoints => attachedDatabase.measurePoints;
  PointDaoManager get managers => PointDaoManager(this);
}

class PointDaoManager {
  final _$PointDaoMixin _db;
  PointDaoManager(this._db);
  $$MeasurementsTableTableManager get measurements =>
      $$MeasurementsTableTableManager(_db.attachedDatabase, _db.measurements);
  $$MeasurePointsTableTableManager get measurePoints =>
      $$MeasurePointsTableTableManager(_db.attachedDatabase, _db.measurePoints);
}
