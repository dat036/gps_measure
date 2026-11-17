import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show Color;
import 'package:geolocator/geolocator.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/domain/models/location_fix.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_tracker.g.dart';

/// Texts of the Android foreground-service notification (localized by the
/// screen, since the controller has no `BuildContext`).
typedef WalkNotificationText = ({
  String title,
  String text,
  String channelName,
});

/// Continuous GPS for Walk (`architecture.md` §8).
///
/// Only ONE position stream may be listened to at a time: geolocator shares
/// a single native stream and ignores new settings while one is active. Cancel
/// the preview subscription before listening to [start] (and vice versa).
abstract interface class LocationTracker {
  /// Fixes for the Ready/Paused screens (accuracy, blue dot). Nothing is
  /// recorded and no foreground service runs.
  Stream<LocationFix> previewStream();

  /// Recording stream: 2 s interval, Android foreground service with an
  /// ongoing notification, iOS background updates (blue indicator).
  /// Cancelling the subscription stops the service.
  Stream<LocationFix> start(WalkNotificationText notification);

  /// Emits whether device location is on, whenever it changes.
  Stream<bool> serviceStatusStream();

  Future<bool> isServiceEnabled();

  Future<bool> openLocationSettings();

  Future<bool> openAppSettings();
}

class GeolocatorLocationTracker implements LocationTracker {
  const GeolocatorLocationTracker({required this.notificationColor});

  /// Accent of the Android notification (brand color).
  final Color notificationColor;

  static const Duration recordingInterval = Duration(seconds: 2);

  @override
  Stream<LocationFix> previewStream() => _positions(
    switch (defaultTargetPlatform) {
      TargetPlatform.android => AndroidSettings(
        intervalDuration: recordingInterval,
      ),
      TargetPlatform.iOS => AppleSettings(
        activityType: ActivityType.fitness,
        // Preview must not keep GPS on while the app is in the background.
        allowBackgroundLocationUpdates: false,
      ),
      _ => const LocationSettings(),
    },
  );

  @override
  Stream<LocationFix> start(WalkNotificationText notification) => _positions(
    switch (defaultTargetPlatform) {
      // Accuracy defaults to `best`.
      TargetPlatform.android => AndroidSettings(
        intervalDuration: recordingInterval,
        foregroundNotificationConfig: ForegroundNotificationConfig(
          notificationTitle: notification.title,
          notificationText: notification.text,
          notificationChannelName: notification.channelName,
          notificationIcon: const AndroidResource(name: 'ic_notification'),
          enableWakeLock: true,
          setOngoing: true,
          color: notificationColor,
        ),
      ),
      TargetPlatform.iOS => AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        activityType: ActivityType.fitness,
        // Defaults kept: no automatic pause, background updates allowed.
        showBackgroundLocationIndicator: true,
      ),
      _ => const LocationSettings(),
    },
  );

  Stream<LocationFix> _positions(LocationSettings settings) =>
      Geolocator.getPositionStream(
        locationSettings: settings,
      ).map(_toFix).handleError((Object e, StackTrace st) {
        throw e is LocationServiceDisabledException
            ? LocationException(
                'Location service disabled',
                cause: e,
                stackTrace: st,
              )
            : LocationException(
                'Position stream failed',
                cause: e,
                stackTrace: st,
              );
      });

  @override
  Stream<bool> serviceStatusStream() => Geolocator.getServiceStatusStream().map(
    (s) => s == ServiceStatus.enabled,
  );

  @override
  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

  @override
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  @override
  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  static LocationFix _toFix(Position p) => LocationFix(
    lat: p.latitude,
    lng: p.longitude,
    accuracy: p.accuracy,
    timestamp: p.timestamp.toUtc(),
    altitude: p.altitude,
    speed: p.speed,
    // Heading is meaningless (0 or -1) when the platform has none.
    bearing: p.headingAccuracy > 0 || p.heading > 0 ? p.heading : null,
    isMocked: p.isMocked,
  );
}

@Riverpod(keepAlive: true)
LocationTracker locationTracker(Ref ref) =>
    GeolocatorLocationTracker(notificationColor: LmColors.light.brandPrimary);
