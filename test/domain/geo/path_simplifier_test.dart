import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/domain/geo/local_projection.dart';
import 'package:gps_measurement/domain/geo/path_simplifier.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';

void main() {
  final proj = LocalProjection(const GeoPoint(lat: 21, lng: 105.8));
  GeoPoint id(GeoPoint p) => p;

  test('short paths are returned untouched (same instance)', () {
    final path = [for (var i = 0; i < 10; i++) proj.toGeo((i * 1.0, 0))];
    expect(
      identical(PathSimplifier.simplifyForDisplay(path, id), path),
      isTrue,
    );
  });

  test('collinear points collapse to endpoints', () {
    final path = [for (var i = 0; i < 100; i++) proj.toGeo((i * 1.0, 0))];
    final s = PathSimplifier.simplify(path, id, toleranceM: 0.5);
    expect(s, [path.first, path.last]);
  });

  test('corners are kept; noise below tolerance removed', () {
    final rng = math.Random(7);
    final path = <GeoPoint>[
      for (var i = 0; i <= 100; i++)
        proj.toGeo((i.toDouble(), rng.nextDouble() * 0.2)),
      for (var i = 1; i <= 100; i++)
        proj.toGeo((100 + rng.nextDouble() * 0.2, i.toDouble())),
    ];
    final s = PathSimplifier.simplify(path, id, toleranceM: 1);
    expect(s.length, 3);
    expect(s[1], path[100]);
  });

  test('long tracks are simplified for display, order preserved', () {
    final path = [
      for (var i = 0; i < 6000; i++)
        proj.toGeo((i * 0.5, math.sin(i / 50) * 20)),
    ];
    final s = PathSimplifier.simplifyForDisplay(path, id);
    expect(s.length, lessThan(path.length));
    expect(s.first, path.first);
    expect(s.last, path.last);
    var last = -1;
    for (final p in s) {
      final i = path.indexOf(p);
      expect(i, greaterThan(last));
      last = i;
    }
  });

  test('handles tiny inputs and duplicate points', () {
    final p = proj.toGeo((0, 0));
    expect(PathSimplifier.simplify([p, p], id, toleranceM: 1), [p, p]);
    expect(PathSimplifier.simplify([p, p, p], id, toleranceM: 1), [p, p]);
  });
}
