import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show AppLifecycleListener;
import 'package:gps_measurement/core/config/env.dart';
import 'package:gps_measurement/core/utils/logger.dart' show Log;
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'purchase_service.g.dart';
part 'storekit_purchase_service.dart';

/// Plans on the paywall, in display order: monthly (with the free trial)
/// then yearly.
enum PremiumPlan { monthly, annual }

/// A purchasable plan with store-localized prices.
@immutable
class PlanOffer {
  const PlanOffer({
    required this.plan,
    required this.price,
    required this.priceAmount,
    required this.currencyCode,
    this.trialDays,
    this.handle,
  });

  final PremiumPlan plan;

  /// "299.000 ₫" — as the store formats it.
  final String price;

  /// The price as a number (for "per week" arithmetic) and its ISO 4217
  /// currency.
  final double priceAmount;
  final String currencyCode;

  /// Free trial length when the user is still eligible.
  final int? trialDays;

  /// The store package; opaque outside the service.
  final Object? handle;
}

enum PurchaseOutcome { purchased, cancelled, pending, failed }

enum RestoreOutcome { restored, nothingToRestore, failed }

/// The `premium` entitlement right now.
@immutable
class PremiumStatus {
  const PremiumStatus({
    required this.isPremium,
    this.isLifetime = false,
    this.managementUrl,
  });

  static const PremiumStatus free = PremiumStatus(isPremium: false);

  final bool isPremium;
  final bool isLifetime;

  /// Store page to cancel/change the subscription.
  final String? managementUrl;
}

/// In-app purchases behind one interface (`architecture.md` §2 rule 5,
/// §11). Google Play Billing on Android, StoreKit 2 on iOS.
abstract interface class PurchaseService {
  /// Starts store observation without waiting on a network response.
  Future<void> init();

  /// False when billing has not been initialized on a supported platform.
  bool get isAvailable;

  PremiumStatus get status;

  /// Emits on every entitlement change (purchase, restore, expiry).
  Stream<PremiumStatus> get statusStream;

  /// Plans of the `default` offering, or empty when the store is not
  /// reachable.
  Future<List<PlanOffer>> plans();

  Future<PurchaseOutcome> purchase(PlanOffer offer);

  Future<RestoreOutcome> restore();
}

/// ISO 8601 billing period ("P3D", "P1W") in days; null for months/years
/// (only trials are measured in days).
@visibleForTesting
int? periodDays(String? iso) {
  final m = RegExp(r'^P(?:(\d+)W)?(?:(\d+)D)?$').firstMatch(iso ?? '');
  if (m == null || (m.group(1) == null && m.group(2) == null)) return null;
  return (int.tryParse(m.group(1) ?? '') ?? 0) * 7 +
      (int.tryParse(m.group(2) ?? '') ?? 0);
}

/// Subscriptions through Google Play Billing Library 9, talking to
/// `PlayBilling.kt` over a [MethodChannel]. No backend and no account: the
/// entitlement is "an active purchase of one of [productIds] on this Google
/// account", read from Play on start, on every return to the app and after
/// each purchase. Android only; elsewhere the app runs as free.
class PlayBillingPurchaseService implements PurchaseService {
  PlayBillingPurchaseService(
    this._settings, {
    MethodChannel? channel,
    String? monthlyId,
    String? yearlyId,
    bool? android,
  }) : _channel = channel ?? const MethodChannel(channelName),
       monthlyId = monthlyId ?? Env.iapProductMonthly,
       yearlyId = yearlyId ?? Env.iapProductYearly,
       _android = android ?? defaultTargetPlatform == TargetPlatform.android,
       _status = PremiumStatus(isPremium: _settings.premiumCached);

  static const String channelName = 'com.avs.gpsareameasurement/billing';

  final SettingsRepository _settings;
  final MethodChannel _channel;
  final String monthlyId;
  final String yearlyId;
  final bool _android;

  List<String> get productIds => [monthlyId, yearlyId];
  final StreamController<PremiumStatus> _changes = StreamController.broadcast();
  PremiumStatus _status;
  String? _package;
  bool _started = false;
  AppLifecycleListener? _lifecycle;

  @override
  bool get isAvailable => _started;

  @override
  PremiumStatus get status => _status;

  @override
  Stream<PremiumStatus> get statusStream => _changes.stream;

  @override
  Future<void> init() async {
    if (!_android || _started) return;
    _started = true;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'entitlementChanged') _apply(call.arguments);
    });
    // Subscriptions expire or are cancelled outside the app.
    _lifecycle = AppLifecycleListener(onResume: () => unawaited(_sync()));
    // Not awaited: the first frame never waits on Google Play.
    unawaited(_sync());
  }

  Future<void> _sync() async {
    try {
      _apply(await _channel.invokeMethod<Object?>('queryActive'));
    } on PlatformException catch (e, st) {
      Log.w('Play Billing: entitlement check failed (${e.code})', e, st);
    } on MissingPluginException {
      Log.w('Play Billing channel missing: running as free');
    }
  }

  void _apply(Object? raw) {
    if (raw is! Map) return;
    _package = raw['package'] as String? ?? _package;
    final owned = (raw['productIds'] as List?)?.cast<String>() ?? const [];
    final premium = owned.any(productIds.contains);
    final next = premium
        ? PremiumStatus(isPremium: true, managementUrl: _manageUrl)
        : PremiumStatus.free;
    if (next.isPremium == _status.isPremium &&
        next.managementUrl == _status.managementUrl) {
      return;
    }
    _status = next;
    unawaited(_settings.setPremiumCached(premium: next.isPremium));
    _changes.add(next);
  }

  String? get _manageUrl {
    final pkg = _package;
    return pkg == null
        ? null
        : 'https://play.google.com/store/account/subscriptions?package=$pkg';
  }

  @override
  Future<List<PlanOffer>> plans() async {
    if (!_android) return const [];
    try {
      final raw = await _channel.invokeListMethod<Map<Object?, Object?>>(
        'queryProducts',
        {'ids': productIds},
      );
      final byId = <Object?, Map<Object?, Object?>>{
        for (final m in raw ?? const <Map<Object?, Object?>>[])
          m['productId']: m,
      };
      PlanOffer? offerOf(PremiumPlan plan, String id) {
        final m = byId[id];
        if (m == null) return null;
        return PlanOffer(
          plan: plan,
          price: m['price']! as String,
          priceAmount: (m['priceMicros']! as num) / 1000000,
          currencyCode: m['currency']! as String,
          trialDays: periodDays(m['trialPeriod'] as String?),
          handle: (productId: id, offerToken: m['offerToken']! as String),
        );
      }

      return [
        ?offerOf(PremiumPlan.monthly, monthlyId),
        ?offerOf(PremiumPlan.annual, yearlyId),
      ];
    } on PlatformException catch (e, st) {
      Log.w('Play Billing: products failed (${e.code})', e, st);
      return const [];
    } on MissingPluginException {
      return const [];
    }
  }

  @override
  Future<PurchaseOutcome> purchase(PlanOffer offer) async {
    final handle = offer.handle;
    if (!_started || handle is! ({String productId, String offerToken})) {
      return PurchaseOutcome.failed;
    }
    try {
      final result = await _channel.invokeMapMethod<String, Object?>(
        'purchase',
        {'productId': handle.productId, 'offerToken': handle.offerToken},
      );
      return switch (result?['state']) {
        'purchased' => PurchaseOutcome.purchased,
        'pending' => PurchaseOutcome.pending,
        'cancelled' => PurchaseOutcome.cancelled, // Silent (P11-02).
        'owned' => await _ownedAlready(),
        _ => PurchaseOutcome.failed,
      };
    } on PlatformException catch (e, st) {
      Log.w('Purchase failed (${e.code})', e, st);
      return PurchaseOutcome.failed;
    }
  }

  /// Play says this account already owns it: refresh and treat as bought.
  Future<PurchaseOutcome> _ownedAlready() async {
    await _sync();
    return _status.isPremium
        ? PurchaseOutcome.purchased
        : PurchaseOutcome.failed;
  }

  @override
  Future<RestoreOutcome> restore() async {
    if (!_started) return RestoreOutcome.failed;
    try {
      _apply(await _channel.invokeMethod<Object?>('queryActive'));
      return _status.isPremium
          ? RestoreOutcome.restored
          : RestoreOutcome.nothingToRestore;
    } on PlatformException catch (e, st) {
      Log.w('Restore failed (${e.code})', e, st);
      return RestoreOutcome.failed;
    }
  }

  void dispose() {
    _lifecycle?.dispose();
    unawaited(_changes.close());
  }
}

@Riverpod(keepAlive: true)
PurchaseService purchaseService(Ref ref) {
  final settings = ref.watch(settingsRepositoryProvider);
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    final service = StoreKitPurchaseService(settings);
    ref.onDispose(service.dispose);
    return service;
  }
  final service = PlayBillingPurchaseService(settings);
  ref.onDispose(service.dispose);
  return service;
}

/// Source of truth for "is premium" in the UI (`architecture.md` §11).
@Riverpod(keepAlive: true)
class Premium extends _$Premium {
  StreamSubscription<PremiumStatus>? _sub;

  @override
  PremiumStatus build() {
    final service = ref.watch(purchaseServiceProvider);
    _sub = service.statusStream.listen((s) => state = s);
    ref.onDispose(() => _sub?.cancel());
    return service.status;
  }
}
