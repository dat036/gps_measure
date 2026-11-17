import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gps_measurement/core/location/location_service.dart';
import 'package:gps_measurement/core/permissions/permission_flows.dart';
import 'package:gps_measurement/core/permissions/permission_service.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/core/widgets/primary_cta.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/location_fix.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:gps_measurement/features/settings/language_screen.dart';
import 'package:gps_measurement/features/settings/map_style_screen.dart';
import 'package:gps_measurement/features/settings/settings_controller.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:gps_measurement/features/settings/settings_screen.dart';
import 'package:gps_measurement/features/settings/units_screen.dart';
import 'package:gps_measurement/services/ads/rewarded_manager.dart';
import 'package:gps_measurement/services/support/support_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fakes.dart';
import '../helpers/golden.dart';
import '../helpers/router.dart';

const SupportLinks allLinks = (
  supportEmail: 'help@example.com',
  privacyPolicyUrl: 'https://example.com/privacy',
  termsUrl: 'https://example.com/terms',
  appStoreId: '',
);

const SupportLinks noLinks = (
  supportEmail: '',
  privacyPolicyUrl: '',
  termsUrl: '',
  appStoreId: '',
);

class FakeLocation implements LocationService {
  LocationAccess access = LocationAccess.denied;

  /// What the system dialog answers.
  LocationAccess answer = LocationAccess.granted;
  final List<bool> requests = [];

  @override
  Future<LocationAccess> ensureAccess({bool request = true}) async {
    requests.add(request);
    if (request && access == LocationAccess.denied) access = answer;
    return access;
  }

  @override
  Future<LocationFix> current({Duration? timeLimit}) =>
      throw const LocationException('not in tests');

  @override
  Future<GeoPoint?> lastKnown() async => null;
}

void main() {
  late SharedPreferences prefs;
  late FakeSupport support;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    support = FakeSupport();
  });

  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    SupportLinks links = allLinks,
    List<Override> extra = const [],
    Locale locale = const Locale('en'),
    double height = 1400,
  }) async {
    tester.view
      ..physicalSize = Size(400, height)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        deviceLocaleProvider.overrideWithValue(const Locale('en', 'US')),
        supportServiceProvider.overrideWithValue(support),
        supportLinksProvider.overrideWithValue(links),
        ...extra,
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: testApp(child: child, locale: locale),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('SettingsScreen', () {
    testWidgets('sections, current values and version', (tester) async {
      await pump(tester, const SettingsScreen());
      expect(find.text('MEASUREMENT PREFERENCES'), findsOneWidget);
      expect(find.text('MEASUREMENT & MAP'), findsOneWidget);
      expect(find.text('SUPPORT & LEGAL'), findsOneWidget);
      // en-US defaults: feet + acres.
      expect(find.text('ft · acre'), findsOneWidget);
      expect(find.text('Standard'), findsOneWidget); // Default map.
      expect(find.text('System default'), findsOneWidget);
      expect(find.text('Area'), findsOneWidget);
      for (final item in [
        'Help & Feedback',
        'Rate Us',
        'Privacy Policy',
        'Terms of Use',
      ]) {
        expect(find.text(item), findsOneWidget);
      }
      expect(find.text('Version 1.0.0 (7)'), findsOneWidget);
    });

    testWidgets('each toggle writes its setting', (tester) async {
      await pump(tester, const SettingsScreen());
      for (final title in [
        'GPS Accuracy Display',
        'Auto Center Map',
        'Save Photos to Measurement',
        'Keep Screen Awake',
      ]) {
        await tester.tap(find.text(title));
        await tester.pump();
      }
      final s = container.read(settingsProvider);
      expect(s.showGpsAccuracy, isFalse);
      expect(s.autoCenter, isFalse);
      expect(s.savePhotosToMeasurement, isFalse);
      expect(s.keepScreenAwake, isFalse);
      // Persisted.
      expect(prefs.getBool('keep_screen_awake'), isFalse);
    });

    testWidgets('default measurement type sheet', (tester) async {
      await pump(tester, const SettingsScreen());
      await tester.tap(find.text('Default Measurement Type'));
      await tester.pumpAndSettle();
      expect(find.text('Selected on Home when you open the app.'), findsOne);
      await tester.tap(find.text('Walk'));
      await tester.pumpAndSettle();
      expect(
        container.read(settingsProvider).defaultMode,
        MeasurementType.walk,
      );
      expect(find.text('Walk'), findsOneWidget); // row value
    });

    testWidgets('unconfigured links are hidden (no dead buttons)', (
      tester,
    ) async {
      await pump(tester, const SettingsScreen(), links: noLinks);
      expect(find.text('Help & Feedback'), findsNothing);
      expect(find.text('Privacy Policy'), findsNothing);
      expect(find.text('Terms of Use'), findsNothing);
      // Android opens the listing by package name.
      expect(find.text('Rate Us'), findsOneWidget);
    });

    testWidgets('help mail, privacy, terms, rate', (tester) async {
      await pump(tester, const SettingsScreen());
      await tester.tap(find.text('Help & Feedback'));
      await tester.pumpAndSettle();
      final mail = support.launched.single;
      expect(mail.scheme, 'mailto');
      expect(mail.path, 'help@example.com');
      expect(mail.toString(), contains('LandMeasure%201.0.0%20(7)'));

      await tester.tap(find.text('Privacy Policy'));
      await tester.tap(find.text('Terms of Use'));
      await tester.tap(find.text('Rate Us'));
      await tester.pumpAndSettle();
      expect(support.launched.skip(1).map((u) => u.toString()), [
        'https://example.com/privacy',
        'https://example.com/terms',
      ]);
      expect(support.storeListings, 1);
    });

    testWidgets('no mail app → address in a snackbar', (tester) async {
      support.canLaunch = false;
      await pump(tester, const SettingsScreen());
      await tester.tap(find.text('Help & Feedback'));
      await tester.pumpAndSettle();
      expect(
        find.text('No email app found. Write to us at help@example.com.'),
        findsOneWidget,
      );
    });
  });

  test('feedback mail: subject and diagnostics, %20 not +', () {
    final uri = feedbackUri(
      email: 'help@example.com',
      subject: 'LandMeasure feedback',
      appName: 'LandMeasure',
      info: (
        version: '1.0.0',
        build: '7',
        device: 'Google Pixel 7',
        os: 'Android 14 (SDK 34)',
      ),
      localeTag: 'vi',
    );
    expect(uri.toString(), isNot(contains('+')));
    final query = Uri.splitQueryString(uri.query);
    expect(query['subject'], 'LandMeasure feedback');
    expect(
      query['body'],
      endsWith(
        '---\nLandMeasure 1.0.0 (7) · Android 14 (SDK 34) · '
        'Google Pixel 7 · vi',
      ),
    );
  });

  group('UnitsScreen', () {
    testWidgets('distance, area, secondary', (tester) async {
      await pump(tester, const UnitsScreen(), height: 2400);
      expect(find.text('VIETNAM LAND UNITS'), findsNothing);
      expect(find.text('Sào Bắc Bộ'), findsNothing);

      await tester.tap(find.text('Kilometers'));
      await tester.pump();
      await tester.tap(find.text('Acres'));
      await tester.pump();
      var s = container.read(settingsProvider);
      expect(s.distanceUnit, DistanceUnit.kilometer);
      expect(s.areaUnit, AreaUnit.acre);

      await tester.tap(find.text('Hectares'));
      await tester.pump();
      await tester.tap(find.text('Show secondary unit'));
      await tester.pump();
      s = container.read(settingsProvider);
      expect(s.areaUnit, AreaUnit.hectare);
      expect(s.showSecondaryUnit, isFalse);
    });
  });

  group('MapStyleScreen', () {
    testWidgets('Apply is enabled after a change and saves it', (
      tester,
    ) async {
      final opened = <String>[];
      tester.view
        ..physicalSize = const Size(400, 1400)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          deviceLocaleProvider.overrideWithValue(const Locale('en', 'US')),
          supportServiceProvider.overrideWithValue(support),
          supportLinksProvider.overrideWithValue(allLinks),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: routerTestApp(
            paywallOpened: opened,
            child: Builder(
              builder: (context) => TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const MapStyleScreen(),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      PrimaryCta apply() => tester.widget(find.byType(PrimaryCta));
      expect(apply().onPressed, isNull);

      // Hybrid is Premium: straight to the paywall (no popup, no ad), and
      // nothing is selected when it is closed.
      await tester.tap(find.text('Hybrid'));
      await tester.pumpAndSettle();
      expect(opened, ['map_style']);
      expect(find.text('Watch an ad'), findsNothing);
      expect(find.text('Go Premium'), findsNothing);
      await tester.tap(find.text('stub close'));
      await tester.pumpAndSettle();
      expect(apply().onPressed, isNull);

      // Terrain is free.
      await tester.tap(find.text('Terrain'));
      await tester.pump();
      expect(apply().onPressed, isNotNull);
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(container.read(settingsProvider).mapStyle, MapStyle.terrain);
      expect(find.byType(MapStyleScreen), findsNothing);
    });
  });

  // The "watch an ad to unlock" path is switched off for now (see
  // `_mapStyleRewardEnabled` in premium_flows.dart); these run again when it
  // is switched back on.
  group('MapStyleScreen rewarded unlock', skip: 'reward unlock is off', () {
    Future<void> open(WidgetTester tester, RewardOutcome outcome) async {
      await pump(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const MapStyleScreen()),
            ),
            child: const Text('open'),
          ),
        ),
        extra: [
          rewardedManagerProvider.overrideWithValue(FakeRewarded(outcome)),
        ],
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    PrimaryCta apply(WidgetTester tester) =>
        tester.widget(find.byType(PrimaryCta));

    testWidgets('watching the ad to the end opens the style', (tester) async {
      await open(tester, RewardOutcome.earned);
      expect(find.text('Premium'), findsNWidgets(2)); // Satellite + Hybrid.
      await tester.tap(find.text('Hybrid'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Watch an ad'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Hybrid map unlocked'), findsOneWidget);
      expect(find.text('Premium'), findsOneWidget); // Only Satellite left.
      expect(apply(tester).onPressed, isNotNull);
      expect(
        container.read(featureGateProvider).canUseMapStyle(MapStyle.hybrid),
        isTrue,
      );
      expect(
        container.read(featureGateProvider).canUseMapStyle(MapStyle.satellite),
        isFalse,
      );
    });

    testWidgets('closing the ad early does not open it', (tester) async {
      await open(tester, RewardOutcome.dismissed);
      await tester.tap(find.text('Hybrid'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Watch an ad'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Watch the ad to the end'), findsOneWidget);
      expect(apply(tester).onPressed, isNull);
      expect(
        container.read(featureGateProvider).canUseMapStyle(MapStyle.hybrid),
        isFalse,
      );
    });

    testWidgets('no ad available: opened anyway (like the KML export)', (
      tester,
    ) async {
      await open(tester, RewardOutcome.unavailable);
      await tester.tap(find.text('Satellite'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Watch an ad'));
      await tester.pumpAndSettle();
      expect(apply(tester).onPressed, isNotNull);
    });
  });

  group('LanguageScreen', () {
    testWidgets('native names; choosing one sets the locale', (tester) async {
      await pump(tester, const LanguageScreen());
      // English twice: the option and the device language under System.
      expect(find.text('English'), findsNWidgets(2));
      for (final name in [
        'Tiếng Việt',
        'Español',
        'Português',
        'हिन्दी',
        'Bahasa Indonesia',
        '中文',
        'ไทย',
        'Français',
        'Deutsch',
        'Polski',
        'Nederlands',
      ]) {
        expect(find.text(name), findsOneWidget);
      }
      expect(find.text('This language was machine-translated'), findsNothing);
      await tester.tap(find.text('Español'));
      await tester.pump();
      expect(container.read(settingsProvider).localeCode, 'es');
      await tester.tap(find.text('System default'));
      await tester.pump();
      expect(container.read(settingsProvider).localeCode, isNull);
    });

    testWidgets('machine-translated languages say so', (tester) async {
      await pump(tester, const LanguageScreen(), locale: const Locale('es'));
      expect(
        find.text(
          'Este idioma se tradujo automáticamente y puede contener errores.',
        ),
        findsOneWidget,
      );
    });
  });

  group('PermissionFlows', () {
    late FakeLocation location;
    late FakePermissions permissions;

    setUp(() {
      location = FakeLocation();
      permissions = FakePermissions();
    });

    Future<Object?> run(
      WidgetTester tester,
      Future<Object?> Function(BuildContext, WidgetRef) flow, {
      String? tap,
    }) async {
      Object? result;
      await pump(
        tester,
        Consumer(
          builder: (context, ref, _) => TextButton(
            onPressed: () async => result = await flow(context, ref),
            child: const Text('go'),
          ),
        ),
        extra: [
          locationServiceProvider.overrideWithValue(location),
          permissionServiceProvider.overrideWithValue(permissions),
        ],
      );
      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();
      if (tap != null) {
        await tester.tap(find.text(tap));
        await tester.pumpAndSettle();
      }
      return result;
    }

    testWidgets('location: pre-prompt, then the system dialog', (
      tester,
    ) async {
      final result = await run(
        tester,
        PermissionFlows.location,
        tap: 'Continue',
      );
      expect(result, LocationAccess.granted);
      expect(location.requests, [false, true]);
    });

    testWidgets('location: "Not now" never shows the system dialog', (
      tester,
    ) async {
      final result = await run(
        tester,
        PermissionFlows.location,
        tap: 'Not now',
      );
      expect(result, LocationAccess.denied);
      expect(location.requests, [false]);
    });

    testWidgets('location refused for good → Open Settings', (tester) async {
      location.access = LocationAccess.deniedForever;
      await run(tester, PermissionFlows.location, tap: 'Open Settings');
      expect(permissions.appSettingsOpened, 1);
      expect(location.requests, [false]);
    });

    testWidgets('location granted / service off: no sheet', (tester) async {
      location.access = LocationAccess.serviceDisabled;
      final result = await run(tester, PermissionFlows.location);
      expect(result, LocationAccess.serviceDisabled);
      expect(find.text('Allow Location Access'), findsNothing);
    });

    testWidgets('walk notifications: asked once, with a pre-prompt', (
      tester,
    ) async {
      Future<void> flow(BuildContext c, WidgetRef r) =>
          PermissionFlows.walkNotificationsOnce(c, r);
      await run(tester, flow, tap: 'Continue');
      expect(permissions.notificationRequests, 1);

      permissions.notifications = PermissionAccess.askable;
      await tester.tap(find.text('go'));
      await tester.pumpAndSettle();
      expect(find.text('Allow Notifications'), findsNothing);
      expect(permissions.notificationRequests, 1);
    });

    testWidgets('walk notifications blocked: no sheet at Start', (
      tester,
    ) async {
      permissions.notifications = PermissionAccess.blocked;
      Future<void> flow(BuildContext c, WidgetRef r) =>
          PermissionFlows.walkNotificationsOnce(c, r);
      await run(tester, flow);
      expect(find.text('Allow Notifications'), findsNothing);
      expect(prefs.getBool('walk_notification_asked'), isTrue);
    });
  });

  test('settings controller keeps the last map camera', () async {
    SharedPreferences.setMockInitialValues({});
    final p = await SharedPreferences.getInstance();
    final c = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(p)],
    );
    addTearDown(c.dispose);
    final repo = c.read(settingsRepositoryProvider);
    expect(repo.lastMapCamera, isNull);
    await repo.setLastMapCamera(21.02, 105.85, 17.5);
    expect(repo.lastMapCamera, (lat: 21.02, lng: 105.85, zoom: 17.5));
    unawaited(p.setString('last_map_camera', 'broken'));
    expect(repo.lastMapCamera, isNull);
  });

  test('location refused for good is remembered (Android says "denied")', () {
    LocationAccess resolve(LocationPermission p, {bool blocked = false}) =>
        GeolocatorLocationService.resolveAccess(p, rememberedBlocked: blocked);
    expect(resolve(LocationPermission.denied), LocationAccess.denied);
    expect(
      resolve(LocationPermission.denied, blocked: true),
      LocationAccess.deniedForever,
    );
    expect(
      resolve(LocationPermission.whileInUse, blocked: true),
      LocationAccess.granted,
    );
    expect(
      resolve(LocationPermission.deniedForever),
      LocationAccess.deniedForever,
    );
  });
}
