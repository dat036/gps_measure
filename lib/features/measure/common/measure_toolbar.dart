import 'package:flutter/material.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_shadows.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/domain/models/enums.dart';

/// Floating toolbar above the result sheet (`design.md` §2.8):
/// `[↶ Undo] [📍] [ ＋ Add Point ] [⬡ Close]` (Distance: `[⟲ Reset]`).
/// A null callback disables its button.
class MeasureToolbar extends StatelessWidget {
  const MeasureToolbar({
    required this.type,
    required this.onUndo,
    required this.onAddAtMyLocation,
    required this.onAddPoint,
    required this.onTrailing,
    this.locating = false,
    super.key,
  });

  final MeasurementType type;
  final VoidCallback? onUndo;
  final VoidCallback? onAddAtMyLocation;
  final VoidCallback? onAddPoint;

  /// Close (Area) or Reset (Distance).
  final VoidCallback? onTrailing;

  /// Waiting for a GPS fix for "add at my location".
  final bool locating;

  static const double height = 52;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final mode = ModeColors.of(context, type);
    final isArea = type == MeasurementType.area;

    Widget iconButton(IconData icon, String tip, VoidCallback? onTap) =>
        IconButton(
          onPressed: onTap,
          tooltip: tip,
          icon: Icon(icon),
          color: colors.textPrimary,
          disabledColor: colors.textTertiary,
          constraints: const BoxConstraints.tightFor(width: 48, height: 48),
        );

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: LmSpacing.s4),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: LmRadius.fullAll,
        boxShadow: LmShadows.float,
      ),
      child: Row(
        children: [
          iconButton(Icons.undo_rounded, l10n.toolbarUndo, onUndo),
          if (locating)
            const SizedBox.square(
              dimension: 48,
              child: Padding(
                padding: EdgeInsets.all(14),
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            )
          else
            iconButton(
              Icons.gps_fixed_rounded,
              l10n.toolbarAddAtMyLocation,
              onAddAtMyLocation,
            ),
          const SizedBox(width: LmSpacing.s4),
          Expanded(
            // 40 dp pill (minimumSize) in a 48 dp touch target: the loose
            // height lets the padded tap target grow around it.
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onAddPoint,
                icon: const Icon(Icons.add_location_alt_rounded, size: 20),
                label: Text(
                  l10n.toolbarAddPoint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: mode.main,
                  foregroundColor: colors.onMode,
                  disabledBackgroundColor: colors.disabledBackground,
                  disabledForegroundColor: colors.disabledForeground,
                  minimumSize: const Size(0, 40),
                  padding: const EdgeInsets.symmetric(
                    horizontal: LmSpacing.s12,
                  ),
                  textStyle: LmTypography.bodyMd.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: LmRadius.fullAll,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: LmSpacing.s4),
          iconButton(
            isArea ? Icons.hexagon_outlined : Icons.restart_alt_rounded,
            isArea ? l10n.toolbarClose : l10n.toolbarReset,
            onTrailing,
          ),
        ],
      ),
    );
  }
}
