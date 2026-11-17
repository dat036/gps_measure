import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';

part 'measure_session_state.freezed.dart';

/// How a point was added (analytics `point_added{method}` in Phase 10).
enum AddPointMethod { crosshair, tap, gps }

/// State of an Area/Distance measuring session.
@freezed
abstract class MeasureSessionState with _$MeasureSessionState {
  const factory MeasureSessionState({
    required MeasurementType type,
    required MapStyle mapStyle,

    /// Draft id; null until the first point creates the draft.
    String? measurementId,
    @Default(<MeasurePoint>[]) List<MeasurePoint> points,
    @Default(false) bool isClosed,
    String? selectedPointId,
    @Default(MeasurementStats.empty) MeasurementStats stats,
    @Default(false) bool canUndo,
    AreaUnit? displayAreaUnit,
    DistanceUnit? displayDistanceUnit,

    /// The last autosave failed; retried on the next change / flush.
    @Default(false) bool saveFailed,

    /// Edit of a saved measurement (`plan.md` P7-08): nothing is written
    /// until "Save Changes".
    @Default(false) bool editing,

    /// Editing: the geometry differs from the saved one.
    @Default(false) bool geometryChanged,
  }) = _MeasureSessionState;

  const MeasureSessionState._();

  int get pointCount => points.length;

  /// Enough points for a result (and for Save).
  bool get hasResult => points.length >= type.minPoints;

  /// A closed Area takes no new points until reopened (Undo).
  bool get canAddPoint => !(type == MeasurementType.area && isClosed);

  bool get canClose =>
      type == MeasurementType.area &&
      !isClosed &&
      points.length >= MeasurementType.area.minPoints;

  int? get selectedIndex {
    if (selectedPointId == null) return null;
    final i = points.indexWhere((p) => p.id == selectedPointId);
    return i < 0 ? null : i;
  }
}
