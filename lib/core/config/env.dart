import 'package:gps_measurement/core/config/flavor.dart';

/// Compile-time configuration from
/// `--dart-define-from-file=env/<flavor>.json` (see `env/example.json`).
///
/// Maps/AdMob app IDs are consumed natively (Gradle manifest placeholders,
/// iOS `DartDefines.xcconfig`); the rest is read here.
abstract final class Env {
  static final Flavor flavor = Flavor.fromName(
    const String.fromEnvironment('FLAVOR', defaultValue: 'dev'),
  );

  static const String adUnitBannerAndroid = String.fromEnvironment(
    'AD_UNIT_BANNER_ANDROID',
  );
  static const String adUnitBannerIos = String.fromEnvironment(
    'AD_UNIT_BANNER_IOS',
  );
  static const String adUnitInterstitialAndroid = String.fromEnvironment(
    'AD_UNIT_INTERSTITIAL_ANDROID',
  );
  static const String adUnitInterstitialIos = String.fromEnvironment(
    'AD_UNIT_INTERSTITIAL_IOS',
  );
  static const String adUnitRewardedAndroid = String.fromEnvironment(
    'AD_UNIT_REWARDED_ANDROID',
  );
  static const String adUnitRewardedIos = String.fromEnvironment(
    'AD_UNIT_REWARDED_IOS',
  );
  static const String adUnitAppOpenAndroid = String.fromEnvironment(
    'AD_UNIT_APP_OPEN_ANDROID',
  );
  static const String adUnitAppOpenIos = String.fromEnvironment(
    'AD_UNIT_APP_OPEN_IOS',
  );
  static const String adUnitNativeLanguageAndroid = String.fromEnvironment(
    'AD_UNIT_NATIVE_LANGUAGE_ANDROID',
  );
  static const String adUnitNativeLanguageIos = String.fromEnvironment(
    'AD_UNIT_NATIVE_LANGUAGE_IOS',
  );
  static const String adUnitNativeIntroAndroid = String.fromEnvironment(
    'AD_UNIT_NATIVE_INTRO_ANDROID',
  );
  static const String adUnitNativeIntroIos = String.fromEnvironment(
    'AD_UNIT_NATIVE_INTRO_IOS',
  );
  static const String adUnitNativeIntroFullAndroid = String.fromEnvironment(
    'AD_UNIT_NATIVE_INTRO_FULL_ANDROID',
  );
  static const String adUnitNativeIntroFullIos = String.fromEnvironment(
    'AD_UNIT_NATIVE_INTRO_FULL_IOS',
  );
  static const String adUnitNativeSavedAndroid = String.fromEnvironment(
    'AD_UNIT_NATIVE_SAVED_ANDROID',
  );
  static const String adUnitNativeSavedIos = String.fromEnvironment(
    'AD_UNIT_NATIVE_SAVED_IOS',
  );

  /// Meta App ID / Client Token (install attribution). Native config reads
  /// them too (Gradle placeholders / Info.plist); empty disables the Meta SDK.
  static const String facebookAppIdAndroid = String.fromEnvironment(
    'FACEBOOK_APP_ID_ANDROID',
  );
  static const String facebookAppIdIos = String.fromEnvironment(
    'FACEBOOK_APP_ID_IOS',
  );

  /// Google Play subscription product IDs (Play Console -> Monetize).
  static const String iapProductMonthly = String.fromEnvironment(
    'IAP_PRODUCT_MONTHLY',
    defaultValue: 'premium_monthly',
  );
  static const String iapProductYearly = String.fromEnvironment(
    'IAP_PRODUCT_YEARLY',
    defaultValue: 'premium_yearly',
  );

  /// App Store Connect IDs are independent of Google Play and case-sensitive.
  static const String iapProductMonthlyIos = String.fromEnvironment(
    'IAP_PRODUCT_MONTHLY_IOS',
    defaultValue: 'monthly',
  );
  static const String iapProductYearlyIos = String.fromEnvironment(
    'IAP_PRODUCT_YEARLY_IOS',
    defaultValue: 'Yearly',
  );

  /// Settings → Help & Feedback. Empty: the item is hidden.
  static const String supportEmail = String.fromEnvironment('SUPPORT_EMAIL');

  /// Settings → Privacy Policy / Terms. Empty: the item is hidden.
  static const String privacyPolicyUrl = String.fromEnvironment(
    'PRIVACY_POLICY_URL',
  );
  static const String termsUrl = String.fromEnvironment('TERMS_URL');

  /// Numeric App Store ID, needed on iOS for Rate Us (store listing).
  static const String appStoreId = String.fromEnvironment('APP_STORE_ID');

  /// Dev only: show the UMP consent form as if in the EEA.
  static const bool umpDebugEea = bool.fromEnvironment('UMP_DEBUG_EEA');

  /// Dev only: hashed device id the UMP SDK logs, for [umpDebugEea].
  static const String umpTestDeviceId = String.fromEnvironment(
    'UMP_TEST_DEVICE_ID',
  );
}
