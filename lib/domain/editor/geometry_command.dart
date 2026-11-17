import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';

/// Editable geometry of an Area/Distance measurement.
class GeometryState {
  GeometryState({
    List<MeasurePoint> points = const [],
    this.isClosed = false,
  }) : points = List.unmodifiable(_reindex(points));

  static final GeometryState empty = GeometryState();

  /// Always ordered, with `orderIndex` == list index.
  final List<MeasurePoint> points;
  final bool isClosed;

  GeometryState copyWith({List<MeasurePoint>? points, bool? isClosed}) =>
      GeometryState(
        points: points ?? this.points,
        isClosed: isClosed ?? this.isClosed,
      );

  int indexOf(String id) => points.indexWhere((p) => p.id == id);

  static List<MeasurePoint> _reindex(List<MeasurePoint> points) => [
    for (var i = 0; i < points.length; i++)
      points[i].orderIndex == i ? points[i] : points[i].copyWith(orderIndex: i),
  ];
}

/// An undoable edit (`architecture.md` §7.5). Each command stores what it
/// needs to revert itself.
sealed class GeometryCommand {
  const GeometryCommand();

  GeometryState apply(GeometryState state);
  GeometryState revert(GeometryState state);
}

final class AddPoint extends GeometryCommand {
  const AddPoint(this.point, {this.atIndex});

  final MeasurePoint point;

  /// Insert position; null appends.
  final int? atIndex;

  @override
  GeometryState apply(GeometryState state) {
    final points = [...state.points];
    final index = (atIndex ?? points.length).clamp(0, points.length);
    points.insert(index, point);
    return state.copyWith(points: points);
  }

  @override
  GeometryState revert(GeometryState state) => state.copyWith(
    points: [...state.points.where((p) => p.id != point.id)],
  );
}

final class MovePoint extends GeometryCommand {
  const MovePoint(this.id, {required this.from, required this.to});

  final String id;
  final GeoPoint from;
  final GeoPoint to;

  @override
  GeometryState apply(GeometryState state) => _moveTo(state, to);

  @override
  GeometryState revert(GeometryState state) => _moveTo(state, from);

  GeometryState _moveTo(GeometryState state, GeoPoint target) => state.copyWith(
    points: [
      for (final p in state.points)
        p.id == id ? p.copyWith(lat: target.lat, lng: target.lng) : p,
    ],
  );
}

final class DeletePoint extends GeometryCommand {
  const DeletePoint(this.point, {required this.index});

  final MeasurePoint point;

  /// Where the point was, to restore it on undo.
  final int index;

  String get id => point.id;

  @override
  GeometryState apply(GeometryState state) => state.copyWith(
    points: [...state.points.where((p) => p.id != point.id)],
  );

  @override
  GeometryState revert(GeometryState state) =>
      AddPoint(point, atIndex: index).apply(state);
}

final class ResetGeometry extends GeometryCommand {
  const ResetGeometry(this.previous);

  final GeometryState previous;

  @override
  GeometryState apply(GeometryState state) => GeometryState.empty;

  @override
  GeometryState revert(GeometryState state) => previous;
}

final class CloseShape extends GeometryCommand {
  const CloseShape();

  @override
  GeometryState apply(GeometryState state) => state.copyWith(isClosed: true);

  @override
  GeometryState revert(GeometryState state) => state.copyWith(isClosed: false);
}

final class ReopenShape extends GeometryCommand {
  const ReopenShape();

  @override
  GeometryState apply(GeometryState state) => state.copyWith(isClosed: false);

  @override
  GeometryState revert(GeometryState state) => state.copyWith(isClosed: true);
}
