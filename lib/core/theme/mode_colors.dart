import 'package:flutter/widgets.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/domain/models/enums.dart';

/// Per-mode colors: CTA, map geometry, selected segment, type chip.
@immutable
class ModeColors {
  const ModeColors({
    required this.main,
    required this.container,
    required this.fill,
  });

  factory ModeColors.of(BuildContext context, MeasurementType type) =>
      ModeColors.from(LmColors.of(context), type);

  factory ModeColors.from(LmColors colors, MeasurementType type) {
    final (main, container) = switch (type) {
      MeasurementType.area => (colors.areaMain, colors.areaContainer),
      MeasurementType.distance => (
        colors.distanceMain,
        colors.distanceContainer,
      ),
      MeasurementType.walk => (colors.walkMain, colors.walkContainer),
    };
    return ModeColors(
      main: main,
      container: container,
      fill: main.withValues(alpha: fillOpacity),
    );
  }

  /// Polygon fill opacity (`area.fill` = main @ 28%).
  static const double fillOpacity = 0.28;

  final Color main;
  final Color container;
  final Color fill;
}
