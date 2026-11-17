import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';

part 'location_fix.freezed.dart';

/// A raw GPS reading, before `TrackFilter` decides whether to record it.
@freezed
abstract class LocationFix with _$LocationFix {
  const factory LocationFix({
    required double lat,
    required double lng,

    /// Horizontal accuracy (meters, 68% radius).
    required double accuracy,
    required DateTime timestamp,
    double? altitude,
    double? speed,
    double? bearing,
    @Default(false) bool isMocked,
  }) = _LocationFix;

  const LocationFix._();

  GeoPoint get position => GeoPoint(lat: lat, lng: lng);
}
