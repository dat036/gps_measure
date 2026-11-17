import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/data/db/app_database.dart';

import '../../drift/app/generated/schema.dart';
import '../../helpers/data.dart';

void main() {
  setUpAll(useHostSqlite);

  test('schema v1 created by onCreate matches drift_schemas dump', () async {
    final verifier = SchemaVerifier(GeneratedHelper());
    final connection = await verifier.startAt(1);
    final db = AppDatabase(connection);
    // Validates tables, columns, indexes against the v1 dump.
    await verifier.migrateAndValidate(db, 1);
    await db.close();
  });

  test('foreign keys are enforced', () async {
    final db = newTestDatabase();
    final fk = await db.customSelect('PRAGMA foreign_keys').getSingle();
    expect(fk.data.values.single, 1);
    await db.close();
  });
}
