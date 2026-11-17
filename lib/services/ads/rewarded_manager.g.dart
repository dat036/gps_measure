// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rewarded_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(rewardedManager)
final rewardedManagerProvider = RewardedManagerProvider._();

final class RewardedManagerProvider
    extends
        $FunctionalProvider<RewardedManager, RewardedManager, RewardedManager>
    with $Provider<RewardedManager> {
  RewardedManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rewardedManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rewardedManagerHash();

  @$internal
  @override
  $ProviderElement<RewardedManager> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RewardedManager create(Ref ref) {
    return rewardedManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RewardedManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RewardedManager>(value),
    );
  }
}

String _$rewardedManagerHash() => r'e28ae76d028a28a0ad84cb254e8ece5981346909';
