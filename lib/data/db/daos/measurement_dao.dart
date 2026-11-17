import 'package:drift/drift.dart';
import 'package:gps_measurement/data/db/app_database.dart';
import 'package:gps_measurement/data/db/tables.dart';
import 'package:gps_measurement/domain/models/enums.dart';

part 'measurement_dao.g.dart';

/// A measurement row plus its photo count (for list tiles).
typedef MeasurementWithPhotoCount = ({MeasurementRow row, int photoCount});

@DriftAccessor(tables: [Measurements, Photos])
class MeasurementDao extends DatabaseAccessor<AppDatabase>
    with _$MeasurementDaoMixin {
  MeasurementDao(super.attachedDatabase);

  Future<void> insertRow(MeasurementsCompanion row) =>
      into(measurements).insert(row);

  /// Updates the given columns; returns the number of rows changed.
  Future<int> updateFields(String id, MeasurementsCompanion fields) =>
      (update(measurements)..where((m) => m.id.equals(id))).write(fields);

  Future<MeasurementRow?> getById(String id) =>
      (select(measurements)..where((m) => m.id.equals(id))).getSingleOrNull();

  Stream<MeasurementRow?> watchById(String id) => (select(
    measurements,
  )..where((m) => m.id.equals(id))).watchSingleOrNull();

  Future<int> deleteById(String id) =>
      (delete(measurements)..where((m) => m.id.equals(id))).go();

  Future<List<String>> allIds() => (selectOnly(
    measurements,
  )..addColumns([measurements.id])).map((r) => r.read(measurements.id)!).get();

  /// List rows with photo counts, newest `updated_at` first.
  ///
  /// [nameQuery] must already be folded (`foldForSearch`); it is matched as
  /// a literal substring (`%` and `_` are escaped).
  Stream<List<MeasurementWithPhotoCount>> watchList({
    required Set<MeasurementStatus> statuses,
    MeasurementType? type,
    String? nameQuery,
    int? limit,
  }) {
    final photoCount = subqueryExpression<int>(
      selectOnly(photos)
        ..addColumns([photos.id.count()])
        ..where(photos.measurementId.equalsExp(measurements.id)),
    );
    final query = select(measurements).addColumns([photoCount])
      ..where(measurements.status.isInValues(statuses));
    if (type != null) query.where(measurements.type.equalsValue(type));
    if (nameQuery != null && nameQuery.isNotEmpty) {
      query.where(
        measurements.nameLower.like(
          '%${_escapeLike(nameQuery)}%',
          escapeChar: r'\',
        ),
      );
    }
    query.orderBy([OrderingTerm.desc(measurements.updatedAt)]);
    if (limit != null) query.limit(limit);
    return query.watch().map(
      (rows) => [
        for (final r in rows)
          (
            row: r.readTable(measurements),
            photoCount: r.read(photoCount) ?? 0,
          ),
      ],
    );
  }

  Future<int> countWithStatus(MeasurementStatus status) async {
    final count = measurements.id.count();
    final row =
        await (selectOnly(measurements)
              ..addColumns([count])
              ..where(measurements.status.equalsValue(status)))
            .getSingle();
    return row.read(count) ?? 0;
  }

  /// Counts per type for rows with [status] (types with 0 are omitted).
  Stream<Map<MeasurementType, int>> watchCountByType(
    MeasurementStatus status,
  ) {
    final count = measurements.id.count();
    final query = selectOnly(measurements)
      ..addColumns([measurements.type, count])
      ..where(measurements.status.equalsValue(status))
      ..groupBy([measurements.type]);
    return query.watch().map(
      (rows) => {
        for (final r in rows)
          MeasurementType.values[r.read(measurements.type)!]:
              r.read(count) ?? 0,
      },
    );
  }

  /// Walk drafts left in `recording` (the app was killed mid-walk).
  Future<List<MeasurementRow>> walksInState(WalkRunState state) =>
      (select(measurements)..where(
            (m) =>
                m.type.equalsValue(MeasurementType.walk) &
                m.walkState.equalsValue(state),
          ))
          .get();

  /// Names starting with [prefix] (literal; exact case — SQLite LIKE
  /// ignores ASCII case, so results are re-checked).
  Future<List<String>> namesWithPrefix(String prefix) async {
    final query = selectOnly(measurements)
      ..addColumns([measurements.name])
      ..where(
        measurements.name.like('${_escapeLike(prefix)}%', escapeChar: r'\'),
      );
    final names = await query.map((r) => r.read(measurements.name)!).get();
    return [
      for (final n in names)
        if (n.startsWith(prefix)) n,
    ];
  }

  static String _escapeLike(String s) =>
      s.replaceAll(r'\', r'\\').replaceAll('%', r'\%').replaceAll('_', r'\_');
}
