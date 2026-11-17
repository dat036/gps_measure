// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Device locale, used for region-dependent default units.

@ProviderFor(deviceLocale)
final deviceLocaleProvider = DeviceLocaleProvider._();

/// Device locale, used for region-dependent default units.

final class DeviceLocaleProvider
    extends $FunctionalProvider<Locale, Locale, Locale>
    with $Provider<Locale> {
  /// Device locale, used for region-dependent default units.
  DeviceLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceLocaleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceLocaleHash();

  @$internal
  @override
  $ProviderElement<Locale> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Locale create(Ref ref) {
    return deviceLocale(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$deviceLocaleHash() => r'81c58216a195cb37feb814f03b5e99bbd2099aab';

/// Current [AppSettings], loaded synchronously from SharedPreferences.
/// Every change is persisted immediately.

@ProviderFor(Settings)
final settingsProvider = SettingsProvider._();

/// Current [AppSettings], loaded synchronously from SharedPreferences.
/// Every change is persisted immediately.
final class SettingsProvider extends $NotifierProvider<Settings, AppSettings> {
  /// Current [AppSettings], loaded synchronously from SharedPreferences.
  /// Every change is persisted immediately.
  SettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsHash();

  @$internal
  @override
  Settings create() => Settings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppSettings>(value),
    );
  }
}

String _$settingsHash() => r'ac576f42607b688fc465046642af154490641481';

/// Current [AppSettings], loaded synchronously from SharedPreferences.
/// Every change is persisted immediately.

abstract class _$Settings extends $Notifier<AppSettings> {
  AppSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppSettings, AppSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppSettings, AppSettings>,
              AppSettings,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
