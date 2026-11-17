import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/services/purchases/purchase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel(StoreKitPurchaseService.channelName);
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late SharedPreferences prefs;
  late ProviderContainer container;
  late StoreKitPurchaseService service;
  late List<MethodCall> calls;
  late Map<String, Object?> active;
  late String purchaseState;
  late bool storeFails;
  late bool purchaseGrantsAccess;

  Map<String, Object?> snapshot(List<String> ids, int revision) => {
    'productIds': ids,
    'revision': revision,
  };

  Future<void> notify(Map<String, Object?> state) async {
    final completed = Completer<void>();
    await messenger.handlePlatformMessage(
      channel.name,
      channel.codec.encodeMethodCall(MethodCall('entitlementChanged', state)),
      (_) => completed.complete(),
    );
    await completed.future;
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    calls = [];
    active = snapshot([], 1);
    purchaseState = 'purchased';
    storeFails = false;
    purchaseGrantsAccess = true;
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      if (storeFails) throw PlatformException(code: 'storekit_error');
      switch (call.method) {
        case 'queryActive':
        case 'restore':
          return active;
        case 'queryProducts':
          // Store ordering does not have to match the paywall ordering.
          return [
            {
              'productId': 'Yearly',
              'price': '499.000 ₫',
              'priceAmount': 499000,
              'currency': 'VND',
            },
            {
              'productId': 'monthly',
              'price': '59.000 ₫',
              'priceAmount': 59000,
              'currency': 'VND',
              'trialDays': 7,
            },
          ];
        case 'purchase':
          return {
            'state': purchaseState,
            if (purchaseState == 'purchased')
              'entitlement': snapshot(
                purchaseGrantsAccess ? ['Yearly'] : [],
                2,
              ),
          };
      }
      return null;
    });
    service = StoreKitPurchaseService(
      container.read(settingsRepositoryProvider),
      channel: channel,
    );
  });

  tearDown(() {
    service.dispose();
    container.dispose();
    messenger.setMockMethodCallHandler(channel, null);
    debugDefaultTargetPlatformOverride = null;
  });

  test('iOS provider selects StoreKit; Android still selects Play Billing', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    expect(
      container.read(purchaseServiceProvider),
      isA<StoreKitPurchaseService>(),
    );
    container.invalidate(purchaseServiceProvider);
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(
      container.read(purchaseServiceProvider),
      isA<PlayBillingPurchaseService>(),
    );
  });

  test('startup restores a verified entitlement and caches Premium', () async {
    active = snapshot(['monthly'], 1);
    final changed = service.statusStream.first;
    await service.init();
    expect((await changed).isPremium, isTrue);
    expect(service.status.managementUrl, contains('apps.apple.com'));
    expect(prefs.getBool('premium_cached'), isTrue);
    expect(calls.single.method, 'queryActive');
    expect(calls.single.arguments, {
      'ids': ['monthly', 'Yearly'],
    });
  });

  test(
    'startup does not wait for the store or request explicit restore',
    () async {
      final reply = Completer<Object?>();
      messenger.setMockMethodCallHandler(channel, (call) {
        expect(call.method, 'queryActive');
        return reply.future;
      });
      await service.init();
      expect(service.isAvailable, isTrue);
      reply.complete(active);
      await Future<void>.delayed(Duration.zero);
    },
  );

  test('localized plans use exact Apple IDs and eligible trial data', () async {
    await service.init();
    final plans = await service.plans();
    expect(plans.map((p) => p.plan), [PremiumPlan.monthly, PremiumPlan.annual]);
    expect(plans.first.price, '59.000 ₫');
    expect(plans.first.priceAmount, 59000);
    expect(plans.first.currencyCode, 'VND');
    expect(plans.first.trialDays, 7);
    expect(plans.last.trialDays, isNull);
    expect(plans.map((p) => p.handle), ['monthly', 'Yearly']);
  });

  test('purchase delivers entitlement before reporting success', () async {
    await service.init();
    final offer = (await service.plans()).last;
    expect(await service.purchase(offer), PurchaseOutcome.purchased);
    expect(service.status.isPremium, isTrue);
    expect(prefs.getBool('premium_cached'), isTrue);
    expect(calls.last.arguments, {'productId': 'Yearly'});
  });

  test(
    'purchase success without a current entitlement cannot unlock',
    () async {
      purchaseGrantsAccess = false;
      await service.init();
      final offer = (await service.plans()).last;
      expect(await service.purchase(offer), PurchaseOutcome.failed);
      expect(service.status.isPremium, isFalse);
    },
  );

  for (final state in ['cancelled', 'pending']) {
    test('$state purchase does not grant Premium', () async {
      purchaseState = state;
      await service.init();
      final offer = (await service.plans()).last;
      expect(
        await service.purchase(offer),
        state == 'pending'
            ? PurchaseOutcome.pending
            : PurchaseOutcome.cancelled,
      );
      expect(service.status.isPremium, isFalse);
    });
  }

  test('delayed approval grants access; expiry/refund removes it', () async {
    await service.init();
    await notify(snapshot(['Yearly'], 2));
    expect(service.status.isPremium, isTrue);
    await notify(snapshot([], 3));
    expect(service.status.isPremium, isFalse);
    expect(prefs.getBool('premium_cached'), isFalse);
  });

  test('older response cannot undo a newer transaction update', () async {
    await service.init();
    await notify(snapshot(['Yearly'], 5));
    await notify(snapshot([], 4));
    expect(service.status.isPremium, isTrue);
  });

  test('unknown products and malformed messages never grant access', () async {
    await service.init();
    await notify(snapshot(['yearly', 'other'], 2));
    await notify({
      'productIds': ['Yearly'],
    });
    expect(service.status.isPremium, isFalse);
  });

  test('restore explicitly invokes native App Store sync path', () async {
    await service.init();
    active = snapshot(['monthly'], 3);
    expect(await service.restore(), RestoreOutcome.restored);
    expect(calls.last.method, 'restore');
    active = snapshot([], 4);
    expect(await service.restore(), RestoreOutcome.nothingToRestore);
    expect(service.status.isPremium, isFalse);
  });

  test(
    'empty store products leave the existing unavailable UI in control',
    () async {
      await service.init();
      messenger.setMockMethodCallHandler(channel, (_) async => []);
      expect(await service.plans(), isEmpty);
    },
  );

  test(
    'store failures return failure instead of claiming an empty restore',
    () async {
      await service.init();
      final offer = (await service.plans()).first;
      storeFails = true;
      expect(await service.purchase(offer), PurchaseOutcome.failed);
      expect(await service.restore(), RestoreOutcome.failed);
      expect(await service.plans(), isEmpty);
    },
  );

  test(
    'a cached Premium is cleared when Apple reports no entitlement',
    () async {
      await prefs.setBool('premium_cached', true);
      // Construct after the cache has been set.
      service.dispose();
      service = StoreKitPurchaseService(
        container.read(settingsRepositoryProvider),
      );
      expect(service.status.isPremium, isTrue);
      final changed = service.statusStream.first;
      await service.init();
      expect((await changed).isPremium, isFalse);
      expect(prefs.getBool('premium_cached'), isFalse);
    },
  );
}
