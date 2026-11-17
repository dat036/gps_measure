import 'package:flutter/material.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/domain/models/enums.dart';

enum PrimaryCtaVariant {
  area,
  distance,
  walk,
  danger,

  /// Pause: light red background, red label.
  tonalDanger
  ;

  static PrimaryCtaVariant forMode(MeasurementType type) => switch (type) {
    MeasurementType.area => area,
    MeasurementType.distance => distance,
    MeasurementType.walk => walk,
  };
}

/// Full-width 56dp call-to-action (`design.md` §2.2).
///
/// Disabled when [onPressed] is null. While [loading], taps are ignored and
/// the icon is replaced by a spinner.
class PrimaryCta extends StatelessWidget {
  const PrimaryCta({
    required this.label,
    required this.onPressed,
    this.variant = PrimaryCtaVariant.area,
    this.icon,
    this.showChevron = false,
    this.loading = false,
    this.expand = true,
    this.buttonHeight = height,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final PrimaryCtaVariant variant;
  final IconData? icon;
  final bool showChevron;
  final bool loading;

  /// Full width when true; otherwise sized to content (e.g. Pause | Finish).
  final bool expand;

  static const double height = 56;

  /// Defaults to [height]; a screen that sits next to a native ad can ask
  /// for a slimmer button.
  final double buttonHeight;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    final (background, foreground) = _colors(context, colors);
    final enabled = onPressed != null;
    final bg = enabled ? background : colors.disabledBackground;
    final fg = enabled ? foreground : colors.disabledForeground;

    Widget? leading;
    if (loading) {
      leading = SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator(strokeWidth: 2.5, color: fg),
      );
    } else if (icon != null) {
      leading = Icon(icon, size: 22, color: fg);
    }

    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[leading, const SizedBox(width: LmSpacing.s8)],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: LmTypography.bodyLg.copyWith(
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ),
        if (showChevron) ...[
          const SizedBox(width: LmSpacing.s4),
          Icon(Icons.chevron_right_rounded, size: 22, color: fg),
        ],
      ],
    );

    return Semantics(
      button: true,
      enabled: enabled,
      child: SizedBox(
        height: buttonHeight,
        width: expand ? double.infinity : null,
        child: Material(
          color: bg,
          shape: const RoundedRectangleBorder(borderRadius: LmRadius.mdAll),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: loading ? null : onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: LmSpacing.s20),
              child: content,
            ),
          ),
        ),
      ),
    );
  }

  (Color, Color) _colors(BuildContext context, LmColors colors) {
    return switch (variant) {
      PrimaryCtaVariant.area => (
        ModeColors.of(context, MeasurementType.area).main,
        colors.onMode,
      ),
      PrimaryCtaVariant.distance => (
        ModeColors.of(context, MeasurementType.distance).main,
        colors.onMode,
      ),
      PrimaryCtaVariant.walk => (
        ModeColors.of(context, MeasurementType.walk).main,
        colors.onMode,
      ),
      PrimaryCtaVariant.danger => (colors.dangerMain, colors.onMode),
      PrimaryCtaVariant.tonalDanger => (
        colors.dangerContainer,
        colors.dangerMain,
      ),
    };
  }
}
