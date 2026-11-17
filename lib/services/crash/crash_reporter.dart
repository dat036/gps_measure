import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:gps_measurement/core/config/env.dart';
import 'package:gps_measurement/core/utils/logger.dart';

/// Crashlytics behind one class (`architecture.md` §9). Every call is a no-op
/// until [init] succeeds, so a missing Firebase config never breaks the app
/// (e.g. an iOS dev/staging flavor without its own Firebase registration).
abstract final class CrashReporter {
  static bool _ready = false;

  static bool get isReady => _ready;

  /// Initializes Firebase and wires the Flutter / platform error handlers.
  /// Collection is off in dev and debug builds.
  static Future<void> init() async {
    try {
      await Firebase.initializeApp();
      final crashlytics = FirebaseCrashlytics.instance;
      await crashlytics.setCrashlyticsCollectionEnabled(
        !kDebugMode && Env.flavor.isProd,
      );
      await crashlytics.setCustomKey('flavor', Env.flavor.name);
      _ready = true;
      Log.i(
        'Firebase initialized; Crashlytics collection: '
        '${!kDebugMode && Env.flavor.isProd}',
      );
    } on Object catch (e, st) {
      Log.w('Firebase unavailable, crash reporting off', e, st);
    }
  }

  /// Fatal Flutter framework error.
  static void recordFlutterFatal(FlutterErrorDetails details) {
    if (_ready) {
      unawaited(FirebaseCrashlytics.instance.recordFlutterFatalError(details));
    }
  }

  /// Uncaught async / platform error.
  static void recordFatal(Object error, StackTrace stack) {
    if (_ready) {
      unawaited(
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
      );
    }
  }

  /// Handled error worth seeing (DB, export, photo, location failures).
  static void recordNonFatal(
    Object error,
    StackTrace? stack, {
    String? reason,
  }) {
    if (_ready) {
      unawaited(
        FirebaseCrashlytics.instance.recordError(error, stack, reason: reason),
      );
    }
  }

  /// Custom key such as `screen` or `walk_state`.
  static void setKey(String key, Object value) {
    if (_ready) {
      unawaited(FirebaseCrashlytics.instance.setCustomKey(key, value));
    }
  }

  static void log(String message) {
    if (_ready) {
      unawaited(FirebaseCrashlytics.instance.log(message));
    }
  }
}
