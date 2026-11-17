import 'package:flutter/material.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/domain/models/enums.dart';

/// "AREA" / "DISTANCE" / "WALK" chip in the mode color.
class TypeChip extends StatelessWidget {
  const TypeChip({required this.type, super.key});

  final MeasurementType type;

  static String labelOf(BuildContext context, MeasurementType type) {
    final l10n = context.l10n;
    return switch (type) {
      MeasurementType.area => l10n.measurementTypeArea,
      MeasurementType.distance => l10n.measurementTypeDistance,
      MeasurementType.walk => l10n.measurementTypeWalk,
    };
  }

  @override
  Widget build(BuildContext context) {
    final mode = ModeColors.of(context, type);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: LmSpacing.s8,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: mode.container,
        borderRadius: LmRadius.xsAll,
      ),
      child: Text(
        labelOf(context, type).toUpperCase(),
        style: LmTypography.labelCaps.copyWith(
          fontSize: 10,
          height: 1.4,
          color: mode.main,
        ),
      ),
    );
  }
}
