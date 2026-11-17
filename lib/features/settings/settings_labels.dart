import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/l10n/gen/app_localizations.dart';

/// App languages in the order of Settings → Language (`design.md` §5.13).
const List<String> appLanguageCodes = [
  'vi',
  'en',
  'es',
  'pt',
  'hi',
  'id',
  'zh',
  'th',
  'fr',
  'de',
  'pl',
  'nl',
];

/// Machine-translated, waiting for a native review (`plan.md` P9-06).
const Set<String> machineTranslatedLanguages = {
  'es',
  'pt',
  'hi',
  'id',
  'zh',
  'th',
  'fr',
  'de',
  'pl',
  'nl',
};

/// Each language in its own script, identical in every UI language so
/// people find theirs whatever the app is showing.
const Map<String, String> languageNativeNames = {
  'vi': 'Tiếng Việt',
  'en': 'English',
  'es': 'Español',
  'pt': 'Português',
  'hi': 'हिन्दी',
  'id': 'Bahasa Indonesia',
  'zh': '中文',
  'th': 'ไทย',
  'fr': 'Français',
  'de': 'Deutsch',
  'pl': 'Polski',
  'nl': 'Nederlands',
};

/// Flag shown before each language (a country flag stands for the
/// language only loosely: Portuguese → Brazil, the app's biggest market).
const Map<String, String> languageFlags = {
  'vi': '🇻🇳',
  'en': '🇬🇧',
  'es': '🇪🇸',
  'pt': '🇧🇷',
  'hi': '🇮🇳',
  'id': '🇮🇩',
  'zh': '🇨🇳',
  'th': '🇹🇭',
  'fr': '🇫🇷',
  'de': '🇩🇪',
  'pl': '🇵🇱',
  'nl': '🇳🇱',
};

/// Full names of units for Settings → Units.
extension SettingsLabels on AppLocalizations {
  String distanceUnitName(DistanceUnit unit) => switch (unit) {
    DistanceUnit.meter => unitMeters,
    DistanceUnit.kilometer => unitKilometers,
    DistanceUnit.foot => unitFeet,
    DistanceUnit.mile => unitMiles,
  };

  String areaUnitName(AreaUnit unit) => switch (unit) {
    AreaUnit.squareMeter => unitSquareMeters,
    AreaUnit.hectare => unitHectares,
    AreaUnit.acre => unitAcres,
    AreaUnit.squareFoot => unitSquareFeet,
  };

  String modeName(MeasurementType type) => switch (type) {
    MeasurementType.area => measurementTypeArea,
    MeasurementType.distance => measurementTypeDistance,
    MeasurementType.walk => measurementTypeWalk,
  };
}
