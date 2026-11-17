import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/domain/editor/geometry_command.dart';
import 'package:gps_measurement/domain/editor/geometry_editor.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';

void main() {
  final t0 = DateTime.utc(2026, 9, 28);
  MeasurePoint p(String id, double lat, {int order = 99}) => MeasurePoint(
    id: id,
    orderIndex: order,
    lat: lat,
    lng: 105,
    timestamp: t0,
  );

  List<String> ids(GeometryEditor e) => [for (final x in e.points) x.id];

  void expectIndexed(GeometryEditor e) {
    for (final (i, x) in e.points.indexed) {
      expect(x.orderIndex, i);
    }
  }

  test('add appends / inserts and reindexes; undo removes', () {
    final e = GeometryEditor()
      ..addPoint(p('a', 1))
      ..addPoint(p('c', 3))
      ..addPoint(p('b', 2), atIndex: 1);
    expect(ids(e), ['a', 'b', 'c']);
    expectIndexed(e);
    expect(e.undo(), isTrue);
    expect(ids(e), ['a', 'c']);
    expectIndexed(e);
  });

  test('insert index is clamped', () {
    final e = GeometryEditor()..addPoint(p('a', 1), atIndex: 5);
    expect(ids(e), ['a']);
  });

  test('move and undo', () {
    final e = GeometryEditor()..addPoint(p('a', 1));
    expect(e.movePoint('a', const GeoPoint(lat: 5, lng: 6)), isTrue);
    expect(e.points.single.lat, 5);
    expect(e.points.single.lng, 6);
    e.undo();
    expect(e.points.single.lat, 1);
    expect(e.points.single.lng, 105);
  });

  test('move to same place or unknown id is a no-op', () {
    final e = GeometryEditor()..addPoint(p('a', 1));
    final depth = e.undoDepth;
    expect(e.movePoint('a', const GeoPoint(lat: 1, lng: 105)), isFalse);
    expect(e.movePoint('x', const GeoPoint(lat: 1, lng: 1)), isFalse);
    expect(e.undoDepth, depth);
  });

  test('delete and undo restores position', () {
    final e = GeometryEditor()
      ..addPoint(p('a', 1))
      ..addPoint(p('b', 2))
      ..addPoint(p('c', 3));
    expect(e.deletePoint('b'), isTrue);
    expect(ids(e), ['a', 'c']);
    expectIndexed(e);
    e.undo();
    expect(ids(e), ['a', 'b', 'c']);
    expectIndexed(e);
    expect(e.deletePoint('zz'), isFalse);
  });

  test('close / reopen with rules and undo', () {
    final e = GeometryEditor()
      ..addPoint(p('a', 1))
      ..addPoint(p('b', 2));
    expect(e.close(), isFalse); // < 3 points
    e.addPoint(p('c', 3));
    expect(e.close(), isTrue);
    expect(e.isClosed, isTrue);
    expect(e.close(), isFalse); // already closed
    expect(e.reopen(), isTrue);
    expect(e.isClosed, isFalse);
    expect(e.reopen(), isFalse);
    e.undo(); // undo reopen
    expect(e.isClosed, isTrue);
    e.undo(); // undo close
    expect(e.isClosed, isFalse);
  });

  test('reset and undo restores everything', () {
    final e = GeometryEditor()
      ..addPoint(p('a', 1))
      ..addPoint(p('b', 2))
      ..addPoint(p('c', 3))
      ..close();
    expect(e.reset(), isTrue);
    expect(e.points, isEmpty);
    expect(e.isClosed, isFalse);
    e.undo();
    expect(ids(e), ['a', 'b', 'c']);
    expect(e.isClosed, isTrue);
    expect(GeometryEditor().reset(), isFalse);
  });

  test('every command reverts to the exact previous state', () {
    final e = GeometryEditor()
      ..addPoint(p('a', 1))
      ..addPoint(p('b', 2))
      ..addPoint(p('c', 3));
    final commands = <GeometryCommand>[
      AddPoint(p('d', 4), atIndex: 0),
      const MovePoint(
        'b',
        from: GeoPoint(lat: 2, lng: 105),
        to: GeoPoint(lat: 9, lng: 9),
      ),
      DeletePoint(e.points[2], index: 2),
      ResetGeometry(e.state),
      const CloseShape(),
    ];
    for (final c in commands) {
      final before = e.state;
      e
        ..execute(c)
        ..undo();
      expect(e.state.points, before.points, reason: c.runtimeType.toString());
      expect(e.state.isClosed, before.isClosed);
    }

    // Reopen is only valid on a closed shape (the editor guards it).
    e
      ..execute(const CloseShape())
      ..execute(const ReopenShape())
      ..undo();
    expect(e.isClosed, isTrue);
  });

  test('undo stack is capped at maxUndo', () {
    final e = GeometryEditor();
    for (var i = 0; i < 60; i++) {
      e.addPoint(p('p$i', i.toDouble()));
    }
    expect(e.undoDepth, 50);
    var undone = 0;
    while (e.undo()) {
      undone++;
    }
    expect(undone, 50);
    expect(e.points, hasLength(10));
    expect(e.canUndo, isFalse);
  });

  test('load replaces state and clears history', () {
    final e = GeometryEditor()
      ..addPoint(p('a', 1))
      ..load(GeometryState(points: [p('x', 1, order: 7)], isClosed: true));
    expect(ids(e), ['x']);
    expect(e.points.single.orderIndex, 0);
    expect(e.isClosed, isTrue);
    expect(e.canUndo, isFalse);
  });

  test('state points are unmodifiable', () {
    final e = GeometryEditor()..addPoint(p('a', 1));
    expect(() => e.points.add(p('b', 2)), throwsUnsupportedError);
    expect(e.state.indexOf('a'), 0);
  });
}
