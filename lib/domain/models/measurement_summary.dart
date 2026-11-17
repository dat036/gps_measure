import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gps_measurement/domain/models/enums.dart';

part 'measurement_summary.freezed.dart';

/// Lightweight row for lists — no points or photos loaded.
@freezed
abstract class MeasurementSummary with _$MeasurementSummary {
  const factory MeasurementSummary({
    required String id,
    required MeasurementType type,
    required MeasurementStatus status,
    required DateTime updatedAt,
    String? name,
    double? areaM2,
    double? perimeterM,
    double? distanceM,
    int? durationSec,
    @Default(0) int pointCount,
    @Default(0) int segmentCount,
    @Default(0) int photoCount,
    String? thumbnailPath,
    DateTime? savedAt,
    WalkRunState? walkState,
  }) = _MeasurementSummary;
}
