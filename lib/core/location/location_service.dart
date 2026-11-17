import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/settings_repository.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/location_fix.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_service.g.dart';

enum LocationAccess { granted, denied, deniedForever, serviceDisabled }

/// One-shot location for the measure screens (my-location, add point at
/// GPS). Walk streaming lives in `LocationTracker` (Phase 5). Screens ask
/// through `PermissionFlows.location` (pre-prompt first).
abstract interface class LocationService {
  /// Checks (and, with [request], asks for) "while in use" permission.
  Future<LocationAccess> ensureAccess({bool request = true});

  /// A fresh high-accuracy fix. Throws [LocationException] on timeout.
  Future<LocationFix> current({Duration timeLimit});

  /// Cached position, if the OS has one and permission is granted.
  Future<GeoPoint?> lastKnown();
}

class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService(this._settings);

  final SettingsRepository _settings;

  @override
  Future<LocationAccess> ensureAccess({bool request = true}) async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationAccess.serviceDisabled;
    }
    var permission = await Geolocator.checkPermission();
    var asked = false;
    if (permission == LocationPermission.denied && request) {
      permission = await Geolocator.requestPermission();
      asked = true;
    }
    final access = resolveAccess(
      permission,
      rememberedBlocked: _settings.locationBlocked,
    );
    // Only a request tells "refused for good" apart from "refused once".
    if (asked || access == LocationAccess.granted) {
      final blocked = access == LocationAccess.deniedForever;
      if (blocked != _settings.locationBlocked) {
        await _settings.setLocationBlocked(blocked: blocked);
      }
    }
    return access;
  }

  /// Android reports a permission refused for good as plain `denied` until
  /// it is requested again (which then returns at once, with no dialog).
  /// [rememberedBlocked] is the last request's answer, so the UI can offer
  /// "Open Settings" instead of a Continue that does nothing.
  @visibleForTesting
  static LocationAccess resolveAccess(
    LocationPermission permission, {
    required bool rememberedBlocked,
  }) => switch (permission) {
    LocationPermission.always ||
    LocationPermission.whileInUse => LocationAccess.granted,
    LocationPermission.deniedForever => LocationAccess.deniedForever,
    LocationPermission.denied =>
      rememberedBlocked ? LocationAccess.deniedForever : LocationAccess.denied,
    LocationPermission.unableToDetermine => LocationAccess.denied,
  };

  @override
  Future<LocationFix> current({
    Duration timeLimit = const Duration(seconds: 10),
  }) async {
    try {
      final p = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(timeLimit: timeLimit),
      );
      return _toFix(p);
    } on Exception catch (e, st) {
      throw LocationException(
        'Could not get current position',
        cause: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<GeoPoint?> lastKnown() async {
    try {
      final p = await Geolocator.getLastKnownPosition();
      return p == null ? null : GeoPoint(lat: p.latitude, lng: p.longitude);
    } on Exception {
      return null;
    }
  }

  static LocationFix _toFix(Position p) => LocationFix(
    lat: p.latitude,
    lng: p.longitude,
    accuracy: p.accuracy,
    timestamp: p.timestamp.toUtc(),
    altitude: p.altitude,
    speed: p.speed,
    bearing: p.heading,
    isMocked: p.isMocked,
  );
}

@Riverpod(keepAlive: true)
LocationService locationService(Ref ref) =>
    GeolocatorLocationService(ref.watch(settingsRepositoryProvider));
