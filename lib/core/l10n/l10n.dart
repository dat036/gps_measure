import 'package:flutter/widgets.dart';
import 'package:gps_measurement/l10n/gen/app_localizations.dart';

export 'package:gps_measurement/l10n/gen/app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
