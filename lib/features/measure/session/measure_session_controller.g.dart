// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measure_session_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Area/Distance measuring session (`architecture.md` §8).
///
/// Every geometry change goes through [GeometryEditor] (undo), recomputes
/// stats and is autosaved to the draft 300 ms later. The draft row is
/// created on the first point (or first photo). Writes are serialized so a
/// quick burst of edits can never save out of order. Leaving the screen
/// flushes pending changes; a draft left with no points and no photos is
/// deleted.
///
/// With [editing] (Edit of a saved measurement) the same editor works on a
/// copy and nothing is written: `EditController.saveChanges` does it.

@ProviderFor(MeasureSessionController)
final measureSessionControllerProvider = MeasureSessionControllerFamily._();

/// Area/Distance measuring session (`architecture.md` §8).
///
/// Every geometry change goes through [GeometryEditor] (undo), recomputes
/// stats and is autosaved to the draft 300 ms later. The draft row is
/// created on the first point (or first photo). Writes are serialized so a
/// quick burst of edits can never save out of order. Leaving the screen
/// flushes pending changes; a draft left with no points and no photos is
/// deleted.
///
/// With [editing] (Edit of a saved measurement) the same editor works on a
/// copy and nothing is written: `EditController.saveChanges` does it.
final class MeasureSessionControllerProvider
    extends
        $AsyncNotifierProvider<MeasureSessionController, MeasureSessionState> {
  /// Area/Distance measuring session (`architecture.md` §8).
  ///
  /// Every geometry change goes through [GeometryEditor] (undo), recomputes
  /// stats and is autosaved to the draft 300 ms later. The draft row is
  /// created on the first point (or first photo). Writes are serialized so a
  /// quick burst of edits can never save out of order. Leaving the screen
  /// flushes pending changes; a draft left with no points and no photos is
  /// deleted.
  ///
  /// With [editing] (Edit of a saved measurement) the same editor works on a
  /// copy and nothing is written: `EditController.saveChanges` does it.
  MeasureSessionControllerProvider._({
    required MeasureSessionControllerFamily super.from,
    required (MeasurementType, String?, {bool editing}) super.argument,
  }) : super(
         retry: null,
         name: r'measureSessionControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$measureSessionControllerHash();

  @override
  String toString() {
    return r'measureSessionControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  MeasureSessionController create() => MeasureSessionController();

  @override
  bool operator ==(Object other) {
    return other is MeasureSessionControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$measureSessionControllerHash() =>
    r'c67e9c2e36abb3b92d47b2f05428d754b8d325a5';

/// Area/Distance measuring session (`architecture.md` §8).
///
/// Every geometry change goes through [GeometryEditor] (undo), recomputes
/// stats and is autosaved to the draft 300 ms later. The draft row is
/// created on the first point (or first photo). Writes are serialized so a
/// quick burst of edits can never save out of order. Leaving the screen
/// flushes pending changes; a draft left with no points and no photos is
/// deleted.
///
/// With [editing] (Edit of a saved measurement) the same editor works on a
/// copy and nothing is written: `EditController.saveChanges` does it.

final class MeasureSessionControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          MeasureSessionController,
          AsyncValue<MeasureSessionState>,
          MeasureSessionState,
          FutureOr<MeasureSessionState>,
          (MeasurementType, String?, {bool editing})
        > {
  MeasureSessionControllerFamily._()
    : super(
        retry: null,
        name: r'measureSessionControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Area/Distance measuring session (`architecture.md` §8).
  ///
  /// Every geometry change goes through [GeometryEditor] (undo), recomputes
  /// stats and is autosaved to the draft 300 ms later. The draft row is
  /// created on the first point (or first photo). Writes are serialized so a
  /// quick burst of edits can never save out of order. Leaving the screen
  /// flushes pending changes; a draft left with no points and no photos is
  /// deleted.
  ///
  /// With [editing] (Edit of a saved measurement) the same editor works on a
  /// copy and nothing is written: `EditController.saveChanges` does it.

  MeasureSessionControllerProvider call(
    MeasurementType type,
    String? draftId, {
    bool editing = false,
  }) => MeasureSessionControllerProvider._(
    argument: (type, draftId, editing: editing),
    from: this,
  );

  @override
  String toString() => r'measureSessionControllerProvider';
}

/// Area/Distance measuring session (`architecture.md` §8).
///
/// Every geometry change goes through [GeometryEditor] (undo), recomputes
/// stats and is autosaved to the draft 300 ms later. The draft row is
/// created on the first point (or first photo). Writes are serialized so a
/// quick burst of edits can never save out of order. Leaving the screen
/// flushes pending changes; a draft left with no points and no photos is
/// deleted.
///
/// With [editing] (Edit of a saved measurement) the same editor works on a
/// copy and nothing is written: `EditController.saveChanges` does it.

abstract class _$MeasureSessionController
    extends $AsyncNotifier<MeasureSessionState> {
  late final _$args = ref.$arg as (MeasurementType, String?, {bool editing});
  MeasurementType get type => _$args.$1;
  String? get draftId => _$args.$2;
  bool get editing => _$args.editing;

  FutureOr<MeasureSessionState> build(
    MeasurementType type,
    String? draftId, {
    bool editing = false,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<MeasureSessionState>, MeasureSessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MeasureSessionState>, MeasureSessionState>,
              AsyncValue<MeasureSessionState>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(_$args.$1, _$args.$2, editing: _$args.editing),
    );
  }
}
