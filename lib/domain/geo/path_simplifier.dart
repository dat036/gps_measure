import 'package:gps_measurement/domain/geo/local_projection.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';

/// Douglas–Peucker simplification for DISPLAY ONLY (`architecture.md`
/// §7.8). Stored data is never simplified.
abstract final class PathSimplifier {
  /// Paths up to this many points are drawn as-is.
  static const int displayThreshold = 5000;

  /// Returns [items] unchanged when short enough, otherwise the subset kept
  /// by Douglas–Peucker with [toleranceM]. First and last are always kept.
  static List<T> simplifyForDisplay<T>(
    List<T> items,
    GeoPoint Function(T item) positionOf, {
    double toleranceM = 1,
    int threshold = displayThreshold,
  }) {
    if (items.length <= threshold) return items;
    return simplify(items, positionOf, toleranceM: toleranceM);
  }

  static List<T> simplify<T>(
    List<T> items,
    GeoPoint Function(T item) positionOf, {
    required double toleranceM,
  }) {
    if (items.length < 3) return List.of(items);
    final proj = LocalProjection(positionOf(items.first));
    final pts = [for (final item in items) proj.toXY(positionOf(item))];
    final keep = List<bool>.filled(items.length, false);
    keep[0] = true;
    keep[items.length - 1] = true;
    final tol2 = toleranceM * toleranceM;

    // Iterative to avoid deep recursion on long tracks.
    final stack = <(int, int)>[(0, items.length - 1)];
    while (stack.isNotEmpty) {
      final (start, end) = stack.removeLast();
      var maxD = -1.0;
      var index = -1;
      for (var i = start + 1; i < end; i++) {
        final d = _segmentDistance2(pts[i], pts[start], pts[end]);
        if (d > maxD) {
          maxD = d;
          index = i;
        }
      }
      if (index != -1 && maxD > tol2) {
        keep[index] = true;
        stack
          ..add((start, index))
          ..add((index, end));
      }
    }
    return [
      for (var i = 0; i < items.length; i++)
        if (keep[i]) items[i],
    ];
  }

  /// Squared distance from [p] to segment [a]–[b].
  static double _segmentDistance2(
    (double, double) p,
    (double, double) a,
    (double, double) b,
  ) {
    final dx = b.$1 - a.$1;
    final dy = b.$2 - a.$2;
    final len2 = dx * dx + dy * dy;
    var t = len2 == 0 ? 0.0 : ((p.$1 - a.$1) * dx + (p.$2 - a.$2) * dy) / len2;
    t = t.clamp(0.0, 1.0);
    final x = a.$1 + t * dx - p.$1;
    final y = a.$2 + t * dy - p.$2;
    return x * x + y * y;
  }
}
