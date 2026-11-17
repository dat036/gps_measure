import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ad_coordinator.g.dart';

/// Shared state of the full-screen ads (App Open, interstitial, rewarded).
///
/// A full-screen ad is its own Activity, so the Flutter app is "hidden" and
/// "shown" around it. Without this, closing an interstitial would look like
/// the user coming back to the app and trigger an App Open ad.
class AdCoordinator {
  int _showing = 0;
  DateTime? _lastClosedAt;

  /// A full-screen ad is on screen (or about to be).
  bool get isShowing => _showing > 0;

  DateTime? get lastClosedAt => _lastClosedAt;

  /// Call right before `ad.show()`.
  void begin() => _showing++;

  /// Call when the ad was dismissed or failed to show.
  void end(DateTime now) {
    if (_showing > 0) _showing--;
    _lastClosedAt = now;
  }

  @visibleForTesting
  void reset() {
    _showing = 0;
    _lastClosedAt = null;
  }
}

@Riverpod(keepAlive: true)
AdCoordinator adCoordinator(Ref ref) => AdCoordinator();
