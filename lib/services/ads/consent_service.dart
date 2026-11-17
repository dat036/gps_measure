import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gps_measurement/core/config/env.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'consent_service.g.dart';

/// Ad consent (`architecture.md` §11): Google UMP before any ad request,
/// then iOS App Tracking Transparency — never on the first launch.
abstract interface class ConsentService {
  /// UMP on every launch: refresh the consent info and show the form when
  /// required (EEA/UK…). Never throws; ads stay off if it fails.
  Future<void> gather();

  Future<bool> canRequestAds();

  /// Settings shows "Privacy choices" only when this is true.
  Future<bool> privacyOptionsRequired();

  Future<void> showPrivacyOptions();

  /// iOS: asks ATT once, from the 2nd launch on or after the first save.
  Future<void> requestTrackingIfEligible();
}

class UmpConsentService implements ConsentService {
  UmpConsentService(this._settings);

  final SettingsRepository _settings;

  ConsentRequestParameters get _params {
    // Dev: `UMP_DEBUG_EEA=true` + `UMP_TEST_DEVICE_ID` (hashed id printed
    // in logcat / Xcode by the UMP SDK) shows the EEA form anywhere.
    if (Env.umpDebugEea && !Env.flavor.isProd) {
      return ConsentRequestParameters(
        consentDebugSettings: ConsentDebugSettings(
          debugGeography: DebugGeography.debugGeographyEea,
          testIdentifiers: [
            if (Env.umpTestDeviceId.isNotEmpty) Env.umpTestDeviceId,
          ],
        ),
      );
    }
    return ConsentRequestParameters();
  }

  @override
  Future<void> gather() async {
    final updated = Completer<void>();
    try {
      ConsentInformation.instance.requestConsentInfoUpdate(
        _params,
        updated.complete,
        (error) {
          Log.w('UMP info update failed: ${error.message}');
          updated.complete();
        },
      );
      await updated.future;
      final shown = Completer<void>();
      await ConsentForm.loadAndShowConsentFormIfRequired((error) {
        if (error != null) Log.w('UMP form failed: ${error.message}');
        shown.complete();
      });
      await shown.future;
    } on Object catch (e, st) {
      Log.w('Consent gathering failed', e, st);
    }
  }

  @override
  Future<bool> canRequestAds() async {
    try {
      return await ConsentInformation.instance.canRequestAds();
    } on Object catch (e, st) {
      Log.w('canRequestAds failed', e, st);
      return false;
    }
  }

  @override
  Future<bool> privacyOptionsRequired() async {
    try {
      return await ConsentInformation.instance
              .getPrivacyOptionsRequirementStatus() ==
          PrivacyOptionsRequirementStatus.required;
    } on Object {
      return false;
    }
  }

  @override
  Future<void> showPrivacyOptions() async {
    final done = Completer<void>();
    try {
      await ConsentForm.showPrivacyOptionsForm((error) {
        if (error != null) Log.w('Privacy options failed: ${error.message}');
        done.complete();
      });
      await done.future;
    } on Object catch (e, st) {
      Log.w('Privacy options failed', e, st);
    }
  }

  @override
  Future<void> requestTrackingIfEligible() async {
    if (defaultTargetPlatform != TargetPlatform.iOS || _settings.attRequested) {
      return;
    }
    final eligible =
        _settings.appOpenCount >= 2 || _settings.savesCountTotal >= 1;
    if (!eligible) return;
    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        // TODO(phase-10): analytics permission_result{type: att, result}.
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
      await _settings.setAttRequested();
    } on Object catch (e, st) {
      Log.w('ATT request failed', e, st);
    }
  }
}

/// Settings → "Privacy choices" is shown only when UMP requires it.
/// Invalidate after the form closes.
@riverpod
Future<bool> privacyOptionsRequired(Ref ref) =>
    ref.watch(consentServiceProvider).privacyOptionsRequired();

@Riverpod(keepAlive: true)
ConsentService consentService(Ref ref) =>
    UmpConsentService(ref.watch(settingsRepositoryProvider));
