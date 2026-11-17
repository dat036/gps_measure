import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';
import 'package:gps_measurement/domain/models/photo.dart';

part 'measurement.freezed.dart';

/// Draft and saved measurements share this model (and one DB table):
/// saving only changes [status].
@freezed
abstract class Measurement with _$Measurement {
  const factory Measurement({
    required String id,
    required MeasurementType type,
    required MeasurementStatus status,
    required MapStyle mapStyle,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? name,
    @Default(<MeasurePoint>[]) List<MeasurePoint> points,
    @Default(<Photo>[]) List<Photo> photos,
    String? notes,
    @Default(MeasurementStats.empty) MeasurementStats stats,
    AreaUnit? displayAreaUnit,
    DistanceUnit? displayDistanceUnit,

    /// Land value: price per [unitPriceArea] in [unitPriceCurrency].
    double? unitPrice,
    String? unitPriceCurrency,
    AreaUnit? unitPriceArea,
    String? thumbnailPath,
    DateTime? savedAt,
    WalkRunState? walkState,
    DateTime? walkStartedAt,
    int? walkElapsedSec,
    DateTime? walkLastResumeAt,
  }) = _Measurement;
}
