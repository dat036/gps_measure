import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/units/land_units.dart';

/// Unit conversion and display-precision rules (`architecture.md` §7.6).
/// Internal values are always meters / m².
abstract final class UnitConverter {
  static double areaTo(double squareMeters, AreaUnit unit) =>
      squareMeters / unit.squareMeters;

  static double areaFrom(double value, AreaUnit unit) =>
      value * unit.squareMeters;

  static double distanceTo(double meters, DistanceUnit unit) =>
      meters / unit.meters;

  static double distanceFrom(double value, DistanceUnit unit) =>
      value * unit.meters;

  /// Decimals for a value already in [unit]: ha/acre always 2; otherwise
  /// < 10 → 2, < 1000 → 1, else 0.
  static int areaDecimals(double value, AreaUnit unit) {
    if (unit == AreaUnit.hectare || unit == AreaUnit.acre) return 2;
    return decimalsFor(value);
  }

  static int distanceDecimals(double value, DistanceUnit unit) =>
      decimalsFor(value);

  static int decimalsFor(double value) {
    final v = value.abs();
    if (v < 10) return 2;
    if (v < 1000) return 1;
    return 0;
  }

  static const double _haThresholdM2 = 10000;
  static const double _acreThresholdFt2 = 43560;

  /// Secondary unit shown under the main result ("12,450 m² / 1.25 ha").
  static AreaUnit? secondaryAreaUnit(double squareMeters, AreaUnit primary) =>
      switch (primary) {
        AreaUnit.squareMeter =>
          squareMeters >= _haThresholdM2 ? AreaUnit.hectare : null,
        AreaUnit.squareFoot =>
          areaTo(squareMeters, AreaUnit.squareFoot) >= _acreThresholdFt2
              ? AreaUnit.acre
              : null,
        AreaUnit.hectare => AreaUnit.squareMeter,
        AreaUnit.acre => AreaUnit.squareFoot,
      };

  /// Secondary distance ("462.8 m / 0.46 km").
  static DistanceUnit secondaryDistanceUnit(DistanceUnit primary) =>
      switch (primary) {
        DistanceUnit.meter => DistanceUnit.kilometer,
        DistanceUnit.kilometer => DistanceUnit.meter,
        DistanceUnit.foot => DistanceUnit.mile,
        DistanceUnit.mile => DistanceUnit.foot,
      };
}
