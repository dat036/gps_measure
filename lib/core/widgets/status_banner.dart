import 'package:flutter/material.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_shadows.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';

enum StatusBannerKind {
  /// GPS ready (green).
  success,

  /// Low accuracy, edges cross (yellow).
  warning,

  /// Location off (red).
  error,

  /// Hints, searching, offline (grey).
  neutral,
}

/// Pill banner over the map (`design.md` §2.15). Place it with 16dp side
/// padding (full width − 32).
class StatusBanner extends StatelessWidget {
  const StatusBanner({
    required this.kind,
    required this.title,
    this.message,
    this.leading,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final StatusBannerKind kind;
  final String title;
  final String? message;

  /// Replaces the default icon (e.g. a spinner or a blinking dot).
  final Widget? leading;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    final (icon, iconColor) = switch (kind) {
      StatusBannerKind.success => (
        Icons.gps_fixed_rounded,
        colors.brandPrimary,
      ),
      StatusBannerKind.warning => (Icons.warning_rounded, colors.warning),
      StatusBannerKind.error => (
        Icons.location_off_rounded,
        colors.dangerMain,
      ),
      StatusBannerKind.neutral => (
        Icons.info_outline_rounded,
        colors.textSecondary,
      ),
    };

    return Semantics(
      liveRegion: true,
      container: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(
          horizontal: LmSpacing.s16,
          vertical: LmSpacing.s8,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: LmRadius.lgAll,
          boxShadow: LmShadows.float,
        ),
        child: Row(
          children: [
            leading ?? Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: LmSpacing.s12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: LmTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  if (message != null)
                    Text(
                      message!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: LmTypography.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(width: LmSpacing.s8),
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: kind == StatusBannerKind.error
                      ? colors.dangerMain
                      : colors.brandPrimary,
                  textStyle: LmTypography.bodyMd.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
