import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/premium/feature_gate.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:gps_measurement/features/premium/paywall_screen.dart';
import 'package:gps_measurement/features/premium/premium_first_screen.dart';
import 'package:gps_measurement/features/premium/premium_links.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:gps_measurement/features/settings/settings_screen.dart';
import 'package:gps_measurement/services/ads/interstitial_manager.dart';
import 'package:gps_measurement/services/purchases/purchase_service.dart';
import 'package:gps_measurement/services/remote_config/rc_keys.dart';
import 'package:gps_measurement/services/support/support_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fakes.dart';
import '../helpers/golden.dart';

void main() {
  final now = DateTime.utc(2026, 10, 1, 12);
  const config = MonetizationConfig();

  group('interstitial after Save', () {
    bool allowed({
      bool ads = true,
      DateTime? last,
      bool walk = false,
    }) => interstitialAllowed(
      adsEnabled: ads,
      now: now,
      lastClosedAt: last,
      config: config,
      walkRecording: walk,
    );

    test('the very first one is allowed (no save counter)', () {
      expect(allowed(), isTrue);
    });

    test('at least 30 s between two interstitials', () {
      expect(allowed(last: now.subtract(const Duration(seconds: 29))), isFalse);
      expect(allowed(last: now.subtract(const Duration(seconds: 30))), isTrue);
    });

    test('never for premium / no consent, never while walking', () {
      expect(allowed(ads: false), isFalse);
      expect(allowed(walk: true), isFalse);
    });
  });

  test('manage subscription: the Play URL, else the store page', () {
    expect(
      manageSubscriptionUri(
        const PremiumStatus(
          isPremium: true,
          managementUrl: 'https://play.google.com/x',
        ),
        ios: false,
      ).toString(),
      'https://play.google.com/x',
    );
    expect(
      manageSubscriptionUri(
        const PremiumStatus(isPremium: true),
        ios: true,
      ).host,
      'apps.apple.com',
    );
    expect(
      manageSubscriptionUri(
        const PremiumStatus(isPremium: true),
        ios: false,
      ).path,
      '/store/account/subscriptions',
    );
  });

  group('FeatureGate from the entitlement', () {
    late SharedPreferences prefs;
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test('free limits until premium, then nothing is gated', () async {
      final store = FakePurchaseService();
      final c = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          purchaseServiceProvider.overrideWithValue(store),
        ],
      );
      addTearDown(c.dispose);
      var gate = c.read(featureGateProvider);
      expect(gate.canSaveNew(10), isFalse);
      expect(gate.canAddPhoto(3), isFalse);
      expect(gate.canExport(ExportFormat.kml, freeUsedToday: true), isFalse);
      expect(gate.showAds, isTrue);

      store.setStatus(const PremiumStatus(isPremium: true));
      await Future<void>.delayed(Duration.zero);
      gate = c.read(featureGateProvider);
      expect(gate.canSaveNew(1000), isTrue);
      expect(gate.canExport(ExportFormat.kml, freeUsedToday: true), isTrue);
      expect(gate.showAds, isFalse);
    });

    test('limits come from the monetization config', () {
      final c = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          purchaseServiceProvider.overrideWithValue(FakePurchaseService()),
          monetizationConfigProvider.overrideWithValue(
            const MonetizationConfig(
              gate: GateConfig(freeMaxSaved: 2, freeMaxPhotos: 1),
            ),
          ),
        ],
      );
      addTearDown(c.dispose);
      final gate = c.read(featureGateProvider);
      expect(gate.canSaveNew(1), isTrue);
      expect(gate.canSaveNew(2), isFalse);
      expect(gate.canAddPhoto(1), isFalse);
    });

    test('the cached entitlement answers before Google Play', () async {
      await prefs.setBool('premium_cached', true);
      final service = PlayBillingPurchaseService(
        c(prefs).read(settingsRepositoryProvider),
        android: false,
      );
      expect(service.status.isPremium, isTrue);
      expect(service.isAvailable, isFalse); // Not Android: free tier.
      await service.init();
      expect(await service.plans(), isEmpty);
    });
  });

  group('PlayBillingPurchaseService (channel)', () {
    late SharedPreferences prefs;
    late List<MethodCall> calls;
    late Map<String, Object?> activeReply;

    PlayBillingPurchaseService service() {
      const channel = MethodChannel('test/billing');
      TestWidgetsFlutterBinding.ensureInitialized();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            switch (call.method) {
              case 'queryActive':
                return activeReply;
              case 'queryProducts':
                return [
                  {
                    'productId': 'm',
                    'offerToken': 'tok-m',
                    'price': r'$3.99',
                    'priceMicros': 3990000,
                    'currency': 'USD',
                    'period': 'P1M',
                    'trialPeriod': 'P3D',
                  },
                  {
                    'productId': 'y',
                    'offerToken': 'tok-y',
                    'price': r'$19.99',
                    'priceMicros': 19990000,
                    'currency': 'USD',
                    'period': 'P1Y',
                    'trialPeriod': null,
                  },
                ];
              case 'purchase':
                return {'state': 'purchased'};
            }
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );
      return PlayBillingPurchaseService(
        c(prefs).read(settingsRepositoryProvider),
        channel: channel,
        monthlyId: 'm',
        yearlyId: 'y',
        android: true,
      );
    }

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      calls = [];
      activeReply = {'package': 'com.x', 'productIds': <String>[]};
    });

    test('periodDays reads ISO trial periods', () {
      expect(periodDays('P3D'), 3);
      expect(periodDays('P1W'), 7);
      expect(periodDays('P1M'), isNull);
      expect(periodDays(null), isNull);
    });

    test('an owned subscription means premium (and is cached)', () async {
      activeReply = {
        'package': 'com.x',
        'productIds': ['y'],
      };
      final s = service();
      expect(s.status.isPremium, isFalse);
      final changes = s.statusStream.first;
      await s.init();
      expect((await changes).isPremium, isTrue);
      expect(s.status.managementUrl, contains('package=com.x'));
      expect(prefs.getBool('premium_cached'), isTrue);
    });

    test('a purchase of something else is not premium', () async {
      activeReply = {
        'package': 'com.x',
        'productIds': ['other'],
      };
      final s = service();
      await s.init();
      expect(await s.restore(), RestoreOutcome.nothingToRestore);
    });

    test('plans: monthly with the 3-day trial, then yearly', () async {
      final s = service();
      await s.init();
      final plans = await s.plans();
      expect(plans.map((p) => p.plan), [
        PremiumPlan.monthly,
        PremiumPlan.annual,
      ]);
      expect(plans.first.trialDays, 3);
      expect(plans.first.priceAmount, closeTo(3.99, 0.001));
      expect(plans.last.trialDays, isNull);
    });

    test('purchase sends the product and its offer token', () async {
      final s = service();
      await s.init();
      final plans = await s.plans();
      expect(await s.purchase(plans.last), PurchaseOutcome.purchased);
      final call = calls.lastWhere((c) => c.method == 'purchase');
      expect(call.arguments, {'productId': 'y', 'offerToken': 'tok-y'});
    });
  });

  group('PaywallScreen', () {
    late SharedPreferences prefs;
    late FakePurchaseService store;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      store = FakePurchaseService(offers: testOffers);
    });

    Future<List<bool?>> pump(
      WidgetTester tester, {
      List<Override>? extra,
    }) async {
      tester.view
        ..physicalSize = const Size(400, 1000)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final popped = <bool?>[];
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            purchaseServiceProvider.overrideWithValue(store),
            supportServiceProvider.overrideWithValue(FakeSupport()),
            supportLinksProvider.overrideWithValue((
              supportEmail: '',
              privacyPolicyUrl: 'https://example.com/privacy',
              termsUrl: 'https://example.com/terms',
              appStoreId: '',
            )),
            ...?extra,
          ],
          child: testApp(
            child: Builder(
              builder: (context) => TextButton(
                onPressed: () async => popped.add(
                  await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => const PaywallScreen(source: 'test'),
                    ),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      return popped;
    }

    testWidgets('monthly (free trial) preselected; honest terms', (
      tester,
    ) async {
      await pump(tester);
      expect(find.text('Measure without limits'), findsOneWidget);
      expect(find.text('3-day free trial'), findsOneWidget);
      expect(find.text(r'Then $3.99 / month'), findsOneWidget);
      expect(find.text('Start 3-day free trial'), findsOneWidget);
      expect(find.textContaining(r'3 days free, then $3.99/month'), findsOne);
      expect(find.text('Yearly plan'), findsOneWidget);
      // The value badge belongs to the yearly plan.
      expect(find.text('Best price'), findsOneWidget);
      expect(
        find.descendant(
          of: find.ancestor(
            of: find.text('Yearly plan'),
            matching: find.byType(InkWell),
          ),
          matching: find.text('Best price'),
        ),
        findsOneWidget,
      );
      expect(find.textContaining(r'Only $19.99 per year'), findsOneWidget);
      expect(find.textContaining('per week'), findsNothing);
      expect(find.textContaining('/ week'), findsNothing);
      expect(find.text('Restore purchases'), findsOneWidget);
      expect(find.text('Terms of Use'), findsOneWidget);

      await tester.tap(find.text('Yearly plan'));
      await tester.pump();
      expect(find.text('Continue'), findsOneWidget);
      expect(find.textContaining(r'$19.99/year'), findsOneWidget);
    });

    testWidgets('yearly with a trial: the trial line, then the price', (
      tester,
    ) async {
      store.offers = [
        testOffers.first,
        const PlanOffer(
          plan: PremiumPlan.annual,
          price: r'$19.99',
          priceAmount: 19.99,
          currencyCode: 'USD',
          trialDays: 3,
        ),
      ];
      await pump(tester);
      // Both plans retain their names and show their trial separately.
      expect(find.text('3-day free trial'), findsNWidgets(2));
      expect(find.text('Yearly plan'), findsOneWidget);
      expect(find.textContaining(r'Only $19.99 per year'), findsOneWidget);
      expect(find.textContaining('/ week'), findsNothing);
      expect(find.text('Best price'), findsOneWidget);
    });

    testWidgets('close button only after 2 s', (tester) async {
      await pump(tester);
      final close = find.byTooltip('Close');
      expect(
        tester
            .widget<IgnorePointer>(
              find
                  .ancestor(of: close, matching: find.byType(IgnorePointer))
                  .first,
            )
            .ignoring,
        isTrue,
      );
      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        tester
            .widget<IgnorePointer>(
              find
                  .ancestor(of: close, matching: find.byType(IgnorePointer))
                  .first,
            )
            .ignoring,
        isFalse,
      );
    });

    testWidgets('purchase → premium → pops true', (tester) async {
      final popped = await pump(tester);
      await tester.tap(find.text('Start 3-day free trial'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(store.purchased, [PremiumPlan.monthly]);
      await tester.pump(const Duration(seconds: 1));
      expect(popped, [true]);
    });

    testWidgets('cancelled purchase is silent and stays', (tester) async {
      store.nextPurchase = PurchaseOutcome.cancelled;
      final popped = await pump(tester);
      await tester.tap(find.text('Start 3-day free trial'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(popped, isEmpty);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('restore: nothing found is explained', (tester) async {
      await pump(tester);
      await tester.tap(find.text('Restore purchases'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(
        find.text('No previous purchase found for this store account.'),
        findsOneWidget,
      );
    });

    testWidgets('store unreachable → retry', (tester) async {
      store.offers = const [];
      await pump(tester);
      expect(find.textContaining("Plans can't be loaded"), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      store.offers = testOffers;
      await tester.tap(find.text('Retry'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Yearly plan'), findsOneWidget);
    });

    testWidgets('already premium: active + manage', (tester) async {
      store.status = const PremiumStatus(isPremium: true);
      await pump(tester);
      expect(find.text('Premium active'), findsOneWidget);
      expect(find.text('Manage'), findsOneWidget);
      expect(find.text('Restore purchases'), findsNothing);
    });
  });

  group('Settings premium card', () {
    late SharedPreferences prefs;
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    Future<void> pump(WidgetTester tester, PremiumStatus status) async {
      tester.view
        ..physicalSize = const Size(400, 1600)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            deviceLocaleProvider.overrideWithValue(const Locale('en', 'US')),
            purchaseServiceProvider.overrideWithValue(
              FakePurchaseService()..status = status,
            ),
            supportServiceProvider.overrideWithValue(FakeSupport()),
          ],
          child: testApp(child: const SettingsScreen()),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
    }

    testWidgets('free: the offer', (tester) async {
      await pump(tester, PremiumStatus.free);
      expect(find.text('LandMeasure Premium'), findsOneWidget);
    });

    testWidgets('subscriber: manage; lifetime: nothing to manage', (
      tester,
    ) async {
      await pump(tester, const PremiumStatus(isPremium: true));
      expect(find.text('Premium active'), findsOneWidget);
      expect(find.text('Manage subscription'), findsOneWidget);

      await pump(
        tester,
        const PremiumStatus(isPremium: true, isLifetime: true),
      );
      expect(find.text('Premium active · Lifetime'), findsOneWidget);
      expect(find.text('Manage subscription'), findsNothing);
    });
  });

  group('PremiumFirstScreen', () {
    late SharedPreferences prefs;
    late FakePurchaseService store;

    const yearlyWithTrial = PlanOffer(
      plan: PremiumPlan.annual,
      price: r'$19.99',
      priceAmount: 19.99,
      currencyCode: 'USD',
      trialDays: 3,
    );

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      store = FakePurchaseService(offers: [testOffers.first, yearlyWithTrial]);
    });

    Future<List<bool?>> pump(WidgetTester tester) async {
      tester.view
        ..physicalSize = const Size(400, 1000)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final popped = <bool?>[];
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            purchaseServiceProvider.overrideWithValue(store),
            supportServiceProvider.overrideWithValue(FakeSupport()),
          ],
          child: testApp(
            child: Builder(
              builder: (context) => TextButton(
                onPressed: () async => popped.add(
                  await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => const PremiumFirstScreen(),
                    ),
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      return popped;
    }

    testWidgets('yearly only: no plan cards, trial then price, cancel', (
      tester,
    ) async {
      await pump(tester);
      expect(find.text('Measure without limits'), findsOneWidget);
      expect(find.text('Start free trial'), findsOneWidget);
      expect(find.text(r'3-day free trial, then $19.99/year'), findsOneWidget);
      expect(find.text('Cancel anytime'), findsOneWidget);
      // The monthly / yearly choice is gone.
      expect(find.text('Yearly plan'), findsNothing);
      expect(find.text('3-day free trial'), findsNothing);
      expect(find.text('Most popular'), findsNothing);
      expect(find.text('Restore purchases'), findsOneWidget);
    });

    testWidgets('✕ is hidden for 10 s, or until Start free trial is tapped', (
      tester,
    ) async {
      bool closeHidden() => tester
          .widget<IgnorePointer>(
            find
                .ancestor(
                  of: find.byTooltip('Close'),
                  matching: find.byType(IgnorePointer),
                )
                .first,
          )
          .ignoring;

      await pump(tester);
      await tester.pump(const Duration(seconds: 5));
      expect(closeHidden(), isTrue);
      await tester.pump(const Duration(seconds: 5, milliseconds: 300));
      expect(closeHidden(), isFalse);
    });

    testWidgets('tapping Start free trial shows the ✕ (bought or not)', (
      tester,
    ) async {
      store.nextPurchase = PurchaseOutcome.cancelled;
      await pump(tester);
      await tester.tap(find.text('Start free trial'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(
        tester
            .widget<IgnorePointer>(
              find
                  .ancestor(
                    of: find.byTooltip('Close'),
                    matching: find.byType(IgnorePointer),
                  )
                  .first,
            )
            .ignoring,
        isFalse,
      );
    });

    testWidgets('the button buys the yearly plan', (tester) async {
      final popped = await pump(tester);
      await tester.tap(find.text('Start free trial'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(store.purchased, [PremiumPlan.annual]);
      await tester.pump(const Duration(seconds: 1));
      expect(popped, [true]);
    });

    testWidgets('a yearly plan without a trial says so', (tester) async {
      store.offers = testOffers; // yearly has no trial here
      await pump(tester);
      expect(find.text('Start free trial'), findsNothing);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.text(r'$19.99/year'), findsOneWidget);
    });

    testWidgets('no yearly plan / store unreachable → retry', (tester) async {
      store.offers = const [];
      await pump(tester);
      expect(find.text('Start free trial'), findsNothing);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}

ProviderContainer c(SharedPreferences prefs) {
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
  addTearDown(container.dispose);
  return container;
}
