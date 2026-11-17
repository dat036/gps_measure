import 'package:flutter/foundation.dart';
import 'package:gps_measurement/core/config/env.dart';

enum AdFormat {
  banner,
  interstitial,
  rewarded,
  appOpen,

  /// Native ad at the bottom of the first-launch language screen.
  nativeLanguage,

  /// Native ad under the intro slides' button.
  nativeIntro,

  /// Native ad shown as its own full-screen intro page.
  nativeIntroFull,

  /// Native ad above the Saved list.
  nativeSaved,
}

/// Ad unit per format and platform (`env/<flavor>.json`). Dev/staging, or a
/// missing value, use Google's official test units so a real unit is never
/// clicked during development (AdMob policy).
abstract final class AdUnitIds {
  static const Map<AdFormat, String> _testAndroid = {
    AdFormat.banner: 'ca-app-pub-3940256099942544/9214589741',
    AdFormat.interstitial: 'ca-app-pub-3940256099942544/1033173712',
    AdFormat.rewarded: 'ca-app-pub-3940256099942544/5224354917',
    AdFormat.appOpen: 'ca-app-pub-3940256099942544/9257395921',
    AdFormat.nativeLanguage: 'ca-app-pub-3940256099942544/2247696110',
    AdFormat.nativeIntro: 'ca-app-pub-3940256099942544/2247696110',
    AdFormat.nativeIntroFull: 'ca-app-pub-3940256099942544/2247696110',
    AdFormat.nativeSaved: 'ca-app-pub-3940256099942544/2247696110',
  };

  static const Map<AdFormat, String> _testIos = {
    AdFormat.banner: 'ca-app-pub-3940256099942544/2435281174',
    AdFormat.interstitial: 'ca-app-pub-3940256099942544/4411468910',
    AdFormat.rewarded: 'ca-app-pub-3940256099942544/1712485313',
    AdFormat.appOpen: 'ca-app-pub-3940256099942544/5575463023',
    AdFormat.nativeLanguage: 'ca-app-pub-3940256099942544/3986624511',
    AdFormat.nativeIntro: 'ca-app-pub-3940256099942544/3986624511',
    AdFormat.nativeIntroFull: 'ca-app-pub-3940256099942544/3986624511',
    AdFormat.nativeSaved: 'ca-app-pub-3940256099942544/3986624511',
  };

  static bool get _ios => defaultTargetPlatform == TargetPlatform.iOS;

  static String of(AdFormat format) {
    final configured = switch ((format, _ios)) {
      (AdFormat.banner, false) => Env.adUnitBannerAndroid,
      (AdFormat.banner, true) => Env.adUnitBannerIos,
      (AdFormat.interstitial, false) => Env.adUnitInterstitialAndroid,
      (AdFormat.interstitial, true) => Env.adUnitInterstitialIos,
      (AdFormat.rewarded, false) => Env.adUnitRewardedAndroid,
      (AdFormat.rewarded, true) => Env.adUnitRewardedIos,
      (AdFormat.appOpen, false) => Env.adUnitAppOpenAndroid,
      (AdFormat.appOpen, true) => Env.adUnitAppOpenIos,
      (AdFormat.nativeLanguage, false) => Env.adUnitNativeLanguageAndroid,
      (AdFormat.nativeLanguage, true) => Env.adUnitNativeLanguageIos,
      (AdFormat.nativeIntro, false) => Env.adUnitNativeIntroAndroid,
      (AdFormat.nativeIntro, true) => Env.adUnitNativeIntroIos,
      (AdFormat.nativeIntroFull, false) => Env.adUnitNativeIntroFullAndroid,
      (AdFormat.nativeIntroFull, true) => Env.adUnitNativeIntroFullIos,
      (AdFormat.nativeSaved, false) => Env.adUnitNativeSavedAndroid,
      (AdFormat.nativeSaved, true) => Env.adUnitNativeSavedIos,
    };
    if (Env.flavor.isProd && configured.isNotEmpty) return configured;
    return (_ios ? _testIos : _testAndroid)[format]!;
  }
}
