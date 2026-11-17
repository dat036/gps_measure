import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/features/settings/settings_controller.dart';
import 'package:gps_measurement/features/settings/settings_labels.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:gps_measurement/features/settings/widgets/language_widgets.dart';
import 'package:gps_measurement/features/settings/widgets/settings_section.dart';

/// Settings → Language (`design.md` §5.13): system default or one of the
/// app languages, each in its own script. Applies at once (no restart).
/// Looks like the first-launch language screen: flags, a native ad at the
/// bottom and a tick at the top right (dimmed until a language is picked;
/// it only closes the screen, the choice is already applied).
class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  bool _picked = false;

  void _pick(String? code) {
    setState(() => _picked = true);
    unawaited(
      ref.read(settingsControllerProvider.notifier).setLocaleCode(code),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final code = ref.watch(settingsProvider.select((s) => s.localeCode));
    final device = ref.watch(deviceLocaleProvider).languageCode;
    final machineTranslated = machineTranslatedLanguages.contains(
      Localizations.localeOf(context).languageCode,
    );

    return Scaffold(
      backgroundColor: colors.surfacePage,
      appBar: AppBar(
        title: Text(l10n.screenLanguage),
        actions: [
          LanguageConfirmButton(
            label: l10n.actionContinue,
            enabled: _picked,
            onTap: () => context.pop(),
          ),
          const SizedBox(width: LmSpacing.s4),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              // The first card has no section title above it.
              padding: const EdgeInsets.fromLTRB(
                LmSpacing.pageH,
                LmSpacing.s16,
                LmSpacing.pageH,
                LmSpacing.s16,
              ),
              children: [
                SettingsSection(
                  dividerIndent: LmSpacing.s16,
                  children: [
                    LanguageTile(
                      leading: Icon(
                        Icons.language_rounded,
                        size: 28,
                        color: colors.textSecondary,
                      ),
                      title: l10n.languageSystem,
                      subtitle: languageNativeNames[device],
                      selected: code == null,
                      onTap: () => _pick(null),
                    ),
                  ],
                ),
                SettingsSection(
                  title: l10n.languageAppLanguages,
                  dividerIndent: LmSpacing.s16,
                  children: [
                    for (final c in appLanguageCodes)
                      LanguageTile(
                        leading: LanguageTile.flag(languageFlags[c]!),
                        title: languageNativeNames[c]!,
                        selected: c == code,
                        onTap: () => _pick(c),
                      ),
                  ],
                ),
                if (machineTranslated)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      LmSpacing.s4,
                      LmSpacing.s12,
                      LmSpacing.s4,
                      0,
                    ),
                    child: Text(
                      l10n.languageMachineNote,
                      style: LmTypography.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const LanguageNativeAd(),
        ],
      ),
    );
  }
}
