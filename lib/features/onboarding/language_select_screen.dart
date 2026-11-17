import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/features/settings/settings_controller.dart';
import 'package:gps_measurement/features/settings/settings_labels.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:gps_measurement/features/settings/widgets/language_widgets.dart';
import 'package:gps_measurement/features/settings/widgets/settings_section.dart';
import 'package:gps_measurement/services/ads/ads_service.dart';
import 'package:gps_measurement/services/ads/native_ad_view.dart';

/// First launch, before the intro: pick the app language. The choice
/// applies at once (this screen changes language as you tap) and can be
/// changed later in Settings → Language, which looks the same.
///
/// No language is selected at first (not even the device's): the tick at
/// the top right is dimmed (0.4) and inactive until the user has picked
/// one; then it lights up and leads to the intro.
class LanguageSelectScreen extends ConsumerStatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  ConsumerState<LanguageSelectScreen> createState() =>
      _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends ConsumerState<LanguageSelectScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Warm the intro's native ads while the user picks a language.
    if (ref.read(adsEnabledProvider)) {
      NativeAdPlacements.preloadIntro(context, ref);
    }
  }

  void _pick(String code) => unawaited(
    ref.read(settingsControllerProvider.notifier).setLocaleCode(code),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    // Only what the user picked (kept if they come back to this screen).
    final selected = ref.watch(settingsProvider.select((s) => s.localeCode));
    return Scaffold(
      backgroundColor: colors.surfacePage,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LmSpacing.pageH,
                LmSpacing.s16,
                LmSpacing.s4,
                LmSpacing.s8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        l10n.languageChooseTitle,
                        style: LmTypography.displayHero.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  LanguageConfirmButton(
                    label: l10n.actionContinue,
                    enabled: selected != null,
                    onTap: () => context.go(Routes.intro),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  LmSpacing.pageH,
                  LmSpacing.s8,
                  LmSpacing.pageH,
                  LmSpacing.s16,
                ),
                children: [
                  SettingsSection(
                    dividerIndent: LmSpacing.s16,
                    children: [
                      for (final code in appLanguageCodes)
                        LanguageTile(
                          leading: LanguageTile.flag(languageFlags[code]!),
                          title: languageNativeNames[code]!,
                          selected: code == selected,
                          onTap: () => _pick(code),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            LanguageNativeAd(
              onAdsReady: () => NativeAdPlacements.preloadIntro(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}
