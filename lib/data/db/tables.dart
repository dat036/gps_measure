import 'package:drift/drift.dart';
import 'package:gps_measurement/domain/models/enums.dart';

// Schema v1 — architecture.md §5.3. Enums are stored by index (intEnum):
// never reorder released enum values. Timestamps are ISO-8601 text in UTC
// (build.yaml `store_date_time_values_as_text`).

/// Drafts and saved measurements share this table; saving only changes
/// `status`.
@DataClassName('MeasurementRow')
@TableIndex.sql(
  'CREATE INDEX idx_measurements_status_updated '
  'ON measurements (status, updated_at DESC)',
)
@TableIndex(name: 'idx_measurements_type_status', columns: {#type, #status})
@TableIndex(name: 'idx_measurements_name_lower', columns: {#nameLower})
class Measurements extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().nullable()();

  /// Search key: lower-cased, Vietnamese diacritics folded (`foldForSearch`).
  TextColumn get nameLower => text().nullable()();
  IntColumn get type => intEnum<MeasurementType>()();
  IntColumn get status => intEnum<MeasurementStatus>()();
  TextColumn get notes => text().nullable()();

  // Cached stats (recomputed from points whenever geometry changes).
  RealColumn get areaM2 => real().named('area_m2').nullable()();
  RealColumn get perimeterM => real().named('perimeter_m').nullable()();
  RealColumn get distanceM => real().named('distance_m').nullable()();
  IntColumn get durationSec => integer().nullable()();
  IntColumn get pointCount => integer().withDefault(const Constant(0))();
  IntColumn get segmentCount => integer().withDefault(const Constant(0))();
  BoolColumn get isClosed => boolean().withDefault(const Constant(false))();
  BoolColumn get selfIntersects =>
      boolean().withDefault(const Constant(false))();

  IntColumn get mapStyle => intEnum<MapStyle>()();
  IntColumn get displayAreaUnit => intEnum<AreaUnit>().nullable()();
  IntColumn get displayDistanceUnit => intEnum<DistanceUnit>().nullable()();
  RealColumn get unitPrice => real().nullable()();
  TextColumn get unitPriceCurrency => text().nullable()();
  IntColumn get unitPriceArea => intEnum<AreaUnit>().nullable()();

  /// Relative to the app documents directory.
  TextColumn get thumbnailPath => text().nullable()();

  // Bounding box, for map fitting and future spatial queries.
  RealColumn get minLat => real().nullable()();
  RealColumn get minLng => real().nullable()();
  RealColumn get maxLat => real().nullable()();
  RealColumn get maxLng => real().nullable()();

  IntColumn get walkState => intEnum<WalkRunState>().nullable()();
  DateTimeColumn get walkStartedAt => dateTime().nullable()();
  IntColumn get walkElapsedSec => integer().nullable()();
  DateTimeColumn get walkLastResumeAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get savedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('PointRow')
@TableIndex(
  name: 'idx_points_measurement_order',
  columns: {#measurementId, #orderIndex},
)
class MeasurePoints extends Table {
  TextColumn get id => text()();
  TextColumn get measurementId => text().references(
    Measurements,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get orderIndex => integer()();
  IntColumn get segmentIndex => integer().withDefault(const Constant(0))();
  RealColumn get lat => real()();
  RealColumn get lng => real()();
  RealColumn get altitude => real().nullable()();
  RealColumn get accuracy => real().nullable()();
  RealColumn get speed => real().nullable()();
  RealColumn get bearing => real().nullable()();
  DateTimeColumn get timestamp => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('PhotoRow')
@TableIndex(
  name: 'idx_photos_measurement_sort',
  columns: {#measurementId, #sortIndex},
)
class Photos extends Table {
  TextColumn get id => text()();
  TextColumn get measurementId => text().references(
    Measurements,
    #id,
    onDelete: KeyAction.cascade,
  )();

  /// No FK: deleting a point sets this to null in code (`detachPoint`).
  TextColumn get pointId => text().nullable()();

  /// Relative to the app documents directory.
  TextColumn get filePath => text()();
  TextColumn get thumbPath => text()();
  DateTimeColumn get takenAt => dateTime()();
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
  TextColumn get caption => text().nullable()();
  IntColumn get source => intEnum<PhotoSource>()();
  IntColumn get width => integer()();
  IntColumn get height => integer()();
  IntColumn get bytes => integer()();
  IntColumn get sortIndex => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
