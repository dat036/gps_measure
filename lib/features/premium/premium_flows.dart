import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/widgets/lm_dialog.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/features/premium/map_style_unlock.dart';
import 'package:gps_measurement/services/ads/rewarded_manager.dart';

enum _MapUnlock { cancel, watchAd, premium }

/// Temporarily off (2026-10-19): Premium map styles can only be bought, the
/// "watch an ad to unlock" path is hidden. Flip to true to bring it back.
const bool _mapStyleRewardEnabled = false;

/// What opened the paywall (analytics `paywall_view{source}`).
abstract final class PaywallSource {
  static const String saveLimit = 'save_limit';
  static const String photoLimit = 'photo_limit';
  static const String mapStyle = 'map_style';
  static const String exportKml = 'export_kml';
  static const String exportPdf = 'export_pdf';
  static const String settings = 'settings';

  /// First screen of the 2nd launch.
  static const String startup = 'startup';
}

abstract final class PremiumFlows {
  /// Opens the paywall; true when the user is premium afterwards (bought
  /// or restored), so the blocked action can run again.
  // TODO(phase-10): analytics paywall_trigger{reason: source}.
  static Future<bool> openPaywall(BuildContext context, String source) async =>
      await context.push<bool>(Routes.paywallFrom(source)) ?? false;

  static String projectUnlockKey(String id) => 'reward_project_v1_$id';

  /// One completed reward opens one project, including its later Save.
  static Future<bool> unlockProject(
    BuildContext context,
    WidgetRef ref, [
    String? measurementId,
  ]) async {
    final l10n = context.l10n;
    final choice = await showLmDialog<_MapUnlock>(
      context,
      title: l10n.projectLimitTitle,
      message: l10n.projectLimitMessage,
      actions: [
        LmDialogAction(label: l10n.actionNotNow, value: _MapUnlock.cancel),
        LmDialogAction(label: l10n.exportWatchAd, value: _MapUnlock.watchAd),
        LmDialogAction(
          label: l10n.premiumPromptUpgrade,
          value: _MapUnlock.premium,
          style: LmDialogActionStyle.primary,
        ),
      ],
    );
    if (!context.mounted) return false;
    if (choice == _MapUnlock.premium) {
      return openPaywall(context, PaywallSource.saveLimit);
    }
    if (choice != _MapUnlock.watchAd) return false;
    final navigator = Navigator.of(context, rootNavigator: true);
    final manager = ref.read(rewardedManagerProvider);
    final prefs = ref.read(sharedPreferencesProvider);
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: LmSpacing.s16),
                Flexible(child: Text(l10n.exportLoadingAd)),
              ],
            ),
          ),
        ),
      ),
    );
    RewardOutcome outcome;
    try {
      outcome = await manager.show();
    } finally {
      if (navigator.mounted) navigator.pop();
    }
    if (!context.mounted) return false;
    if (outcome != RewardOutcome.earned) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.projectRewardRequired),
        ),
      );
      return false;
    }
    if (measurementId != null) {
      return prefs.setBool(projectUnlockKey(measurementId), true);
    }
    return true;
  }

  /// A free user picked a Premium map style. While [_mapStyleRewardEnabled]
  /// is off (current setting) this goes straight to the paywall — no popup,
  /// no rewarded ad. True when the user is premium afterwards.
  ///
  /// With the reward on, a popup offers to watch a rewarded ad (the style
  /// then stays open until the app is closed) or to upgrade. [styleLabel] is
  /// the style's name. True when the style may be used now (ad watched, or
  /// Premium bought).
  ///
  /// As for the KML export, no ad available (no fill, offline) opens the
  /// style anyway: the user asked for the ad and is not punished for our
  /// missing inventory. Closing the ad early does not.
  static Future<bool> unlockMapStyle(
    BuildContext context,
    WidgetRef ref, {
    required MapStyle style,
    required String styleLabel,
  }) async {
    if (!_mapStyleRewardEnabled) {
      return openPaywall(context, PaywallSource.mapStyle);
    }
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context, rootNavigator: true);
    final choice = await showLmDialog<_MapUnlock>(
      context,
      title: l10n.premiumPromptTitle,
      message: l10n.premiumPromptMapStyleReward(styleLabel),
      actions: [
        LmDialogAction(label: l10n.actionNotNow, value: _MapUnlock.cancel),
        LmDialogAction(label: l10n.exportWatchAd, value: _MapUnlock.watchAd),
        LmDialogAction(
          label: l10n.premiumPromptUpgrade,
          value: _MapUnlock.premium,
          style: LmDialogActionStyle.primary,
        ),
      ],
    );
    if (!context.mounted) return false;
    switch (choice) {
      case _MapUnlock.watchAd:
        // The ad may take a few seconds to load: show that something happens.
        unawaited(
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) => PopScope(
              canPop: false,
              child: AlertDialog(
                content: Row(
                  children: [
                    const SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                    const SizedBox(width: LmSpacing.s16),
                    Flexible(child: Text(l10n.exportLoadingAd)),
                  ],
                ),
              ),
            ),
          ),
        );
        final reward = await ref.read(rewardedManagerProvider).show();
        // The loading dialog is on top of everything else.
        navigator.pop();
        if (reward == RewardOutcome.dismissed) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(l10n.mapStyleAdDismissed)));
          return false;
        }
        ref.read(unlockedMapStylesProvider.notifier).unlock(style);
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(l10n.mapStyleUnlocked(styleLabel))),
          );
        return true;
      case _MapUnlock.premium:
        return openPaywall(context, PaywallSource.mapStyle);
      case _MapUnlock.cancel || null:
        return false;
    }
  }

  /// "This is a Premium feature" popup; "Upgrade" goes straight to the
  /// paywall. True when the user is premium afterwards.
  static Future<bool> promptUpgrade(
    BuildContext context, {
    required String message,
    required String source,
  }) async {
    final l10n = context.l10n;
    final upgrade = await showLmConfirm(
      context,
      title: l10n.premiumPromptTitle,
      message: message,
      confirmLabel: l10n.premiumPromptUpgrade,
      cancelLabel: l10n.actionNotNow,
    );
    if (!upgrade || !context.mounted) return false;
    return openPaywall(context, source);
  }
}
