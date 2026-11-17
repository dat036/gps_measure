import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/domain/geo/geo_calculator.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';

void main() {
  group('area_cases.json (independent reference values)', () {
    final cases =
        (json.decode(File('test/fixtures/area_cases.json').readAsStringSync())
                as List<dynamic>)
            .cast<Map<String, dynamic>>();

    test('has at least 6 cases', () => expect(cases.length, greaterThan(6)));

    for (final c in cases) {
      final ring = [
        for (final p in (c['points'] as List<dynamic>).cast<List<dynamic>>())
          GeoPoint(
            lat: (p[0] as num).toDouble(),
            lng: (p[1] as num).toDouble(),
          ),
      ];
      final expectedArea = (c['area_m2'] as num).toDouble();
      final expectedPerimeter = (c['perimeter_m'] as num).toDouble();

      test('${c['name']} — area error ≤ 0.1%', () {
        final area = GeoCalculator.area(ring);
        expect((area - expectedArea).abs() / expectedArea, lessThan(0.001));
        // Orientation-independent.
        expect(
          GeoCalculator.area(ring.reversed.toList()),
          closeTo(area, area * 1e-9),
        );
      });

      test('${c['name']} — perimeter error ≤ 0.1%', () {
        final p = GeoCalculator.perimeter(ring);
        expect(
          (p - expectedPerimeter).abs() / expectedPerimeter,
          lessThan(0.001),
        );
      });
    }
  });

  const hanoi = GeoPoint(lat: 21.0285, lng: 105.8542);
  const hcmc = GeoPoint(lat: 10.8231, lng: 106.6297);

  test('distance: Hanoi → HCMC ≈ 1,137 km', () {
    expect(GeoCalculator.distance(hanoi, hcmc), closeTo(1137e3, 3e3));
    expect(GeoCalculator.distance(hanoi, hanoi), 0);
  });

  test('signed area: counter-clockwise positive', () {
    const ccw = [
      GeoPoint(lat: 0, lng: 0),
      GeoPoint(lat: 0, lng: 0.001),
      GeoPoint(lat: 0.001, lng: 0.001),
    ];
    expect(GeoCalculator.signedArea(ccw), greaterThan(0));
    expect(GeoCalculator.signedArea(ccw.reversed.toList()), lessThan(0));
  });

  test('fewer than 3 points has no area; perimeter = open path', () {
    const two = [hanoi, GeoPoint(lat: 21.0295, lng: 105.8542)];
    expect(GeoCalculator.area(two), 0);
    expect(GeoCalculator.perimeter(two), GeoCalculator.pathLength(two));
    expect(GeoCalculator.pathLength(const []), 0);
    expect(GeoCalculator.segmentLengths(two), hasLength(1));
  });

  test('bearing', () {
    const north = GeoPoint(lat: 22, lng: 105.8542);
    const east = GeoPoint(lat: 21.0285, lng: 106.8542);
    expect(GeoCalculator.bearing(hanoi, north), closeTo(0, 1e-9));
    expect(GeoCalculator.bearing(hanoi, east), closeTo(90, 0.2));
    expect(GeoCalculator.bearing(north, hanoi), closeTo(180, 1e-9));
  });

  test('interpolate', () {
    const b = GeoPoint(lat: 21.0385, lng: 105.8542);
    final mid = GeoCalculator.interpolate(hanoi, b, 0.5);
    expect(mid.lat, closeTo(21.0335, 1e-9));
    expect(mid.lng, closeTo(105.8542, 1e-9));
    expect(GeoCalculator.interpolate(hanoi, hanoi, 0.5), hanoi);
  });

  test('midpointAlongPath splits by length', () {
    const path = [
      GeoPoint(lat: 0, lng: 0),
      GeoPoint(lat: 0, lng: 0.001),
      GeoPoint(lat: 0, lng: 0.004),
    ];
    final m = GeoCalculator.midpointAlongPath(path)!;
    expect(m.lng, closeTo(0.002, 1e-9));
    expect(GeoCalculator.midpointAlongPath(const []), isNull);
    expect(GeoCalculator.midpointAlongPath(const [hanoi]), hanoi);
    // Zero-length path returns a point on it.
    expect(GeoCalculator.midpointAlongPath(const [hanoi, hanoi]), hanoi);
  });

  test('centroid of a square is its center', () {
    const sq = [
      GeoPoint(lat: 10, lng: 106),
      GeoPoint(lat: 10, lng: 106.002),
      GeoPoint(lat: 10.002, lng: 106.002),
      GeoPoint(lat: 10.002, lng: 106),
    ];
    final c = GeoCalculator.centroid(sq)!;
    expect(c.lat, closeTo(10.001, 1e-7));
    expect(c.lng, closeTo(106.001, 1e-7));
    expect(GeoCalculator.centroid(const []), isNull);
    // Degenerate (collinear) → vertex average.
    const line = [
      GeoPoint(lat: 0, lng: 0),
      GeoPoint(lat: 0, lng: 1),
      GeoPoint(lat: 0, lng: 2),
    ];
    expect(GeoCalculator.centroid(line)!.lng, closeTo(1, 1e-12));
    expect(GeoCalculator.centroid(const [hanoi]), hanoi);
  });

  test('bounds', () {
    expect(GeoCalculator.bounds(const []), isNull);
    final b = GeoCalculator.bounds(const [hanoi, hcmc])!;
    expect(b.minLat, hcmc.lat);
    expect(b.maxLat, hanoi.lat);
    expect(b.minLng, hanoi.lng);
    expect(b.maxLng, hcmc.lng);
    expect(b.contains(b.center), isTrue);
    expect(b.contains(const GeoPoint(lat: 30, lng: 106)), isFalse);
  });
}
