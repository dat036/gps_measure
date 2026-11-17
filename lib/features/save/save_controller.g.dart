// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Save Measurement (`architecture.md` §8): validate → FeatureGate →
/// transaction (name, notes, status = saved, saved_at) → thumbnail (never
/// blocks, errors ignored) → saves counter.

@ProviderFor(SaveController)
final saveControllerProvider = SaveControllerFamily._();

/// Save Measurement (`architecture.md` §8): validate → FeatureGate →
/// transaction (name, notes, status = saved, saved_at) → thumbnail (never
/// blocks, errors ignored) → saves counter.
final class SaveControllerProvider
    extends $AsyncNotifierProvider<SaveController, SaveState> {
  /// Save Measurement (`architecture.md` §8): validate → FeatureGate →
  /// transaction (name, notes, status = saved, saved_at) → thumbnail (never
  /// blocks, errors ignored) → saves counter.
  SaveControllerProvider._({
    required SaveControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: _noRetry,
         name: r'saveControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$saveControllerHash();

  @override
  String toString() {
    return r'saveControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SaveController create() => SaveController();

  @override
  bool operator ==(Object other) {
    return other is SaveControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$saveControllerHash() => r'89e1e5bc2ed15b2f2d9ada14f24cce5e8f719045';

/// Save Measurement (`architecture.md` §8): validate → FeatureGate →
/// transaction (name, notes, status = saved, saved_at) → thumbnail (never
/// blocks, errors ignored) → saves counter.

final class SaveControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          SaveController,
          AsyncValue<SaveState>,
          SaveState,
          FutureOr<SaveState>,
          String
        > {
  SaveControllerFamily._()
    : super(
        retry: _noRetry,
        name: r'saveControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Save Measurement (`architecture.md` §8): validate → FeatureGate →
  /// transaction (name, notes, status = saved, saved_at) → thumbnail (never
  /// blocks, errors ignored) → saves counter.

  SaveControllerProvider call(String measurementId) =>
      SaveControllerProvider._(argument: measurementId, from: this);

  @override
  String toString() => r'saveControllerProvider';
}

/// Save Measurement (`architecture.md` §8): validate → FeatureGate →
/// transaction (name, notes, status = saved, saved_at) → thumbnail (never
/// blocks, errors ignored) → saves counter.

abstract class _$SaveController extends $AsyncNotifier<SaveState> {
  late final _$args = ref.$arg as String;
  String get measurementId => _$args;

  FutureOr<SaveState> build(String measurementId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SaveState>, SaveState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SaveState>, SaveState>,
              AsyncValue<SaveState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
