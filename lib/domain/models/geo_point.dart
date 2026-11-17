import 'package:freezed_annotation/freezed_annotation.dart';

part 'geo_point.freezed.dart';

/// WGS84 position in degrees.
@freezed
abstract class GeoPoint with _$GeoPoint {
  const factory GeoPoint({required double lat, required double lng}) =
      _GeoPoint;

  const GeoPoint._();

  bool get isValid =>
      lat.isFinite &&
      lng.isFinite &&
      lat >= -90 &&
      lat <= 90 &&
      lng >= -180 &&
      lng <= 180;
}

/// Lat/lng bounding box (no antimeridian handling — land parcels never
/// straddle it in practice).
@freezed
abstract class GeoBounds with _$GeoBounds {
  const factory GeoBounds({
    required double minLat,
    required double minLng,
    required double maxLat,
    required double maxLng,
  }) = _GeoBounds;

  const GeoBounds._();

  GeoPoint get center =>
      GeoPoint(lat: (minLat + maxLat) / 2, lng: (minLng + maxLng) / 2);

  bool contains(GeoPoint p) =>
      p.lat >= minLat && p.lat <= maxLat && p.lng >= minLng && p.lng <= maxLng;
}
