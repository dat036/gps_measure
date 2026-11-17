import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/units/land_units.dart';
import 'package:gps_measurement/domain/units/unit_converter.dart';

void main() {
  test('area factors (architecture.md §7.6)', () {
    const expected = {
      AreaUnit.squareMeter: 1.0,
      AreaUnit.hectare: 10000.0,
      AreaUnit.acre: 4046.8564224,
      AreaUnit.squareFoot: 0.09290304,
    };
    for (final u in AreaUnit.values) {
      expect(u.squareMeters, expected[u], reason: u.name);
      expect(
        UnitConverter.areaFrom(UnitConverter.areaTo(12450, u), u),
        closeTo(12450, 1e-9),
      );
    }
    expect(UnitConverter.areaTo(12500, AreaUnit.hectare), 1.25);
  });

  test('distance factors', () {
    expect(UnitConverter.distanceTo(1609.344, DistanceUnit.mile), 1);
    expect(UnitConverter.distanceTo(0.3048, DistanceUnit.foot), 1);
    expect(UnitConverter.distanceTo(462.8, DistanceUnit.kilometer), 0.4628);
    expect(UnitConverter.distanceFrom(2, DistanceUnit.kilometer), 2000);
    expect(DistanceUnit.values.where((u) => u.isImperial), [
      DistanceUnit.foot,
      DistanceUnit.mile,
    ]);
  });

  test('imperial area units', () {
    expect(AreaUnit.values.where((u) => u.isImperial), [
      AreaUnit.acre,
      AreaUnit.squareFoot,
    ]);
  });

  test('display decimals', () {
    expect(UnitConverter.areaDecimals(1.25, AreaUnit.hectare), 2);
    expect(UnitConverter.areaDecimals(1250, AreaUnit.acre), 2);
    expect(UnitConverter.areaDecimals(7.5, AreaUnit.squareMeter), 2);
    expect(UnitConverter.areaDecimals(462.8, AreaUnit.squareMeter), 1);
    expect(UnitConverter.areaDecimals(12450, AreaUnit.squareMeter), 0);
    expect(UnitConverter.distanceDecimals(0.46, DistanceUnit.kilometer), 2);
    expect(UnitConverter.distanceDecimals(-462.8, DistanceUnit.meter), 1);
  });

  group('secondary units', () {
    test('metric area', () {
      expect(
        UnitConverter.secondaryAreaUnit(12450, AreaUnit.squareMeter),
        AreaUnit.hectare,
      );
      expect(
        UnitConverter.secondaryAreaUnit(5000, AreaUnit.squareMeter),
        isNull,
      );
      expect(
        UnitConverter.secondaryAreaUnit(5000, AreaUnit.hectare),
        AreaUnit.squareMeter,
      );
    });

    test('imperial area', () {
      // 43,560 ft² = 1 acre ≈ 4046.86 m².
      expect(
        UnitConverter.secondaryAreaUnit(4100, AreaUnit.squareFoot),
        AreaUnit.acre,
      );
      expect(
        UnitConverter.secondaryAreaUnit(4000, AreaUnit.squareFoot),
        isNull,
      );
      expect(
        UnitConverter.secondaryAreaUnit(4000, AreaUnit.acre),
        AreaUnit.squareFoot,
      );
    });

    test('distance', () {
      expect(
        UnitConverter.secondaryDistanceUnit(DistanceUnit.meter),
        DistanceUnit.kilometer,
      );
      expect(
        UnitConverter.secondaryDistanceUnit(DistanceUnit.kilometer),
        DistanceUnit.meter,
      );
      expect(
        UnitConverter.secondaryDistanceUnit(DistanceUnit.foot),
        DistanceUnit.mile,
      );
      expect(
        UnitConverter.secondaryDistanceUnit(DistanceUnit.mile),
        DistanceUnit.foot,
      );
    });
  });
}
