import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/features/measure/walk/walk_controller.dart';
import 'package:gps_measurement/services/ads/ad_coordinator.dart';
import 'package:gps_measurement/services/ads/ad_unit_ids.dart';
import 'package:gps_measurement/services/ads/ads_service.dart';
import 'package:gps_measurement/services/remote_config/rc_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'interstitial_manager.g.dart';

/// Whether an interstitial may be shown now: ads on, no walk recording,
/// and at least [MonetizationConfig.interstitialMinInterval] since the
/// previous one was closed. When false the caller just carries on with
/// what the user asked for.
@visibleForTesting
bool interstitialAllowed({
  required bool adsEnabled,
  required DateTime now,
  required DateTime? lastClosedAt,
  required MonetizationConfig config,
  required bool walkRecording,
}) {
  if (!adsEnabled || walkRecording) return false;
  return lastClosedAt == null ||
      now.difference(lastClosedAt) >= config.interstitialMinInterval;
}

/// Interstitial shown after a Save / Save Changes.
///
/// One cached ad: preloaded when the user starts measuring (and again right
/// after each show). `_ad` is only ever filled when null and is set back to
/// null the moment an ad is shown, so an ad is never shown twice or
/// requested over a cached one. An ad that could not be shown (too soon
/// after the last one) stays cached for the next opportunity, until it is
/// older than [adLifetime].
class InterstitialManager {
  InterstitialManager(this._ref);

  final Ref _ref;

  /// Google: an interstitial older than 1 hour must not be shown.
  static const Duration adLifetime = Duration(hours: 1);

  /// After `show()` the ad must report it is on screen within this time,
  /// otherwise it is dropped and the app continues (never stuck).
  static const Duration showGuard = Duration(seconds: 4);

  InterstitialAd? _ad;
  DateTime? _loadedAt;
  bool _loading = false;
  bool _showing = false;
  DateTime? _lastClosedAt;

  DateTime get _now => _ref.read(clockProvider).nowUtc();

  bool get _expired {
    final at = _loadedAt;
    return at == null || _now.difference(at) >= adLifetime;
  }

  void preload() {
    if (_loading || _showing || !_ref.read(adsEnabledProvider)) return;
    if (_ad != null) {
      if (!_expired) return; // cached: do not request again
      unawaited(_ad!.dispose());
      _ad = null;
      _loadedAt = null;
    }
    _loading = true;
    try {
      unawaited(
        InterstitialAd.load(
          adUnitId: AdUnitIds.of(AdFormat.interstitial),
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              _loading = false;
              _ad = ad;
              _loadedAt = _now;
            },
            onAdFailedToLoad: (error) {
              _loading = false;
              Log.i('Interstitial not loaded: ${error.message}');
            },
          ),
        ),
      );
    } on Object catch (e, st) {
      _loading = false;
      Log.w('Interstitial request failed', e, st);
    }
  }

  /// Shows an interstitial when allowed and one is ready, and completes
  /// once it is closed. Completes at once (no ad) when it is too soon after
  /// the previous one, nothing is cached, ads are off — so the caller can
  /// always `await` this and then carry on. Never throws.
  Future<void> showIfReady() async {
    try {
      final coordinator = _ref.read(adCoordinatorProvider);
      final allowed =
          !_showing &&
          !coordinator.isShowing &&
          interstitialAllowed(
            adsEnabled: _ref.read(adsEnabledProvider),
            now: _now,
            lastClosedAt: _lastClosedAt,
            config: _ref.read(monetizationConfigProvider),
            walkRecording: _ref.read(walkControllerProvider).isRecording,
          );
      if (!allowed) return;
      final ad = _ad;
      if (ad == null || _expired) {
        preload();
        return;
      }
      _ad = null; // shown once, then null
      _loadedAt = null;
      await _show(ad, coordinator);
    } on Object catch (e, st) {
      Log.w('Interstitial flow failed', e, st);
    }
  }

  Future<void> _show(InterstitialAd ad, AdCoordinator coordinator) async {
    final done = Completer<void>();
    var onScreen = false;
    Timer? guard;

    void finish({required bool wasShown}) {
      guard?.cancel();
      if (!_showing) return;
      _showing = false;
      final now = _now;
      coordinator.end(now);
      if (wasShown) _lastClosedAt = now;
      unawaited(ad.dispose());
      preload(); // the next one
      if (!done.isCompleted) done.complete();
    }

    _showing = true;
    coordinator.begin();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) => onScreen = true,
      onAdDismissedFullScreenContent: (_) => finish(wasShown: true),
      onAdFailedToShowFullScreenContent: (_, error) {
        Log.w('Interstitial failed to show: ${error.message}');
        finish(wasShown: false);
      },
    );
    guard = Timer(showGuard, () {
      if (!onScreen) {
        Log.w('Interstitial never appeared: continuing');
        finish(wasShown: false);
      }
    });
    try {
      await ad.show();
    } on Object catch (e, st) {
      Log.w('Interstitial show threw', e, st);
      finish(wasShown: false);
    }
    await done.future;
  }

  void dispose() => unawaited(_ad?.dispose());
}

@Riverpod(keepAlive: true)
InterstitialManager interstitialManager(Ref ref) {
  final manager = InterstitialManager(ref);
  ref
    ..onDispose(manager.dispose)
    ..listen(adsEnabledProvider, (_, enabled) {
      if (enabled) manager.preload();
    }, fireImmediately: true);
  return manager;
}
