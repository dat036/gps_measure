// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_dao.dart';

// ignore_for_file: type=lint
mixin _$MeasurementDaoMixin on DatabaseAccessor<AppDatabase> {
  $MeasurementsTable get measurements => attachedDatabase.measurements;
  $PhotosTable get photos => attachedDatabase.photos;
  MeasurementDaoManager get managers => MeasurementDaoManager(this);
}

class MeasurementDaoManager {
  final _$MeasurementDaoMixin _db;
  MeasurementDaoManager(this._db);
  $$MeasurementsTableTableManager get measurements =>
      $$MeasurementsTableTableManager(_db.attachedDatabase, _db.measurements);
  $$PhotosTableTableManager get photos =>
      $$PhotosTableTableManager(_db.attachedDatabase, _db.photos);
}
