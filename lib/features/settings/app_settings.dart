import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gps_measurement/domain/models/enums.dart';

part 'app_settings.freezed.dart';

/// User preferences (Setting tab). Persisted by `SettingsRepository`.
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    required DistanceUnit distanceUnit,
    required AreaUnit areaUnit,
    @Default(true) bool showSecondaryUnit,
    @Default(MapStyle.standard) MapStyle mapStyle,

    /// Language code override; null = follow the system.
    String? localeCode,
    @Default(MeasurementType.area) MeasurementType defaultMode,
    @Default(true) bool showGpsAccuracy,
    @Default(true) bool autoCenter,
    @Default(true) bool savePhotosToMeasurement,
    @Default(true) bool keepScreenAwake,
    @Default(InputMode.crosshair) InputMode inputMode,
    @Default(true) bool showEdgeLabels,
  }) = _AppSettings;

  /// Defaults depend on the device region (`architecture.md` §5.5):
  /// US/UK/MM/LR measure distance in feet, US/UK area in acres.
  factory AppSettings.defaultsFor(String? countryCode) {
    final country = countryCode?.toUpperCase();
    return AppSettings(
      distanceUnit: _feetCountries.contains(country)
          ? DistanceUnit.foot
          : DistanceUnit.meter,
      areaUnit: _acreCountries.contains(country)
          ? AreaUnit.acre
          : AreaUnit.squareMeter,
    );
  }

  static const Set<String> _feetCountries = {'US', 'GB', 'MM', 'LR'};
  static const Set<String> _acreCountries = {'US', 'GB'};
}
