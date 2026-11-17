import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:gps_measurement/services/ads/consent_service.dart';
import 'package:gps_measurement/services/meta/meta_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ads_service.g.dart';

/// Mobile Ads SDK lifecycle (`architecture.md` §9 step 9, §11): consent
/// first, the SDK only when ads may be requested and the user is free.
/// State: the SDK is initialized and ads may be requested.
@Riverpod(keepAlive: true)
class AdsService extends _$AdsService {
  bool _canRequest = false;
  Future<void>? _initializing;
  Future<void>? _starting;

  @override
  bool build() {
    // Premium → free again (subscription expired): start the SDK then.
    ref.listen(featureGateProvider.select((g) => g.showAds), (_, show) {
      if (show && _canRequest) unawaited(_initSdk());
    });
    return false;
  }

  /// UMP → ATT (iOS) → SDK. Never throws. Idempotent: bootstrap and the
  /// splash screen both call it and share the same run.
  Future<void> start() => _starting ??= _start();

  Future<void> _start() async {
    final consent = ref.read(consentServiceProvider);
    await consent.gather();
    await consent.requestTrackingIfEligible();
    _canRequest = await consent.canRequestAds();
    if (!ref.mounted) return;
    // Meta install attribution follows the same consent as ads, and is
    // independent of Premium.
    unawaited(ref.read(metaServiceProvider).start(consented: _canRequest));
    if (!_canRequest) {
      Log.w('Ads disabled: UMP canRequestAds=false after consent gathering');
      return;
    }
    if (ref.read(featureGateProvider).showAds) await _initSdk();
  }

  Future<void> _initSdk() => _initializing ??= () async {
    try {
      await MobileAds.instance.initialize();
      if (ref.mounted) state = true;
    } on Object catch (e, st) {
      _initializing = null;
      Log.w('Mobile Ads init failed', e, st);
    }
  }();

  /// Ad Inspector (P11-10: check Meta bidding takes part). Dev builds.
  void openAdInspector() => MobileAds.instance.openAdInspector((error) {
    if (error != null) Log.w('Ad Inspector: ${error.message}');
  });
}

/// Ads may be shown now: SDK ready and the user is not premium. Every ad
/// surface checks this, so buying premium removes ads at once.
@Riverpod(keepAlive: true)
bool adsEnabled(Ref ref) =>
    ref.watch(adsServiceProvider) &&
    ref.watch(featureGateProvider.select((g) => g.showAds));
