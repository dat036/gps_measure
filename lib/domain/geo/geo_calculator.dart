import 'dart:math' as math;

import 'package:gps_measurement/domain/geo/local_projection.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';

/// Spherical geometry on WGS84 lat/lng (`architecture.md` §7.1).
///
/// Distances use the mean Earth radius; areas use Google's equatorial radius
/// so results match `SphericalUtil.computeArea` / the Google Maps ruler.
abstract final class GeoCalculator {
  /// Mean Earth radius (IUGG), meters — for distances.
  static const double distanceRadius = 6371008.8;

  /// Radius used by Google Maps utils for areas, meters.
  static const double areaRadius = 6378137;

  static double _rad(double deg) => deg * math.pi / 180;
  static double _deg(double rad) => rad * 180 / math.pi;

  /// Great-circle (haversine) distance in meters.
  static double distance(GeoPoint a, GeoPoint b) {
    final dLat = _rad(b.lat - a.lat);
    final dLng = _rad(b.lng - a.lng);
    final h =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(_rad(a.lat)) *
            math.cos(_rad(b.lat)) *
            math.pow(math.sin(dLng / 2), 2);
    return 2 * distanceRadius * math.asin(math.min(1, math.sqrt(h)));
  }

  /// Length of each consecutive segment of [path].
  static List<double> segmentLengths(List<GeoPoint> path) => [
    for (var i = 1; i < path.length; i++) distance(path[i - 1], path[i]),
  ];

  /// Total length of an open path in meters.
  static double pathLength(List<GeoPoint> path) {
    var total = 0.0;
    for (var i = 1; i < path.length; i++) {
      total += distance(path[i - 1], path[i]);
    }
    return total;
  }

  /// Perimeter of a closed ring (path + closing edge). Fewer than 3 points
  /// is not a ring: returns the open path length.
  static double perimeter(List<GeoPoint> ring) {
    if (ring.length < 3) return pathLength(ring);
    return pathLength(ring) + distance(ring.last, ring.first);
  }

  /// Signed spherical area in m² (counter-clockwise positive), same formula
  /// as `SphericalUtil.computeSignedArea`.
  static double signedArea(List<GeoPoint> ring) {
    if (ring.length < 3) return 0;
    var total = 0.0;
    final prev = ring.last;
    var prevTan = math.tan((math.pi / 2 - _rad(prev.lat)) / 2);
    var prevLng = _rad(prev.lng);
    for (final p in ring) {
      final tan = math.tan((math.pi / 2 - _rad(p.lat)) / 2);
      final lng = _rad(p.lng);
      total += _polarTriangleArea(tan, lng, prevTan, prevLng);
      prevTan = tan;
      prevLng = lng;
    }
    return total * areaRadius * areaRadius;
  }

  /// Area of a closed ring in m².
  static double area(List<GeoPoint> ring) => signedArea(ring).abs();

  static double _polarTriangleArea(
    double tan1,
    double lng1,
    double tan2,
    double lng2,
  ) {
    final deltaLng = lng1 - lng2;
    final t = tan1 * tan2;
    return 2 * math.atan2(t * math.sin(deltaLng), 1 + t * math.cos(deltaLng));
  }

  /// Initial bearing from [a] to [b], degrees in [0, 360).
  static double bearing(GeoPoint a, GeoPoint b) {
    final lat1 = _rad(a.lat);
    final lat2 = _rad(b.lat);
    final dLng = _rad(b.lng - a.lng);
    final y = math.sin(dLng) * math.cos(lat2);
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLng);
    return (_deg(math.atan2(y, x)) + 360) % 360;
  }

  /// Point at [fraction] (0..1) along the great circle from [a] to [b].
  static GeoPoint interpolate(GeoPoint a, GeoPoint b, double fraction) {
    final lat1 = _rad(a.lat);
    final lng1 = _rad(a.lng);
    final lat2 = _rad(b.lat);
    final lng2 = _rad(b.lng);
    final d = distance(a, b) / distanceRadius;
    if (d < 1e-12) return a;
    final sinD = math.sin(d);
    final wa = math.sin((1 - fraction) * d) / sinD;
    final wb = math.sin(fraction * d) / sinD;
    final x =
        wa * math.cos(lat1) * math.cos(lng1) +
        wb * math.cos(lat2) * math.cos(lng2);
    final y =
        wa * math.cos(lat1) * math.sin(lng1) +
        wb * math.cos(lat2) * math.sin(lng2);
    final z = wa * math.sin(lat1) + wb * math.sin(lat2);
    return GeoPoint(
      lat: _deg(math.atan2(z, math.sqrt(x * x + y * y))),
      lng: _deg(math.atan2(y, x)),
    );
  }

  /// Point halfway along [path] by length (label position for Distance).
  static GeoPoint? midpointAlongPath(List<GeoPoint> path) {
    if (path.isEmpty) return null;
    if (path.length == 1) return path.first;
    final lengths = segmentLengths(path);
    var remaining = lengths.fold<double>(0, (a, b) => a + b) / 2;
    for (var i = 0; i < lengths.length; i++) {
      if (remaining <= lengths[i]) {
        final f = lengths[i] == 0 ? 0.0 : remaining / lengths[i];
        return interpolate(path[i], path[i + 1], f);
      }
      remaining -= lengths[i];
    }
    return path.last;
  }

  /// Area-weighted centroid of a ring (label position for Area). Falls back
  /// to the vertex average for degenerate rings.
  static GeoPoint? centroid(List<GeoPoint> ring) {
    if (ring.isEmpty) return null;
    final average = _vertexAverage(ring);
    if (ring.length < 3) return average;

    final proj = LocalProjection(average);
    final pts = ring.map(proj.toXY).toList();
    var a2 = 0.0;
    var cx = 0.0;
    var cy = 0.0;
    for (var i = 0; i < pts.length; i++) {
      final (x0, y0) = pts[i];
      final (x1, y1) = pts[(i + 1) % pts.length];
      final cross = x0 * y1 - x1 * y0;
      a2 += cross;
      cx += (x0 + x1) * cross;
      cy += (y0 + y1) * cross;
    }
    if (a2.abs() < 1e-9) return average;
    return proj.toGeo((cx / (3 * a2), cy / (3 * a2)));
  }

  static GeoPoint _vertexAverage(List<GeoPoint> pts) {
    var lat = 0.0;
    var lng = 0.0;
    for (final p in pts) {
      lat += p.lat;
      lng += p.lng;
    }
    return GeoPoint(lat: lat / pts.length, lng: lng / pts.length);
  }

  static GeoBounds? bounds(Iterable<GeoPoint> points) {
    final it = points.iterator;
    if (!it.moveNext()) return null;
    var minLat = it.current.lat;
    var maxLat = minLat;
    var minLng = it.current.lng;
    var maxLng = minLng;
    while (it.moveNext()) {
      final p = it.current;
      minLat = math.min(minLat, p.lat);
      maxLat = math.max(maxLat, p.lat);
      minLng = math.min(minLng, p.lng);
      maxLng = math.max(maxLng, p.lng);
    }
    return GeoBounds(
      minLat: minLat,
      minLng: minLng,
      maxLat: maxLat,
      maxLng: maxLng,
    );
  }
}
