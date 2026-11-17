part of 'purchase_service.dart';

/// StoreKit 2 verifies Apple-signed transactions on-device. Only the native
/// bridge's current entitlements grant Premium; a purchase result alone cannot.
class StoreKitPurchaseService implements PurchaseService {
  StoreKitPurchaseService(
    this._settings, {
    MethodChannel? channel,
    String? monthlyId,
    String? yearlyId,
  }) : _channel = channel ?? const MethodChannel(channelName),
       monthlyId = monthlyId ?? Env.iapProductMonthlyIos,
       yearlyId = yearlyId ?? Env.iapProductYearlyIos,
       _status = PremiumStatus(isPremium: _settings.premiumCached);

  static const String channelName = 'com.avs.gpsareameasurement/storekit';
  static const String _managementUrl =
      'https://apps.apple.com/account/subscriptions';

  final SettingsRepository _settings;
  final MethodChannel _channel;
  final String monthlyId;
  final String yearlyId;
  final StreamController<PremiumStatus> _changes = StreamController.broadcast();
  PremiumStatus _status;
  AppLifecycleListener? _lifecycle;
  bool _started = false;
  bool _disposed = false;
  int _revision = -1;

  List<String> get _productIds => [monthlyId, yearlyId];

  @override
  bool get isAvailable => _started && !_disposed;

  @override
  PremiumStatus get status => _status;

  @override
  Stream<PremiumStatus> get statusStream => _changes.stream;

  @override
  Future<void> init() async {
    if (_started || _disposed) return;
    _started = true;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'entitlementChanged') _apply(call.arguments);
    });
    _lifecycle = AppLifecycleListener(onResume: () => unawaited(_sync()));
    unawaited(_sync());
  }

  Future<bool> _sync() async {
    try {
      _apply(
        await _channel.invokeMethod<Object?>(
          'queryActive',
          {'ids': _productIds},
        ),
      );
      return true;
    } on PlatformException catch (e, st) {
      Log.w('StoreKit: entitlement check failed (${e.code})', e, st);
    } on MissingPluginException {
      Log.w('StoreKit channel missing');
    }
    return false;
  }

  void _apply(Object? raw) {
    if (_disposed || raw is! Map) return;
    final revision = raw['revision'];
    final ids = raw['productIds'];
    if (revision is! int || revision < _revision || ids is! List) return;
    _revision = revision;
    final premium = ids.any(_productIds.contains);
    final next = premium
        ? const PremiumStatus(isPremium: true, managementUrl: _managementUrl)
        : PremiumStatus.free;
    // Clear a cached entitlement even when the visible state is already free.
    unawaited(_settings.setPremiumCached(premium: premium));
    if (next.isPremium == _status.isPremium &&
        next.managementUrl == _status.managementUrl) {
      return;
    }
    _status = next;
    _changes.add(next);
  }

  @override
  Future<List<PlanOffer>> plans() async {
    if (!isAvailable) return const [];
    try {
      final raw = await _channel.invokeListMethod<Map<Object?, Object?>>(
        'queryProducts',
        {'ids': _productIds},
      );
      final products = {
        for (final product in raw ?? <Map<Object?, Object?>>[])
          product['productId']: product,
      };
      PlanOffer? offer(PremiumPlan plan, String id) {
        final product = products[id];
        if (product == null) {
          Log.w('StoreKit: App Store returned no product for "$id"');
          return null;
        }
        return PlanOffer(
          plan: plan,
          price: product['price']! as String,
          priceAmount: (product['priceAmount']! as num).toDouble(),
          currencyCode: product['currency']! as String,
          trialDays: product['trialDays'] as int?,
          handle: id,
        );
      }

      return [
        ?offer(PremiumPlan.monthly, monthlyId),
        ?offer(PremiumPlan.annual, yearlyId),
      ];
    } on PlatformException catch (e, st) {
      Log.w('StoreKit: products failed (${e.code})', e, st);
    } on MissingPluginException {
      Log.w('StoreKit channel missing');
    }
    return const [];
  }

  @override
  Future<PurchaseOutcome> purchase(PlanOffer offer) async {
    final id = offer.handle;
    if (!isAvailable || id is! String || !_productIds.contains(id)) {
      return PurchaseOutcome.failed;
    }
    try {
      final result = await _channel.invokeMapMethod<String, Object?>(
        'purchase',
        {'productId': id},
      );
      if (result?['state'] == 'purchased') {
        _apply(result?['entitlement']);
        return _status.isPremium
            ? PurchaseOutcome.purchased
            : PurchaseOutcome.failed;
      }
      return switch (result?['state']) {
        'cancelled' => PurchaseOutcome.cancelled,
        'pending' => PurchaseOutcome.pending,
        _ => PurchaseOutcome.failed,
      };
    } on PlatformException catch (e, st) {
      Log.w('StoreKit: purchase failed (${e.code})', e, st);
    } on MissingPluginException {
      Log.w('StoreKit channel missing');
    }
    return PurchaseOutcome.failed;
  }

  @override
  Future<RestoreOutcome> restore() async {
    if (!isAvailable) return RestoreOutcome.failed;
    try {
      _apply(
        await _channel.invokeMethod<Object?>(
          'restore',
          {'ids': _productIds},
        ),
      );
      return _status.isPremium
          ? RestoreOutcome.restored
          : RestoreOutcome.nothingToRestore;
    } on PlatformException catch (e, st) {
      Log.w('StoreKit: restore failed (${e.code})', e, st);
    } on MissingPluginException {
      Log.w('StoreKit channel missing');
    }
    return RestoreOutcome.failed;
  }

  void dispose() {
    _disposed = true;
    _lifecycle?.dispose();
    _channel.setMethodCallHandler(null);
    unawaited(_changes.close());
  }
}
