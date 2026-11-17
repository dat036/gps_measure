import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/services/ads/ad_unit_ids.dart';
import 'package:gps_measurement/services/ads/ads_service.dart';
import 'package:gps_measurement/services/ads/native_ad_controller.dart';
import 'package:gps_measurement/services/ads/native_ad_view.dart';

/// Pieces shared by the first-launch language screen and Settings →
/// Language, so the two look the same.

/// One row: [leading] (a flag), the name in its own script, an optional
/// [subtitle] and a radio mark; the chosen row is tinted.
class LanguageTile extends StatelessWidget {
  const LanguageTile({
    required this.leading,
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    super.key,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  /// A country flag, sized for [LanguageTile.leading].
  static Widget flag(String emoji) => Text(
    emoji,
    style: const TextStyle(fontSize: 28, height: 1.2),
  );

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    final accent = ModeColors.of(context, MeasurementType.distance);
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      child: Material(
        color: selected ? accent.container : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 60),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: LmSpacing.s16,
                vertical: LmSpacing.s8,
              ),
              child: Row(
                children: [
                  ExcludeSemantics(
                    child: SizedBox(
                      width: 36,
                      child: Center(child: leading),
                    ),
                  ),
                  const SizedBox(width: LmSpacing.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: LmTypography.bodyLg.copyWith(
                            color: colors.textPrimary,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: LmTypography.caption.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  ExcludeSemantics(
                    child: Icon(
                      selected
                          ? Icons.radio_button_checked_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: selected ? accent.main : colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Just a blue tick (no circle): 0.4 and inactive until [enabled], then
/// full and tappable. The hit area stays 48dp.
class LanguageConfirmButton extends StatelessWidget {
  const LanguageConfirmButton({
    required this.label,
    required this.enabled,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = ModeColors.of(context, MeasurementType.distance);
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1 : 0.4,
        duration: const Duration(milliseconds: 200),
        child: InkResponse(
          onTap: enabled ? onTap : null,
          radius: 24,
          child: SizedBox.square(
            dimension: LmSpacing.touchMin,
            child: Icon(Icons.check_rounded, size: 26, color: accent.main),
          ),
        ),
      ),
    );
  }
}

/// The medium native ad under the language list. It owns its request (once,
/// when ads are ready) and is left out on short screens, where the list
/// needs the room.
class LanguageNativeAd extends ConsumerStatefulWidget {
  const LanguageNativeAd({this.onAdsReady, super.key});

  /// Called when ads become ready while this screen is open.
  final VoidCallback? onAdsReady;

  static const double minScreenHeight = 700;

  @override
  ConsumerState<LanguageNativeAd> createState() => _LanguageNativeAdState();
}

class _LanguageNativeAdState extends ConsumerState<LanguageNativeAd> {
  NativeAdController? _ad;

  @override
  void initState() {
    super.initState();
    ref.listenManual(adsEnabledProvider, (_, enabled) {
      if (!enabled || !mounted) return;
      setState(_start);
      widget.onAdsReady?.call();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ref.read(adsEnabledProvider)) _start();
  }

  void _start() {
    if (_ad != null || !ref.read(nativeAdsEnabledProvider)) return;
    _ad = ref
        .read(nativeAdCacheProvider)
        .obtain(
          AdFormat.nativeLanguage,
          NativeLayout.medium,
          NativeAdPlacements.languageBottom(context),
        );
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _ad;
    if (ad == null ||
        MediaQuery.sizeOf(context).height < LanguageNativeAd.minScreenHeight) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        LmSpacing.pageH,
        0,
        LmSpacing.pageH,
        LmSpacing.s16,
      ),
      child: NativeAdBox(controller: ad),
    );
  }
}
