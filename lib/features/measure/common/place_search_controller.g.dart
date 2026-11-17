// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_search_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Search sheet logic: runs only on submit (never per keystroke — the OS
/// geocoder is rate limited), remembers the last 5 successful queries.

@ProviderFor(PlaceSearchController)
final placeSearchControllerProvider = PlaceSearchControllerProvider._();

/// Search sheet logic: runs only on submit (never per keystroke — the OS
/// geocoder is rate limited), remembers the last 5 successful queries.
final class PlaceSearchControllerProvider
    extends $NotifierProvider<PlaceSearchController, PlaceSearchState> {
  /// Search sheet logic: runs only on submit (never per keystroke — the OS
  /// geocoder is rate limited), remembers the last 5 successful queries.
  PlaceSearchControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'placeSearchControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$placeSearchControllerHash();

  @$internal
  @override
  PlaceSearchController create() => PlaceSearchController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlaceSearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlaceSearchState>(value),
    );
  }
}

String _$placeSearchControllerHash() =>
    r'fc48e57ccc7977bb9852c345a35b8d7c5cbdd849';

/// Search sheet logic: runs only on submit (never per keystroke — the OS
/// geocoder is rate limited), remembers the last 5 successful queries.

abstract class _$PlaceSearchController extends $Notifier<PlaceSearchState> {
  PlaceSearchState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PlaceSearchState, PlaceSearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlaceSearchState, PlaceSearchState>,
              PlaceSearchState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
