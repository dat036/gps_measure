import 'package:flutter/material.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';

/// Empty / no-result placeholder.
///
/// [EmptyState.compact] is the single-row variant (≤ 96dp) used under
/// "Recent Measurements" on Home.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    this.message,
    this.icon = Icons.pentagon_outlined,
    this.illustration,
    this.action,
    super.key,
  }) : compact = false;

  const EmptyState.compact({
    required this.title,
    this.message,
    this.icon = Icons.pentagon_outlined,
    super.key,
  }) : compact = true,
       illustration = null,
       action = null;

  final String title;
  final String? message;
  final IconData icon;

  /// Replaces [icon] in the full variant.
  final Widget? illustration;

  /// Usually a `PrimaryCta`.
  final Widget? action;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    final titleStyle = LmTypography.titleSection.copyWith(
      color: colors.textPrimary,
    );
    final messageStyle = LmTypography.bodyMd.copyWith(
      color: colors.textSecondary,
    );

    if (compact) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 96),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: LmSpacing.s12),
          child: Row(
            children: [
              Icon(icon, size: 32, color: colors.textTertiary),
              const SizedBox(width: LmSpacing.s12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: titleStyle),
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
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(LmSpacing.s32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          illustration ?? Icon(icon, size: 72, color: colors.outlineDashed),
          const SizedBox(height: LmSpacing.s16),
          Text(title, style: titleStyle, textAlign: TextAlign.center),
          if (message != null) ...[
            const SizedBox(height: LmSpacing.s8),
            Text(message!, style: messageStyle, textAlign: TextAlign.center),
          ],
          if (action != null) ...[
            const SizedBox(height: LmSpacing.s24),
            action!,
          ],
        ],
      ),
    );
  }
}
