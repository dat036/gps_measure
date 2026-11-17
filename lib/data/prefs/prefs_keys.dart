/// SharedPreferences keys (`architecture.md` §5.5). Never rename a released
/// key — users would silently lose the value.
abstract final class PrefsKeys {
  // User settings (AppSettings).
  static const String distanceUnit = 'distance_unit';
  static const String areaUnit = 'area_unit';
  static const String showSecondaryUnit = 'show_secondary_unit';
  static const String mapStyle = 'map_style';
  static const String locale = 'locale';
  static const String defaultMode = 'default_mode';
  static const String showGpsAccuracy = 'show_gps_accuracy';
  static const String autoCenter = 'auto_center';
  static const String savePhotosToMeasurement = 'save_photos_to_measurement';
  static const String keepScreenAwake = 'keep_screen_awake';
  static const String inputMode = 'input_mode';
  static const String showEdgeLabels = 'show_edge_labels';

  // App state.
  static const String recentSearches = 'recent_searches';
  static const String oemBatteryHintShown = 'oem_battery_hint_shown';
  static const String savesCountTotal = 'saves_count_total';
  static const String exportFreeUsedOn = 'export_free_used_on';
  static const String reviewPromptedAt = 'review_prompted_at';
  static const String attRequested = 'att_requested';
  static const String premiumCached = 'premium_cached';
  static const String appOpenCount = 'app_open_count';
  static const String orphanCleanupAt = 'orphan_cleanup_at';
  static const String walkNotificationAsked = 'walk_notification_asked';
  static const String lastMapCamera = 'last_map_camera';
  static const String locationBlocked = 'location_blocked';
  static const String onboardingSeen = 'onboarding_seen';
  static const String onboardingDoneAtOpen = 'onboarding_done_at_open';
  static const String startupPaywallShown = 'startup_paywall_shown';

  /// `help_seen_area` / `_distance` / `_walk`: help sheet auto-shown once.
  static String helpSeen(String mode) => 'help_seen_$mode';
}
