import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' show AdWidget;
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/widgets/primary_cta.dart';
import 'package:gps_measurement/core/widgets/shimmer.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/services/ads/ad_unit_ids.dart';
import 'package:gps_measurement/services/ads/ads_service.dart';
import 'package:gps_measurement/services/ads/native_ad_controller.dart';
import 'package:gps_measurement/services/ads/native_ad_view.dart';

/// The Next button is as tall as the button inside the native ad.
const double _ctaHeight = 44;

/// The native ad is wider than the content: 16dp from the screen edges
/// (the rest of the panel keeps 24dp).
const double _adMargin = LmSpacing.s16;

/// One intro slide. Drop the picture at [imageAsset] (in `assets/images/`)
/// and it replaces the placeholder automatically.
class _IntroPage {
  const _IntroPage({
    required this.imageAsset,
    required this.icon,
    required this.title,
    required this.body,
  });

  final String imageAsset;
  final IconData icon;
  final String Function(AppLocalizations) title;
  final String Function(AppLocalizations) body;
}

final List<_IntroPage> _pages = [
  _IntroPage(
    imageAsset: 'assets/images/intro_area.webp',
    icon: Icons.crop_square_rounded,
    title: (l) => l.introAreaTitle,
    body: (l) => l.introAreaBody,
  ),
  _IntroPage(
    imageAsset: 'assets/images/intro_distance.webp',
    icon: Icons.straighten_rounded,
    title: (l) => l.introDistanceTitle,
    body: (l) => l.introDistanceBody,
  ),
  _IntroPage(
    imageAsset: 'assets/images/intro_field.webp',
    icon: Icons.agriculture_rounded,
    title: (l) => l.introFieldTitle,
    body: (l) => l.introFieldBody,
  ),
];

/// A page of the pager: an intro slide, or the full-screen native ad
/// inserted after the first slide.
@immutable
class _Step {
  const _Step.slide(this.slide) : isAd = false;
  const _Step.ad() : slide = -1, isAd = true;

  final int slide;
  final bool isAd;
}

/// First-launch slides: Area → Distance & Walk → Real use cases.
///
/// Ads (free users, Android):
///  * a compact native ad under the button on slides 1 and 3, hidden from the
///    moment slide 1 is left. The next one is requested right then, so it is
///    ready (or still a skeleton, never the old ad again) on slide 3;
///  * a full-screen native ad page between slide 1 and 2, only if it loads
///    (while it loads the page shows a skeleton; if it fails the page
///    disappears). It has a close button and can be swiped past.
class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen> {
  static const double _compactMinScreenHeight = 600;

  final PageController _controller = PageController();
  int _page = 0;

  NativeAdController? _full;
  NativeAdController? _bottom;
  NativeAdController? _bottomNext;
  bool _adsStarted = false;
  bool _refreshed = false;

  List<_Step> get _steps => [
    const _Step.slide(0),
    if (_full != null && _full!.status != NativeAdStatus.failed)
      const _Step.ad(),
    const _Step.slide(1),
    const _Step.slide(2),
  ];

  _Step get _step => _steps[_page.clamp(0, _steps.length - 1)];

  /// The bottom ad on screen: while a refresh is pending, the new one (a
  /// skeleton until it loads), never the one the user has already seen.
  NativeAdController? get _bottomShown => _bottomNext ?? _bottom;

  @override
  void initState() {
    super.initState();
    // Ads that become ready after this screen opened (consent / SDK
    // start-up) are only used while the user is still on the first slide.
    ref.listenManual(adsEnabledProvider, (_, enabled) {
      if (enabled && _page == 0) _startAds();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ref.read(adsEnabledProvider)) _startAds();
  }

  @override
  void dispose() {
    _controller.dispose();
    _full?.removeListener(_onFullChanged);
    _full?.dispose();
    _bottom?.dispose();
    _bottomNext?.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------- ads

  void _startAds() {
    if (_adsStarted || !NativeAdController.supported) return;
    _adsStarted = true;
    final cache = ref.read(nativeAdCacheProvider);
    _bottom = cache.obtain(
      AdFormat.nativeIntro,
      NativeLayout.compact,
      NativeAdPlacements.introBottom(context),
    );
    _full = cache.obtain(
      AdFormat.nativeIntroFull,
      NativeLayout.full,
      NativeAdPlacements.introFull(context),
    )..addListener(_onFullChanged);
    if (mounted) setState(() {});
  }

  /// The full-screen ad failed: its page goes away. A user who already
  /// swiped past its place stays on the slide they were on.
  void _onFullChanged() {
    final full = _full;
    if (full == null || full.status != NativeAdStatus.failed) return;
    final removedBeforeCurrent = _page > 1;
    full.removeListener(_onFullChanged);
    setState(() {
      _full = null;
      if (removedBeforeCurrent) _page -= 1;
    });
    // Not while it is still notifying its listeners.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      full.dispose();
      if (removedBeforeCurrent && _controller.hasClients) {
        _controller.jumpToPage(_page);
      }
    });
  }

  /// Leaving slide 1 hides the bottom ad and asks for the next one in the
  /// background; slide 3 (or slide 1 again) shows that one. If it cannot be
  /// loaded the slot stays empty rather than repeating the old ad.
  void _refreshBottom() {
    if (_bottom == null || _bottomNext != null) return;
    final next = ref
        .read(nativeAdCacheProvider)
        .create(
          AdFormat.nativeIntro,
          NativeLayout.compact,
          NativeAdPlacements.introBottom(context),
        );
    _bottomNext = next;
    void swap() {
      if (next.status == NativeAdStatus.loading) return;
      next.removeListener(swap);
      if (!mounted) return;
      final old = _bottom;
      final loaded = next.status == NativeAdStatus.loaded;
      setState(() {
        _bottom = loaded ? next : null;
        _bottomNext = null;
      });
      // After the frame that stopped showing them.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        old?.dispose();
        if (!loaded) next.dispose();
      });
    }

    next.addListener(swap);
    swap();
  }

  // -------------------------------------------------------- navigation

  void _onPageChanged(int i) {
    final wasFirst = !_step.isAd && _step.slide == 0;
    setState(() => _page = i);
    final step = _steps[i];
    if (!step.isAd && step.slide == 0) {
      // Back on slide 1: it shows the (fresh) bottom ad again.
      _refreshed = false;
    } else if (wasFirst && !_refreshed) {
      // Slide 1 was seen with its ad: ask for the next one now.
      _refreshed = true;
      _refreshBottom();
    }
  }

  void _goNext() => unawaited(
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    ),
  );

  Future<void> _finish() async {
    await ref.read(settingsRepositoryProvider).setOnboardingSeen();
    if (mounted) context.go(Routes.home);
  }

  void _onNext() {
    final step = _step;
    if (!step.isAd && step.slide == _pages.length - 1) {
      unawaited(_finish());
    } else {
      _goNext();
    }
  }

  // ------------------------------------------------------------- build

  /// Space the bottom panel takes: dots, button and the native ad.
  double _panelHeight(BuildContext context, {required bool withAd}) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return LmSpacing.s16 +
        8 +
        LmSpacing.s16 +
        _ctaHeight +
        LmSpacing.s16 +
        (withAd ? NativeLayout.compact.height + LmSpacing.s12 : 0) +
        bottom;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final steps = _steps;
    final step = _step;
    final lastSlide = !step.isAd && step.slide == _pages.length - 1;
    final tallEnough =
        MediaQuery.sizeOf(context).height >= _compactMinScreenHeight;
    // The bottom ad is on slides 1 and 3 only.
    final showBottomAd =
        tallEnough &&
        _bottomShown != null &&
        !step.isAd &&
        step.slide != 1 &&
        _bottomShown!.status != NativeAdStatus.failed;

    return Scaffold(
      backgroundColor: colors.surfaceSheet,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: steps.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, i) {
              final s = steps[i];
              if (s.isAd) {
                return _FullAdPage(controller: _full!, onClose: _goNext);
              }
              return AnimatedPadding(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.only(
                  bottom: _panelHeight(context, withAd: showBottomAd),
                ),
                child: _SlideView(page: _pages[s.slide]),
              );
            },
          ),
          if (!step.isAd) ...[
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomPanel(
                dotsCount: _pages.length,
                dotIndex: step.slide,
                ctaLabel: lastSlide ? l10n.introGetStarted : l10n.introNext,
                onNext: _onNext,
                ad: showBottomAd ? _bottomShown : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Dots, the button and (when [ad] is given) the native ad under it.
class _BottomPanel extends StatelessWidget {
  const _BottomPanel({
    required this.dotsCount,
    required this.dotIndex,
    required this.ctaLabel,
    required this.onNext,
    required this.ad,
  });

  final int dotsCount;
  final int dotIndex;
  final String ctaLabel;
  final VoidCallback onNext;
  final NativeAdController? ad;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.surfaceSheet),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          0,
          LmSpacing.s16,
          0,
          MediaQuery.paddingOf(context).bottom + LmSpacing.s16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dots(count: dotsCount, index: dotIndex),
            const SizedBox(height: LmSpacing.s16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: LmSpacing.s24),
              child: PrimaryCta(
                label: ctaLabel,
                variant: PrimaryCtaVariant.distance,
                icon: Icons.arrow_forward_rounded,
                buttonHeight: _ctaHeight,
                onPressed: onNext,
              ),
            ),
            if (ad != null) ...[
              const SizedBox(height: LmSpacing.s12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: _adMargin),
                child: NativeAdBox(controller: ad!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Picture on top, title and text below.
class _SlideView extends StatelessWidget {
  const _SlideView({required this.page});

  final _IntroPage page;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    return Column(
      children: [
        Expanded(child: _IntroImage(page: page)),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            LmSpacing.s24,
            LmSpacing.s20,
            LmSpacing.s24,
            0,
          ),
          child: Column(
            children: [
              Text(
                page.title(l10n),
                textAlign: TextAlign.center,
                style: LmTypography.displayHero.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: LmSpacing.s8),
              Text(
                page.body(l10n),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: LmTypography.bodyLg.copyWith(
                  fontWeight: FontWeight.w400,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The full-screen native ad page: skeleton while loading, the ad when
/// loaded, always with a close button (also swipe to leave).
const double _swipeEdge = 36;

/// Invisible but hit-testable: lets the pager's drag recognizer win.
class _SwipeEdge extends StatelessWidget {
  const _SwipeEdge();

  @override
  Widget build(BuildContext context) => const ExcludeSemantics(
    child: Listener(
      behavior: HitTestBehavior.opaque,
      child: SizedBox.expand(),
    ),
  );
}

class _FullAdPage extends StatelessWidget {
  const _FullAdPage({required this.controller, required this.onClose});

  final NativeAdController controller;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    final padding = MediaQuery.paddingOf(context);
    return ColoredBox(
      color: colors.surfaceSheet,
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(
                top: padding.top,
                bottom: padding.bottom,
              ),
              child: ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  final ad = controller.ad;
                  if (controller.status == NativeAdStatus.loaded &&
                      ad != null) {
                    return AdWidget(ad: ad);
                  }
                  return const _FullAdSkeleton();
                },
              ),
            ),
          ),
          // The ad is a native view that swallows touches: Flutter-side
          // strips at both edges keep "swipe to the next page" working
          // (the pager only sees touches that reach Flutter).
          const PositionedDirectional(
            top: 0,
            bottom: 0,
            start: 0,
            width: _swipeEdge,
            child: _SwipeEdge(),
          ),
          const PositionedDirectional(
            top: 0,
            bottom: 0,
            end: 0,
            width: _swipeEdge,
            child: _SwipeEdge(),
          ),
          PositionedDirectional(
            top: padding.top + LmSpacing.s8,
            end: LmSpacing.s8,
            child: Semantics(
              button: true,
              label: context.l10n.actionClose,
              child: Material(
                color: colors.mapPill,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onClose,
                  child: SizedBox.square(
                    dimension: LmSpacing.touchMin,
                    child: Icon(Icons.close_rounded, color: colors.onMode),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullAdSkeleton extends StatelessWidget {
  const _FullAdSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 56, 20, 20),
      child: Shimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ShimmerBox(width: 56, height: 56, radius: LmRadius.sm),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 180, height: 20),
                      SizedBox(height: LmSpacing.s8),
                      ShimmerBox(height: 14),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(child: ShimmerBox(radius: LmRadius.sm)),
            SizedBox(height: 16),
            ShimmerBox(height: 56, radius: LmRadius.sm),
          ],
        ),
      ),
    );
  }
}

class _IntroImage extends StatelessWidget {
  const _IntroImage({required this.page});

  final _IntroPage page;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    final placeholder = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors.heroFieldA, colors.heroBase],
        ),
      ),
      child: Center(
        child: Icon(
          page.icon,
          size: 96,
          color: colors.onMode.withValues(alpha: 0.85),
        ),
      ),
    );
    return Image.asset(
      page.imageAsset,
      fit: BoxFit.cover,
      width: double.infinity,
      excludeFromSemantics: true,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < count; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == index ? 28 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == index ? colors.distanceMain : colors.divider,
                borderRadius: LmRadius.fullAll,
              ),
            ),
        ],
      ),
    );
  }
}
