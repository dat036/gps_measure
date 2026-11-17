import 'package:gps_measurement/domain/geo/geo_calculator.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';

/// Decides whether a Walk track returned to its start (`architecture.md`
/// §7.4), so an area can be computed.
abstract final class ClosureDetector {
  static const double minThresholdM = 20;
  static const double maxThresholdM = 60;
  static const double minPathLengthM = 50;
  static const int minPoints = 4;

  /// Distance to the start under which the loop counts as closed.
  static double threshold({
    required double pathLength,
    double? medianAccuracy,
  }) {
    var t = minThresholdM;
    t = t > 0.05 * pathLength ? t : 0.05 * pathLength;
    if (medianAccuracy != null && 2 * medianAccuracy > t) {
      t = 2 * medianAccuracy;
    }
    return t.clamp(minThresholdM, maxThresholdM);
  }

  static bool isClosed(
    List<GeoPoint> track, {
    double? pathLength,
    double? medianAccuracy,
  }) {
    if (track.length < minPoints) return false;
    final length = pathLength ?? GeoCalculator.pathLength(track);
    if (length < minPathLengthM) return false;
    final gap = GeoCalculator.distance(track.first, track.last);
    return gap <= threshold(pathLength: length, medianAccuracy: medianAccuracy);
  }

  /// Median of the non-null accuracies, or null if none.
  static double? medianAccuracy(Iterable<double?> accuracies) {
    final values = accuracies.nonNulls.toList()..sort();
    if (values.isEmpty) return null;
    final mid = values.length ~/ 2;
    return values.length.isOdd
        ? values[mid]
        : (values[mid - 1] + values[mid]) / 2;
  }
}
