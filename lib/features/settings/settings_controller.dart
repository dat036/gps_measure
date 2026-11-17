import 'package:flutter/foundation.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/features/settings/app_settings.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:gps_measurement/services/support/support_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_controller.g.dart';

/// Version and device, for the Settings footer and feedback mail.
@Riverpod(keepAlive: true)
Future<AppInfo> appInfo(Ref ref) => ref.watch(supportServiceProvider).appInfo();

/// Setting tab and its sub-screens (`design.md` §5.10–5.13). State: which
/// Support & Legal links are configured (the others are hidden, so no
/// item is a dead button). Preferences are written through
/// [settingsProvider] and apply immediately everywhere.
@riverpod
class SettingsController extends _$SettingsController {
  @override
  SupportLinks build() => ref.watch(supportLinksProvider);

  Settings get _settings => ref.read(settingsProvider.notifier);

  Future<void> _change(AppSettings Function(AppSettings s) update) =>
      _settings.change(update);

  // ------------------------------------------------------------ preferences

  // TODO(phase-10): analytics unit_changed{kind, unit}.
  Future<void> setDistanceUnit(DistanceUnit unit) =>
      _change((s) => s.copyWith(distanceUnit: unit));

  Future<void> setAreaUnit(AreaUnit unit) =>
      _change((s) => s.copyWith(areaUnit: unit));

  Future<void> setShowSecondaryUnit({required bool on}) =>
      _change((s) => s.copyWith(showSecondaryUnit: on));

  // TODO(phase-10): analytics map_style_changed{style}.
  Future<void> setMapStyle(MapStyle style) =>
      _change((s) => s.copyWith(mapStyle: style));

  /// `null` follows the system language.
  Future<void> setLocaleCode(String? code) => _settings.setLocaleCode(code);

  Future<void> setDefaultMode(MeasurementType mode) =>
      _change((s) => s.copyWith(defaultMode: mode));

  Future<void> setShowGpsAccuracy({required bool on}) =>
      _change((s) => s.copyWith(showGpsAccuracy: on));

  Future<void> setAutoCenter({required bool on}) =>
      _change((s) => s.copyWith(autoCenter: on));

  Future<void> setSavePhotos({required bool on}) =>
      _change((s) => s.copyWith(savePhotosToMeasurement: on));

  Future<void> setKeepScreenAwake({required bool on}) =>
      _change((s) => s.copyWith(keepScreenAwake: on));

  // ------------------------------------------------------------ support

  bool get canSendFeedback => state.supportEmail.isNotEmpty;

  /// iOS opens the listing by App Store ID; Android by package name.
  bool get canRate =>
      defaultTargetPlatform != TargetPlatform.iOS ||
      state.appStoreId.isNotEmpty;

  SupportService get _support => ref.read(supportServiceProvider);

  /// Mail to support with version/device prefilled. False when no mail
  /// app can take it.
  Future<bool> sendFeedback({
    required String subject,
    required String appName,
    required String localeTag,
  }) async {
    final info = await ref.read(appInfoProvider.future);
    return _support.launch(
      feedbackUri(
        email: state.supportEmail,
        subject: subject,
        appName: appName,
        info: info,
        localeTag: localeTag,
      ),
    );
  }

  Future<bool> rate() => _support.openStoreListing();

  Future<bool> openPrivacyPolicy() =>
      _support.launch(Uri.parse(state.privacyPolicyUrl));

  Future<bool> openTerms() => _support.launch(Uri.parse(state.termsUrl));
}

/// `mailto:` with subject and a diagnostics footer under an empty body:
/// "LandMeasure 1.0.0 (1) · Android 14 (SDK 34) · Google Pixel 7 · vi".
/// Encoded by hand: `Uri.queryParameters` turns spaces into `+`, which
/// mail apps show literally.
@visibleForTesting
Uri feedbackUri({
  required String email,
  required String subject,
  required String appName,
  required AppInfo info,
  required String localeTag,
}) {
  final footer = [
    '$appName ${info.version} (${info.build})',
    info.os,
    info.device,
    localeTag,
  ].where((s) => s.isNotEmpty).join(' · ');
  final body = '\n\n\n---\n$footer';
  return Uri.parse(
    'mailto:$email'
    '?subject=${Uri.encodeComponent(subject)}'
    '&body=${Uri.encodeComponent(body)}',
  );
}
