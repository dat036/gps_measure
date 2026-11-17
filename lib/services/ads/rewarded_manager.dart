import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/services/ads/ad_coordinator.dart';
import 'package:gps_measurement/services/ads/ad_unit_ids.dart';
import 'package:gps_measurement/services/ads/ads_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rewarded_manager.g.dart';

enum RewardOutcome {
  /// Watched to the end: unlock.
  earned,

  /// Closed before the reward: no unlock.
  dismissed,

  /// No ad (no fill, offline, consent, SDK off): unlock anyway — the user
  /// asked for the ad and must not be punished for our missing inventory
  /// (`plan.md` P11-09).
  unavailable,
}

/// Rewarded ad that unlocks one KML export. Loaded on demand (rare use, a
/// preloaded ad would mostly expire unused).
class RewardedManager {
  RewardedManager(this._ref);

  final Ref _ref;

  static const Duration loadTimeout = Duration(seconds: 8);

  Future<RewardOutcome> show() async {
    if (!_ref.read(adsEnabledProvider)) return RewardOutcome.unavailable;
    final ad = await _load();
    if (ad == null) return RewardOutcome.unavailable;

    // Its Activity hides the app: no App Open ad when it closes.
    final coordinator = _ref.read(adCoordinatorProvider);
    final clock = _ref.read(clockProvider);
    final done = Completer<RewardOutcome>();
    var earned = false;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        coordinator.end(clock.nowUtc());
        unawaited(ad.dispose());
        if (!done.isCompleted) {
          done.complete(
            earned ? RewardOutcome.earned : RewardOutcome.dismissed,
          );
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        Log.w('Rewarded failed to show: ${error.message}');
        coordinator.end(clock.nowUtc());
        unawaited(ad.dispose());
        if (!done.isCompleted) done.complete(RewardOutcome.unavailable);
      },
    );
    coordinator.begin();
    await ad.show(onUserEarnedReward: (_, _) => earned = true);
    return done.future;
  }

  Future<RewardedAd?> _load() {
    final loaded = Completer<RewardedAd?>();
    var timedOut = false;
    unawaited(
      RewardedAd.load(
        adUnitId: AdUnitIds.of(AdFormat.rewarded),
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            if (timedOut || loaded.isCompleted) {
              unawaited(ad.dispose()); // Arrived after the timeout.
            } else {
              loaded.complete(ad);
            }
          },
          onAdFailedToLoad: (error) {
            Log.i('Rewarded not loaded: ${error.message}');
            if (!loaded.isCompleted) loaded.complete(null);
          },
        ),
      ),
    );
    return loaded.future.timeout(
      loadTimeout,
      onTimeout: () {
        timedOut = true;
        return null;
      },
    );
  }
}

@Riverpod(keepAlive: true)
RewardedManager rewardedManager(Ref ref) => RewardedManager(ref);
