// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battery_optimization_helper.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(batteryOptimizationHelper)
final batteryOptimizationHelperProvider = BatteryOptimizationHelperProvider._();

final class BatteryOptimizationHelperProvider
    extends
        $FunctionalProvider<
          BatteryOptimizationHelper,
          BatteryOptimizationHelper,
          BatteryOptimizationHelper
        >
    with $Provider<BatteryOptimizationHelper> {
  BatteryOptimizationHelperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'batteryOptimizationHelperProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$batteryOptimizationHelperHash();

  @$internal
  @override
  $ProviderElement<BatteryOptimizationHelper> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BatteryOptimizationHelper create(Ref ref) {
    return batteryOptimizationHelper(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BatteryOptimizationHelper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BatteryOptimizationHelper>(value),
    );
  }
}

String _$batteryOptimizationHelperHash() =>
    r'9d532472769ee09df5f50a1083c9907ed069978a';
