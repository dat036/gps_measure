import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gps_measurement/domain/geo/closure_detector.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/location_fix.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';

part 'walk_state.freezed.dart';

/// What the GPS banner shows (`design.md` §5.4, §5.16).
enum GpsStatus {
  /// No fix yet, or the last one is stale.
  searching,

  /// Latest fix is good enough to record.
  ready,

  /// Latest fix is worse than the Walk accuracy limit: not recorded.
  low,

  /// Device location service is off.
  off,

  /// Location permission refused.
  denied,

  /// Refused with "don't ask again": only system Settings can fix it.
  deniedForever,
}

/// State of the Walk screen (`WalkController`).
@freezed
abstract class WalkState with _$WalkState {
  const factory WalkState({
    required MapStyle mapStyle,

    /// False until `prepare()` has loaded the draft and checked permission.
    @Default(false) bool ready,
    @Default(WalkRunState.idle) WalkRunState runState,

    /// Draft id; null until Start Walking.
    String? measurementId,
    @Default(<MeasurePoint>[]) List<MeasurePoint> points,
    @Default(MeasurementStats.empty) MeasurementStats stats,

    /// Segment new points go to (incremented on every Resume).
    @Default(0) int segmentIndex,

    /// Total recorded time, seconds (updated every second while recording).
    @Default(0) int elapsedSec,
    @Default(GpsStatus.searching) GpsStatus gps,

    /// Latest raw fix (blue dot, accuracy halo) — recorded or not.
    LocationFix? lastFix,

    /// A mocked location was seen: those fixes are never recorded.
    @Default(false) bool mockDetected,
    AreaUnit? displayAreaUnit,
    DistanceUnit? displayDistanceUnit,

    /// The last write failed; retried on the next flush.
    @Default(false) bool saveFailed,
  }) = _WalkState;

  const WalkState._();

  bool get isRecording => runState == WalkRunState.recording;
  bool get isPaused => runState == WalkRunState.paused;
  bool get isFinished => runState == WalkRunState.finished;

  /// Start Walking needs permission, location on and at least one fix.
  bool get canStart =>
      ready &&
      runState == WalkRunState.idle &&
      lastFix != null &&
      (gps == GpsStatus.ready || gps == GpsStatus.low);

  /// Distance from the track's end to its start below which the loop is
  /// closed (circle drawn around Start).
  double get closureThresholdM => ClosureDetector.threshold(
    pathLength: stats.distanceM ?? 0,
    medianAccuracy: ClosureDetector.medianAccuracy(
      points.map((p) => p.accuracy),
    ),
  );

  /// Enough to save (at least one recorded point).
  bool get hasResult => points.length >= MeasurementType.walk.minPoints;
}
