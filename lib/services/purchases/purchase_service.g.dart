// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(purchaseService)
final purchaseServiceProvider = PurchaseServiceProvider._();

final class PurchaseServiceProvider
    extends
        $FunctionalProvider<PurchaseService, PurchaseService, PurchaseService>
    with $Provider<PurchaseService> {
  PurchaseServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'purchaseServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$purchaseServiceHash();

  @$internal
  @override
  $ProviderElement<PurchaseService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PurchaseService create(Ref ref) {
    return purchaseService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PurchaseService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PurchaseService>(value),
    );
  }
}

String _$purchaseServiceHash() => r'a824d74ed312d3cd56ca7fe42ac2dfe6376092a2';

/// Source of truth for "is premium" in the UI (`architecture.md` §11).

@ProviderFor(Premium)
final premiumProvider = PremiumProvider._();

/// Source of truth for "is premium" in the UI (`architecture.md` §11).
final class PremiumProvider extends $NotifierProvider<Premium, PremiumStatus> {
  /// Source of truth for "is premium" in the UI (`architecture.md` §11).
  PremiumProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'premiumProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$premiumHash();

  @$internal
  @override
  Premium create() => Premium();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PremiumStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PremiumStatus>(value),
    );
  }
}

String _$premiumHash() => r'6b64756e0e2a0ad6583fcf3b9c2901acb6b8e8ed';

/// Source of truth for "is premium" in the UI (`architecture.md` §11).

abstract class _$Premium extends $Notifier<PremiumStatus> {
  PremiumStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PremiumStatus, PremiumStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PremiumStatus, PremiumStatus>,
              PremiumStatus,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
