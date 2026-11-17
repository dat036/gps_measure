import 'package:flutter/material.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_shadows.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';

/// Actions for the selected point (`design.md` §5.2), shown as a bar above
/// the toolbar: "Point 3 · 📷 Photo · 🗑 Delete · Done".
///
/// Anchored above the toolbar rather than next to the marker: following the
/// marker would need a platform call per camera frame.
class PointActionsPopup extends StatelessWidget {
  const PointActionsPopup({
    required this.pointNumber,
    required this.onDelete,
    required this.onDone,
    this.onPhoto,
    super.key,
  });

  /// 1-based.
  final int pointNumber;
  final VoidCallback onDelete;
  final VoidCallback onDone;

  /// Adds a photo attached to this point; hidden when null.
  final VoidCallback? onPhoto;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    // Scales down rather than overflowing with long translations.
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.only(
          left: LmSpacing.s16,
          right: LmSpacing.s4,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceCard,
          borderRadius: LmRadius.fullAll,
          boxShadow: LmShadows.float,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.pointLabel(pointNumber),
              style: LmTypography.bodyMd.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(width: LmSpacing.s8),
            if (onPhoto != null)
              IconButton(
                tooltip: l10n.pointPhoto,
                onPressed: onPhoto,
                icon: const Icon(Icons.photo_camera_outlined, size: 22),
                color: colors.textPrimary,
              ),
            TextButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
              label: Text(l10n.pointDelete),
              style: TextButton.styleFrom(foregroundColor: colors.dangerMain),
            ),
            TextButton(
              onPressed: onDone,
              style: TextButton.styleFrom(
                foregroundColor: colors.textSecondary,
              ),
              child: Text(l10n.pointDeselect),
            ),
          ],
        ),
      ),
    );
  }
}
