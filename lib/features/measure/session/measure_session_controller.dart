import 'dart:async';

import 'package:collection/collection.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/core/utils/debouncer.dart';
import 'package:gps_measurement/core/utils/id_generator.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:gps_measurement/data/repositories/photo_repository.dart';
import 'package:gps_measurement/domain/editor/geometry_command.dart';
import 'package:gps_measurement/domain/editor/geometry_editor.dart';
import 'package:gps_measurement/domain/geo/stats_calculator.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';
import 'package:gps_measurement/features/measure/session/measure_session_state.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'measure_session_controller.g.dart';

/// Area/Distance measuring session (`architecture.md` §8).
///
/// Every geometry change goes through [GeometryEditor] (undo), recomputes
/// stats and is autosaved to the draft 300 ms later. The draft row is
/// created on the first point (or first photo). Writes are serialized so a
/// quick burst of edits can never save out of order. Leaving the screen
/// flushes pending changes; a draft left with no points and no photos is
/// deleted.
///
/// With [editing] (Edit of a saved measurement) the same editor works on a
/// copy and nothing is written: `EditController.saveChanges` does it.
@riverpod
class MeasureSessionController extends _$MeasureSessionController {
  static const Duration autosaveDelay = Duration(milliseconds: 300);

  late GeometryEditor _editor;
  late MeasurementRepository _repo;
  late PhotoRepository _photos;
  late Clock _clock;
  late IdGenerator _ids;
  final Debouncer _debouncer = Debouncer(autosaveDelay);

  /// Serializes repository writes.
  Future<void> _writes = Future.value();
  int _version = 0;
  int _savedVersion = 0;
  bool _disposed = false;

  /// Mirror of the state, still readable after disposal (final flush).
  /// Null until [build] finishes loading.
  MeasureSessionState? _loaded;
  MeasureSessionState get _latest => _loaded!;
  set _latest(MeasureSessionState value) => _loaded = value;

  /// Geometry as loaded (editing: to tell whether it changed).
  List<MeasurePoint> _originalPoints = const [];
  bool _originalClosed = false;

  @override
  Future<MeasureSessionState> build(
    MeasurementType type,
    String? draftId, {
    bool editing = false,
  }) async {
    _repo = ref.watch(measurementRepositoryProvider);
    _photos = ref.watch(photoRepositoryProvider);
    _clock = ref.watch(clockProvider);
    _ids = ref.watch(idGeneratorProvider);
    ref.onDispose(_onDispose);

    final mapStyle = ref
        .read(featureGateProvider)
        .effectiveMapStyle(ref.read(settingsProvider).mapStyle);
    final draft = draftId == null ? null : await _repo.get(draftId);
    if (draft == null) {
      _editor = GeometryEditor();
      return _latest = MeasureSessionState(type: type, mapStyle: mapStyle);
    }
    _editor = GeometryEditor(
      initial: GeometryState(
        points: draft.points,
        isClosed: draft.stats.isClosed,
      ),
    );
    _originalPoints = _editor.points;
    _originalClosed = _editor.isClosed;
    return _latest = MeasureSessionState(
      editing: editing,
      type: type,
      mapStyle: draft.mapStyle,
      measurementId: draft.id,
      points: _editor.points,
      isClosed: _editor.isClosed,
      stats: _stats(type),
      displayAreaUnit: draft.displayAreaUnit,
      displayDistanceUnit: draft.displayDistanceUnit,
    );
  }

  MeasureSessionState get _current => _latest;

  void _set(MeasureSessionState next) {
    _latest = next;
    if (!_disposed) state = AsyncData(next);
  }

  // ---------------------------------------------------------------- edits

  /// Adds a point at [at] (appended, or inserted at [atIndex]). Returns
  /// false when the shape is closed.
  bool addPointAt(
    GeoPoint at, {
    AddPointMethod method = AddPointMethod.crosshair,
    double? accuracy,
    int? atIndex,
  }) {
    if (!_current.canAddPoint) return false;
    _editor.addPoint(
      MeasurePoint(
        id: _ids.newId(),
        orderIndex: atIndex ?? _editor.points.length,
        lat: at.lat,
        lng: at.lng,
        accuracy: accuracy,
        timestamp: _clock.nowUtc(),
      ),
      atIndex: atIndex,
    );
    _commit(selectedPointId: null);
    return true;
  }

  /// Drag end. Selection follows the moved point.
  void movePoint(String id, GeoPoint to) {
    if (_editor.movePoint(id, to)) _commit(selectedPointId: id);
  }

  /// Toggles selection; null clears it.
  void selectPoint(String? id) {
    final next = id == _current.selectedPointId ? null : id;
    _set(_current.copyWith(selectedPointId: next));
  }

  /// Its photos stay, unattached (editing: done on Save Changes).
  void deleteSelected() {
    final id = _current.selectedPointId;
    if (id == null) return;
    if (!_editor.deletePoint(id)) return;
    _commit(selectedPointId: null);
    if (!_current.editing) {
      unawaited(_enqueue(() => _photos.detachPoint(id)));
    }
  }

  void undo() {
    if (_editor.undo()) _commit(selectedPointId: null);
  }

  void reset() {
    if (_editor.reset()) _commit(selectedPointId: null);
  }

  void closeShape() {
    if (_current.type == MeasurementType.area && _editor.close()) {
      _commit(selectedPointId: _current.selectedPointId);
    }
  }

  void reopenShape() {
    if (_editor.reopen()) _commit(selectedPointId: _current.selectedPointId);
  }

  // ---------------------------------------------------------------- meta
  // Display preferences are written at once, also while editing (they are
  // not part of "Save Changes"), without reordering the lists then.

  void setMapStyle(MapStyle style) {
    _set(_current.copyWith(mapStyle: style));
    final id = _current.measurementId;
    if (id != null) {
      unawaited(
        _enqueue(
          () => _repo.updateMeta(
            id,
            mapStyle: Value(style),
            touch: !_current.editing,
          ),
        ),
      );
    }
  }

  void setDisplayAreaUnit(AreaUnit unit) {
    _set(_current.copyWith(displayAreaUnit: unit));
    final id = _current.measurementId;
    if (id != null) {
      unawaited(
        _enqueue(
          () => _repo.updateMeta(
            id,
            displayAreaUnit: Value(unit),
            touch: !_current.editing,
          ),
        ),
      );
    }
  }

  void setDisplayDistanceUnit(DistanceUnit unit) {
    _set(_current.copyWith(displayDistanceUnit: unit));
    final id = _current.measurementId;
    if (id != null) {
      unawaited(
        _enqueue(
          () => _repo.updateMeta(
            id,
            displayDistanceUnit: Value(unit),
            touch: !_current.editing,
          ),
        ),
      );
    }
  }

  // ------------------------------------------------------------- persistence

  /// Draft id, creating the draft now if needed (a photo before any
  /// point).
  Future<String> ensureDraft() async {
    await flushNow();
    final existing = _latest.measurementId;
    if (existing != null) return existing;
    final draft = await _repo.createDraft(_latest.type, _latest.mapStyle);
    _set(_current.copyWith(measurementId: draft.id));
    return draft.id;
  }

  /// Flushes, then describes the draft left behind (null when there is
  /// none) — for the "Draft saved · Discard" snackbar when leaving.
  Future<({String id, int pointCount})?> flushAndDescribe() async {
    await flushNow();
    final id = _latest.measurementId;
    if (id == null || _latest.points.isEmpty) return null;
    return (id: id, pointCount: _latest.points.length);
  }

  /// Writes pending changes now (app paused, leaving the screen).
  Future<void> flushNow() {
    _debouncer.cancel();
    if (_latest.editing) return _writes;
    return _enqueue(_persist);
  }

  void _commit({required String? selectedPointId}) {
    final geometry = _editor.state;
    final keepSelection =
        selectedPointId != null &&
        geometry.points.any((p) => p.id == selectedPointId);
    _set(
      _current.copyWith(
        points: geometry.points,
        isClosed: geometry.isClosed,
        stats: _stats(_current.type),
        canUndo: _editor.canUndo,
        selectedPointId: keepSelection ? selectedPointId : null,
        geometryChanged:
            geometry.isClosed != _originalClosed ||
            !const ListEquality<MeasurePoint>().equals(
              geometry.points,
              _originalPoints,
            ),
      ),
    );
    if (_current.editing) return;
    _version++;
    _debouncer.run(() => unawaited(flushNow()));
  }

  MeasurementStats _stats(MeasurementType type) => StatsCalculator.compute(
    type,
    _editor.points,
    closed: _editor.isClosed,
  );

  Future<void> _enqueue(Future<void> Function() write) {
    return _writes = _writes.then((_) => write()).catchError((
      Object e,
      StackTrace st,
    ) {
      Log.e('Draft autosave failed', e, st);
      _set(_current.copyWith(saveFailed: true));
    });
  }

  Future<void> _persist() async {
    if (_version == _savedVersion) return;
    final version = _version;
    final snapshot = _current;
    var id = snapshot.measurementId;
    if (id == null) {
      if (snapshot.points.isEmpty) {
        _savedVersion = version;
        return;
      }
      final draft = await _repo.createDraft(snapshot.type, snapshot.mapStyle);
      id = draft.id;
      if (snapshot.displayAreaUnit != null ||
          snapshot.displayDistanceUnit != null) {
        await _repo.updateMeta(
          id,
          displayAreaUnit: Value(snapshot.displayAreaUnit),
          displayDistanceUnit: Value(snapshot.displayDistanceUnit),
        );
      }
      _set(_current.copyWith(measurementId: id));
    }
    await _repo.replacePoints(id, snapshot.points, snapshot.stats);
    _savedVersion = version;
    if (_current.saveFailed) {
      _set(_current.copyWith(saveFailed: false));
    }
  }

  void _onDispose() {
    _debouncer.cancel();
    _disposed = true;
    if (_loaded == null) return; // disposed while loading: nothing to save
    if (_latest.editing) return; // Edit writes only on Save Changes
    // Repositories outlive this provider, so these writes still complete.
    unawaited(
      _enqueue(() async {
        await _persist();
        final id = _latest.measurementId;
        if (id != null &&
            _latest.points.isEmpty &&
            await _photos.count(id) == 0) {
          await _repo.delete(id);
        }
      }),
    );
  }
}
