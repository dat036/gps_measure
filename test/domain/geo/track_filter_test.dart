import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/domain/geo/closure_detector.dart';
import 'package:gps_measurement/domain/geo/geo_calculator.dart';
import 'package:gps_measurement/domain/geo/track_filter.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/location_fix.dart';

import '../../helpers/gpx.dart';

void main() {
  final t0 = DateTime.utc(2026, 9, 28, 7);
  const origin = GeoPoint(lat: 21, lng: 105.8);

  /// Fix [east] meters east of origin, [seconds] after t0.
  LocationFix fix(
    double east,
    int seconds, {
    double accuracy = 5,
    bool mocked = false,
  }) => LocationFix(
    lat: origin.lat,
    lng: origin.lng + east / (111320 * 0.9335804),
    accuracy: accuracy,
    timestamp: t0.add(Duration(seconds: seconds)),
    isMocked: mocked,
  );

  ({List<GeoPoint> track, Map<TrackRejectReason, int> rejects}) run(
    List<LocationFix> fixes, {
    TrackFilterConfig config = const TrackFilterConfig(),
  }) {
    final filter = TrackFilter(config);
    final track = <GeoPoint>[];
    final rejects = <TrackRejectReason, int>{};
    for (final f in fixes) {
      final d = filter.process(f);
      if (d.accepted) {
        track.add(d.position!);
      } else {
        rejects[d.reason!] = (rejects[d.reason!] ?? 0) + 1;
      }
    }
    return (track: track, rejects: rejects);
  }

  const raw = TrackFilterConfig(smoothing: false);

  group('rules', () {
    test('first good fix is accepted', () {
      final f = TrackFilter(raw);
      expect(f.process(fix(0, 0)).accepted, isTrue);
      expect(f.lastAccepted, isNotNull);
    });

    test('rejects low accuracy, even as the first fix', () {
      final d = TrackFilter(raw).process(fix(0, 0, accuracy: 26));
      expect(d.reason, TrackRejectReason.lowAccuracy);
    });

    test('rejects non-finite accuracy', () {
      final d = TrackFilter(raw).process(fix(0, 0, accuracy: double.nan));
      expect(d.reason, TrackRejectReason.lowAccuracy);
    });

    test('rejects mocked locations', () {
      final d = TrackFilter(raw).process(fix(0, 0, mocked: true));
      expect(d.reason, TrackRejectReason.mocked);
    });

    test('rejects timestamps not after the last accepted fix', () {
      final f = TrackFilter(raw)..process(fix(0, 10));
      expect(f.process(fix(10, 10)).reason, TrackRejectReason.staleTimestamp);
      expect(f.process(fix(10, 5)).reason, TrackRejectReason.staleTimestamp);
    });

    test('rejects impossible speed', () {
      final f = TrackFilter(raw)..process(fix(0, 0));
      expect(f.process(fix(50, 2)).reason, TrackRejectReason.tooFast);
      expect(f.process(fix(20, 2)).accepted, isTrue); // 10 m/s ok
    });

    test('min distance is max(minDistance, 0.5 × accuracy)', () {
      final f = TrackFilter(raw)..process(fix(0, 0));
      expect(f.process(fix(2.5, 2)).reason, TrackRejectReason.tooClose);
      // accuracy 10 → needs 5 m.
      expect(
        f.process(fix(4, 4, accuracy: 10)).reason,
        TrackRejectReason.tooClose,
      );
      expect(f.process(fix(3.2, 6)).accepted, isTrue);
    });

    test('idle rule: ≥ 15 s and ≥ 1 m is accepted', () {
      final f = TrackFilter(raw)..process(fix(0, 0));
      expect(f.process(fix(1.5, 10)).reason, TrackRejectReason.tooClose);
      expect(f.process(fix(1.5, 15)).accepted, isTrue);
      expect(f.process(fix(1.8, 40)).reason, TrackRejectReason.tooClose);
    });

    test('reset starts a new segment (next fix accepted)', () {
      final f = TrackFilter(raw)..process(fix(0, 0));
      expect(f.process(fix(0.5, 2)).accepted, isFalse);
      f.reset();
      expect(f.lastAccepted, isNull);
      expect(f.process(fix(0.5, 3)).accepted, isTrue);
    });

    test('smoothing averages recent fixes weighted by 1/accuracy²', () {
      final f = TrackFilter()
        ..process(fix(0, 0))
        ..process(fix(1, 1, accuracy: 20)); // too close, but remembered
      final d = f.process(fix(10, 3));
      // Weights: 1/25, 1/400, 1/25 → pulled back from 10 m toward 0.
      final east = GeoCalculator.distance(origin, d.position!);
      expect(east, closeTo((0 * 16 + 1 * 1 + 10 * 16) / 33, 0.05));
    });
  });

  group('GPX fixtures (synthetic)', () {
    test('field loop: outliers removed, area within 5%', () {
      final result = run(loadGpx('field_loop.gpx'));
      expect(result.rejects[TrackRejectReason.lowAccuracy], 3);
      expect(result.rejects[TrackRejectReason.tooFast], 1);
      expect(result.rejects[TrackRejectReason.staleTimestamp], 1);

      final length = GeoCalculator.pathLength(result.track);
      expect(ClosureDetector.isClosed(result.track), isTrue);
      final area = GeoCalculator.area(result.track);
      printOnFailure(
        'field_loop: ${result.track.length} pts, '
        'length ${length.toStringAsFixed(1)} m, '
        'area ${area.toStringAsFixed(0)} m²',
      );
      // Truth: 6000 m² (area radius makes it ~6013), 320 m path.
      expect(area, closeTo(6013, 0.05 * 6013));
      expect(length, closeTo(320, 0.08 * 320));
    });

    test('stationary: jitter does not become distance', () {
      final result = run(loadGpx('stationary.gpx'));
      final length = GeoCalculator.pathLength(result.track);
      printOnFailure(
        'stationary: ${result.track.length} pts, '
        'length ${length.toStringAsFixed(1)} m',
      );
      // Regression bound, NOT a quality target: with the §7.3 rules
      // (esp. "≥ 15 s && ≥ 1 m") 3 min of σ 3 m jitter still adds ~60 m.
      // To be tuned with real recordings (plan P5-11 / Remote Config).
      expect(result.track.length, lessThanOrEqualTo(25));
      expect(length, lessThan(80));
    });

    test('road walk: mocked fixes skipped, length within 8%', () {
      final result = run(loadGpx('road_walk.gpx'));
      expect(result.rejects[TrackRejectReason.mocked], 2);
      final length = GeoCalculator.pathLength(result.track);
      printOnFailure(
        'road_walk: ${result.track.length} pts, '
        'length ${length.toStringAsFixed(1)} m, rejects ${result.rejects}',
      );
      expect(length, closeTo(400, 0.08 * 400));
      expect(ClosureDetector.isClosed(result.track), isFalse);
    });
  });
}
