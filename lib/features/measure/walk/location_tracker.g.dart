// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_tracker.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(locationTracker)
final locationTrackerProvider = LocationTrackerProvider._();

final class LocationTrackerProvider
    extends
        $FunctionalProvider<LocationTracker, LocationTracker, LocationTracker>
    with $Provider<LocationTracker> {
  LocationTrackerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationTrackerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationTrackerHash();

  @$internal
  @override
  $ProviderElement<LocationTracker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocationTracker create(Ref ref) {
    return locationTracker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationTracker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationTracker>(value),
    );
  }
}

String _$locationTrackerHash() => r'970c362cff0f39af29bbc68a5a4c0bbd496e99fc';
