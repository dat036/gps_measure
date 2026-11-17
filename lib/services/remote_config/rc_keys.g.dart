// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rc_keys.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(monetizationConfig)
final monetizationConfigProvider = MonetizationConfigProvider._();

final class MonetizationConfigProvider
    extends
        $FunctionalProvider<
          MonetizationConfig,
          MonetizationConfig,
          MonetizationConfig
        >
    with $Provider<MonetizationConfig> {
  MonetizationConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monetizationConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monetizationConfigHash();

  @$internal
  @override
  $ProviderElement<MonetizationConfig> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MonetizationConfig create(Ref ref) {
    return monetizationConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MonetizationConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MonetizationConfig>(value),
    );
  }
}

String _$monetizationConfigHash() =>
    r'8f1f98f8ac0357b167be291c1a0a543afa036d54';
