import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_locale.g.dart';

/// App locale from Settings. `null` = follow the system.
/// Change it with `settingsProvider.notifier.setLocaleCode`.
@Riverpod(keepAlive: true)
Locale? appLocale(Ref ref) {
  final code = ref.watch(settingsProvider.select((s) => s.localeCode));
  return code == null ? null : Locale(code);
}
