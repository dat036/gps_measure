import 'package:gps_measurement/domain/models/enums.dart';

/// Free-tier limits; values come from Remote Config
/// (`free_max_saved`, `free_max_photos`).
class GateConfig {
  const GateConfig({this.freeMaxSaved = 4, this.freeMaxPhotos = 2});

  final int freeMaxSaved;
  final int freeMaxPhotos;
}

/// Premium gating (`architecture.md` §7.9, `overview.md` §5.3).
///
/// Gates new projects and premium features. Existing projects stay accessible.
class FeatureGate {
  const FeatureGate({
    required this.isPremium,
    this.config = const GateConfig(),
    this.unlockedMapStyles = const {},
  });

  final bool isPremium;
  final GateConfig config;

  /// Premium map styles opened by watching a rewarded ad (this app run).
  final Set<MapStyle> unlockedMapStyles;

  /// Saving one more measurement when [savedCount] are already saved. When
  /// false the measurement stays a draft (nothing is lost).
  bool canSaveNew(int savedCount) =>
      isPremium || savedCount < config.freeMaxSaved;

  /// Adding one more photo to a measurement that has [photoCount].
  bool canAddPhoto(int photoCount) =>
      isPremium || photoCount < config.freeMaxPhotos;

  /// CSV is always free. KML: premium, or the one free export of the day
  /// (otherwise the UI offers a rewarded ad or the paywall). PDF report:
  /// premium only (the UI goes straight to the paywall).
  bool canExport(ExportFormat format, {required bool freeUsedToday}) {
    if (isPremium) return true;
    return switch (format) {
      ExportFormat.csv => true,
      ExportFormat.kml => !freeUsedToday,
      ExportFormat.pdf => false,
    };
  }

  /// Satellite and Hybrid maps are Premium; Standard and Terrain are free.
  static bool isPremiumMapStyle(MapStyle style) =>
      style == MapStyle.satellite || style == MapStyle.hybrid;

  bool canUseMapStyle(MapStyle style) =>
      isPremium ||
      !isPremiumMapStyle(style) ||
      unlockedMapStyles.contains(style);

  /// [style] if allowed, else Standard (e.g. after a subscription ended).
  MapStyle effectiveMapStyle(MapStyle style) =>
      canUseMapStyle(style) ? style : MapStyle.standard;

  bool get canUsePdf => isPremium;

  /// Standard Vietnamese units are free; user-defined units are premium.
  bool get canUseCustomUnit => isPremium;

  bool get showAds => !isPremium;
}
