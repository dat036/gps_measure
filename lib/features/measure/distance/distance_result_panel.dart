import 'package:flutter/material.dart';
import 'package:gps_measurement/core/format/unit_formatter.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/widgets/unit_chips.dart';
import 'package:gps_measurement/domain/geo/geo_calculator.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';
import 'package:gps_measurement/features/measure/common/animated_number.dart';

/// DISTANCE result, segment count, unit chips and the per-segment list
/// ("A → B  210 m") visible when the sheet is expanded (`design.md` §5.3).
class DistanceResultPanel extends StatelessWidget {
  const DistanceResultPanel({
    required this.stats,
    required this.points,
    required this.distanceUnit,
    required this.onDistanceUnitChanged,
    this.showSecondary = true,
    super.key,
  });

  final MeasurementStats stats;
  final List<MeasurePoint> points;
  final DistanceUnit distanceUnit;
  final bool showSecondary;
  final ValueChanged<DistanceUnit> onDistanceUnitChanged;

  /// A, B, … Z, AA, AB … — labels of points in the segment list.
  static String pointLetter(int index) {
    var n = index;
    var label = '';
    do {
      label = String.fromCharCode(65 + n % 26) + label;
      n = n ~/ 26 - 1;
    } while (n >= 0);
    return label;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final locale = Localizations.localeOf(context).toString();
    final distance = stats.distanceM;
    final segments = GeoCalculator.segmentLengths([
      for (final p in points) p.position,
    ]);
    final numberStyle = LmTypography.displayResult.copyWith(
      color: colors.textPrimary,
    );
    String fmt(double m) => UnitFormatter.distance(m, distanceUnit, locale);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
          child: Semantics(
            container: true,
            label: l10n.resultDistance,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // The Semantics label above already says it (no "Area, AREA").
                ExcludeSemantics(
                  child: Text(
                    l10n.resultDistance.toUpperCase(),
                    style: LmTypography.labelCaps.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: LmSpacing.s4),
                if (distance == null)
                  Text('—', style: numberStyle)
                else
                  AnimatedNumber(
                    value: distance,
                    format: fmt,
                    style: numberStyle,
                  ),
                if (distance != null && showSecondary)
                  Text(
                    UnitFormatter.distanceWithSecondary(
                      distance,
                      distanceUnit,
                      locale,
                    ).secondary!,
                    style: LmTypography.resultSecondary.copyWith(
                      color: colors.textSecondary,
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
            distance == null
                ? l10n.resultDistanceNeedsPoints
                : l10n.resultSegmentCount(segments.length),
            style: LmTypography.caption.copyWith(color: colors.textSecondary),
          ),
        ),
        const SizedBox(height: LmSpacing.s12),
        UnitChips<DistanceUnit>(
          units: DistanceUnit.values,
          selected: distanceUnit,
          labelOf: UnitFormatter.distanceSymbol,
          onSelected: onDistanceUnitChanged,
          mode: MeasurementType.distance,
        ),
        if (segments.isNotEmpty) ...[
          const SizedBox(height: LmSpacing.s16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
            child: Text(
              l10n.segmentsTitle,
              style: LmTypography.titleSection.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: LmSpacing.s4),
          for (final (i, length) in segments.indexed)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: LmSpacing.pageH,
                vertical: LmSpacing.s8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${pointLetter(i)} → ${pointLetter(i + 1)}',
                      style: LmTypography.bodyMd.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    fmt(length),
                    style: LmTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFeatures: LmTypography.tabular,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}
