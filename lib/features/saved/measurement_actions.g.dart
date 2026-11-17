// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(measurementActions)
final measurementActionsProvider = MeasurementActionsProvider._();

final class MeasurementActionsProvider
    extends
        $FunctionalProvider<
          MeasurementActions,
          MeasurementActions,
          MeasurementActions
        >
    with $Provider<MeasurementActions> {
  MeasurementActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'measurementActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$measurementActionsHash();

  @$internal
  @override
  $ProviderElement<MeasurementActions> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MeasurementActions create(Ref ref) {
    return measurementActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeasurementActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeasurementActions>(value),
    );
  }
}

String _$measurementActionsHash() =>
    r'1c2565121b60bd84a0b13c443e6276302cf95b9d';
