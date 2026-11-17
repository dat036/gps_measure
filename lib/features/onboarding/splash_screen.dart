import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:gps_measurement/services/ads/ad_coordinator.dart';
import 'package:gps_measurement/services/ads/ads_service.dart';
import 'package:gps_measurement/services/ads/app_open_manager.dart';
import 'package:gps_measurement/services/ads/native_ad_view.dart';
import 'package:gps_measurement/services/purchases/purchase_service.dart';

/// Brand screen shown on launch (`design.md` §6): logo, name and a progress
/// bar that loops from the first frame, while the App Open ad loads.
///
/// It never blocks the user for more than [maxWait] (+ [startWait] for
/// consent and the SDK):
///  * ad fails to load, or ads are off → on to the next screen at once;
///  * ad loads → shown at once (the wait is over), next screen when closed;
///  * nothing in time → on to the next screen.
/// A second, independent timer (`_watchdog`) moves on even if the ad flow
/// itself got stuck, as long as no ad is on screen.
///
/// Next screen: first launch → language → intro → Home; the launch after
/// that → the first paywall (yearly plan only) → Home; later launches →
/// Home.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  /// The ad's own wait, once consent and the SDK are ready.
  static const Duration maxWait = AppOpenManager.splashAdWait;

  /// Consent (UMP) and Mobile Ads SDK start-up.
  static const Duration startWait = AppOpenManager.splashStartWait;

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _watchdog;
  bool _left = false;

  @override
  void initState() {
    super.initState();
    _armWatchdog(
      SplashScreen.startWait +
          SplashScreen.maxWait +
          const Duration(seconds: 1),
    );
    unawaited(_preloadLanguageAd());
    unawaited(_run());
  }

  /// First launch: the language screen is next, so its native ad loads
  /// while the splash (consent, App Open ad) is still going, and is there
  /// when the screen opens. Waits for the same consent + SDK start-up the
  /// splash ad does; nothing happens when ads are off.
  Future<void> _preloadLanguageAd() async {
    if (ref.read(settingsRepositoryProvider).onboardingSeen) return;
    if (!ref.read(featureGateProvider).showAds) return;
    await ref.read(adsServiceProvider.notifier).start();
    if (!mounted || !ref.read(adsEnabledProvider)) return;
    NativeAdPlacements.preloadLanguage(context, ref);
  }

  Future<void> _run() async {
    // Completes in every case (never throws); see `AppOpenManager.runSplash`.
    await ref.read(appOpenManagerProvider).runSplash();
    _next();
  }

  void _armWatchdog(Duration after) {
    _watchdog?.cancel();
    _watchdog = Timer(after, () {
      if (!mounted || _left) return;
      // Never pull the screen from under an ad the user is looking at.
      if (ref.read(adCoordinatorProvider).isShowing) {
        _armWatchdog(const Duration(seconds: 1));
      } else {
        _next();
      }
    });
  }

  void _next() {
    if (!mounted || _left) return;
    _left = true;
    _watchdog?.cancel();
    final settings = ref.read(settingsRepositoryProvider);
    final premium = ref.read(premiumProvider).isPremium;
    if (!settings.onboardingSeen) {
      context.go(Routes.language);
    } else if (settings.startupPaywallDue) {
      unawaited(settings.setStartupPaywallShown());
      context.go(premium ? Routes.home : Routes.paywallFirst);
    } else {
      context.go(Routes.home);
    }
  }

  @override
  void dispose() {
    _watchdog?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    return Scaffold(
      backgroundColor: colors.brandPrimary,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            Image.asset(
              'assets/icon/splash_logo.png',
              width: 120,
              height: 120,
              excludeFromSemantics: true,
            ),
            const SizedBox(height: LmSpacing.s24),
            Text(
              context.l10n.appTitle,
              style: LmTypography.titleScreen.copyWith(
                color: colors.onMode,
                fontSize: 28,
                height: 34 / 28,
              ),
            ),
            const Spacer(flex: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64),
              // Indeterminate: keeps moving for as long as we wait, however
              // long consent / SDK start-up / the ad take.
              child: ClipRRect(
                borderRadius: LmRadius.fullAll,
                child: LinearProgressIndicator(
                  minHeight: 6,
                  color: colors.onMode,
                  backgroundColor: colors.onMode.withValues(alpha: 0.24),
                ),
              ),
            ),
            const SizedBox(height: LmSpacing.s40),
          ],
        ),
      ),
    );
  }
}
