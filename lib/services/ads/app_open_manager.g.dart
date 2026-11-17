// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_open_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appOpenManager)
final appOpenManagerProvider = AppOpenManagerProvider._();

final class AppOpenManagerProvider
    extends $FunctionalProvider<AppOpenManager, AppOpenManager, AppOpenManager>
    with $Provider<AppOpenManager> {
  AppOpenManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appOpenManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appOpenManagerHash();

  @$internal
  @override
  $ProviderElement<AppOpenManager> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppOpenManager create(Ref ref) {
    return appOpenManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppOpenManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppOpenManager>(value),
    );
  }
}

String _$appOpenManagerHash() => r'ab34dbafcd2a1d23676043c8211247dc9ce2dac1';
