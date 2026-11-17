import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
// Maps has no native view in widget tests.
// ignore: depend_on_referenced_packages
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:gps_measurement/core/connectivity/connectivity_service.dart';
import 'package:gps_measurement/core/location/location_service.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/data/prefs/prefs_keys.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/location_fix.dart';
import 'package:gps_measurement/domain/premium/feature_gate.dart';
import 'package:gps_measurement/features/measure/common/measure_map_view.dart';
import 'package:gps_measurement/features/measure/common/measure_screen.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:gps_measurement/services/ads/ads_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/data.dart';
import '../../helpers/golden.dart';

class TestMapPlatform extends GoogleMapsFlutterPlatform {
  @override
  Widget buildViewWithConfiguration(
    int creationId,
    PlatformViewCreatedCallback onPlatformViewCreated, {
    required MapWidgetConfiguration widgetConfiguration,
    MapConfiguration mapConfiguration = const MapConfiguration(),
    MapObjects mapObjects = const MapObjects(),
  }) => const SizedBox();
}

class EntryLocation implements LocationService {
  LocationAccess access = LocationAccess.denied;
  int requests = 0;
  int fixes = 0;
  bool failFix = false;

  @override
  Future<LocationAccess> ensureAccess({bool request = true}) async {
    if (request) {
      requests++;
      access = LocationAccess.granted;
    }
    return access;
  }

  @override
  Future<GeoPoint?> lastKnown() async => const GeoPoint(lat: 21, lng: 105);

  @override
  Future<LocationFix> current({Duration? timeLimit}) async {
    fixes++;
    if (failFix) throw const LocationException('GPS timeout');
    return LocationFix(
      lat: 10.7769,
      lng: 106.7009,
      accuracy: 5,
      timestamp: DateTime.utc(2026),
    );
  }
}

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  late GoogleMapsFlutterPlatform originalMaps;

  setUp(() {
    originalMaps = GoogleMapsFlutterPlatform.instance;
    GoogleMapsFlutterPlatform.instance = TestMapPlatform();
    binding.defaultBinaryMessenger.setMockMessageHandler(
      'dev.flutter.pigeon.wakelock_plus_platform_interface.'
      'WakelockPlusApi.toggle',
      (_) async => const StandardMessageCodec().encodeMessage(<Object?>[null]),
    );
  });

  tearDown(() {
    GoogleMapsFlutterPlatform.instance = originalMaps;
  });

  Future<void> open(
    WidgetTester tester,
    EntryLocation location, {
    bool autoCenter = true,
    MeasurementType type = MeasurementType.area,
  }) async {
    SharedPreferences.setMockInitialValues({
      PrefsKeys.autoCenter: autoCenter,
      PrefsKeys.helpSeen(type.name): true,
      PrefsKeys.lastMapCamera: '48.85,2.35,14.0',
    });
    final prefs = await SharedPreferences.getInstance();
    final db = newTestDatabase();
    final temp = TempDirectories();
    addTearDown(() async {
      await db.close();
      temp.dispose();
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          appDirectoriesProvider.overrideWithValue(temp.dirs),
          appDatabaseProvider.overrideWithValue(db),
          locationServiceProvider.overrideWithValue(location),
          featureGateProvider.overrideWithValue(
            const FeatureGate(isPremium: true),
          ),
          adsEnabledProvider.overrideWithValue(false),
          isOnlineProvider.overrideWith((ref) => Stream.value(true)),
        ],
        child: testApp(child: MeasureScreen(type: type)),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  for (final type in [MeasurementType.area, MeasurementType.distance]) {
    testWidgets('$type requests permission and centers on a fresh GPS fix', (
      tester,
    ) async {
      final location = EntryLocation();
      await open(tester, location, type: type);
      expect(find.text('Continue'), findsOneWidget);
      expect(location.requests, 0);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      final map = tester.widget<MeasureMapView>(find.byType(MeasureMapView));
      expect(location.requests, 1);
      expect(location.fixes, 1);
      expect(map.myLocationEnabled, isTrue);
      expect(map.initialCamera.target.latitude, 10.7769);
      expect(map.initialCamera.target.longitude, 106.7009);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets(
    'declining permission still opens the map without requesting GPS',
    (tester) async {
      final location = EntryLocation();
      await open(tester, location);
      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();
      final map = tester.widget<MeasureMapView>(find.byType(MeasureMapView));
      expect(map.myLocationEnabled, isFalse);
      expect(location.requests, 0);
      expect(location.fixes, 0);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('GPS failure falls back to the cached location', (tester) async {
    final location = EntryLocation()
      ..access = LocationAccess.granted
      ..failFix = true;
    await open(tester, location);
    final map = tester.widget<MeasureMapView>(find.byType(MeasureMapView));
    expect(map.initialCamera.target.latitude, 21);
    expect(map.initialCamera.target.longitude, 105);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('auto center off preserves the saved camera', (tester) async {
    final location = EntryLocation()..access = LocationAccess.granted;
    await open(tester, location, autoCenter: false);
    final map = tester.widget<MeasureMapView>(find.byType(MeasureMapView));
    expect(map.initialCamera.target.latitude, 48.85);
    expect(map.initialCamera.target.longitude, 2.35);
    expect(location.fixes, 0);
    await tester.pumpWidget(const SizedBox());
  });
}
