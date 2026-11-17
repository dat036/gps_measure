import 'package:gps_measurement/domain/geo/geo_calculator.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/location_fix.dart';

/// Tunables for [TrackFilter]; values come from Remote Config
/// (`walk_max_accuracy_m`, `walk_min_distance_m`, `walk_max_speed_mps`,
/// `walk_smoothing`).
class TrackFilterConfig {
  const TrackFilterConfig({
    this.maxAccuracyM = 25,
    this.minDistanceM = 3,
    this.maxSpeedMps = 12,
    this.smoothing = true,
  });

  final double maxAccuracyM;
  final double minDistanceM;
  final double maxSpeedMps;
  final bool smoothing;

  /// A fix this old since the last accepted one is kept if it moved ≥ 1 m.
  static const Duration idleInterval = Duration(seconds: 15);
  static const double idleMinDistanceM = 1;

  /// Fixes averaged when [smoothing] is on.
  static const int smoothingWindow = 3;
}

enum TrackRejectReason {
  lowAccuracy,
  mocked,
  staleTimestamp,
  tooFast,
  tooClose,
}

class TrackDecision {
  const TrackDecision.accepted(GeoPoint this.position) : reason = null;
  const TrackDecision.rejected(TrackRejectReason this.reason) : position = null;

  /// Position to record (smoothed when enabled). Null when rejected.
  final GeoPoint? position;
  final TrackRejectReason? reason;

  bool get accepted => position != null;
}

/// Walk GPS noise filter (`architecture.md` §7.3). Stateful: feed fixes in
/// time order; call [reset] when a new segment starts (after Resume).
///
/// Rules, in order:
/// reject accuracy > max · reject mocked · reject timestamp ≤ last ·
/// reject speed > max · accept first · accept d ≥ max(minDistance,
/// 0.5×accuracy) · accept dt ≥ 15 s && d ≥ 1 m · else reject.
/// "last" is the last accepted raw fix.
class TrackFilter {
  TrackFilter([this.config = const TrackFilterConfig()]);

  TrackFilterConfig config;

  LocationFix? _last;

  /// Recent fixes that passed the quality gates (accuracy, mock, time,
  /// speed) — including ones rejected as too close, which still carry
  /// information about the current position.
  final List<LocationFix> _window = [];

  LocationFix? get lastAccepted => _last;

  void reset() {
    _last = null;
    _window.clear();
  }

  TrackDecision process(LocationFix fix) {
    if (!fix.accuracy.isFinite || fix.accuracy > config.maxAccuracyM) {
      return const TrackDecision.rejected(TrackRejectReason.lowAccuracy);
    }
    if (fix.isMocked) {
      return const TrackDecision.rejected(TrackRejectReason.mocked);
    }

    final last = _last;
    if (last == null) return _accept(fix);

    if (!fix.timestamp.isAfter(last.timestamp)) {
      return const TrackDecision.rejected(TrackRejectReason.staleTimestamp);
    }
    final d = GeoCalculator.distance(last.position, fix.position);
    final dt = fix.timestamp.difference(last.timestamp);
    final seconds = dt.inMicroseconds / Duration.microsecondsPerSecond;
    if (d / seconds > config.maxSpeedMps) {
      return const TrackDecision.rejected(TrackRejectReason.tooFast);
    }

    _remember(fix);
    final minMove = config.minDistanceM > 0.5 * fix.accuracy
        ? config.minDistanceM
        : 0.5 * fix.accuracy;
    if (d >= minMove) return _accept(fix, remembered: true);
    if (dt >= TrackFilterConfig.idleInterval &&
        d >= TrackFilterConfig.idleMinDistanceM) {
      return _accept(fix, remembered: true);
    }
    return const TrackDecision.rejected(TrackRejectReason.tooClose);
  }

  TrackDecision _accept(LocationFix fix, {bool remembered = false}) {
    if (!remembered) _remember(fix);
    _last = fix;
    return TrackDecision.accepted(
      config.smoothing ? _smoothed() : fix.position,
    );
  }

  void _remember(LocationFix fix) {
    _window.add(fix);
    if (_window.length > TrackFilterConfig.smoothingWindow) {
      _window.removeAt(0);
    }
  }

  /// Weighted mean of the window, weights 1/accuracy².
  GeoPoint _smoothed() {
    var wSum = 0.0;
    var lat = 0.0;
    var lng = 0.0;
    for (final f in _window) {
      final acc = f.accuracy < 1 ? 1.0 : f.accuracy;
      final w = 1 / (acc * acc);
      wSum += w;
      lat += f.lat * w;
      lng += f.lng * w;
    }
    return GeoPoint(lat: lat / wSum, lng: lng / wSum);
  }
}
