import 'package:freezed_annotation/freezed_annotation.dart';

part 'measurement_stats.freezed.dart';

/// Derived numbers, always recomputed from points when the geometry changes
/// (`StatsCalculator`) and cached in the DB for fast lists.
@freezed
abstract class MeasurementStats with _$MeasurementStats {
  const factory MeasurementStats({
    double? areaM2,
    double? perimeterM,
    double? distanceM,
    int? durationSec,
    @Default(0) int pointCount,
    @Default(0) int segmentCount,
    @Default(false) bool isClosed,
    @Default(false) bool selfIntersects,
  }) = _MeasurementStats;

  static const MeasurementStats empty = MeasurementStats();
}
