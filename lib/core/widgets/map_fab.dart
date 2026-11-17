import 'package:flutter/material.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_shadows.dart';

/// Round white button floating over the map (`design.md` §2.3).
class MapFab extends StatelessWidget {
  const MapFab({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.active = false,
    this.activeColor,
    this.large = false,
    super.key,
  });

  final IconData icon;

  /// Also the accessibility label.
  final String tooltip;
  final VoidCallback? onPressed;

  /// E.g. auto-follow on: the icon takes [activeColor] (mode color).
  final bool active;
  final Color? activeColor;

  /// 56dp variant used for the Camera button.
  final bool large;

  /// Gap between stacked FABs and from the screen edge.
  static const double spacing = 12;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    final size = large ? 56.0 : 48.0;
    final enabled = onPressed != null;
    final iconColor = !enabled
        ? colors.textTertiary
        : active
        ? (activeColor ?? colors.brandPrimary)
        : colors.textPrimary;

    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: tooltip,
        excludeSemantics: true,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: LmShadows.float,
          ),
          child: Material(
            color: colors.surfaceCard,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              child: Icon(icon, size: large ? 24 : 22, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}
