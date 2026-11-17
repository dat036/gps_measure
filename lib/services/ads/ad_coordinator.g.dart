// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_coordinator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adCoordinator)
final adCoordinatorProvider = AdCoordinatorProvider._();

final class AdCoordinatorProvider
    extends $FunctionalProvider<AdCoordinator, AdCoordinator, AdCoordinator>
    with $Provider<AdCoordinator> {
  AdCoordinatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adCoordinatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adCoordinatorHash();

  @$internal
  @override
  $ProviderElement<AdCoordinator> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AdCoordinator create(Ref ref) {
    return adCoordinator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdCoordinator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdCoordinator>(value),
    );
  }
}

String _$adCoordinatorHash() => r'81678ff31a9411deb9553f7fce5fde93296a989b';
