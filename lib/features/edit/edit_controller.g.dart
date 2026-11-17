// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Edit Measurement (`plan.md` P7-08). Details (name, notes, photos) are
/// held here; geometry (Area/Distance) is edited by
/// `MeasureSessionController(editing: true)` on a copy. Nothing touches the
/// saved record until [saveChanges]; [discard] undoes the photo imports.

@ProviderFor(EditController)
final editControllerProvider = EditControllerFamily._();

/// Edit Measurement (`plan.md` P7-08). Details (name, notes, photos) are
/// held here; geometry (Area/Distance) is edited by
/// `MeasureSessionController(editing: true)` on a copy. Nothing touches the
/// saved record until [saveChanges]; [discard] undoes the photo imports.
final class EditControllerProvider
    extends $AsyncNotifierProvider<EditController, EditState> {
  /// Edit Measurement (`plan.md` P7-08). Details (name, notes, photos) are
  /// held here; geometry (Area/Distance) is edited by
  /// `MeasureSessionController(editing: true)` on a copy. Nothing touches the
  /// saved record until [saveChanges]; [discard] undoes the photo imports.
  EditControllerProvider._({
    required EditControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: _noRetry,
         name: r'editControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$editControllerHash();

  @override
  String toString() {
    return r'editControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EditController create() => EditController();

  @override
  bool operator ==(Object other) {
    return other is EditControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$editControllerHash() => r'b5e1ba265ecf97b3f37cfd81d25dcbeb306da411';

/// Edit Measurement (`plan.md` P7-08). Details (name, notes, photos) are
/// held here; geometry (Area/Distance) is edited by
/// `MeasureSessionController(editing: true)` on a copy. Nothing touches the
/// saved record until [saveChanges]; [discard] undoes the photo imports.

final class EditControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          EditController,
          AsyncValue<EditState>,
          EditState,
          FutureOr<EditState>,
          String
        > {
  EditControllerFamily._()
    : super(
        retry: _noRetry,
        name: r'editControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Edit Measurement (`plan.md` P7-08). Details (name, notes, photos) are
  /// held here; geometry (Area/Distance) is edited by
  /// `MeasureSessionController(editing: true)` on a copy. Nothing touches the
  /// saved record until [saveChanges]; [discard] undoes the photo imports.

  EditControllerProvider call(String measurementId) =>
      EditControllerProvider._(argument: measurementId, from: this);

  @override
  String toString() => r'editControllerProvider';
}

/// Edit Measurement (`plan.md` P7-08). Details (name, notes, photos) are
/// held here; geometry (Area/Distance) is edited by
/// `MeasureSessionController(editing: true)` on a copy. Nothing touches the
/// saved record until [saveChanges]; [discard] undoes the photo imports.

abstract class _$EditController extends $AsyncNotifier<EditState> {
  late final _$args = ref.$arg as String;
  String get measurementId => _$args;

  FutureOr<EditState> build(String measurementId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<EditState>, EditState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EditState>, EditState>,
              AsyncValue<EditState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
