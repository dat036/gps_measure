import 'package:gps_measurement/domain/geo/closure_detector.dart';
import 'package:gps_measurement/domain/geo/geo_calculator.dart';
import 'package:gps_measurement/domain/geo/polygon_validator.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';

/// Recomputes [MeasurementStats] from points (`architecture.md` §5.2: stats
/// are always derived, then cached).
abstract final class StatsCalculator {
  static MeasurementStats compute(
    MeasurementType type,
    List<MeasurePoint> points, {
    bool closed = false,
    int? durationSec,
  }) {
    return switch (type) {
      MeasurementType.area => _area(points, closed: closed),
      MeasurementType.distance => _distance(points),
      MeasurementType.walk => _walk(points, durationSec: durationSec),
    };
  }

  static List<GeoPoint> _positions(List<MeasurePoint> points) => [
    for (final p in points) p.position,
  ];

  static MeasurementStats _area(
    List<MeasurePoint> points, {
    required bool closed,
  }) {
    final ring = _positions(points);
    final enough = ring.length >= MeasurementType.area.minPoints;
    return MeasurementStats(
      areaM2: enough ? GeoCalculator.area(ring) : null,
      perimeterM: enough ? GeoCalculator.perimeter(ring) : null,
      pointCount: ring.length,
      segmentCount: ring.isEmpty ? 0 : 1,
      isClosed: closed,
      selfIntersects: enough && PolygonValidator.selfIntersects(ring),
    );
  }

  static MeasurementStats _distance(List<MeasurePoint> points) {
    final path = _positions(points);
    final enough = path.length >= MeasurementType.distance.minPoints;
    return MeasurementStats(
      distanceM: enough ? GeoCalculator.pathLength(path) : null,
      pointCount: path.length,
      segmentCount: path.isEmpty ? 0 : 1,
    );
  }

  /// Distance = sum of each segment's length (no line between segments).
  /// Area only when the whole track returns to its start.
  static MeasurementStats _walk(
    List<MeasurePoint> points, {
    int? durationSec,
  }) {
    final segments = <int, List<GeoPoint>>{};
    for (final p in points) {
      (segments[p.segmentIndex] ??= []).add(p.position);
    }
    var distance = 0.0;
    for (final segment in segments.values) {
      distance += GeoCalculator.pathLength(segment);
    }

    final track = _positions(points);
    final closed = ClosureDetector.isClosed(
      track,
      pathLength: distance,
      medianAccuracy: ClosureDetector.medianAccuracy(
        points.map((p) => p.accuracy),
      ),
    );
    return MeasurementStats(
      distanceM: distance,
      areaM2: closed ? GeoCalculator.area(track) : null,
      perimeterM: closed ? GeoCalculator.perimeter(track) : null,
      durationSec: durationSec,
      pointCount: points.length,
      segmentCount: segments.length,
      isClosed: closed,
      selfIntersects: closed && PolygonValidator.selfIntersects(track),
    );
  }
}
