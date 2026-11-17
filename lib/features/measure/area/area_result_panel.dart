import 'package:flutter/material.dart';
import 'package:gps_measurement/core/format/unit_formatter.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/widgets/unit_chips.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';
import 'package:gps_measurement/features/measure/common/animated_number.dart';

/// AREA | PERIMETER columns + unit chips (`design.md` §5.2).
class AreaResultPanel extends StatelessWidget {
  const AreaResultPanel({
    required this.stats,
    required this.areaUnit,
    required this.distanceUnit,
    required this.onAreaUnitChanged,
    this.showSecondary = true,
    super.key,
  });

  final MeasurementStats stats;
  final AreaUnit areaUnit;
  final DistanceUnit distanceUnit;
  final bool showSecondary;
  final ValueChanged<AreaUnit> onAreaUnitChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final locale = Localizations.localeOf(context).toString();
    final area = stats.areaM2;
    final perimeter = stats.perimeterM;

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
                  child: _ResultColumn(
                    label: l10n.resultArea,
                    value: area,
                    format: (v) => UnitFormatter.area(v, areaUnit, locale),
                    secondary: area == null
                        ? null
                        : UnitFormatter.areaWithSecondary(
                            area,
                            areaUnit,
                            locale,
                            secondary: showSecondary,
                          ).secondary,
                  ),
                ),
                VerticalDivider(width: LmSpacing.s32, color: colors.divider),
                Expanded(
                  child: _ResultColumn(
                    label: l10n.resultPerimeter,
                    value: perimeter,
                    format: (v) =>
                        UnitFormatter.distance(v, distanceUnit, locale),
                    secondary: perimeter == null
                        ? null
                        : UnitFormatter.distanceWithSecondary(
                            perimeter,
                            distanceUnit,
                            locale,
                            secondary: showSecondary,
                          ).secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: LmSpacing.s8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
          child: Text(
            area == null
                ? l10n.resultAreaNeedsPoints
                : l10n.resultPointCount(stats.pointCount),
            style: LmTypography.caption.copyWith(color: colors.textSecondary),
          ),
        ),
        const SizedBox(height: LmSpacing.s12),
        UnitChips<AreaUnit>(
          units: AreaUnit.values,
          selected: areaUnit,
          labelOf: UnitFormatter.areaSymbol,
          onSelected: onAreaUnitChanged,
        ),
      ],
    );
  }
}

class _ResultColumn extends StatelessWidget {
  const _ResultColumn({
    required this.label,
    required this.value,
    required this.format,
    required this.secondary,
  });

  final String label;
  final double? value;
  final String Function(double) format;
  final String? secondary;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    final numberStyle = LmTypography.displayResult.copyWith(
      color: colors.textPrimary,
    );
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
              style: LmTypography.labelCaps.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: LmSpacing.s4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: value == null
                ? Text('—', style: numberStyle)
                : AnimatedNumber(
                    value: value!,
                    format: format,
                    style: numberStyle,
                  ),
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
