import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/domain/geo/geo_parse.dart';

void main() {
  void expectCoord(String input, double lat, double lng) {
    final q = GeoParse.parse(input);
    expect(q, isA<CoordinateQuery>(), reason: input);
    final p = (q! as CoordinateQuery).point;
    expect(p.lat, closeTo(lat, 1e-5), reason: input);
    expect(p.lng, closeTo(lng, 1e-5), reason: input);
  }

  void expectAddress(String input) {
    expect(
      GeoParse.parse(input),
      GeoQuery.address(input.trim()),
      reason: input,
    );
  }

  test('empty input', () {
    expect(GeoParse.parse(''), isNull);
    expect(GeoParse.parse('   '), isNull);
  });

  group('decimal', () {
    test('comma / space / semicolon separated', () {
      expectCoord('21.0285, 105.8542', 21.0285, 105.8542);
      expectCoord('21.0285,105.8542', 21.0285, 105.8542);
      expectCoord('  21.0285 105.8542 ', 21.0285, 105.8542);
      expectCoord('21.0285; 105.8542', 21.0285, 105.8542);
      expectCoord('-33.8688, 151.2093', -33.8688, 151.2093);
      expectCoord('21, 105', 21, 105);
    });

    test('hemisphere letters', () {
      expectCoord('21.0285N 105.8542E', 21.0285, 105.8542);
      expectCoord('33.8688 S, 70.1 W', -33.8688, -70.1);
      expectCoord('N21.0285 E105.8542', 21.0285, 105.8542);
      expectCoord('21.0285° N, 105.8542° E', 21.0285, 105.8542);
    });

    test('out of range is not a coordinate', () {
      expectAddress('95.0, 105.0');
      expectAddress('21.0, 190.0');
    });
  });

  group('DMS', () {
    test('standard forms', () {
      expectCoord(
        '21°01\'42.6"N 105°51\'15.1"E',
        21 + 1 / 60 + 42.6 / 3600,
        105 + 51 / 60 + 15.1 / 3600,
      );
      expectCoord(
        '21° 1′ 42.6″ N, 105° 51′ 15.1″ E',
        21 + 1 / 60 + 42.6 / 3600,
        105 + 51 / 60 + 15.1 / 3600,
      );
      expectCoord(
        "33°52'07.7''S 151°12'33.5''E",
        -(33 + 52 / 60 + 7.7 / 3600),
        151 + 12 / 60 + 33.5 / 3600,
      );
      expectCoord('10 45 30 N 106 40 0 W', 10.758333, -106.666667);
    });

    test('invalid minutes/seconds', () {
      expectAddress('21°75\'42.6"N 105°51\'15.1"E');
    });
  });

  group('Google Maps links', () {
    test('@lat,lng', () {
      expectCoord(
        'https://www.google.com/maps/@21.0285,105.8542,15z',
        21.0285,
        105.8542,
      );
      expectCoord(
        'https://www.google.com/maps/place/Hoan+Kiem/@21.0287,105.8524,17z/data=x',
        21.0287,
        105.8524,
      );
    });

    test('query parameters', () {
      expectCoord(
        'https://maps.google.com/?q=21.0285,105.8542',
        21.0285,
        105.8542,
      );
      expectCoord(
        'https://maps.google.com/maps?ll=10.77,106.70&z=15',
        10.77,
        106.70,
      );
      expectCoord(
        'https://www.google.com/maps/search/?api=1&query=21.0285%2C105.8542',
        21.0285,
        105.8542,
      );
    });

    test('/search/lat,+lng path', () {
      expectCoord(
        'https://www.google.com/maps/search/21.0285,+105.8542',
        21.0285,
        105.8542,
      );
    });

    test('geo: URI', () {
      expectCoord('geo:21.0285,105.8542?z=15', 21.0285, 105.8542);
    });

    test('short links cannot be resolved offline → address', () {
      expectAddress('https://maps.app.goo.gl/AbCdEf123');
    });
  });

  test('addresses', () {
    expectAddress('Hồ Hoàn Kiếm, Hà Nội');
    expectAddress('123 Nguyễn Huệ, Quận 1');
    expectAddress('Thái Bình');
  });
}
