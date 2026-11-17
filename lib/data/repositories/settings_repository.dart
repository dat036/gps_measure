import 'package:gps_measurement/data/prefs/prefs_keys.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/features/settings/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Reads/writes [AppSettings] and small app-state values in
/// SharedPreferences. Enum values are stored by index.
class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  /// Stored settings on top of the region defaults for [countryCode].
  AppSettings load({String? countryCode}) {
    final d = AppSettings.defaultsFor(countryCode);
    return AppSettings(
      distanceUnit:
          _enum(PrefsKeys.distanceUnit, DistanceUnit.values) ?? d.distanceUnit,
      areaUnit: _enum(PrefsKeys.areaUnit, AreaUnit.values) ?? d.areaUnit,
      showSecondaryUnit:
          _prefs.getBool(PrefsKeys.showSecondaryUnit) ?? d.showSecondaryUnit,
      mapStyle: _enum(PrefsKeys.mapStyle, MapStyle.values) ?? d.mapStyle,
      localeCode: _prefs.getString(PrefsKeys.locale),
      defaultMode:
          _enum(PrefsKeys.defaultMode, MeasurementType.values) ?? d.defaultMode,
      showGpsAccuracy:
          _prefs.getBool(PrefsKeys.showGpsAccuracy) ?? d.showGpsAccuracy,
      autoCenter: _prefs.getBool(PrefsKeys.autoCenter) ?? d.autoCenter,
      savePhotosToMeasurement:
          _prefs.getBool(PrefsKeys.savePhotosToMeasurement) ??
          d.savePhotosToMeasurement,
      keepScreenAwake:
          _prefs.getBool(PrefsKeys.keepScreenAwake) ?? d.keepScreenAwake,
      inputMode: _enum(PrefsKeys.inputMode, InputMode.values) ?? d.inputMode,
      showEdgeLabels:
          _prefs.getBool(PrefsKeys.showEdgeLabels) ?? d.showEdgeLabels,
    );
  }

  /// Persists every field (settings are few; writing all keeps it simple).
  Future<void> save(AppSettings s) async {
    await Future.wait([
      _prefs.setInt(PrefsKeys.distanceUnit, s.distanceUnit.index),
      _prefs.setInt(PrefsKeys.areaUnit, s.areaUnit.index),
      _prefs.setBool(PrefsKeys.showSecondaryUnit, s.showSecondaryUnit),
      _prefs.setInt(PrefsKeys.mapStyle, s.mapStyle.index),
      if (s.localeCode == null)
        _prefs.remove(PrefsKeys.locale)
      else
        _prefs.setString(PrefsKeys.locale, s.localeCode!),
      _prefs.setInt(PrefsKeys.defaultMode, s.defaultMode.index),
      _prefs.setBool(PrefsKeys.showGpsAccuracy, s.showGpsAccuracy),
      _prefs.setBool(PrefsKeys.autoCenter, s.autoCenter),
      _prefs.setBool(
        PrefsKeys.savePhotosToMeasurement,
        s.savePhotosToMeasurement,
      ),
      _prefs.setBool(PrefsKeys.keepScreenAwake, s.keepScreenAwake),
      _prefs.setInt(PrefsKeys.inputMode, s.inputMode.index),
      _prefs.setBool(PrefsKeys.showEdgeLabels, s.showEdgeLabels),
    ]);
  }

  /// Last orphan-file cleanup (UTC), or null if never run.
  DateTime? get lastOrphanCleanupAt {
    final ms = _prefs.getInt(PrefsKeys.orphanCleanupAt);
    return ms == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
  }

  Future<void> setLastOrphanCleanupAt(DateTime at) =>
      _prefs.setInt(PrefsKeys.orphanCleanupAt, at.millisecondsSinceEpoch);

  // ------------------------------------------------------ permissions

  /// The last location request answered "denied forever" (Android only
  /// says so when asked; see `GeolocatorLocationService`).
  bool get locationBlocked =>
      _prefs.getBool(PrefsKeys.locationBlocked) ?? false;

  Future<void> setLocationBlocked({required bool blocked}) =>
      _prefs.setBool(PrefsKeys.locationBlocked, blocked);

  // ------------------------------------------------------ map camera

  /// Where the Area/Distance map was left (opened there when Auto Center
  /// Map is off). Stored as `lat,lng,zoom`.
  ({double lat, double lng, double zoom})? get lastMapCamera {
    final parts = _prefs.getString(PrefsKeys.lastMapCamera)?.split(',');
    if (parts == null || parts.length != 3) return null;
    final [lat, lng, zoom] = parts.map(double.tryParse).toList();
    if (lat == null || lng == null || zoom == null) return null;
    return (lat: lat, lng: lng, zoom: zoom);
  }

  Future<void> setLastMapCamera(double lat, double lng, double zoom) =>
      _prefs.setString(PrefsKeys.lastMapCamera, '$lat,$lng,$zoom');

  // ------------------------------------------------------ recent searches

  static const int maxRecentSearches = 5;

  /// Newest first.
  List<String> get recentSearches =>
      _prefs.getStringList(PrefsKeys.recentSearches) ?? const [];

  /// Moves [query] to the front; keeps [maxRecentSearches].
  Future<void> addRecentSearch(String query) {
    final q = query.trim();
    final next = [
      q,
      ...recentSearches.where((s) => s != q),
    ].take(maxRecentSearches).toList();
    return _prefs.setStringList(PrefsKeys.recentSearches, next);
  }

  Future<void> clearRecentSearches() => _prefs.remove(PrefsKeys.recentSearches);

  // ------------------------------------------------------ onboarding

  /// Intro slides already completed or skipped (shown once per install).
  bool get onboardingSeen => _prefs.getBool(PrefsKeys.onboardingSeen) ?? false;

  /// Remembers which launch finished the intro, so the paywall comes on
  /// the next one (launch 1: language + intro; launch 2: paywall; from
  /// launch 3: straight to Home).
  Future<void> setOnboardingSeen() async {
    await _prefs.setInt(PrefsKeys.onboardingDoneAtOpen, appOpenCount);
    await _prefs.setBool(PrefsKeys.onboardingSeen, true);
  }

  /// The launch after the intro was finished, and the startup paywall has
  /// not been offered yet. Installs from before this existed (no launch
  /// recorded) never get it.
  bool get startupPaywallDue {
    final doneAt = _prefs.getInt(PrefsKeys.onboardingDoneAtOpen);
    return onboardingSeen &&
        doneAt != null &&
        appOpenCount > doneAt &&
        !(_prefs.getBool(PrefsKeys.startupPaywallShown) ?? false);
  }

  /// This launch is the one that ran the first-run flow (language → intro →
  /// Home), or the flow is not finished. Ads that must not disturb the very
  /// first session (Home banner) wait for the next launch. Installs from
  /// before this existed (no launch recorded) are never "first".
  bool get inFirstRunSession {
    if (!onboardingSeen) return true;
    return _prefs.getInt(PrefsKeys.onboardingDoneAtOpen) == appOpenCount;
  }

  Future<void> setStartupPaywallShown() =>
      _prefs.setBool(PrefsKeys.startupPaywallShown, true);

  // ------------------------------------------------------ walk prompts

  /// OEM battery-optimization sheet already shown (once per install).
  bool get oemBatteryHintShown =>
      _prefs.getBool(PrefsKeys.oemBatteryHintShown) ?? false;

  Future<void> setOemBatteryHintShown() =>
      _prefs.setBool(PrefsKeys.oemBatteryHintShown, true);

  /// Notification permission already asked before a first Start Walking.
  bool get walkNotificationAsked =>
      _prefs.getBool(PrefsKeys.walkNotificationAsked) ?? false;

  Future<void> setWalkNotificationAsked() =>
      _prefs.setBool(PrefsKeys.walkNotificationAsked, true);

  // ------------------------------------------------------ saves

  /// Measurements saved since install (review prompt, interstitials).
  int get savesCountTotal => _prefs.getInt(PrefsKeys.savesCountTotal) ?? 0;

  Future<void> incrementSavesCount() =>
      _prefs.setInt(PrefsKeys.savesCountTotal, savesCountTotal + 1);

  // ------------------------------------------------------ export

  /// Day (`yyyy-MM-dd`, local) of the last free KML export.
  String get exportFreeUsedOn =>
      _prefs.getString(PrefsKeys.exportFreeUsedOn) ?? '';

  Future<void> setExportFreeUsedOn(String day) =>
      _prefs.setString(PrefsKeys.exportFreeUsedOn, day);

  // ------------------------------------------------------ monetization

  /// Last known entitlement, used until Google Play answers (offline start).
  bool get premiumCached => _prefs.getBool(PrefsKeys.premiumCached) ?? false;

  Future<void> setPremiumCached({required bool premium}) =>
      _prefs.setBool(PrefsKeys.premiumCached, premium);

  /// Cold starts since install (ATT not on the first one).
  int get appOpenCount => _prefs.getInt(PrefsKeys.appOpenCount) ?? 0;

  Future<void> incrementAppOpenCount() =>
      _prefs.setInt(PrefsKeys.appOpenCount, appOpenCount + 1);

  /// iOS App Tracking Transparency prompt already shown.
  bool get attRequested => _prefs.getBool(PrefsKeys.attRequested) ?? false;

  Future<void> setAttRequested() =>
      _prefs.setBool(PrefsKeys.attRequested, true);

  // ------------------------------------------------------ help

  bool helpSeen(MeasurementType mode) =>
      _prefs.getBool(PrefsKeys.helpSeen(mode.name)) ?? false;

  Future<void> setHelpSeen(MeasurementType mode) =>
      _prefs.setBool(PrefsKeys.helpSeen(mode.name), true);

  /// Out-of-range indexes (e.g. after a downgrade) fall back to defaults.
  T? _enum<T extends Enum>(String key, List<T> values) {
    final i = _prefs.getInt(key);
    return i == null || i < 0 || i >= values.length ? null : values[i];
  }
}
