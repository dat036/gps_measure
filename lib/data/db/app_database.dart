import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:gps_measurement/data/db/daos/measurement_dao.dart';
import 'package:gps_measurement/data/db/daos/photo_dao.dart';
import 'package:gps_measurement/data/db/daos/point_dao.dart';
import 'package:gps_measurement/data/db/tables.dart';
import 'package:gps_measurement/domain/models/enums.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Measurements, MeasurePoints, Photos],
  daos: [MeasurementDao, PointDao, PhotoDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// On-device database (`landmeasure.sqlite` in app documents), opened on
  /// a background isolate by drift_flutter.
  factory AppDatabase.open() => AppDatabase(driftDatabase(name: 'landmeasure'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    // One `_migrateVxToVy` per version; each is tested with the schema
    // dumps in drift_schemas/ (dart run drift_dev make-migrations).
    onUpgrade: (m, from, to) async {
      // No upgrades yet: v1 is the first schema.
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      // Returns a row, so it must be run as a select.
      await customSelect('PRAGMA journal_mode = WAL').get();
    },
  );
}
