// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_gate_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Premium gate used by Save / photos / export / ads: the `premium`
/// entitlement and the free limits of [MonetizationConfig].

@ProviderFor(featureGate)
final featureGateProvider = FeatureGateProvider._();

/// Premium gate used by Save / photos / export / ads: the `premium`
/// entitlement and the free limits of [MonetizationConfig].

final class FeatureGateProvider
    extends $FunctionalProvider<FeatureGate, FeatureGate, FeatureGate>
    with $Provider<FeatureGate> {
  /// Premium gate used by Save / photos / export / ads: the `premium`
  /// entitlement and the free limits of [MonetizationConfig].
  FeatureGateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featureGateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featureGateHash();

  @$internal
  @override
  $ProviderElement<FeatureGate> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FeatureGate create(Ref ref) {
    return featureGate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeatureGate value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeatureGate>(value),
    );
  }
}

String _$featureGateHash() => r'3fa34ef63b398d84d08aa9ddb563b2f73db789cf';
