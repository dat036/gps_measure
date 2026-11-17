import 'dart:ui';

import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/features/settings/app_settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

/// Device locale, used for region-dependent default units.
@Riverpod(keepAlive: true)
Locale deviceLocale(Ref ref) => PlatformDispatcher.instance.locale;

/// Current [AppSettings], loaded synchronously from SharedPreferences.
/// Every change is persisted immediately.
@Riverpod(keepAlive: true)
class Settings extends _$Settings {
  @override
  AppSettings build() => ref
      .watch(settingsRepositoryProvider)
      .load(countryCode: ref.watch(deviceLocaleProvider).countryCode);

  Future<void> change(AppSettings Function(AppSettings current) update) {
    final next = update(state);
    state = next;
    return ref.read(settingsRepositoryProvider).save(next);
  }

  /// `null` follows the system language.
  Future<void> setLocaleCode(String? code) =>
      change((s) => s.copyWith(localeCode: code));
}
