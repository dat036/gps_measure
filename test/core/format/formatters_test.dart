import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/format/date_formatter.dart';
import 'package:gps_measurement/core/format/duration_formatter.dart';
import 'package:gps_measurement/core/format/money_formatter.dart';
import 'package:gps_measurement/core/format/unit_formatter.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('vi');
    await initializeDateFormatting('es');
  });

  group('UnitFormatter', () {
    test('area in en / vi', () {
      expect(
        UnitFormatter.area(12450, AreaUnit.squareMeter, 'en'),
        '12,450 m²',
      );
      expect(
        UnitFormatter.area(12450, AreaUnit.squareMeter, 'vi'),
        '12.450 m²',
      );
      expect(UnitFormatter.area(12450, AreaUnit.hectare, 'en'), '1.25 ha');
      expect(UnitFormatter.area(12450, AreaUnit.hectare, 'vi'), '1,25 ha');
      expect(UnitFormatter.area(12500, AreaUnit.acre, 'vi'), '3,09 acre');
    });

    test('distance', () {
      expect(
        UnitFormatter.distance(462.8, DistanceUnit.meter, 'en'),
        '462.8 m',
      );
      expect(
        UnitFormatter.distance(462.8, DistanceUnit.kilometer, 'en'),
        '0.46 km',
      );
      expect(UnitFormatter.distance(860, DistanceUnit.foot, 'en'), '2,822 ft');
    });

    test('with secondary', () {
      expect(
        UnitFormatter.areaWithSecondary(12450, AreaUnit.squareMeter, 'en'),
        (primary: '12,450 m²', secondary: '1.25 ha'),
      );
      expect(
        UnitFormatter.areaWithSecondary(5000, AreaUnit.squareMeter, 'en'),
        (primary: '5,000 m²', secondary: null),
      );
      expect(
        UnitFormatter.areaWithSecondary(5000, AreaUnit.squareMeter, 'vi_VN'),
        (primary: '5.000 m²', secondary: null),
      );
      expect(
        UnitFormatter.areaWithSecondary(
          12450,
          AreaUnit.squareMeter,
          'en',
          secondary: false,
        ),
        (primary: '12,450 m²', secondary: null),
      );
      expect(
        UnitFormatter.distanceWithSecondary(462.8, DistanceUnit.meter, 'en'),
        (primary: '462.8 m', secondary: '0.46 km'),
      );
      expect(
        UnitFormatter.distanceWithSecondary(
          462.8,
          DistanceUnit.meter,
          'en',
          secondary: false,
        ).secondary,
        isNull,
      );
    });

    test('every unit has a symbol', () {
      for (final u in AreaUnit.values) {
        expect(UnitFormatter.areaSymbol(u), isNotEmpty);
      }
      for (final u in DistanceUnit.values) {
        expect(UnitFormatter.distanceSymbol(u), isNotEmpty);
      }
    });
  });

  test('DurationFormatter', () {
    expect(DurationFormatter.hms(0), '00:00:00');
    expect(DurationFormatter.hms(756), '00:12:36');
    expect(DurationFormatter.hms(360000), '100:00:00');
    expect(DurationFormatter.hms(-5), '00:00:00');
    expect(
      DurationFormatter.fromDuration(const Duration(hours: 1, seconds: 2)),
      '01:00:02',
    );
  });

  group('DateFormatter', () {
    // Local time: build a local DateTime so the test is timezone-proof.
    final value = DateTime(2026, 9, 22, 10, 24);

    test('en / vi formats', () {
      expect(DateFormatter.dateTime(value, 'en'), 'Sep 22, 2026 · 10:24');
      expect(DateFormatter.dateTime(value, 'vi'), '22/09/2026 · 10:24');
      expect(DateFormatter.date(value, 'en_US'), 'Sep 22, 2026');
    });

    test('UTC values are shown in local time', () {
      final utc = value.toUtc();
      expect(DateFormatter.dateTime(utc, 'vi'), '22/09/2026 · 10:24');
    });

    test('other locales use the locale medium date', () {
      expect(DateFormatter.date(value, 'es'), contains('2026'));
    });
  });

  group('MoneyFormatter', () {
    test('Vietnamese words for VND', () {
      expect(MoneyFormatter.format(1870000000, locale: 'vi'), '1,87 tỷ');
      expect(MoneyFormatter.format(2000000000, locale: 'vi'), '2 tỷ');
      expect(MoneyFormatter.format(350000000, locale: 'vi'), '350 triệu');
      expect(MoneyFormatter.format(1500000, locale: 'vi'), '1,5 triệu');
      expect(MoneyFormatter.format(850000, locale: 'vi'), '850.000 đ');
    });

    test('other locales use compact currency', () {
      expect(
        MoneyFormatter.format(1870000000, locale: 'en', currency: 'USD'),
        r'$1.87B',
      );
      expect(
        MoneyFormatter.format(350000000, locale: 'en'),
        contains('350'),
      );
    });
  });
}
