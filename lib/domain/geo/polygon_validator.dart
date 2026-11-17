import 'package:gps_measurement/domain/geo/geo_calculator.dart';
import 'package:gps_measurement/domain/geo/local_projection.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';

/// Sanity checks for Area rings (`architecture.md` §7.2).
abstract final class PolygonValidator {
  /// Above this many vertices the O(n²) check is skipped.
  static const int maxCheckedVertices = 300;

  /// Rings smaller than this are considered degenerate.
  static const double minAreaM2 = 0.5;

  /// True when two non-adjacent edges of the closed [ring] cross or overlap
  /// (the computed area would then be wrong).
  static bool selfIntersects(List<GeoPoint> ring) {
    final n = ring.length;
    if (n < 4 || n > maxCheckedVertices) return false;

    final proj = LocalProjection(ring.first);
    final pts = ring.map(proj.toXY).toList();

    for (var i = 0; i < n; i++) {
      final a1 = pts[i];
      final a2 = pts[(i + 1) % n];
      // j > i + 1 skips the edge adjacent after i; the closing edge (n-1)
      // is adjacent to edge 0, so skip that pair too.
      for (var j = i + 2; j < n; j++) {
        if (i == 0 && j == n - 1) continue;
        final b1 = pts[j];
        final b2 = pts[(j + 1) % n];
        if (_segmentsIntersect(a1, a2, b1, b2)) return true;
      }
    }
    return false;
  }

  /// Fewer than 3 distinct points, or an area under [minAreaM2].
  static bool isDegenerate(List<GeoPoint> ring) {
    if (ring.toSet().length < 3) return true;
    return GeoCalculator.area(ring) < minAreaM2;
  }

  static const double _eps = 1e-9;

  static bool _segmentsIntersect(
    (double, double) p1,
    (double, double) p2,
    (double, double) q1,
    (double, double) q2,
  ) {
    final d1 = _orient(q1, q2, p1);
    final d2 = _orient(q1, q2, p2);
    final d3 = _orient(p1, p2, q1);
    final d4 = _orient(p1, p2, q2);

    if (((d1 > _eps && d2 < -_eps) || (d1 < -_eps && d2 > _eps)) &&
        ((d3 > _eps && d4 < -_eps) || (d3 < -_eps && d4 > _eps))) {
      return true;
    }
    // Collinear / touching cases.
    if (d1.abs() <= _eps && _onSegment(q1, q2, p1)) return true;
    if (d2.abs() <= _eps && _onSegment(q1, q2, p2)) return true;
    if (d3.abs() <= _eps && _onSegment(p1, p2, q1)) return true;
    if (d4.abs() <= _eps && _onSegment(p1, p2, q2)) return true;
    return false;
  }

  static double _orient(
    (double, double) a,
    (double, double) b,
    (double, double) c,
  ) => (b.$1 - a.$1) * (c.$2 - a.$2) - (b.$2 - a.$2) * (c.$1 - a.$1);

  static bool _onSegment(
    (double, double) a,
    (double, double) b,
    (double, double) p,
  ) {
    final minX = a.$1 < b.$1 ? a.$1 : b.$1;
    final maxX = a.$1 > b.$1 ? a.$1 : b.$1;
    final minY = a.$2 < b.$2 ? a.$2 : b.$2;
    final maxY = a.$2 > b.$2 ? a.$2 : b.$2;
    return p.$1 >= minX - _eps &&
        p.$1 <= maxX + _eps &&
        p.$2 >= minY - _eps &&
        p.$2 <= maxY + _eps;
  }
}
