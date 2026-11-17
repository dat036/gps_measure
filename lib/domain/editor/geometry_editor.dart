import 'package:gps_measurement/domain/editor/geometry_command.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';

/// Applies [GeometryCommand]s with an undo stack (max [maxUndo]).
/// Pure Dart; the session/edit controllers own one instance each.
class GeometryEditor {
  GeometryEditor({GeometryState? initial, this.maxUndo = 50})
    : _state = initial ?? GeometryState.empty;

  final int maxUndo;
  GeometryState _state;
  final List<GeometryCommand> _undo = [];

  GeometryState get state => _state;
  List<MeasurePoint> get points => _state.points;
  bool get isClosed => _state.isClosed;
  bool get canUndo => _undo.isNotEmpty;
  int get undoDepth => _undo.length;

  GeometryState execute(GeometryCommand command) {
    _state = command.apply(_state);
    _undo.add(command);
    if (_undo.length > maxUndo) _undo.removeAt(0);
    return _state;
  }

  /// Reverts the last command. Returns false when there is nothing to undo.
  bool undo() {
    if (_undo.isEmpty) return false;
    _state = _undo.removeLast().revert(_state);
    return true;
  }

  /// Replaces the whole state (e.g. loading a draft) and clears history.
  void load(GeometryState state) {
    _state = state;
    _undo.clear();
  }

  // Convenience builders ---------------------------------------------------

  void addPoint(MeasurePoint point, {int? atIndex}) =>
      execute(AddPoint(point, atIndex: atIndex));

  /// No-op (and no undo entry) if the point is missing or did not move.
  bool movePoint(String id, GeoPoint to) {
    final index = _state.indexOf(id);
    if (index < 0) return false;
    final from = _state.points[index].position;
    if (from == to) return false;
    execute(MovePoint(id, from: from, to: to));
    return true;
  }

  bool deletePoint(String id) {
    final index = _state.indexOf(id);
    if (index < 0) return false;
    execute(DeletePoint(_state.points[index], index: index));
    return true;
  }

  bool reset() {
    if (_state.points.isEmpty && !_state.isClosed) return false;
    execute(ResetGeometry(_state));
    return true;
  }

  /// Closing needs at least [MeasurementType.area] minimum points.
  bool close() {
    if (_state.isClosed ||
        _state.points.length < MeasurementType.area.minPoints) {
      return false;
    }
    execute(const CloseShape());
    return true;
  }

  bool reopen() {
    if (!_state.isClosed) return false;
    execute(const ReopenShape());
    return true;
  }
}
