import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/location/location_service.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/core/utils/id_generator.dart';
import 'package:gps_measurement/data/db/app_database.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:gps_measurement/domain/geo/track_filter.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/location_fix.dart';
import 'package:gps_measurement/features/measure/walk/location_tracker.dart';
import 'package:gps_measurement/features/measure/walk/walk_controller.dart';
import 'package:gps_measurement/features/measure/walk/walk_recovery_service.dart';
import 'package:gps_measurement/features/measure/walk/walk_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/data.dart';

/// Position streams driven by the test. Tracks which stream is listened
/// to, like geolocator's single native stream.
class FakeTracker implements LocationTracker {
  final preview = StreamController<LocationFix>.broadcast();
  final recording = StreamController<LocationFix>.broadcast();
  final service = StreamController<bool>.broadcast();
  WalkNotificationText? notification;
  int openedLocationSettings = 0;
  int openedAppSettings = 0;

  bool get previewing => preview.hasListener;
  bool get recordingActive => recording.hasListener;

  @override
  Stream<LocationFix> previewStream() => preview.stream;

  @override
  Stream<LocationFix> start(WalkNotificationText notification) {
    this.notification = notification;
    return recording.stream;
  }

  @override
  Stream<bool> serviceStatusStream() => service.stream;

  @override
  Future<bool> isServiceEnabled() async => true;

  @override
  Future<bool> openLocationSettings() async {
    openedLocationSettings++;
    return true;
  }

  @override
  Future<bool> openAppSettings() async {
    openedAppSettings++;
    return true;
  }

  /// Sends [fix] to whichever stream is listened to.
  Future<void> emit(LocationFix fix) async {
    if (recording.hasListener) recording.add(fix);
    if (preview.hasListener) preview.add(fix);
    await pumpEventQueue();
  }
}

class FakeLocationService implements LocationService {
  LocationAccess access = LocationAccess.granted;
  final List<bool> requests = [];

  @override
  Future<LocationAccess> ensureAccess({bool request = true}) async {
    requests.add(request);
    return access;
  }

  @override
  Future<LocationFix> current({Duration? timeLimit}) =>
      throw const LocationException('not in tests');

  @override
  Future<GeoPoint?> lastKnown() async => null;
}

const WalkNotificationText notification = (
  title: 'Recording',
  text: 'Tap to return',
  channelName: 'Walk',
);

void main() {
  late AppDatabase db;
  late TempDirectories temp;
  late SharedPreferences prefs;
  late FixedClock clock;
  late FakeTracker tracker;
  late FakeLocationService location;
  late ProviderContainer container;

  const origin = GeoPoint(lat: 21, lng: 105);

  /// ~[north]/[east] meters from [origin].
  GeoPoint at(double north, double east) => GeoPoint(
    lat: origin.lat + north / 111320,
    lng: origin.lng + east / 103900, // cos(21°) × 111320
  );

  var t = 0;
  LocationFix fix(
    GeoPoint p, {
    double accuracy = 5,
    bool mocked = false,
  }) {
    t += 2;
    return LocationFix(
      lat: p.lat,
      lng: p.lng,
      accuracy: accuracy,
      timestamp: DateTime.utc(2026, 9, 28, 8).add(Duration(seconds: t)),
      isMocked: mocked,
    );
  }

  ProviderContainer newContainer() {
    final c = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDirectoriesProvider.overrideWithValue(temp.dirs),
        appDatabaseProvider.overrideWithValue(db),
        imageCompressorProvider.overrideWithValue(FakeCompressor()),
        clockProvider.overrideWithValue(clock),
        idGeneratorProvider.overrideWithValue(SequentialIds()),
        locationTrackerProvider.overrideWithValue(tracker),
        locationServiceProvider.overrideWithValue(location),
        // Raw positions: exact geometry in assertions.
        trackFilterConfigProvider.overrideWithValue(
          const TrackFilterConfig(smoothing: false),
        ),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  WalkController walk() => container.read(walkControllerProvider.notifier);
  WalkState state() => container.read(walkControllerProvider);
  MeasurementRepository repo() => container.read(measurementRepositoryProvider);

  /// Prepares and gets a first good fix.
  Future<void> ready({String? draftId}) async {
    await walk().prepare(notification: notification, draftId: draftId);
    await tracker.emit(fix(origin));
  }

  /// Walks east in 4 m steps.
  Future<void> walkEast(int steps, {double north = 0, double from = 0}) async {
    for (var i = 1; i <= steps; i++) {
      await tracker.emit(fix(at(north, from + 4.0 * i)));
    }
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = newTestDatabase();
    temp = TempDirectories();
    clock = testClock();
    tracker = FakeTracker();
    location = FakeLocationService();
    t = 0;
    container = newContainer();
  });

  tearDown(() async {
    await db.close();
    temp.dispose();
  });

  group('Ready', () {
    test('checks permission, previews, Start enabled on a fix', () async {
      await walk().prepare(notification: notification);
      // Never the system dialog here: the screen pre-prompts first.
      expect(location.requests, [false]);
      expect(state().ready, isTrue);
      expect(state().gps, GpsStatus.searching);
      expect(state().canStart, isFalse);
      expect(tracker.previewing, isTrue);
      expect(tracker.recordingActive, isFalse);

      await tracker.emit(fix(origin, accuracy: 4));
      expect(state().gps, GpsStatus.ready);
      expect(state().lastFix?.accuracy, 4);
      expect(state().canStart, isTrue);
    });

    test('low accuracy and mock location are flagged', () async {
      await walk().prepare(notification: notification);
      await tracker.emit(fix(origin, accuracy: 40));
      expect(state().gps, GpsStatus.low);
      await tracker.emit(fix(origin, mocked: true));
      expect(state().mockDetected, isTrue);
    });

    test('permission denied → no stream, banner action asks again', () async {
      location.access = LocationAccess.denied;
      await walk().prepare(notification: notification);
      expect(state().gps, GpsStatus.denied);
      expect(tracker.previewing, isFalse);

      location.access = LocationAccess.granted;
      await walk().fixAccess();
      expect(location.requests, [false, true]);
      expect(state().gps, GpsStatus.searching);
      expect(tracker.previewing, isTrue);
    });

    test('denied forever / location off open system settings', () async {
      location.access = LocationAccess.deniedForever;
      await walk().prepare(notification: notification);
      await walk().fixAccess();
      expect(tracker.openedAppSettings, 1);

      location.access = LocationAccess.serviceDisabled;
      await walk().refreshAccess();
      expect(state().gps, GpsStatus.off);
      await walk().fixAccess();
      expect(tracker.openedLocationSettings, 1);
    });

    test('nothing is recorded before Start', () async {
      await ready();
      await walkEast(5);
      expect(state().points, isEmpty);
      expect(state().measurementId, isNull);
    });
  });

  group('Recording', () {
    test(
      'Start creates the draft and switches to the recording stream',
      () async {
        await ready();
        expect(await walk().start(), isTrue);

        final id = state().measurementId!;
        final m = await repo().get(id);
        expect(m!.type, MeasurementType.walk);
        expect(m.status, MeasurementStatus.draft);
        expect(m.walkState, WalkRunState.recording);
        expect(m.walkStartedAt, clock.nowUtc());
        expect(tracker.recordingActive, isTrue);
        expect(tracker.previewing, isFalse);
        expect(tracker.notification, notification);
      },
    );

    test('filtered fixes are recorded and flushed every 5 points', () async {
      await ready();
      await walk().start();
      final id = state().measurementId!;

      await tracker.emit(fix(origin)); // first point
      await tracker.emit(fix(at(0, 1))); // 1 m: too close
      await tracker.emit(fix(at(0, 4), accuracy: 60)); // too inaccurate
      await tracker.emit(fix(at(0, 4), mocked: true)); // mocked
      expect(state().points, hasLength(1));
      expect(state().mockDetected, isTrue);

      await walkEast(3); // 4, 8, 12 m
      expect(state().points, hasLength(4));
      expect((await repo().get(id))!.points, isEmpty); // still buffered

      await walkEast(1, from: 12); // 5th point → flush
      await walk().flushNow();
      final stored = await repo().get(id);
      expect(stored!.points, hasLength(5));
      expect(stored.stats.distanceM, closeTo(16, 0.2));
      expect(state().stats.distanceM, closeTo(16, 0.2));
    });

    test('elapsed time counts only while recording', () async {
      await ready();
      await walk().start();
      clock.advance(const Duration(seconds: 30));
      walk().tick();
      expect(state().elapsedSec, 30);

      await walk().pause();
      clock.advance(const Duration(minutes: 5));
      await walk().resume();
      clock.advance(const Duration(seconds: 10));
      walk().tick();
      expect(state().elapsedSec, 40);
      expect(state().stats.durationSec, 40);
      await walk().flushNow();
    });

    test('tick flushes every 10 s, even without new points', () async {
      await ready();
      await walk().start();
      final id = state().measurementId!;
      await walkEast(2);
      clock.advance(const Duration(seconds: 11));
      walk().tick();
      await walk().flushNow();
      final m = await repo().get(id);
      expect(m!.points, hasLength(2));
      expect(m.walkElapsedSec, 11);
    });

    test('stale fix → Searching', () async {
      await ready();
      await walk().start();
      await tracker.emit(fix(origin));
      expect(state().gps, GpsStatus.ready);
      clock.advance(WalkController.staleFixAfter + const Duration(seconds: 1));
      walk().tick();
      expect(state().gps, GpsStatus.searching);
      await walk().flushNow();
    });

    test('Pause flushes; Resume starts a new, unjoined segment', () async {
      await ready();
      await walk().start();
      final id = state().measurementId!;
      await tracker.emit(fix(origin));
      await walkEast(2); // 0 → 8 m, segment 0
      clock.advance(const Duration(seconds: 20));
      await walk().pause();

      var m = await repo().get(id);
      expect(m!.walkState, WalkRunState.paused);
      expect(m.walkElapsedSec, 20);
      expect(m.walkLastResumeAt, isNull);
      expect(m.points, hasLength(3));
      expect(tracker.previewing, isTrue);
      expect(tracker.recordingActive, isFalse);

      // Fixes while paused are not recorded.
      await tracker.emit(fix(at(50, 0)));
      expect(state().points, hasLength(3));

      await walk().resume();
      expect(state().segmentIndex, 1);
      expect(tracker.recordingActive, isTrue);
      // 50 m north: a jump that must not be drawn or counted.
      await tracker.emit(fix(at(50, 0)));
      await walkEast(2, north: 50);
      await walk().flushNow();

      m = await repo().get(id);
      expect(m!.walkState, WalkRunState.recording);
      expect(m.points.map((p) => p.segmentIndex), [0, 0, 0, 1, 1, 1]);
      expect(m.stats.segmentCount, 2);
      expect(state().stats.distanceM, closeTo(16, 0.3)); // 8 + 8, no jump
    });

    test('Finish completes the draft and stops GPS', () async {
      await ready();
      await walk().start();
      final id = state().measurementId!;
      await tracker.emit(fix(origin));
      await walkEast(2);
      clock.advance(const Duration(seconds: 42));
      await walk().finish();

      final m = await repo().get(id);
      expect(m!.status, MeasurementStatus.completed);
      expect(m.walkState, WalkRunState.finished);
      expect(m.walkElapsedSec, 42);
      expect(m.stats.durationSec, 42);
      expect(m.points, hasLength(3));
      expect(state().isFinished, isTrue);
      expect(tracker.recordingActive, isFalse);
      expect(tracker.previewing, isFalse);
    });

    test('a loop back to Start closes and gets an area', () async {
      await ready();
      await walk().start();
      // 40 × 40 m square, 4 m steps.
      await tracker.emit(fix(origin));
      for (var i = 1; i <= 10; i++) {
        await tracker.emit(fix(at(0, 4.0 * i)));
      }
      for (var i = 1; i <= 10; i++) {
        await tracker.emit(fix(at(4.0 * i, 40)));
      }
      expect(state().stats.isClosed, isFalse);
      for (var i = 9; i >= 0; i--) {
        await tracker.emit(fix(at(40, 4.0 * i)));
      }
      for (var i = 9; i >= 1; i--) {
        await tracker.emit(fix(at(4.0 * i, 0)));
      }
      final stats = state().stats;
      expect(stats.isClosed, isTrue);
      expect(stats.areaM2, closeTo(1600, 1600 * 0.05));
      expect(state().closureThresholdM, 20);
    });

    test('location off mid-walk keeps the walk; back on resumes GPS', () async {
      await ready();
      await walk().start();
      await tracker.emit(fix(origin));

      tracker.service.add(false);
      await pumpEventQueue();
      expect(state().gps, GpsStatus.off);
      expect(state().isRecording, isTrue);
      expect(tracker.recordingActive, isFalse);

      tracker.service.add(true);
      await pumpEventQueue();
      expect(tracker.recordingActive, isTrue);
      await walkEast(1);
      expect(state().points, hasLength(2));
    });
  });

  group('Leaving', () {
    test('leave pauses, flushes and describes the draft', () async {
      await ready();
      await walk().start();
      final id = state().measurementId!;
      await tracker.emit(fix(origin));
      await walkEast(1);

      final left = await walk().leave();
      expect(left, (id: id, pointCount: 2));
      final m = await repo().get(id);
      expect(m!.walkState, WalkRunState.paused);
      expect(m.points, hasLength(2));
      expect(state().measurementId, isNull);
      expect(tracker.previewing, isFalse);
      expect(tracker.recordingActive, isFalse);
    });

    test('a walk without points leaves no draft', () async {
      await ready();
      await walk().start();
      final id = state().measurementId!;
      expect(await walk().leave(), isNull);
      expect(await repo().get(id), isNull);
    });

    test('leave before Start does nothing', () async {
      await ready();
      expect(await walk().leave(), isNull);
      expect(await repo().watchDrafts().first, isEmpty);
    });
  });

  group('Recovery', () {
    test('killed while recording → paused, then resumable', () async {
      await ready();
      await walk().start();
      final id = state().measurementId!;
      await tracker.emit(fix(origin));
      await walkEast(4);
      clock.advance(const Duration(seconds: 15));
      walk().tick(); // periodic flush
      await walk().flushNow();

      // Process dies: a new container, the row still says `recording`.
      final stored = await repo().get(id);
      expect(stored!.walkState, WalkRunState.recording);
      tracker = FakeTracker();
      container = newContainer();

      final recovered = await container
          .read(walkRecoveryServiceProvider)
          .check();
      expect(recovered, [id]);
      final m = await repo().get(id);
      expect(m!.walkState, WalkRunState.paused);
      expect(m.walkElapsedSec, 15);
      expect(m.points, hasLength(5));

      await walk().prepare(notification: notification, draftId: id);
      expect(state().isPaused, isTrue);
      expect(state().points, hasLength(5));
      expect(state().elapsedSec, 15);
      expect(state().stats.distanceM, closeTo(16, 0.2));

      await walk().resume();
      expect(state().segmentIndex, 1);
    });

    test('nothing to recover', () async {
      expect(
        await container.read(walkRecoveryServiceProvider).check(),
        isEmpty,
      );
    });

    test('a finished walk reopens as finished', () async {
      await ready();
      await walk().start();
      final id = state().measurementId!;
      await tracker.emit(fix(origin));
      await walk().finish();
      await walk().leave();

      await walk().prepare(notification: notification, draftId: id);
      expect(state().isFinished, isTrue);
      expect(tracker.previewing, isFalse);
    });
  });
}
