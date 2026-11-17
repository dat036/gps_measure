// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ads_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Mobile Ads SDK lifecycle (`architecture.md` §9 step 9, §11): consent
/// first, the SDK only when ads may be requested and the user is free.
/// State: the SDK is initialized and ads may be requested.

@ProviderFor(AdsService)
final adsServiceProvider = AdsServiceProvider._();

/// Mobile Ads SDK lifecycle (`architecture.md` §9 step 9, §11): consent
/// first, the SDK only when ads may be requested and the user is free.
/// State: the SDK is initialized and ads may be requested.
final class AdsServiceProvider extends $NotifierProvider<AdsService, bool> {
  /// Mobile Ads SDK lifecycle (`architecture.md` §9 step 9, §11): consent
  /// first, the SDK only when ads may be requested and the user is free.
  /// State: the SDK is initialized and ads may be requested.
  AdsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adsServiceHash();

  @$internal
  @override
  AdsService create() => AdsService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$adsServiceHash() => r'5acb3de583c9291fa3b8ee945c3f1280f010c359';

/// Mobile Ads SDK lifecycle (`architecture.md` §9 step 9, §11): consent
/// first, the SDK only when ads may be requested and the user is free.
/// State: the SDK is initialized and ads may be requested.

abstract class _$AdsService extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Ads may be shown now: SDK ready and the user is not premium. Every ad
/// surface checks this, so buying premium removes ads at once.

@ProviderFor(adsEnabled)
final adsEnabledProvider = AdsEnabledProvider._();

/// Ads may be shown now: SDK ready and the user is not premium. Every ad
/// surface checks this, so buying premium removes ads at once.

final class AdsEnabledProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Ads may be shown now: SDK ready and the user is not premium. Every ad
  /// surface checks this, so buying premium removes ads at once.
  AdsEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adsEnabledProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adsEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return adsEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$adsEnabledHash() => r'a4e15ce58144f10252949798892ae72f08e7c3b8';
