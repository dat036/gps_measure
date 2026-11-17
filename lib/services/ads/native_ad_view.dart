import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/core/widgets/shimmer.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/services/ads/ad_unit_ids.dart';
import 'package:gps_measurement/services/ads/ads_service.dart';
import 'package:gps_measurement/services/ads/native_ad_controller.dart';

/// Where native ads appear and how they are dressed. The button always has
/// the color of the primary button of the screen the ad is on (the intro's
/// button is `PrimaryCtaVariant.distance`).
abstract final class NativeAdPlacements {
  /// Language screen: the ad sits under its Continue button (same blue).
  static NativeAdStyle languageBottom(BuildContext context) {
    final colors = LmColors.of(context);
    return NativeAdStyle.from(
      colors,
      cta: ModeColors.of(context, MeasurementType.distance).main,
      background: colors.surfaceCard,
    );
  }

  static NativeAdStyle introBottom(BuildContext context) {
    final colors = LmColors.of(context);
    return NativeAdStyle.from(
      colors,
      cta: ModeColors.of(context, MeasurementType.distance).main,
      background: colors.surfacePage,
    );
  }

  static NativeAdStyle introFull(BuildContext context) {
    final colors = LmColors.of(context);
    return NativeAdStyle.from(
      colors,
      cta: ModeColors.of(context, MeasurementType.distance).main,
      background: colors.surfaceSheet,
    );
  }

  /// Detail page: the button has the color of the measurement's mode.
  static NativeAdStyle detailForm(BuildContext context, MeasurementType type) {
    final colors = LmColors.of(context);
    return NativeAdStyle.from(
      colors,
      cta: ModeColors.of(context, type).main,
      background: colors.surfaceCard,
    );
  }

  /// Warms the language screen's ad (from the first launch's splash).
  static void preloadLanguage(BuildContext context, WidgetRef ref) {
    ref
        .read(nativeAdCacheProvider)
        .preload(
          AdFormat.nativeLanguage,
          NativeLayout.medium,
          languageBottom(context),
        );
  }

  /// Warms the intro ads while the language screen is on.
  static void preloadIntro(BuildContext context, WidgetRef ref) {
    ref.read(nativeAdCacheProvider)
      ..preload(
        AdFormat.nativeIntro,
        NativeLayout.compact,
        introBottom(context),
      )
      ..preload(
        AdFormat.nativeIntroFull,
        NativeLayout.full,
        introFull(context),
      );
  }

  /// Warms the Detail page's ad while the user measures (Detail is the
  /// page after Save).
  static void preloadDetail(
    BuildContext context,
    WidgetRef ref,
    MeasurementType type,
  ) {
    ref
        .read(nativeAdCacheProvider)
        .preload(
          AdFormat.nativeSaved,
          NativeLayout.medium,
          detailForm(context, type),
        );
  }
}

/// A native ad of [NativeLayout.compact] / [NativeLayout.medium] size.
/// Loading: a skeleton of the same height when [showSkeleton], else
/// nothing. Failed: collapses. The size change is animated.
class NativeAdBox extends StatelessWidget {
  const NativeAdBox({
    required this.controller,
    this.showSkeleton = true,
    this.margin = EdgeInsets.zero,
    super.key,
  });

  final NativeAdController controller;
  final bool showSkeleton;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final height = controller.layout.height;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final ad = controller.ad;
        final Widget child = switch (controller.status) {
          NativeAdStatus.loaded when ad != null => Padding(
            padding: margin,
            child: SizedBox(
              height: height,
              child: ClipRRect(
                borderRadius: LmRadius.mdAll,
                child: AdWidget(ad: ad),
              ),
            ),
          ),
          NativeAdStatus.loading when showSkeleton => Padding(
            padding: margin,
            child: NativeAdSkeleton(height: height),
          ),
          _ => const SizedBox(width: double.infinity),
        };
        return AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: child,
        );
      },
    );
  }
}

/// Placeholder shaped like a native card (icon, two lines, button).
class NativeAdSkeleton extends StatelessWidget {
  const NativeAdSkeleton({required this.height, super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    return Container(
      height: height,
      padding: const EdgeInsets.all(LmSpacing.s12),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: LmRadius.mdAll,
        border: Border.all(color: colors.divider),
      ),
      child: Shimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                ShimmerBox(width: 44, height: 44, radius: LmRadius.sm),
                SizedBox(width: LmSpacing.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 150, height: 14),
                      SizedBox(height: LmSpacing.s8),
                      ShimmerBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
            if (height > 200) ...[
              const SizedBox(height: LmSpacing.s12),
              const Expanded(child: ShimmerBox(radius: LmRadius.sm)),
            ] else
              const Spacer(),
            const SizedBox(height: LmSpacing.s12),
            const ShimmerBox(height: 44, radius: LmRadius.sm),
          ],
        ),
      ),
    );
  }
}

/// Whether native ads can appear at all right now (SDK ready, not premium,
/// platform supported). Screens use it to skip building the slots.
final nativeAdsEnabledProvider = Provider<bool>(
  (ref) => NativeAdController.supported && ref.watch(adsEnabledProvider),
);
