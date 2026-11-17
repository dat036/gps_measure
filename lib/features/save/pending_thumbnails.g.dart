// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_thumbnails.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pendingThumbnails)
final pendingThumbnailsProvider = PendingThumbnailsProvider._();

final class PendingThumbnailsProvider
    extends
        $FunctionalProvider<
          PendingThumbnails,
          PendingThumbnails,
          PendingThumbnails
        >
    with $Provider<PendingThumbnails> {
  PendingThumbnailsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingThumbnailsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingThumbnailsHash();

  @$internal
  @override
  $ProviderElement<PendingThumbnails> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PendingThumbnails create(Ref ref) {
    return pendingThumbnails(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PendingThumbnails value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PendingThumbnails>(value),
    );
  }
}

String _$pendingThumbnailsHash() => r'6a1b7f037a497d3844eb518a9e8ee5fbdd5d86df';
