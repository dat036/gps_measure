import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';
import 'package:gps_measurement/core/config/env.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meta_service.g.dart';

/// Meta (Facebook) SDK, used only to attribute installs for Meta ad
/// campaigns. The SDK is configured natively with auto-init and auto-logging
/// off; this turns logging on once the user's consent allows it, which sends
/// the activate-app event Meta counts as an install. AdMob bidding does not
/// need this: it runs through the `gma_mediation_meta` adapter.
class MetaService {
  MetaService({FacebookAppEvents? events}) : _events = events;

  FacebookAppEvents? _events;
  bool _started = false;

  /// App ID of the current platform; empty disables the SDK (dev, tests).
  String get appId => defaultTargetPlatform == TargetPlatform.iOS
      ? Env.facebookAppIdIos
      : Env.facebookAppIdAndroid;

  /// Call after UMP and ATT, with the UMP result ([consented] is
  /// `canRequestAds`). Never throws; without consent nothing is logged.
  Future<void> start({required bool consented}) async {
    if (_started || appId.isEmpty || !consented) return;
    _started = true;
    try {
      final events = _events ??= FacebookAppEvents();
      await events.setAutoLogAppEventsEnabled(true);
      // iOS only returns the IDFA when ATT is granted; the SDK checks it.
      await events.setAdvertiserIdCollectionEnabled(true);
      await events.activateApp();
    } on Object catch (e, st) {
      _started = false;
      Log.w('Meta SDK start failed', e, st);
    }
  }
}

@Riverpod(keepAlive: true)
MetaService metaService(Ref ref) => MetaService();
