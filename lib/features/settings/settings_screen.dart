import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_measurement/core/config/env.dart';
import 'package:gps_measurement/core/format/unit_formatter.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/core/widgets/lm_bottom_sheet.dart';
import 'package:gps_measurement/core/widgets/mode_icon.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/features/measure/common/map_layer_sheet.dart';
import 'package:gps_measurement/features/premium/premium_flows.dart';
import 'package:gps_measurement/features/premium/premium_links.dart';
import 'package:gps_measurement/features/settings/settings_controller.dart';
import 'package:gps_measurement/features/settings/settings_labels.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:gps_measurement/features/settings/widgets/settings_section.dart';
import 'package:gps_measurement/services/ads/ads_service.dart';
import 'package:gps_measurement/services/ads/consent_service.dart';
import 'package:gps_measurement/services/purchases/purchase_service.dart';

/// Setting tab (`design.md` §5.10): the Premium card, preferences, measuring
/// & map toggles, Support & Legal and the app version. Every change applies
/// at once.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final settings = ref.watch(settingsProvider);
    // Watched first: keeps the auto-dispose controller alive for the
    // callbacks below.
    final links = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final languageCode = settings.localeCode;

    return Scaffold(
      backgroundColor: colors.surfacePage,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            LmSpacing.pageH,
            0,
            LmSpacing.pageH,
            LmSpacing.s32,
          ),
          children: [
            const _Header(),
            const SizedBox(height: LmSpacing.s12),
            const _PremiumCard(),
            SettingsSection(
              title: l10n.settingsSectionPreferences,
              children: [
                SettingsTile(
                  icon: Icons.straighten_rounded,
                  title: l10n.screenUnits,
                  value:
                      '${UnitFormatter.distanceSymbol(settings.distanceUnit)}'
                      ' · ${UnitFormatter.areaSymbol(settings.areaUnit)}',
                  onTap: () => unawaited(
                    context.push(Routes.settingsChild(Routes.settingsUnits)),
                  ),
                ),
                SettingsTile(
                  icon: Icons.layers_rounded,
                  title: l10n.screenMapStyle,
                  value: mapStyleLabel(context, settings.mapStyle),
                  onTap: () => unawaited(
                    context.push(
                      Routes.settingsChild(Routes.settingsMapStyle),
                    ),
                  ),
                ),
                SettingsTile(
                  icon: Icons.translate_rounded,
                  title: l10n.screenLanguage,
                  value: languageCode == null
                      ? l10n.languageSystem
                      : languageNativeNames[languageCode],
                  onTap: () => unawaited(
                    context.push(
                      Routes.settingsChild(Routes.settingsLanguage),
                    ),
                  ),
                ),
              ],
            ),
            SettingsSection(
              title: l10n.settingsSectionMeasureMap,
              children: [
                SettingsTile(
                  icon: modeIcon(settings.defaultMode),
                  title: l10n.settingsDefaultMode,
                  value: l10n.modeName(settings.defaultMode),
                  onTap: () => unawaited(_pickDefaultMode(context, ref)),
                ),
                SettingsTile.toggle(
                  icon: Icons.gps_fixed_rounded,
                  title: l10n.settingsGpsAccuracy,
                  subtitle: l10n.settingsGpsAccuracySubtitle,
                  switchValue: settings.showGpsAccuracy,
                  onChanged: (on) =>
                      unawaited(controller.setShowGpsAccuracy(on: on)),
                ),
                SettingsTile.toggle(
                  icon: Icons.center_focus_strong_rounded,
                  title: l10n.settingsAutoCenter,
                  subtitle: l10n.settingsAutoCenterSubtitle,
                  switchValue: settings.autoCenter,
                  onChanged: (on) =>
                      unawaited(controller.setAutoCenter(on: on)),
                ),
                SettingsTile.toggle(
                  icon: Icons.add_photo_alternate_outlined,
                  title: l10n.settingsSavePhotos,
                  subtitle: l10n.settingsSavePhotosSubtitle,
                  switchValue: settings.savePhotosToMeasurement,
                  onChanged: (on) =>
                      unawaited(controller.setSavePhotos(on: on)),
                ),
                SettingsTile.toggle(
                  icon: Icons.light_mode_outlined,
                  title: l10n.settingsKeepAwake,
                  subtitle: l10n.settingsKeepAwakeSubtitle,
                  switchValue: settings.keepScreenAwake,
                  onChanged: (on) =>
                      unawaited(controller.setKeepScreenAwake(on: on)),
                ),
              ],
            ),
            SettingsSection(
              title: l10n.settingsSectionSupport,
              children: [
                if (controller.canSendFeedback)
                  SettingsTile(
                    icon: Icons.mail_outline_rounded,
                    title: l10n.settingsHelpFeedback,
                    external: true,
                    onTap: () => unawaited(_sendFeedback(context, ref)),
                  ),
                if (controller.canRate)
                  SettingsTile(
                    icon: Icons.star_outline_rounded,
                    title: l10n.settingsRateUs,
                    external: true,
                    onTap: () => unawaited(
                      _open(context, controller.rate),
                    ),
                  ),
                if (links.privacyPolicyUrl.isNotEmpty)
                  SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: l10n.settingsPrivacyPolicy,
                    external: true,
                    onTap: () => unawaited(
                      _open(context, controller.openPrivacyPolicy),
                    ),
                  ),
                if (links.termsUrl.isNotEmpty)
                  SettingsTile(
                    icon: Icons.description_outlined,
                    title: l10n.settingsTerms,
                    external: true,
                    onTap: () => unawaited(
                      _open(context, controller.openTerms),
                    ),
                  ),
                if (ref.watch(privacyOptionsRequiredProvider).value ?? false)
                  SettingsTile(
                    icon: Icons.shield_outlined,
                    title: l10n.settingsPrivacyChoices,
                    onTap: () => unawaited(_privacyChoices(ref)),
                  ),
                if (!Env.flavor.isProd)
                  SettingsTile(
                    icon: Icons.bug_report_outlined,
                    title: l10n.settingsAdInspector,
                    onTap: ref
                        .read(adsServiceProvider.notifier)
                        .openAdInspector,
                  ),
              ],
            ),
            const _Footer(),
          ],
        ),
      ),
    );
  }

  static Future<void> _pickDefaultMode(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final current = ref.read(settingsProvider).defaultMode;
    final mode = await showLmBottomSheet<MeasurementType>(
      context: context,
      useRootNavigator: true,
      builder: (context) => _DefaultModeSheet(current: current),
    );
    if (mode != null) {
      await ref.read(settingsControllerProvider.notifier).setDefaultMode(mode);
    }
  }

  static Future<void> _privacyChoices(WidgetRef ref) async {
    await ref.read(consentServiceProvider).showPrivacyOptions();
    ref.invalidate(privacyOptionsRequiredProvider);
  }

  static Future<void> _sendFeedback(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final controller = ref.read(settingsControllerProvider.notifier);
    final ok = await controller.sendFeedback(
      subject: l10n.feedbackSubject,
      appName: l10n.appTitle,
      localeTag: Localizations.localeOf(context).toLanguageTag(),
    );
    if (!ok) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              l10n.feedbackNoEmailApp(
                ref.read(settingsControllerProvider).supportEmail,
              ),
            ),
          ),
        );
    }
  }

  static Future<void> _open(
    BuildContext context,
    Future<bool> Function() open,
  ) async {
    final text = context.l10n.linkOpenFailed;
    final messenger = ScaffoldMessenger.of(context);
    if (!await open()) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(text)));
    }
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: LmSpacing.s12),
      child: Row(
        children: [
          Icon(Icons.location_on_rounded, size: 28, color: colors.brandPrimary),
          const SizedBox(width: LmSpacing.s8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.screenSettings,
                    style: LmTypography.titleScreen.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  l10n.settingsSubtitle,
                  style: LmTypography.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Premium entry (`design.md` §5.10 item 3): the offer for free users,
/// "Premium active · Manage subscription" for subscribers.
class _PremiumCard extends ConsumerWidget {
  const _PremiumCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final status = ref.watch(premiumProvider);
    final title = status.isPremium
        ? (status.isLifetime ? l10n.premiumActiveLifetime : l10n.premiumActive)
        : l10n.settingsPremiumTitle;
    final subtitle = status.isPremium
        ? (status.isLifetime ? null : l10n.settingsManageSubscription)
        : l10n.settingsPremiumSubtitle;
    final onTap = switch (status) {
      PremiumStatus(isPremium: false) => () => unawaited(
        PremiumFlows.openPaywall(context, PaywallSource.settings),
      ),
      PremiumStatus(isLifetime: true) => null,
      _ => () => unawaited(openManageSubscription(ref, status)),
    };
    return Semantics(
      button: onTap != null,
      child: Material(
        color: colors.areaContainer,
        shape: RoundedRectangleBorder(
          borderRadius: LmRadius.mdAll,
          side: BorderSide(color: colors.brandPrimary.withValues(alpha: 0.4)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 72),
            child: Padding(
              padding: const EdgeInsets.all(LmSpacing.s16),
              child: Row(
                children: [
                  Icon(
                    Icons.workspace_premium_rounded,
                    size: 32,
                    color: colors.brandPrimary,
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
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle,
                            style: LmTypography.caption.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (onTap != null)
                    Icon(
                      status.isPremium
                          ? Icons.open_in_new_rounded
                          : Icons.chevron_right_rounded,
                      color: colors.brandPrimary,
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

class _Footer extends ConsumerWidget {
  const _Footer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final info = ref.watch(appInfoProvider).value;
    return Padding(
      padding: const EdgeInsets.only(top: LmSpacing.s32),
      child: Column(
        children: [
          Icon(Icons.location_on_rounded, size: 32, color: colors.brandPrimary),
          const SizedBox(height: LmSpacing.s4),
          Text(
            l10n.appTitle,
            style: LmTypography.titleSection.copyWith(
              color: colors.textPrimary,
            ),
          ),
          if (info != null)
            Text(
              l10n.settingsVersion(info.version, info.build),
              style: LmTypography.caption.copyWith(
                color: colors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}

/// Default Measurement Type: the mode Home selects on launch.
class _DefaultModeSheet extends StatelessWidget {
  const _DefaultModeSheet({required this.current});

  final MeasurementType current;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: LmSpacing.s8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LmSpacing.pageH,
              0,
              LmSpacing.pageH,
              LmSpacing.s4,
            ),
            child: Text(
              l10n.settingsDefaultMode,
              style: LmTypography.titleSection.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LmSpacing.pageH,
              0,
              LmSpacing.pageH,
              LmSpacing.s8,
            ),
            child: Text(
              l10n.settingsDefaultModeHint,
              style: LmTypography.caption.copyWith(color: colors.textSecondary),
            ),
          ),
          RadioGroup<MeasurementType>(
            groupValue: current,
            onChanged: (mode) => Navigator.of(context).pop(mode),
            child: Column(
              children: [
                for (final mode in MeasurementType.values)
                  RadioListTile<MeasurementType>(
                    value: mode,
                    controlAffinity: ListTileControlAffinity.trailing,
                    secondary: Icon(
                      modeIcon(mode),
                      color: ModeColors.of(context, mode).main,
                    ),
                    title: Text(l10n.modeName(mode)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
