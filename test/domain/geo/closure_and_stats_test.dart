import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/domain/geo/closure_detector.dart';
import 'package:gps_measurement/domain/geo/local_projection.dart';
import 'package:gps_measurement/domain/geo/stats_calculator.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';

void main() {
  final proj = LocalProjection(const GeoPoint(lat: 21, lng: 105.8));
  final t0 = DateTime.utc(2026, 9, 28);

  List<GeoPoint> geo(List<(double, double)> xy) => xy.map(proj.toGeo).toList();

  List<MeasurePoint> pts(List<(double, double)> xy, {int segment = 0}) => [
    for (final (i, g) in geo(xy).indexed)
      MeasurePoint(
        id: 's$segment-$i',
        orderIndex: i,
        lat: g.lat,
        lng: g.lng,
        timestamp: t0.add(Duration(seconds: i)),
        segmentIndex: segment,
        accuracy: 5,
      ),
  ];

  group('ClosureDetector', () {
    test('threshold = clamp(max(20, 5% length, 2×accuracy), 20, 60)', () {
      expect(ClosureDetector.threshold(pathLength: 100), 20);
      expect(ClosureDetector.threshold(pathLength: 800), 40);
      expect(ClosureDetector.threshold(pathLength: 5000), 60);
      expect(
        ClosureDetector.threshold(pathLength: 100, medianAccuracy: 15),
        30,
      );
      expect(
        ClosureDetector.threshold(pathLength: 100, medianAccuracy: 50),
        60,
      );
    });

    test('closed loop vs open path', () {
      final loop = geo([(0, 0), (100, 0), (100, 60), (0, 60), (0, 15)]);
      expect(ClosureDetector.isClosed(loop), isTrue);
      final open = geo([(0, 0), (100, 0), (100, 60), (0, 60), (0, 40)]);
      expect(ClosureDetector.isClosed(open), isFalse);
    });

    test('needs ≥ 4 points and ≥ 50 m', () {
      expect(ClosureDetector.isClosed(geo([(0, 0), (30, 0), (0, 5)])), isFalse);
      expect(
        ClosureDetector.isClosed(geo([(0, 0), (10, 0), (10, 10), (0, 5)])),
        isFalse,
      );
    });

    test('medianAccuracy', () {
      expect(ClosureDetector.medianAccuracy([null, 3, 9, 5]), 5);
      expect(ClosureDetector.medianAccuracy([4, 8]), 6);
      expect(ClosureDetector.medianAccuracy([null]), isNull);
    });
  });

  group('StatsCalculator', () {
    test('area: nothing until 3 points', () {
      final s = StatsCalculator.compute(
        MeasurementType.area,
        pts([(0, 0), (10, 0)]),
      );
      expect(s.areaM2, isNull);
      expect(s.perimeterM, isNull);
      expect(s.pointCount, 2);
      expect(
        StatsCalculator.compute(MeasurementType.area, const []).segmentCount,
        0,
      );
    });

    test('area: square 100 m', () {
      final s = StatsCalculator.compute(
        MeasurementType.area,
        pts([(0, 0), (100, 0), (100, 100), (0, 100)]),
        closed: true,
      );
      expect(s.areaM2, closeTo(10000 * 1.00224, 10));
      expect(s.perimeterM, closeTo(400, 0.5));
      expect(s.isClosed, isTrue);
      expect(s.selfIntersects, isFalse);
      expect(s.segmentCount, 1);
    });

    test('area: bow-tie flagged', () {
      final s = StatsCalculator.compute(
        MeasurementType.area,
        pts([(0, 0), (100, 100), (100, 0), (0, 100)]),
      );
      expect(s.selfIntersects, isTrue);
    });

    test('distance', () {
      final s = StatsCalculator.compute(
        MeasurementType.distance,
        pts([(0, 0), (300, 0), (300, 400)]),
      );
      expect(s.distanceM, closeTo(700, 0.5));
      expect(s.areaM2, isNull);
      expect(
        StatsCalculator.compute(
          MeasurementType.distance,
          pts([(0, 0)]),
        ).distanceM,
        isNull,
      );
    });

    test('walk: segments are not joined; area only when closed', () {
      final seg0 = pts([(0, 0), (100, 0)]);
      final seg1 = pts([(100, 60), (0, 60), (0, 10)], segment: 1);
      final s = StatsCalculator.compute(
        MeasurementType.walk,
        [...seg0, ...seg1],
        durationSec: 600,
      );
      // 100 + 100 + 50, the 60 m gap between segments is not counted.
      expect(s.distanceM, closeTo(250, 0.5));
      expect(s.segmentCount, 2);
      expect(s.durationSec, 600);
      expect(s.isClosed, isTrue);
      expect(s.areaM2, greaterThan(5000));
      expect(s.perimeterM, isNotNull);

      final open = StatsCalculator.compute(
        MeasurementType.walk,
        pts([(0, 0), (100, 0), (200, 0), (300, 0)]),
      );
      expect(open.isClosed, isFalse);
      expect(open.areaM2, isNull);
      expect(open.distanceM, closeTo(300, 0.5));
    });
  });
}
