import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';

part 'measure_point.freezed.dart';

/// A vertex of an Area/Distance shape or a recorded Walk fix.
@freezed
abstract class MeasurePoint with _$MeasurePoint {
  const factory MeasurePoint({
    required String id,
    required int orderIndex,
    required double lat,
    required double lng,
    required DateTime timestamp,

    /// Walk: incremented after each Resume. Area/Distance: always 0.
    @Default(0) int segmentIndex,
    double? altitude,

    /// Horizontal accuracy in meters (GPS points only).
    double? accuracy,
    double? speed,
    double? bearing,
  }) = _MeasurePoint;

  const MeasurePoint._();

  GeoPoint get position => GeoPoint(lat: lat, lng: lng);
}
