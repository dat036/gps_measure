import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show Color;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/services/ads/ad_unit_ids.dart';
import 'package:gps_measurement/services/ads/ads_service.dart';

/// Native ad layouts registered on Android and iOS with the same factory IDs.
enum NativeLayout {
  /// Icon, headline, one line of body and the button. Under the intro
  /// slides' button.
  compact('lm_native_compact', 132),

  /// Header, media and the button. Above the Saved list.
  medium('lm_native_medium', 272),

  /// The whole screen: media, text and a large button. An intro page.
  full('lm_native_full', 0);

  const NativeLayout(this.factoryId, this._height);

  final String factoryId;

  final double _height;

  /// iOS compact includes a 120pt media view for native video creatives.
  /// 0 fills the parent (the full-screen intro ad).
  double get height =>
      this == compact && defaultTargetPlatform == TargetPlatform.iOS
      ? 164
      : _height;
}

/// Colors handed to the native layout. Built from the app's palette so the
/// ad looks like part of the screen, with the button in the same color as
/// the screen's own primary button ([cta]).
@immutable
class NativeAdStyle {
  const NativeAdStyle({
    required this.background,
    required this.stroke,
    required this.title,
    required this.body,
    required this.cta,
    required this.ctaText,
    required this.badge,
    required this.badgeText,
  });

  /// [background] is the surface the ad sits on; [cta] the color of the
  /// screen's primary button.
  factory NativeAdStyle.from(
    LmColors colors, {
    required Color cta,
    required Color background,
  }) => NativeAdStyle(
    background: background,
    stroke: colors.divider,
    title: colors.textPrimary,
    body: colors.textSecondary,
    cta: cta,
    ctaText: colors.onMode,
    badge: colors.areaContainer,
    badgeText: colors.brandPrimary,
  );

  final Color background;
  final Color stroke;
  final Color title;
  final Color body;
  final Color cta;
  final Color ctaText;
  final Color badge;
  final Color badgeText;

  /// `customOptions` for the factory: ARGB ints under fixed keys.
  Map<String, Object> toOptions() => {
    'background': background.toARGB32(),
    'stroke': stroke.toARGB32(),
    'title': title.toARGB32(),
    'body': body.toARGB32(),
    'cta': cta.toARGB32(),
    'ctaText': ctaText.toARGB32(),
    'badge': badge.toARGB32(),
    'badgeText': badgeText.toARGB32(),
  };
}

enum NativeAdStatus { loading, loaded, failed }

/// One native ad request and its result. Owns the [NativeAd]: whoever
/// holds the controller calls [dispose] (which disposes the ad).
class NativeAdController extends ChangeNotifier {
  NativeAdController({
    required this.format,
    required this.layout,
    required this.style,
  });

  /// Google: a native ad older than 1 hour must not be shown.
  static const Duration adLifetime = Duration(hours: 1);

  static bool get supported =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  final AdFormat format;
  final NativeLayout layout;
  final NativeAdStyle style;

  NativeAd? _ad;
  NativeAdStatus _status = NativeAdStatus.loading;
  DateTime? _loadedAt;
  bool _disposed = false;

  NativeAd? get ad => _ad;
  NativeAdStatus get status => _status;

  bool get isStale {
    final at = _loadedAt;
    return at != null && DateTime.now().difference(at) >= adLifetime;
  }

  /// Marks the request as failed without asking for an ad (ads off).
  void markUnavailable() => _set(NativeAdStatus.failed);

  void load() {
    if (!supported) {
      _set(NativeAdStatus.failed);
      return;
    }
    try {
      final request = NativeAd(
        adUnitId: AdUnitIds.of(format),
        factoryId: layout.factoryId,
        customOptions: style.toOptions(),
        request: const AdRequest(),
        nativeAdOptions: NativeAdOptions(
          // Full screen: the close button takes the top-right corner.
          adChoicesPlacement: layout == NativeLayout.full
              ? AdChoicesPlacement.topLeftCorner
              : AdChoicesPlacement.topRightCorner,
          videoOptions: VideoOptions(startMuted: true),
        ),
        listener: NativeAdListener(
          onAdLoaded: (loaded) {
            if (_disposed) {
              unawaited(loaded.dispose());
              return;
            }
            _ad = loaded as NativeAd;
            _loadedAt = DateTime.now();
            _set(NativeAdStatus.loaded);
          },
          onAdFailedToLoad: (failed, error) {
            Log.w(
              'Native ad ${format.name} not loaded '
              '[${error.domain}/${error.code}]: ${error.message}',
            );
            unawaited(failed.dispose());
            _set(NativeAdStatus.failed);
          },
        ),
      );
      unawaited(request.load());
    } on Object catch (e, st) {
      Log.w('Native ad ${format.name} request failed', e, st);
      _set(NativeAdStatus.failed);
    }
  }

  void _set(NativeAdStatus next) {
    if (_disposed) return;
    _status = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_ad?.dispose());
    _ad = null;
    super.dispose();
  }
}

/// Native ads loaded ahead of the screen that shows them (one per format).
/// [obtain] hands the cached controller over (the screen then owns it); a
/// stale or failed one is never reused. Only filled while ads are enabled.
class NativeAdCache {
  NativeAdCache(this._ref);

  final Ref _ref;
  final Map<AdFormat, NativeAdController> _cached = {};

  bool get _canLoad =>
      NativeAdController.supported && _ref.read(adsEnabledProvider);

  /// Starts loading [format] if nothing usable is cached (the cache is
  /// checked first: no request over a cached ad).
  void preload(AdFormat format, NativeLayout layout, NativeAdStyle style) {
    if (!_canLoad) return;
    final existing = _cached[format];
    if (existing != null &&
        existing.status != NativeAdStatus.failed &&
        !existing.isStale) {
      return;
    }
    existing?.dispose();
    _cached[format] = NativeAdController(
      format: format,
      layout: layout,
      style: style,
    )..load();
  }

  /// A controller for [format] to show: the preloaded one when usable,
  /// else a fresh request. The caller must dispose it.
  NativeAdController obtain(
    AdFormat format,
    NativeLayout layout,
    NativeAdStyle style,
  ) {
    final cached = _cached.remove(format);
    if (cached != null &&
        cached.status != NativeAdStatus.failed &&
        !cached.isStale) {
      return cached;
    }
    cached?.dispose();
    return create(format, layout, style);
  }

  /// A new request that skips the cache (refreshing a visible ad). The
  /// caller must dispose it.
  NativeAdController create(
    AdFormat format,
    NativeLayout layout,
    NativeAdStyle style,
  ) {
    final controller = NativeAdController(
      format: format,
      layout: layout,
      style: style,
    );
    if (_canLoad) {
      controller.load();
    } else {
      controller.markUnavailable();
    }
    return controller;
  }

  void dispose() {
    for (final c in _cached.values) {
      c.dispose();
    }
    _cached.clear();
  }
}

final nativeAdCacheProvider = Provider<NativeAdCache>((ref) {
  final cache = NativeAdCache(ref);
  ref.onDispose(cache.dispose);
  return cache;
});
