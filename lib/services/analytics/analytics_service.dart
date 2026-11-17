import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:gps_measurement/core/config/env.dart';
import 'package:gps_measurement/core/utils/logger.dart';

/// Firebase Analytics behind one class. Every call is a no-op until [init]
/// succeeds, so a missing Firebase config never breaks the app.
abstract final class AnalyticsService {
  static FirebaseAnalytics? _analytics;

  /// Call after `Firebase.initializeApp` (see `CrashReporter.init`).
  ///
  /// Non-prod release builds stay silent; every event carries the `flavor`
  /// user property. iOS dev/staging need separate Firebase registrations.
  /// DebugView: Android sets `debug.firebase.analytics.app` using adb;
  /// iOS uses the Xcode launch argument `-FIRDebugEnabled`.
  static Future<void> init() async {
    if (Firebase.apps.isEmpty) return;
    try {
      final analytics = FirebaseAnalytics.instance;
      await analytics.setAnalyticsCollectionEnabled(
        kDebugMode || Env.flavor.isProd,
      );
      await analytics.setUserProperty(name: 'flavor', value: Env.flavor.name);
      _analytics = analytics;
    } on Object catch (e, st) {
      Log.w('Analytics unavailable', e, st);
    }
  }

  /// `screen_view` for one Flutter screen. Android would otherwise only see
  /// `MainActivity` (automatic reporting is off in the manifest).
  static void logScreenView(String screenName) {
    final analytics = _analytics;
    if (analytics == null) return;
    unawaited(
      analytics
          .logScreenView(screenName: screenName, screenClass: screenName)
          .catchError((Object e, StackTrace st) {
            Log.w('screen_view failed', e, st);
          }),
    );
  }

  static void logEvent(String name, [Map<String, Object>? parameters]) {
    final analytics = _analytics;
    if (analytics == null) return;
    unawaited(
      analytics.logEvent(name: name, parameters: parameters).catchError((
        Object e,
        StackTrace st,
      ) {
        Log.w('logEvent($name) failed', e, st);
      }),
    );
  }
}
