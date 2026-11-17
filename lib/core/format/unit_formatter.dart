import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/units/unit_converter.dart';
import 'package:intl/intl.dart';

/// Primary result text plus optional secondary line ("1.25 ha").
typedef FormattedValue = ({String primary, String? secondary});

/// Formats internal meters / m² for display in the user's unit and locale:
/// `12,450 m²` (en) · `12.450 m²` (vi).
abstract final class UnitFormatter {
  /// Short unit symbols.
  static String areaSymbol(AreaUnit unit) => switch (unit) {
    AreaUnit.squareMeter => 'm²',
    AreaUnit.hectare => 'ha',
    AreaUnit.acre => 'acre',
    AreaUnit.squareFoot => 'ft²',
  };

  static String distanceSymbol(DistanceUnit unit) => switch (unit) {
    DistanceUnit.meter => 'm',
    DistanceUnit.kilometer => 'km',
    DistanceUnit.foot => 'ft',
    DistanceUnit.mile => 'mi',
  };

  static String number(double value, int decimals, String locale) =>
      NumberFormat.decimalPatternDigits(
        locale: locale,
        decimalDigits: decimals,
      ).format(value);

  static String area(double squareMeters, AreaUnit unit, String locale) {
    final v = UnitConverter.areaTo(squareMeters, unit);
    final text = number(v, UnitConverter.areaDecimals(v, unit), locale);
    return '$text ${areaSymbol(unit)}';
  }

  static String distance(double meters, DistanceUnit unit, String locale) {
    final v = UnitConverter.distanceTo(meters, unit);
    final text = number(v, UnitConverter.distanceDecimals(v, unit), locale);
    return '$text ${distanceSymbol(unit)}';
  }

  /// [secondary]: include the automatic secondary unit
  /// (`show_secondary_unit` setting).
  static FormattedValue areaWithSecondary(
    double squareMeters,
    AreaUnit unit,
    String locale, {
    bool secondary = true,
  }) {
    final second = secondary
        ? UnitConverter.secondaryAreaUnit(squareMeters, unit)
        : null;
    return (
      primary: area(squareMeters, unit, locale),
      secondary: second == null ? null : area(squareMeters, second, locale),
    );
  }

  static FormattedValue distanceWithSecondary(
    double meters,
    DistanceUnit unit,
    String locale, {
    bool secondary = true,
  }) {
    return (
      primary: distance(meters, unit, locale),
      secondary: secondary
          ? distance(
              meters,
              UnitConverter.secondaryDistanceUnit(unit),
              locale,
            )
          : null,
    );
  }
}
