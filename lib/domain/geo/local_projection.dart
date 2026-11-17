import 'dart:math' as math;

import 'package:gps_measurement/domain/models/geo_point.dart';

/// Equirectangular projection to meters around [origin]. Accurate for the
/// planar tests we need (edge crossing, centroid, simplification) at parcel
/// scale (≤ a few km); not used for area or distance results.
class LocalProjection {
  LocalProjection(this.origin) : _cosLat = math.cos(origin.lat * math.pi / 180);

  static const double _r = 6371008.8;
  static const double _degToRad = math.pi / 180;

  final GeoPoint origin;
  final double _cosLat;

  (double, double) toXY(GeoPoint p) => (
    (p.lng - origin.lng) * _degToRad * _r * _cosLat,
    (p.lat - origin.lat) * _degToRad * _r,
  );

  GeoPoint toGeo((double, double) xy) => GeoPoint(
    lat: origin.lat + xy.$2 / (_r * _degToRad),
    lng: origin.lng + xy.$1 / (_r * _degToRad * _cosLat),
  );
}
