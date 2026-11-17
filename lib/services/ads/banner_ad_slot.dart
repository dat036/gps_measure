import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/services/ads/ad_unit_ids.dart';
import 'package:gps_measurement/services/ads/ads_service.dart';
import 'package:gps_measurement/services/remote_config/rc_keys.dart';

/// Adaptive anchored banner (free users only; never on measuring screens).
/// The slot keeps the banner's height while it loads so content does not
/// jump, and collapses if no ad comes.
///
/// [collapsible]: the main banner, under the bottom nav of every tab. It
/// opens as a larger ad that the user collapses to the banner; switched by
/// `homeBannerEnabled`. The plain one (Detail) is switched by
/// `bannerEnabled`.
///
/// [bottomInset] (the system navigation bar) is kept clear under the banner
/// in [background], whether or not an ad shows, so a slot at the very
/// bottom of the screen never leaves the bar's area uncovered.
class BannerAdSlot extends ConsumerWidget {
  const BannerAdSlot({
    this.collapsible = false,
    this.bottomInset = 0,
    this.background,
    super.key,
  });

  final bool collapsible;
  final double bottomInset;

  /// Behind the banner and the inset; the page color when null.
  final Color? background;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled =
        ref.watch(adsEnabledProvider) &&
        ref.watch(
          monetizationConfigProvider.select(
            (c) => collapsible ? c.homeBannerEnabled : c.bannerEnabled,
          ),
        );
    final color = background ?? LmColors.of(context).surfacePage;
    if (!enabled) return _Inset(color: color, height: bottomInset);
    return LayoutBuilder(
      builder: (context, constraints) => _Banner(
        key: ValueKey(constraints.maxWidth.truncate()),
        width: constraints.maxWidth.truncate(),
        collapsible: collapsible,
        bottomInset: bottomInset,
        background: color,
      ),
    );
  }
}

/// Just the system bar's area, in the slot's color.
class _Inset extends StatelessWidget {
  const _Inset({required this.color, required this.height});

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) => height <= 0
      ? const SizedBox.shrink()
      : ColoredBox(
          color: color,
          child: SizedBox(width: double.infinity, height: height),
        );
}

class _Banner extends StatefulWidget {
  const _Banner({
    required this.width,
    required this.collapsible,
    required this.bottomInset,
    required this.background,
    super.key,
  });

  final int width;
  final bool collapsible;
  final double bottomInset;
  final Color background;

  @override
  State<_Banner> createState() => _BannerState();
}

class _BannerState extends State<_Banner> {
  BannerAd? _ad;
  AdSize? _size;
  bool _loaded = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    // The "large" adaptive size is up to 15% of the screen tall: a slot
    // under the bottom nav must stay a plain banner (~50-60 dp), or the
    // ad sits at the bottom of a tall blank box. The Detail banner keeps
    // the large one.
    final size = widget.collapsible
        // Its replacement is the tall "large" size avoided here.
        // ignore: deprecated_member_use
        ? await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            widget.width,
          )
        : await AdSize.getLargeAnchoredAdaptiveBannerAdSize(widget.width);
    if (!mounted) return;
    if (size == null) {
      setState(() => _failed = true);
      return;
    }
    setState(() => _size = size);
    _ad = BannerAd(
      adUnitId: AdUnitIds.of(AdFormat.banner),
      size: size,
      request: AdRequest(
        // The expanded ad folds down towards the bottom edge.
        extras: widget.collapsible ? const {'collapsible': 'bottom'} : null,
      ),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          Log.w(
            'Banner not loaded '
            '[${error.domain}/${error.code}]: ${error.message}',
          );
          unawaited(ad.dispose());
          _ad = null;
          if (mounted) setState(() => _failed = true);
        },
      ),
    );
    await _ad!.load();
  }

  @override
  void dispose() {
    unawaited(_ad?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = _size;
    final inset = _Inset(
      color: widget.background,
      height: widget.bottomInset,
    );
    if (_failed || size == null) return inset;
    final ad = _ad;
    return ColoredBox(
      color: widget.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: size.height.toDouble(),
            child: _loaded && ad != null
                ? Center(
                    child: SizedBox(
                      width: size.width.toDouble(),
                      height: size.height.toDouble(),
                      child: AdWidget(ad: ad),
                    ),
                  )
                : null,
          ),
          inset,
        ],
      ),
    );
  }
}
