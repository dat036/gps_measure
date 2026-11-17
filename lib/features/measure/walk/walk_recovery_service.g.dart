// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walk_recovery_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(walkRecoveryService)
final walkRecoveryServiceProvider = WalkRecoveryServiceProvider._();

final class WalkRecoveryServiceProvider
    extends
        $FunctionalProvider<
          WalkRecoveryService,
          WalkRecoveryService,
          WalkRecoveryService
        >
    with $Provider<WalkRecoveryService> {
  WalkRecoveryServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walkRecoveryServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walkRecoveryServiceHash();

  @$internal
  @override
  $ProviderElement<WalkRecoveryService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WalkRecoveryService create(Ref ref) {
    return walkRecoveryService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WalkRecoveryService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WalkRecoveryService>(value),
    );
  }
}

String _$walkRecoveryServiceHash() =>
    r'1932834e5308943a444e3ee765a63d1e87e64f63';
