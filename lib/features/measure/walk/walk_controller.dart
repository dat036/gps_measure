import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:gps_measurement/core/location/location_service.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/core/utils/id_generator.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:gps_measurement/domain/geo/stats_calculator.dart';
import 'package:gps_measurement/domain/geo/track_filter.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/location_fix.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';
import 'package:gps_measurement/features/measure/walk/location_tracker.dart';
import 'package:gps_measurement/features/measure/walk/walk_state.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'walk_controller.g.dart';

/// Walk noise-filter tunables.
// TODO(phase-10): read walk_* keys from Remote Config.
@Riverpod(keepAlive: true)
TrackFilterConfig trackFilterConfig(Ref ref) => const TrackFilterConfig();

/// Walk & Measure recording (`architecture.md` §8).
///
/// `LocationTracker` fixes → [TrackFilter] → appended to the current
/// segment → stats → buffered and flushed to the draft every
/// [flushEveryPoints] points or [flushInterval] (Pause/Finish/app in
/// background flush at once). keepAlive: recording must survive rebuilds
/// and routes pushed on top of the Walk screen.
///
/// Elapsed time = seconds banked at the last Pause + (now − last Resume).
/// While recording, `walk_elapsed_sec` in the DB holds the total at the last
/// flush, so a crash loses at most [flushInterval].
@Riverpod(keepAlive: true)
class WalkController extends _$WalkController {
  static const int flushEveryPoints = 5;
  static const Duration flushInterval = Duration(seconds: 10);

  /// Without a fix for this long, the banner goes back to "Searching".
  static const Duration staleFixAfter = Duration(seconds: 15);

  /// Delay before re-subscribing after the position stream failed.
  static const Duration retryDelay = Duration(seconds: 3);

  late MeasurementRepository _repo;
  late LocationTracker _tracker;
  late LocationService _location;
  late Clock _clock;
  late IdGenerator _ids;
  late TrackFilter _filter;

  WalkNotificationText? _notification;
  // Both cancelled in _stopStreams / _cancelFixSubscription.
  // ignore: cancel_subscriptions
  StreamSubscription<LocationFix>? _fixSub;
  bool _fixSubRecording = false;
  // Cancelled in _stopStreams.
  // ignore: cancel_subscriptions
  StreamSubscription<bool>? _serviceSub;
  Timer? _ticker;
  Timer? _retry;

  /// Serializes stream switches (geolocator allows one stream at a time).
  Future<void> _streamOps = Future.value();

  /// Serializes repository writes.
  Future<void> _writes = Future.value();
  Future<({String id, int pointCount})?>? _leaving;

  int _elapsedBase = 0;
  DateTime? _resumedAt;
  DateTime? _lastFixAt;
  DateTime? _lastFlushAt;
  final List<MeasurePoint> _buffer = [];

  @override
  WalkState build() {
    _repo = ref.watch(measurementRepositoryProvider);
    _tracker = ref.watch(locationTrackerProvider);
    _location = ref.watch(locationServiceProvider);
    _clock = ref.watch(clockProvider);
    _ids = ref.watch(idGeneratorProvider);
    _filter = TrackFilter(ref.watch(trackFilterConfigProvider));
    ref.onDispose(() => unawaited(_stopStreams()));
    return _initial();
  }

  WalkState _initial() => WalkState(
    mapStyle: ref
        .read(featureGateProvider)
        .effectiveMapStyle(ref.read(settingsProvider).mapStyle),
  );

  // ------------------------------------------------------------- lifecycle

  /// Opens the Walk screen: loads [draftId] (a walk left paused/finished)
  /// or starts fresh, checks location access and starts the preview
  /// stream (asking is the screen's job: pre-prompt, `PermissionFlows`).
  /// Re-entering for the walk already in memory keeps it.
  Future<void> prepare({
    required WalkNotificationText notification,
    String? draftId,
  }) async {
    _notification = notification;
    await _leaving;
    final current = state;
    if (current.ready &&
        current.measurementId != null &&
        current.measurementId == draftId) {
      await refreshAccess();
      return;
    }

    // Another walk still in memory (screen closed without leaving): save
    // it first.
    if (current.measurementId != null) await leave();
    await _stopStreams();
    _resetRuntime();
    var next = _initial();
    if (draftId != null) {
      final loaded = await _load(draftId);
      if (loaded != null) next = loaded;
    }
    state = next;
    await refreshAccess();
    state = state.copyWith(ready: true);
  }

  Future<WalkState?> _load(String id) async {
    try {
      final m = await _repo.get(id);
      if (m == null || m.type != MeasurementType.walk) return null;
      final elapsed = m.walkElapsedSec ?? 0;
      _elapsedBase = elapsed;
      var run = m.walkState ?? WalkRunState.idle;
      if (m.status == MeasurementStatus.completed) run = WalkRunState.finished;
      if (run == WalkRunState.recording) {
        // Not recording anymore (no stream in this process): paused.
        run = WalkRunState.paused;
        await _repo.updateWalkState(
          id,
          run,
          lastResumeAt: const Value(null),
        );
      }
      return _initial().copyWith(
        measurementId: m.id,
        mapStyle: m.mapStyle,
        runState: run,
        points: List.unmodifiable(m.points),
        stats: _stats(m.points, elapsed),
        segmentIndex: m.points.isEmpty ? 0 : m.points.last.segmentIndex,
        elapsedSec: elapsed,
        displayAreaUnit: m.displayAreaUnit,
        displayDistanceUnit: m.displayDistanceUnit,
      );
    } on AppException catch (e, st) {
      Log.e('Could not load walk draft $id', e, st);
      return null;
    }
  }

  /// Leaves the Walk screen: pauses a recording, stops GPS, flushes and
  /// describes the draft left behind (null if none — an empty draft is
  /// deleted). Resets to a fresh idle state. Safe to call twice.
  Future<({String id, int pointCount})?> leave() =>
      _leaving ??= _leave().whenComplete(() => _leaving = null);

  Future<({String id, int pointCount})?> _leave() async {
    if (state.isRecording) await pause();
    await _stopStreams();
    await flushNow();
    final left = state;
    _resetRuntime();
    state = _initial();
    final id = left.measurementId;
    if (id == null) return null;
    if (left.points.isEmpty) {
      await _enqueue(() => _repo.delete(id));
      return null;
    }
    return (id: id, pointCount: left.points.length);
  }

  void _resetRuntime() {
    _ticker?.cancel();
    _ticker = null;
    _buffer.clear();
    _elapsedBase = 0;
    _resumedAt = null;
    _lastFixAt = null;
    _lastFlushAt = null;
    _filter.reset();
  }

  // ------------------------------------------------------------- GPS access

  /// Re-checks permission and location service (screen resumed, banner
  /// action) and (re)starts the right position stream.
  Future<void> refreshAccess({bool request = false}) async {
    final access = await _location.ensureAccess(request: request);
    if (!ref.mounted) return;
    _listenServiceStatus();
    switch (access) {
      case LocationAccess.granted:
        if (_blocked(state.gps)) {
          state = state.copyWith(gps: GpsStatus.searching);
        }
        await _syncStream();
      case LocationAccess.serviceDisabled:
        state = state.copyWith(gps: GpsStatus.off);
        await _cancelFixStream();
      case LocationAccess.denied:
        state = state.copyWith(gps: GpsStatus.denied);
        await _cancelFixStream();
      case LocationAccess.deniedForever:
        state = state.copyWith(gps: GpsStatus.deniedForever);
        await _cancelFixStream();
    }
  }

  static bool _blocked(GpsStatus s) =>
      s == GpsStatus.off ||
      s == GpsStatus.denied ||
      s == GpsStatus.deniedForever;

  /// Banner action: settings for location off / permission refused for
  /// good; otherwise asks for permission again (the screen shows its
  /// pre-prompt first).
  Future<void> fixAccess() async {
    switch (state.gps) {
      case GpsStatus.off:
        await _tracker.openLocationSettings();
      case GpsStatus.deniedForever:
        await _tracker.openAppSettings();
      case GpsStatus.denied:
        await refreshAccess(request: true);
      case GpsStatus.searching || GpsStatus.ready || GpsStatus.low:
        break;
    }
  }

  void _listenServiceStatus() {
    _serviceSub ??= _tracker.serviceStatusStream().listen(
      (enabled) {
        if (enabled) {
          unawaited(refreshAccess());
        } else {
          state = state.copyWith(gps: GpsStatus.off);
          unawaited(_cancelFixStream());
        }
      },
      onError: (Object e, StackTrace st) =>
          Log.w('Location service status stream failed', e, st),
    );
  }

  /// Recording stream while recording, preview while idle/paused, nothing
  /// once finished.
  Future<void> _syncStream() => _streamOps = _streamOps.then((_) async {
    if (_blocked(state.gps)) return;
    final wantRecording = state.isRecording;
    if (state.isFinished) {
      await _cancelFixSubscription();
      return;
    }
    if (_fixSub != null && _fixSubRecording == wantRecording) return;
    await _cancelFixSubscription();
    final notification = _notification;
    final stream = wantRecording && notification != null
        ? _tracker.start(notification)
        : _tracker.previewStream();
    _fixSubRecording = wantRecording;
    _fixSub = stream.listen(_onFix, onError: _onStreamError);
  });

  Future<void> _cancelFixStream() =>
      _streamOps = _streamOps.then((_) => _cancelFixSubscription());

  Future<void> _cancelFixSubscription() async {
    final sub = _fixSub;
    _fixSub = null;
    await sub?.cancel();
  }

  Future<void> _stopStreams() async {
    _retry?.cancel();
    _ticker?.cancel();
    _ticker = null;
    final service = _serviceSub;
    _serviceSub = null;
    await service?.cancel();
    await _cancelFixStream();
  }

  void _onStreamError(Object e, StackTrace st) {
    Log.w('Walk position stream failed', e, st);
    unawaited(_cancelFixStream());
    _retry?.cancel();
    _retry = Timer(retryDelay, () => unawaited(refreshAccess()));
  }

  // ------------------------------------------------------------- fixes

  void _onFix(LocationFix fix) {
    final now = _clock.nowUtc();
    _lastFixAt = now;
    final maxAccuracy = _filter.config.maxAccuracyM;
    var s = state.copyWith(
      lastFix: fix,
      gps: fix.accuracy <= maxAccuracy ? GpsStatus.ready : GpsStatus.low,
      mockDetected: state.mockDetected || fix.isMocked,
    );
    if (s.isRecording && _fixSubRecording) {
      final decision = _filter.process(fix);
      final at = decision.position;
      if (at != null) {
        final point = MeasurePoint(
          id: _ids.newId(),
          orderIndex: s.points.length,
          segmentIndex: s.segmentIndex,
          lat: at.lat,
          lng: at.lng,
          altitude: fix.altitude,
          accuracy: fix.accuracy,
          speed: fix.speed,
          bearing: fix.bearing,
          timestamp: fix.timestamp,
        );
        final points = List<MeasurePoint>.unmodifiable([...s.points, point]);
        s = s.copyWith(points: points, stats: _stats(points, s.elapsedSec));
        _buffer.add(point);
      }
    }
    state = s;
    if (_buffer.length >= flushEveryPoints) unawaited(flushNow());
  }

  /// Once a second while recording: timer, stale-fix check, periodic flush.
  @visibleForTesting
  void tick() {
    if (!state.isRecording) return;
    final now = _clock.nowUtc();
    final elapsed = _elapsedNow(now);
    var s = state;
    if (elapsed != s.elapsedSec) {
      s = s.copyWith(
        elapsedSec: elapsed,
        stats: s.stats.copyWith(durationSec: elapsed),
      );
    }
    final lastFix = _lastFixAt;
    if ((s.gps == GpsStatus.ready || s.gps == GpsStatus.low) &&
        (lastFix == null || now.difference(lastFix) > staleFixAfter)) {
      s = s.copyWith(gps: GpsStatus.searching);
    }
    state = s;
    final lastFlush = _lastFlushAt;
    if (lastFlush == null || now.difference(lastFlush) >= flushInterval) {
      unawaited(flushNow());
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  int _elapsedNow([DateTime? now]) {
    final since = _resumedAt;
    if (since == null) return _elapsedBase;
    final running = (now ?? _clock.nowUtc()).difference(since).inSeconds;
    return _elapsedBase + (running < 0 ? 0 : running);
  }

  MeasurementStats _stats(List<MeasurePoint> points, int elapsedSec) =>
      StatsCalculator.compute(
        MeasurementType.walk,
        points,
        durationSec: elapsedSec,
      );

  // ------------------------------------------------------------- run state

  /// Creates the draft and starts recording segment 0. False when not
  /// possible (no fix yet, location off) or the draft could not be written.
  Future<bool> start() async {
    if (!state.canStart) return false;
    final now = _clock.nowUtc();
    var id = state.measurementId;
    try {
      if (id == null) {
        id = (await _repo.createDraft(MeasurementType.walk, state.mapStyle)).id;
        final s = state;
        if (s.displayAreaUnit != null || s.displayDistanceUnit != null) {
          await _repo.updateMeta(
            id,
            displayAreaUnit: Value(s.displayAreaUnit),
            displayDistanceUnit: Value(s.displayDistanceUnit),
          );
        }
      }
      await _repo.updateWalkState(
        id,
        WalkRunState.recording,
        startedAt: Value(now),
        elapsedSec: const Value(0),
        lastResumeAt: Value(now),
      );
    } on AppException catch (e, st) {
      Log.e('Could not start walk', e, st);
      state = state.copyWith(measurementId: id, saveFailed: true);
      return false;
    }
    _filter.reset();
    _elapsedBase = 0;
    _resumedAt = now;
    _lastFlushAt = now;
    state = state.copyWith(
      measurementId: id,
      runState: WalkRunState.recording,
      segmentIndex: 0,
      elapsedSec: 0,
      saveFailed: false,
    );
    _startTicker();
    await _syncStream();
    return true;
  }

  Future<void> pause() async {
    final id = state.measurementId;
    if (!state.isRecording || id == null) return;
    final elapsed = _elapsedNow();
    _elapsedBase = elapsed;
    _resumedAt = null;
    _ticker?.cancel();
    _ticker = null;
    state = state.copyWith(
      runState: WalkRunState.paused,
      elapsedSec: elapsed,
      stats: state.stats.copyWith(durationSec: elapsed),
    );
    await flushNow();
    await _enqueue(
      () => _repo.updateWalkState(
        id,
        WalkRunState.paused,
        elapsedSec: Value(elapsed),
        lastResumeAt: const Value(null),
      ),
    );
    await _syncStream();
  }

  /// Starts a new segment: no line is drawn from where Pause happened.
  Future<void> resume() async {
    final id = state.measurementId;
    if (!state.isPaused || id == null) return;
    final now = _clock.nowUtc();
    final points = state.points;
    _filter.reset();
    _resumedAt = now;
    _lastFlushAt = now;
    state = state.copyWith(
      runState: WalkRunState.recording,
      segmentIndex: points.isEmpty ? 0 : points.last.segmentIndex + 1,
    );
    await _enqueue(
      () => _repo.updateWalkState(
        id,
        WalkRunState.recording,
        lastResumeAt: Value(now),
      ),
    );
    _startTicker();
    await _syncStream();
  }

  /// Stops GPS for good; the draft becomes `completed` (Save in Phase 6).
  Future<void> finish() async {
    final id = state.measurementId;
    if (!(state.isRecording || state.isPaused) || id == null) return;
    final elapsed = _elapsedNow();
    _elapsedBase = elapsed;
    _resumedAt = null;
    _ticker?.cancel();
    _ticker = null;
    state = state.copyWith(
      runState: WalkRunState.finished,
      elapsedSec: elapsed,
      stats: _stats(state.points, elapsed),
    );
    await _cancelFixStream();
    await flushNow();
    await _enqueue(() async {
      await _repo.updateWalkState(
        id,
        WalkRunState.finished,
        elapsedSec: Value(elapsed),
        lastResumeAt: const Value(null),
      );
      await _repo.setStatus(id, MeasurementStatus.completed);
    });
  }

  // ------------------------------------------------------------- meta

  void setMapStyle(MapStyle style) {
    state = state.copyWith(mapStyle: style);
    final id = state.measurementId;
    if (id != null) {
      unawaited(_enqueue(() => _repo.updateMeta(id, mapStyle: Value(style))));
    }
  }

  void setDisplayAreaUnit(AreaUnit unit) {
    state = state.copyWith(displayAreaUnit: unit);
    final id = state.measurementId;
    if (id != null) {
      unawaited(
        _enqueue(() => _repo.updateMeta(id, displayAreaUnit: Value(unit))),
      );
    }
  }

  void setDisplayDistanceUnit(DistanceUnit unit) {
    state = state.copyWith(displayDistanceUnit: unit);
    final id = state.measurementId;
    if (id != null) {
      unawaited(
        _enqueue(
          () => _repo.updateMeta(id, displayDistanceUnit: Value(unit)),
        ),
      );
    }
  }

  // ------------------------------------------------------------- persistence

  /// Writes buffered points, stats and elapsed time now (every 5 points /
  /// 10 s, Pause, Finish, app going to the background).
  Future<void> flushNow() {
    final id = state.measurementId;
    if (id == null || state.runState == WalkRunState.idle) {
      return _writes;
    }
    _lastFlushAt = _clock.nowUtc();
    final batch = List<MeasurePoint>.of(_buffer);
    _buffer.clear();
    final elapsed = _elapsedNow();
    final stats = state.stats.copyWith(durationSec: elapsed);
    return _enqueue(() async {
      try {
        await _repo.appendWalkPoints(id, batch, stats, elapsed);
      } on Object {
        // Nothing was written (one transaction): retry with the next flush.
        _buffer.insertAll(0, batch);
        rethrow;
      }
      if (ref.mounted && state.saveFailed) {
        state = state.copyWith(saveFailed: false);
      }
    });
  }

  Future<void> _enqueue(Future<void> Function() write) {
    return _writes = _writes.then((_) => write()).catchError((
      Object e,
      StackTrace st,
    ) {
      Log.e('Walk draft write failed', e, st);
      if (ref.mounted) state = state.copyWith(saveFailed: true);
    });
  }
}
