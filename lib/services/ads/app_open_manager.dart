import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:gps_measurement/services/ads/ad_coordinator.dart';
import 'package:gps_measurement/services/ads/ad_unit_ids.dart';
import 'package:gps_measurement/services/ads/ads_service.dart';
import 'package:gps_measurement/services/remote_config/rc_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_open_manager.g.dart';

/// The App Open ad: shown once per launch, on the splash. Coming back from
/// the background never shows one. Loaded while the splash waits (as soon
/// as ads are enabled) and never again after it.
class AppOpenManager {
  AppOpenManager(this._ref);

  final Ref _ref;

  /// Google: an App Open ad older than 4 hours must not be shown.
  static const Duration adLifetime = Duration(hours: 4);

  /// After `show()` the ad must report it is on screen within this time,
  /// otherwise it is dropped and the app continues (never stuck).
  static const Duration showGuard = Duration(seconds: 4);

  /// Splash: the ad's own wait, and the allowance for consent + SDK start.
  static const Duration splashAdWait = Duration(seconds: 8);
  static const Duration splashStartWait = Duration(seconds: 12);

  AppOpenAd? _ad;
  DateTime? _loadedAt;
  Future<void>? _loading;
  bool _showing = false;

  /// The splash has had its turn: no more loading (a late ad is dropped).
  bool _splashDone = false;

  DateTime get _now => _ref.read(clockProvider).nowUtc();

  bool get _expired {
    final at = _loadedAt;
    return at == null || _now.difference(at) >= adLifetime;
  }

  bool get _hasFreshAd => _ad != null && !_expired;

  /// Starts loading the splash ad early, unless one is cached (checked
  /// first: never request over a cached ad) or a request is running.
  void preload() => unawaited(_load());

  Future<void> _load() {
    if (_splashDone || !_ref.read(adsEnabledProvider)) return Future.value();
    if (_hasFreshAd) return Future.value();
    final running = _loading;
    if (running != null) return running;
    if (_ad != null) {
      // Stale: drop it, then ask for a new one.
      unawaited(_ad!.dispose());
      _ad = null;
    }
    final done = Completer<void>();
    _loading = done.future;
    void finish() {
      _loading = null;
      if (!done.isCompleted) done.complete();
    }

    try {
      unawaited(
        AppOpenAd.load(
          adUnitId: AdUnitIds.of(AdFormat.appOpen),
          request: const AdRequest(),
          adLoadCallback: AppOpenAdLoadCallback(
            onAdLoaded: (ad) {
              if (_splashDone) {
                unawaited(ad.dispose()); // too late: the splash moved on
                finish();
                return;
              }
              _ad = ad;
              _loadedAt = _now;
              finish();
            },
            onAdFailedToLoad: (error) {
              Log.w(
                'App open ad not loaded '
                '[${error.domain}/${error.code}]: ${error.message}',
              );
              finish();
            },
          ),
        ),
      );
    } on Object catch (e, st) {
      Log.w('App open ad request failed', e, st);
      finish();
    }
    return done.future;
  }

  /// The splash screen's ad. Completes when the app may move on:
  ///
  /// * ads are off (premium, no consent, SDK not ready) → at once;
  /// * the ad fails to load → at once;
  /// * the ad loads → it is shown at once and this completes when the user
  ///   closes it (or it fails to show);
  /// * the ad takes longer than [maxWait] → gives up (the late ad is dropped:
  ///   the app never shows an App Open ad after the splash).
  ///
  /// Consent and the SDK start-up have their own allowance, [startWait]:
  /// on a fresh install they take several seconds (UMP form, first SDK
  /// init) and must not eat the ad's own [maxWait].
  ///
  /// Never throws and always completes.
  Future<void> runSplash({
    Duration maxWait = splashAdWait,
    Duration startWait = splashStartWait,
  }) async {
    try {
      if (!_ref.read(featureGateProvider).showAds) return;
      if (!_ref.read(monetizationConfigProvider).appOpenEnabled) return;
      // UMP → SDK (shared with bootstrap).
      await _ref.read(adsServiceProvider.notifier).start().timeout(startWait);
      if (!_ref.read(adsEnabledProvider)) return;
      final ad = await _adForSplash().timeout(maxWait);
      if (ad == null) return;
      await _show(ad);
    } on TimeoutException {
      Log.w('Splash ad: gave up waiting for consent, SDK or ad load');
    } on Object catch (e, st) {
      Log.w('Splash ad failed', e, st);
    } finally {
      _splashDone = true;
      unawaited(_ad?.dispose());
      _ad = null;
    }
  }

  Future<AppOpenAd?> _adForSplash() async {
    await _load();
    return _take();
  }

  AppOpenAd? _take() {
    if (!_hasFreshAd) return null;
    final ad = _ad;
    _ad = null;
    return ad;
  }

  /// Shows [ad]; completes when it is closed or could not be shown.
  Future<void> _show(AppOpenAd ad) async {
    final coordinator = _ref.read(adCoordinatorProvider);
    final done = Completer<void>();
    var onScreen = false;
    Timer? guard;

    void finish() {
      guard?.cancel();
      if (!_showing) return;
      _showing = false;
      coordinator.end(_now);
      unawaited(ad.dispose());
      if (!done.isCompleted) done.complete();
    }

    _showing = true;
    coordinator.begin();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) => onScreen = true,
      onAdDismissedFullScreenContent: (_) => finish(),
      onAdFailedToShowFullScreenContent: (_, error) {
        Log.w('App open ad failed to show: ${error.message}');
        finish();
      },
    );
    guard = Timer(showGuard, () {
      if (!onScreen) {
        Log.w('App open ad never appeared: continuing');
        finish();
      }
    });
    try {
      await ad.show();
    } on Object catch (e, st) {
      Log.w('App open ad show threw', e, st);
      finish();
    }
    await done.future;
  }

  void dispose() {
    unawaited(_ad?.dispose());
  }
}

@Riverpod(keepAlive: true)
AppOpenManager appOpenManager(Ref ref) {
  final manager = AppOpenManager(ref);
  ref
    ..onDispose(manager.dispose)
    ..listen(adsEnabledProvider, (_, enabled) {
      if (enabled) manager.preload();
    }, fireImmediately: true);
  return manager;
}
