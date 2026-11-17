import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_measurement/app.dart';
import 'package:gps_measurement/core/config/env.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/storage/app_directories.dart';
import 'package:gps_measurement/features/measure/walk/walk_recovery_service.dart';
import 'package:gps_measurement/services/ads/ads_service.dart';
import 'package:gps_measurement/services/ads/app_open_manager.dart';
import 'package:gps_measurement/services/ads/interstitial_manager.dart';
import 'package:gps_measurement/services/analytics/analytics_service.dart';
import 'package:gps_measurement/services/crash/crash_reporter.dart';
import 'package:gps_measurement/services/purchases/purchase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App start-up in the order of `architecture.md` §9. Nothing here may wait
/// on the network (ads, Remote Config, Play Billing) before the first frame.
Future<void> bootstrap() async {
  // 1. Bindings.
  WidgetsFlutterBinding.ensureInitialized();
  Log.i('Starting LandMeasure (${Env.flavor.name})');

  // 2. Firebase (Android: google-services.json; iOS prod: bundled
  // GoogleService-Info.plist). Unconfigured flavors degrade to a no-op.
  await CrashReporter.init();
  await AnalyticsService.init();
  Log.sink = (level, message, error, stackTrace) => CrashReporter.log(
    '${level.name}: $message${error == null ? '' : ' ($error)'}',
  );

  // 3. Error handlers (Crashlytics collection is off outside prod release).
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    Log.e('Flutter error', details.exception, details.stack);
    CrashReporter.recordFlutterFatal(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    Log.e('Uncaught error', error, stack);
    CrashReporter.recordFatal(error, stack);
    return true;
  };

  // 4. Local storage. The database itself opens lazily on first query (on
  // a background isolate), so it does not delay the first frame.
  final (prefs, directories) = await (
    SharedPreferences.getInstance(),
    AppDirectories.load(),
  ).wait;
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      appDirectoriesProvider.overrideWithValue(directories),
    ],
  );

  // 5. TODO(phase-10): RemoteConfigService.init() with defaults; fetch in
  // the background and never wait more than 3s.

  // 6. Purchases: configure only (the entitlement arrives later; the
  // `premium_cached` pref answers until then).
  await container.read(purchaseServiceProvider).init();
  await container.read(settingsRepositoryProvider).incrementAppOpenCount();

  // 7. A walk left `recording` (app killed) becomes `paused`.
  await container.read(walkRecoveryServiceProvider).check();

  // 8. First frame.
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const LandMeasureApp(),
    ),
  );

  // 9. After the first frame.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // UMP → iOS ATT (when eligible) → Mobile Ads SDK; managers preload
    // once ads are enabled.
    container
      ..read(interstitialManagerProvider)
      ..read(appOpenManagerProvider);
    unawaited(container.read(adsServiceProvider.notifier).start());
    // TODO(phase-10): NotificationService.init() and PushService.init().
    unawaited(_housekeeping(container));
  });
}

/// Clears temp exports and (weekly) removes orphan photo/thumbnail files.
Future<void> _housekeeping(ProviderContainer container) async {
  try {
    final cleaner = container.read(orphanFileCleanerProvider);
    await cleaner.clearExports();
    await cleaner.runIfDue();
  } on Object catch (e, st) {
    Log.w('Housekeeping failed', e, st);
  }
}
