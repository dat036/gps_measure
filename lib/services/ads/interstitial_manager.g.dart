// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interstitial_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(interstitialManager)
final interstitialManagerProvider = InterstitialManagerProvider._();

final class InterstitialManagerProvider
    extends
        $FunctionalProvider<
          InterstitialManager,
          InterstitialManager,
          InterstitialManager
        >
    with $Provider<InterstitialManager> {
  InterstitialManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interstitialManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interstitialManagerHash();

  @$internal
  @override
  $ProviderElement<InterstitialManager> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InterstitialManager create(Ref ref) {
    return interstitialManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InterstitialManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InterstitialManager>(value),
    );
  }
}

String _$interstitialManagerHash() =>
    r'61bb1e074c94383183b8e4928a4f44aaaf649719';
