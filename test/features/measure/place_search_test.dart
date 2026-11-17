import 'dart:io';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/connectivity/connectivity_service.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/features/measure/common/place_search_controller.dart';
import 'package:gps_measurement/features/measure/common/place_search_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeGeocoder implements AddressGeocoder {
  bool present = true;
  Exception? error;
  List<GeoPoint> points = const [];
  final List<String> located = [];
  int nameCalls = 0;

  @override
  Future<bool> isPresent() async => present;

  @override
  Future<List<GeoPoint>> locate(String address, Locale? locale) async {
    located.add(address);
    if (error != null) throw error!;
    return points;
  }

  @override
  Future<String?> nameOf(GeoPoint point, Locale? locale) async {
    nameCalls++;
    if (point.lat > 50) throw Exception('reverse failed');
    return 'Place ${point.lat}';
  }
}

void main() {
  group('DefaultPlaceSearchService', () {
    late FakeGeocoder geocoder;
    late List<Uri> resolved;
    late DefaultPlaceSearchService service;
    Uri? Function(Uri)? redirect;

    setUp(() {
      geocoder = FakeGeocoder();
      resolved = [];
      redirect = null;
      service = DefaultPlaceSearchService(
        geocoder: geocoder,
        resolveShortLink: (uri) async {
          resolved.add(uri);
          return redirect?.call(uri);
        },
      );
    });

    test('coordinates and full links are parsed locally', () async {
      for (final input in [
        '21.0285, 105.8542',
        '21°01\'42.6"N 105°51\'15.1"E',
        'https://maps.google.com/?q=21.0285,105.8542',
      ]) {
        final r = await service.search(input);
        expect(r.single.isExact, isTrue, reason: input);
        expect(r.single.point.lat, closeTo(21.0285, 1e-4));
      }
      expect(geocoder.located, isEmpty);
      expect(resolved, isEmpty);
      expect(await service.search('   '), isEmpty);
    });

    test('short links are expanded, only for Google hosts', () async {
      redirect = (_) => Uri.parse(
        'https://www.google.com/maps/place/X/@20.446,106.3395,17z/data=1',
      );
      final r = await service.search('https://maps.app.goo.gl/AbC123');
      expect(resolved.single.host, 'maps.app.goo.gl');
      expect(r.single.point, const GeoPoint(lat: 20.446, lng: 106.3395));

      redirect = (_) => null;
      expect(await service.search('https://maps.app.goo.gl/dead'), isEmpty);
      // Another host is treated as an address, never fetched.
      await service.search('https://example.com/abc');
      expect(resolved, hasLength(2));
    });

    test('short link network errors mean offline', () async {
      final offline = DefaultPlaceSearchService(
        geocoder: geocoder,
        resolveShortLink: (_) async =>
            throw const SocketException('no network'),
      );
      await expectLater(
        offline.search('https://maps.app.goo.gl/x'),
        throwsA(
          isA<PlaceSearchException>().having(
            (e) => e.failure,
            'failure',
            PlaceSearchFailure.offline,
          ),
        ),
      );
    });

    test('addresses go to the OS geocoder; first 3 get names', () async {
      geocoder.points = [
        for (var i = 0; i < 5; i++) GeoPoint(lat: 20.0 + i, lng: 106),
      ];
      final r = await service.search('Vũ Thư, Thái Bình');
      expect(geocoder.located, ['Vũ Thư, Thái Bình']);
      expect(r, hasLength(5));
      expect(r.first.title, 'Place 20.0');
      expect(r.first.isExact, isFalse);
      expect(r.first.subtitle, '20.000000, 106.000000');
      expect(r.last.title, 'Vũ Thư, Thái Bình'); // not reverse-geocoded
      expect(geocoder.nameCalls, 3);
    });

    test('reverse-geocoding failures keep the address as title', () async {
      geocoder.points = [const GeoPoint(lat: 60, lng: 10)];
      final r = await service.search('Oslo');
      expect(r.single.title, 'Oslo');
    });

    test('no geocoder / errors / no match', () async {
      geocoder.present = false;
      await expectLater(
        service.search('Hà Nội'),
        throwsA(
          isA<PlaceSearchException>().having(
            (e) => e.failure,
            'failure',
            PlaceSearchFailure.unavailable,
          ),
        ),
      );
      geocoder
        ..present = true
        ..error = Exception('IOException: grpc failed');
      await expectLater(
        service.search('Hà Nội'),
        throwsA(isA<PlaceSearchException>()),
      );
      geocoder
        ..error = null
        ..points = const [];
      expect(await service.search('zzzz'), isEmpty);
    });
  });

  group('PlaceSearchController', () {
    late ProviderContainer container;
    late _ScriptedService service;
    late SharedPreferences prefs;
    late _Connectivity connectivity;

    setUp(() async {
      connectivity = _Connectivity();
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      service = _ScriptedService();
      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          placeSearchServiceProvider.overrideWithValue(service),
          connectivityServiceProvider.overrideWithValue(connectivity),
        ],
      );
      addTearDown(container.dispose);
      container.listen(placeSearchControllerProvider, (_, _) {});
    });

    PlaceSearchState read() => container.read(placeSearchControllerProvider);
    PlaceSearchController notifier() =>
        container.read(placeSearchControllerProvider.notifier);

    test('an exact result is returned for a direct jump', () async {
      service.next = [
        const PlaceResult(point: GeoPoint(lat: 1, lng: 2), title: '1, 2'),
      ];
      final exact = await notifier().submit('1, 2');
      expect(exact?.point, const GeoPoint(lat: 1, lng: 2));
      expect(read().recent, ['1, 2']);
    });

    test('address results are listed; empty and failures', () async {
      service.next = [
        const PlaceResult(
          point: GeoPoint(lat: 1, lng: 2),
          title: 'A',
          subtitle: '1, 2',
        ),
      ];
      expect(await notifier().submit('Thái Bình'), isNull);
      expect(read().status, PlaceSearchStatus.results);
      expect(read().results, hasLength(1));

      service.next = [];
      await notifier().submit('nowhere');
      expect(read().status, PlaceSearchStatus.empty);
      expect(read().recent, ['Thái Bình']); // failed queries not kept

      service.failure = PlaceSearchFailure.offline;
      connectivity.online = false;
      await notifier().submit('x');
      expect(read().status, PlaceSearchStatus.offline);
      // Geocoder error while online: not blamed on the network.
      connectivity.online = true;
      await notifier().submit('x');
      expect(read().status, PlaceSearchStatus.failed);
      service.failure = PlaceSearchFailure.unavailable;
      await notifier().submit('x');
      expect(read().status, PlaceSearchStatus.unavailable);

      await notifier().submit('  ');
      expect(read().status, PlaceSearchStatus.idle);
    });

    test('recent searches: newest first, deduplicated, max 5', () async {
      service.next = [
        const PlaceResult(point: GeoPoint(lat: 0, lng: 0), title: 't'),
      ];
      for (final q in ['a', 'b', 'c', 'd', 'e', 'f', 'c']) {
        await notifier().submit(q);
      }
      expect(read().recent, ['c', 'f', 'e', 'd', 'b']);
      await notifier().clearRecent();
      expect(read().recent, isEmpty);
    });
  });
}

class _ScriptedService implements PlaceSearchService {
  List<PlaceResult> next = const [];
  PlaceSearchFailure? failure;

  @override
  Future<List<PlaceResult>> search(String input, {Locale? locale}) async {
    if (failure != null) throw PlaceSearchException(failure!);
    return next;
  }
}

class _Connectivity implements ConnectivityService {
  bool online = true;

  @override
  Future<bool> isOnline() async => online;

  @override
  Stream<bool> get onlineChanges => const Stream.empty();
}
