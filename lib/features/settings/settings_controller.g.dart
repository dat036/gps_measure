// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Version and device, for the Settings footer and feedback mail.

@ProviderFor(appInfo)
final appInfoProvider = AppInfoProvider._();

/// Version and device, for the Settings footer and feedback mail.

final class AppInfoProvider
    extends $FunctionalProvider<AsyncValue<AppInfo>, AppInfo, FutureOr<AppInfo>>
    with $FutureModifier<AppInfo>, $FutureProvider<AppInfo> {
  /// Version and device, for the Settings footer and feedback mail.
  AppInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appInfoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appInfoHash();

  @$internal
  @override
  $FutureProviderElement<AppInfo> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AppInfo> create(Ref ref) {
    return appInfo(ref);
  }
}

String _$appInfoHash() => r'287127b09c0ffe3193eb925d1be6f2d736ee1a55';

/// Setting tab and its sub-screens (`design.md` §5.10–5.13). State: which
/// Support & Legal links are configured (the others are hidden, so no
/// item is a dead button). Preferences are written through
/// [settingsProvider] and apply immediately everywhere.

@ProviderFor(SettingsController)
final settingsControllerProvider = SettingsControllerProvider._();

/// Setting tab and its sub-screens (`design.md` §5.10–5.13). State: which
/// Support & Legal links are configured (the others are hidden, so no
/// item is a dead button). Preferences are written through
/// [settingsProvider] and apply immediately everywhere.
final class SettingsControllerProvider
    extends $NotifierProvider<SettingsController, SupportLinks> {
  /// Setting tab and its sub-screens (`design.md` §5.10–5.13). State: which
  /// Support & Legal links are configured (the others are hidden, so no
  /// item is a dead button). Preferences are written through
  /// [settingsProvider] and apply immediately everywhere.
  SettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsControllerHash();

  @$internal
  @override
  SettingsController create() => SettingsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupportLinks value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupportLinks>(value),
    );
  }
}

String _$settingsControllerHash() =>
    r'3e43dd01dec3a92a8152f967b8ad15c96a820073';

/// Setting tab and its sub-screens (`design.md` §5.10–5.13). State: which
/// Support & Legal links are configured (the others are hidden, so no
/// item is a dead button). Preferences are written through
/// [settingsProvider] and apply immediately everywhere.

abstract class _$SettingsController extends $Notifier<SupportLinks> {
  SupportLinks build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SupportLinks, SupportLinks>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SupportLinks, SupportLinks>,
              SupportLinks,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
