import 'package:flutter/material.dart';
import 'package:gps_measurement/core/format/duration_formatter.dart';
import 'package:gps_measurement/core/format/unit_formatter.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_shadows.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';
import 'package:gps_measurement/domain/units/unit_converter.dart';

/// One cell of the result card.
typedef ResultItem = ({String label, String value, String? secondary});

/// Result card (`design.md` §5.8): 2-column grid, content per type —
/// Area: Area, Perimeter, Points · Distance: Distance, Points, Segments ·
/// Walk: Distance, Duration, Area, Avg pace.
class ResultGrid extends StatelessWidget {
  const ResultGrid({
    required this.type,
    required this.stats,
    required this.areaUnit,
    required this.distanceUnit,
    this.showSecondary = true,
    this.landValue,
    super.key,
  });

  final MeasurementType type;
  final MeasurementStats stats;
  final AreaUnit areaUnit;
  final DistanceUnit distanceUnit;
  final bool showSecondary;

  /// "1,87 tỷ" + "50 triệu / sào": adds a VALUE cell (`design.md` §5.8).
  final ({String value, String rate})? landValue;

  static List<ResultItem> itemsFor(
    BuildContext context, {
    required MeasurementType type,
    required MeasurementStats stats,
    required AreaUnit areaUnit,
    required DistanceUnit distanceUnit,
    bool showSecondary = true,
    ({String value, String rate})? landValue,
  }) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    const dash = '—';

    ResultItem area() {
      final a = stats.areaM2;
      if (a == null) {
        return (label: l10n.resultArea, value: dash, secondary: null);
      }
      final f = UnitFormatter.areaWithSecondary(
        a,
        areaUnit,
        locale,
        secondary: showSecondary,
      );
      return (label: l10n.resultArea, value: f.primary, secondary: f.secondary);
    }

    ResultItem distance(String label, double? meters) {
      if (meters == null) return (label: label, value: dash, secondary: null);
      final f = UnitFormatter.distanceWithSecondary(
        meters,
        distanceUnit,
        locale,
        secondary: showSecondary,
      );
      return (label: label, value: f.primary, secondary: f.secondary);
    }

    ResultItem count(String label, int n) =>
        (label: label, value: '$n', secondary: null);

    final value = landValue == null
        ? null
        : (
            label: l10n.resultValue,
            value: landValue.value,
            secondary: landValue.rate,
          );
    return [
      ...switch (type) {
        MeasurementType.area => [
          area(),
          distance(l10n.resultPerimeter, stats.perimeterM),
          count(l10n.resultPoints, stats.pointCount),
        ],
        MeasurementType.distance => [
          distance(l10n.resultDistance, stats.distanceM),
          count(l10n.resultPoints, stats.pointCount),
          count(
            l10n.resultSegments,
            stats.pointCount < 2 ? 0 : stats.pointCount - 1,
          ),
        ],
        MeasurementType.walk => [
          distance(l10n.resultDistance, stats.distanceM),
          (
            label: l10n.resultDuration,
            value: DurationFormatter.hms(stats.durationSec ?? 0),
            secondary: null,
          ),
          area(),
          (
            label: l10n.resultAvgPace,
            value: pace(context, stats, distanceUnit) ?? dash,
            secondary: null,
          ),
        ],
      },
      ?value,
    ];
  }

  /// "12:30 /km" (or /mi for imperial units); null without enough data.
  static String? pace(
    BuildContext context,
    MeasurementStats stats,
    DistanceUnit distanceUnit,
  ) {
    final meters = stats.distanceM;
    final seconds = stats.durationSec;
    if (meters == null || seconds == null || meters < 10 || seconds <= 0) {
      return null;
    }
    final imperial =
        distanceUnit == DistanceUnit.foot || distanceUnit == DistanceUnit.mile;
    final unit = imperial ? DistanceUnit.mile : DistanceUnit.kilometer;
    final perUnit = seconds / UnitConverter.distanceTo(meters, unit);
    final s = perUnit.round();
    final mmss = '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
    return context.l10n.paceValue(mmss, UnitFormatter.distanceSymbol(unit));
  }

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    final items = itemsFor(
      context,
      type: type,
      stats: stats,
      areaUnit: areaUnit,
      distanceUnit: distanceUnit,
      showSecondary: showSecondary,
      landValue: landValue,
    );
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 2) {
      if (i > 0) rows.add(Divider(height: 1, color: colors.divider));
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _Cell(items[i])),
              VerticalDivider(width: 1, color: colors.divider),
              Expanded(
                child: i + 1 < items.length
                    ? _Cell(items[i + 1])
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: LmRadius.mdAll,
        boxShadow: LmShadows.card,
      ),
      child: Column(children: rows),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(this.item);

  final ResultItem item;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    return Semantics(
      container: true,
      label: item.label,
      child: Padding(
        padding: const EdgeInsets.all(LmSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The Semantics label above already says it (no "Area, AREA").
            ExcludeSemantics(
              child: Text(
                item.label.toUpperCase(),
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
              child: Text(
                item.value,
                maxLines: 1,
                style: LmTypography.displayResultCompact.copyWith(
                  fontSize: 22,
                  height: 28 / 22,
                  color: colors.textPrimary,
                ),
              ),
            ),
            if (item.secondary != null)
              Text(
                item.secondary!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: LmTypography.bodyMd.copyWith(
                  color: colors.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
