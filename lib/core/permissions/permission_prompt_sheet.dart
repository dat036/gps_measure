import 'package:flutter/material.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/widgets/lm_bottom_sheet.dart';
import 'package:gps_measurement/core/widgets/primary_cta.dart';

/// Pre-prompt before a system permission dialog (`design.md` §5.16):
/// illustration, title, why, **Continue** (or **Open Settings** when the
/// permission is blocked) and "Not now". Returns true on the main action.
/// Used through `PermissionFlows`.
Future<bool> showPermissionPromptSheet(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String message,
  bool blocked = false,
}) async {
  final result = await showLmBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (context) => PermissionPromptSheet(
      icon: icon,
      title: title,
      message: message,
      blocked: blocked,
    ),
  );
  return result ?? false;
}

class PermissionPromptSheet extends StatelessWidget {
  const PermissionPromptSheet({
    required this.icon,
    required this.title,
    required this.message,
    this.blocked = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;

  /// Denied for good: the action opens system Settings.
  final bool blocked;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        LmSpacing.pageH,
        LmSpacing.s8,
        LmSpacing.pageH,
        LmSpacing.s16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.areaContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: colors.brandPrimary),
            ),
          ),
          const SizedBox(height: LmSpacing.s16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: LmTypography.titleScreen.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: LmSpacing.s8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: LmTypography.bodyMd.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: LmSpacing.s24),
          PrimaryCta(
            label: blocked ? l10n.actionOpenSettings : l10n.actionContinue,
            onPressed: () => Navigator.of(context).pop(true),
          ),
          const SizedBox(height: LmSpacing.s8),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: colors.textSecondary,
              minimumSize: const Size.fromHeight(48),
            ),
            child: Text(l10n.actionNotNow),
          ),
        ],
      ),
    );
  }
}
