import 'package:flutter/material.dart';
import 'package:gps_measurement/core/format/duration_formatter.dart';
import 'package:gps_measurement/core/format/unit_formatter.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/core/widgets/unit_chips.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';
import 'package:gps_measurement/features/measure/common/animated_number.dart';

/// DURATION | DISTANCE | AREA while recording/paused, and the result after
/// Finish (`design.md` §5.5): area only when the track returned to its
/// start, otherwise "Route not closed — distance only".
class WalkResultPanel extends StatelessWidget {
  const WalkResultPanel({
    required this.stats,
    required this.elapsedSec,
    required this.runState,
    required this.areaUnit,
    required this.distanceUnit,
    required this.onAreaUnitChanged,
    required this.onDistanceUnitChanged,
    this.showSecondary = true,
    super.key,
  });

  final MeasurementStats stats;
  final int elapsedSec;
  final WalkRunState runState;
  final AreaUnit areaUnit;
  final DistanceUnit distanceUnit;
  final bool showSecondary;
  final ValueChanged<AreaUnit> onAreaUnitChanged;
  final ValueChanged<DistanceUnit> onDistanceUnitChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final locale = Localizations.localeOf(context).toString();
    final distance = stats.distanceM ?? 0;
    final area = stats.areaM2;
    final finished = runState == WalkRunState.finished;

    final (caption, captionColor, captionIcon) = switch ((
      finished,
      stats.isClosed,
    )) {
      (false, true) => (
        l10n.walkCloseToStart,
        ModeColors.of(context, MeasurementType.area).main,
        Icons.check_circle_rounded,
      ),
      (true, false) => (
        l10n.walkNotClosed,
        colors.textSecondary,
        Icons.info_outline_rounded,
      ),
      (false, false) when stats.pointCount >= 2 => (
        l10n.walkKeepWalking,
        colors.textSecondary,
        null,
      ),
      _ => (
        l10n.resultPointCount(stats.pointCount),
        colors.textSecondary,
        null,
      ),
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _Column(
                    label: l10n.resultDuration,
                    child: Text(
                      DurationFormatter.hms(elapsedSec),
                      maxLines: 1,
                      style: _numberStyle(colors),
                    ),
                  ),
                ),
                VerticalDivider(width: LmSpacing.s24, color: colors.divider),
                Expanded(
                  child: _Column(
                    label: l10n.resultDistance,
                    secondary: showSecondary
                        ? UnitFormatter.distanceWithSecondary(
                            distance,
                            distanceUnit,
                            locale,
                          ).secondary
                        : null,
                    child: AnimatedNumber(
                      value: distance,
                      format: (v) =>
                          UnitFormatter.distance(v, distanceUnit, locale),
                      style: _numberStyle(colors),
                    ),
                  ),
                ),
                VerticalDivider(width: LmSpacing.s24, color: colors.divider),
                Expanded(
                  child: _Column(
                    label: l10n.resultArea,
                    secondary: area == null
                        ? null
                        : UnitFormatter.areaWithSecondary(
                            area,
                            areaUnit,
                            locale,
                            secondary: showSecondary,
                          ).secondary,
                    child: area == null
                        ? Text('—', style: _numberStyle(colors))
                        : AnimatedNumber(
                            value: area,
                            format: (v) =>
                                UnitFormatter.area(v, areaUnit, locale),
                            style: _numberStyle(colors),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: LmSpacing.s12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
          child: Row(
            children: [
              if (captionIcon != null) ...[
                Icon(captionIcon, size: 16, color: captionColor),
                const SizedBox(width: LmSpacing.s4),
              ],
              Expanded(
                child: Text(
                  caption,
                  style: LmTypography.caption.copyWith(color: captionColor),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: LmSpacing.s12),
        UnitChips<DistanceUnit>(
          units: DistanceUnit.values,
          selected: distanceUnit,
          labelOf: UnitFormatter.distanceSymbol,
          onSelected: onDistanceUnitChanged,
          mode: MeasurementType.walk,
        ),
        if (area != null) ...[
          const SizedBox(height: LmSpacing.s4),
          UnitChips<AreaUnit>(
            units: AreaUnit.values,
            selected: areaUnit,
            labelOf: UnitFormatter.areaSymbol,
            onSelected: onAreaUnitChanged,
            mode: MeasurementType.walk,
          ),
        ],
      ],
    );
  }

  static TextStyle _numberStyle(LmColors colors) =>
      LmTypography.displayResultCompact.copyWith(color: colors.textPrimary);
}

class _Column extends StatelessWidget {
  const _Column({required this.label, required this.child, this.secondary});

  final String label;
  final Widget child;
  final String? secondary;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    return Semantics(
      container: true,
      label: label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // The Semantics label above already says it (no "Area, AREA").
          ExcludeSemantics(
            child: Text(
              label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: LmTypography.labelCaps.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: LmSpacing.s4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: child,
          ),
          if (secondary != null)
            Text(
              secondary!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: LmTypography.resultSecondary.copyWith(
                color: colors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}
