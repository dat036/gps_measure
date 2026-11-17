// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Saved tab filters (`design.md` §5.7). The lists themselves are Drift
/// streams ([savedList], [draftList], [savedCounts]) so they update as soon
/// as anything is saved, renamed or deleted.

@ProviderFor(SavedController)
final savedControllerProvider = SavedControllerProvider._();

/// Saved tab filters (`design.md` §5.7). The lists themselves are Drift
/// streams ([savedList], [draftList], [savedCounts]) so they update as soon
/// as anything is saved, renamed or deleted.
final class SavedControllerProvider
    extends $NotifierProvider<SavedController, SavedFilter> {
  /// Saved tab filters (`design.md` §5.7). The lists themselves are Drift
  /// streams ([savedList], [draftList], [savedCounts]) so they update as soon
  /// as anything is saved, renamed or deleted.
  SavedControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedControllerHash();

  @$internal
  @override
  SavedController create() => SavedController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SavedFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SavedFilter>(value),
    );
  }
}

String _$savedControllerHash() => r'35fdc60b8364b10151d04f5985ec9e0b3fccb617';

/// Saved tab filters (`design.md` §5.7). The lists themselves are Drift
/// streams ([savedList], [draftList], [savedCounts]) so they update as soon
/// as anything is saved, renamed or deleted.

abstract class _$SavedController extends $Notifier<SavedFilter> {
  SavedFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SavedFilter, SavedFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SavedFilter, SavedFilter>,
              SavedFilter,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Saved measurements matching the filter, newest first.

@ProviderFor(savedList)
final savedListProvider = SavedListProvider._();

/// Saved measurements matching the filter, newest first.

final class SavedListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MeasurementSummary>>,
          List<MeasurementSummary>,
          Stream<List<MeasurementSummary>>
        >
    with
        $FutureModifier<List<MeasurementSummary>>,
        $StreamProvider<List<MeasurementSummary>> {
  /// Saved measurements matching the filter, newest first.
  SavedListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedListHash();

  @$internal
  @override
  $StreamProviderElement<List<MeasurementSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MeasurementSummary>> create(Ref ref) {
    return savedList(ref);
  }
}

String _$savedListHash() => r'e9bccfa737ddc7c8c8ccac4473aa868377874511';

/// Saved counts per type for the chips.

@ProviderFor(savedCounts)
final savedCountsProvider = SavedCountsProvider._();

/// Saved counts per type for the chips.

final class SavedCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<MeasurementType, int>>,
          Map<MeasurementType, int>,
          Stream<Map<MeasurementType, int>>
        >
    with
        $FutureModifier<Map<MeasurementType, int>>,
        $StreamProvider<Map<MeasurementType, int>> {
  /// Saved counts per type for the chips.
  SavedCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedCountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedCountsHash();

  @$internal
  @override
  $StreamProviderElement<Map<MeasurementType, int>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<MeasurementType, int>> create(Ref ref) {
    return savedCounts(ref);
  }
}

String _$savedCountsHash() => r'2a977050357005b4caf8fa4fbb74b10753368295';

/// Drafts and finished-not-saved walks, newest first (Saved drafts
/// section, Home "Continue Measurement").

@ProviderFor(draftList)
final draftListProvider = DraftListProvider._();

/// Drafts and finished-not-saved walks, newest first (Saved drafts
/// section, Home "Continue Measurement").

final class DraftListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MeasurementSummary>>,
          List<MeasurementSummary>,
          Stream<List<MeasurementSummary>>
        >
    with
        $FutureModifier<List<MeasurementSummary>>,
        $StreamProvider<List<MeasurementSummary>> {
  /// Drafts and finished-not-saved walks, newest first (Saved drafts
  /// section, Home "Continue Measurement").
  DraftListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'draftListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$draftListHash();

  @$internal
  @override
  $StreamProviderElement<List<MeasurementSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MeasurementSummary>> create(Ref ref) {
    return draftList(ref);
  }
}

String _$draftListHash() => r'e7d9884a8c38ff20965862d72e38c64d42feff1d';
