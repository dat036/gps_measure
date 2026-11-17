// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walk_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Walk noise-filter tunables.
// TODO(phase-10): read walk_* keys from Remote Config.

@ProviderFor(trackFilterConfig)
final trackFilterConfigProvider = TrackFilterConfigProvider._();

/// Walk noise-filter tunables.
// TODO(phase-10): read walk_* keys from Remote Config.

final class TrackFilterConfigProvider
    extends
        $FunctionalProvider<
          TrackFilterConfig,
          TrackFilterConfig,
          TrackFilterConfig
        >
    with $Provider<TrackFilterConfig> {
  /// Walk noise-filter tunables.
  // TODO(phase-10): read walk_* keys from Remote Config.
  TrackFilterConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackFilterConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackFilterConfigHash();

  @$internal
  @override
  $ProviderElement<TrackFilterConfig> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TrackFilterConfig create(Ref ref) {
    return trackFilterConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrackFilterConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrackFilterConfig>(value),
    );
  }
}

String _$trackFilterConfigHash() => r'4d30dd4542a2f8fbff597e924c122a4fd44f2a12';

/// Walk & Measure recording (`architecture.md` §8).
///
/// `LocationTracker` fixes → [TrackFilter] → appended to the current
/// segment → stats → buffered and flushed to the draft every
/// [flushEveryPoints] points or [flushInterval] (Pause/Finish/app in
/// background flush at once). keepAlive: recording must survive rebuilds
/// and routes pushed on top of the Walk screen.
///
/// Elapsed time = seconds banked at the last Pause + (now − last Resume).
/// While recording, `walk_elapsed_sec` in the DB holds the total at the last
/// flush, so a crash loses at most [flushInterval].

@ProviderFor(WalkController)
final walkControllerProvider = WalkControllerProvider._();

/// Walk & Measure recording (`architecture.md` §8).
///
/// `LocationTracker` fixes → [TrackFilter] → appended to the current
/// segment → stats → buffered and flushed to the draft every
/// [flushEveryPoints] points or [flushInterval] (Pause/Finish/app in
/// background flush at once). keepAlive: recording must survive rebuilds
/// and routes pushed on top of the Walk screen.
///
/// Elapsed time = seconds banked at the last Pause + (now − last Resume).
/// While recording, `walk_elapsed_sec` in the DB holds the total at the last
/// flush, so a crash loses at most [flushInterval].
final class WalkControllerProvider
    extends $NotifierProvider<WalkController, WalkState> {
  /// Walk & Measure recording (`architecture.md` §8).
  ///
  /// `LocationTracker` fixes → [TrackFilter] → appended to the current
  /// segment → stats → buffered and flushed to the draft every
  /// [flushEveryPoints] points or [flushInterval] (Pause/Finish/app in
  /// background flush at once). keepAlive: recording must survive rebuilds
  /// and routes pushed on top of the Walk screen.
  ///
  /// Elapsed time = seconds banked at the last Pause + (now − last Resume).
  /// While recording, `walk_elapsed_sec` in the DB holds the total at the last
  /// flush, so a crash loses at most [flushInterval].
  WalkControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walkControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walkControllerHash();

  @$internal
  @override
  WalkController create() => WalkController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WalkState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WalkState>(value),
    );
  }
}

String _$walkControllerHash() => r'5d586cee8fab6eafd832a4fdd61dfb3dd5614d2d';

/// Walk & Measure recording (`architecture.md` §8).
///
/// `LocationTracker` fixes → [TrackFilter] → appended to the current
/// segment → stats → buffered and flushed to the draft every
/// [flushEveryPoints] points or [flushInterval] (Pause/Finish/app in
/// background flush at once). keepAlive: recording must survive rebuilds
/// and routes pushed on top of the Walk screen.
///
/// Elapsed time = seconds banked at the last Pause + (now − last Resume).
/// While recording, `walk_elapsed_sec` in the DB holds the total at the last
/// flush, so a crash loses at most [flushInterval].

abstract class _$WalkController extends $Notifier<WalkState> {
  WalkState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<WalkState, WalkState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<WalkState, WalkState>,
              WalkState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
