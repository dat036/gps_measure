import 'package:gps_measurement/domain/premium/feature_gate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rc_keys.g.dart';

/// Remote Config keys and their in-app defaults (`architecture.md` §11).
abstract final class RcKeys {
  static const String freeMaxSaved = 'free_max_saved';
  static const String freeMaxPhotos = 'free_max_photos';
  static const String interstitialMinIntervalSec =
      'interstitial_min_interval_sec';
  static const String appOpenEnabled = 'app_open_enabled';
  static const String bannerEnabled = 'banner_enabled';
  static const String homeBannerEnabled = 'home_banner_enabled';
  static const String paywallVariant = 'paywall_variant';
}

/// Monetization knobs. Phase 10 (Remote Config) is not built yet, so these
/// are the defaults of §11; `monetizationConfigProvider` will read RC then.
class MonetizationConfig {
  const MonetizationConfig({
    this.gate = const GateConfig(),
    this.interstitialMinInterval = const Duration(seconds: 30),
    this.appOpenEnabled = true,
    this.bannerEnabled = false,
    this.homeBannerEnabled = true,
    this.paywallVariant = 'a',
  });

  final GateConfig gate;

  /// Minimum time between two interstitials (a skipped one never delays
  /// the action behind it).
  final Duration interstitialMinInterval;

  /// The splash's App Open ad (the only one the app shows).
  final bool appOpenEnabled;
  final bool bannerEnabled;

  /// Collapsible banner above Home's bottom nav (not on the first launch).
  final bool homeBannerEnabled;
  final String paywallVariant;
}

// TODO(phase-10): values from RemoteConfigService (keys in [RcKeys]).
@Riverpod(keepAlive: true)
MonetizationConfig monetizationConfig(Ref ref) => const MonetizationConfig();
