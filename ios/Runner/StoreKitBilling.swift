import Flutter
import StoreKit

/// App-lifetime StoreKit 2 bridge. No shared secret or server credentials
/// belong in the app: StoreKit verifies Apple's signed transactions locally.
@MainActor
final class StoreKitBilling {
  private let channel: FlutterMethodChannel
  private var productIDs = Set<String>()
  private var products: [String: Product] = [:]
  private var updates: Task<Void, Never>?
  private var refreshTimer: Task<Void, Never>?
  private var revision = 0
  private var purchasing = false

  init(messenger: FlutterBinaryMessenger) {
    channel = FlutterMethodChannel(
      name: "com.avs.gpsareameasurement/storekit", binaryMessenger: messenger
    )
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else { return }
      Task { @MainActor in
        do {
          let arguments = call.arguments as? [String: Any] ?? [:]
          switch call.method {
          case "queryActive":
            try self.configure(arguments)
            result(await self.refreshEntitlements())
          case "queryProducts":
            try self.configure(arguments)
            result(try await self.queryProducts())
          case "purchase":
            guard let id = arguments["productId"] as? String,
                  self.productIDs.contains(id) else {
              throw BillingError.invalidProduct
            }
            result(try await self.purchase(id))
          case "restore":
            try self.configure(arguments)
            // Only an explicit Restore action may prompt for App Store login.
            try await AppStore.sync()
            result(await self.refreshEntitlements())
          default:
            result(FlutterMethodNotImplemented)
          }
        } catch {
          NSLog("LandMeasure StoreKit: %@", String(describing: error))
          result(FlutterError(
            code: "storekit_error", message: error.localizedDescription, details: nil
          ))
        }
      }
    }
  }

  deinit {
    updates?.cancel()
    refreshTimer?.cancel()
  }

  private func configure(_ arguments: [String: Any]) throws {
    guard let ids = arguments["ids"] as? [String],
          ids.count == 2, Set(ids).count == 2,
          ids.allSatisfy({ !$0.isEmpty }) else {
      throw BillingError.invalidProduct
    }
    let requested = Set(ids)
    guard productIDs.isEmpty || requested == productIDs else {
      throw BillingError.invalidProduct
    }
    productIDs = requested
    guard updates == nil else { return }
    updates = Task { [weak self] in
      // Start before the initial entitlement read, so delayed approvals and
      // renewals cannot be missed while the app is launching.
      for await update in Transaction.updates {
        guard !Task.isCancelled, let self else { return }
        guard case .verified(let transaction) = update else {
          NSLog("LandMeasure StoreKit: ignored unverified transaction update")
          continue
        }
        guard self.productIDs.contains(transaction.productID),
              transaction.productType == .autoRenewable else { continue }
        _ = await self.refreshEntitlements()
        // Deliver/revoke the entitlement before finishing the transaction.
        await transaction.finish()
      }
    }
    refreshTimer = Task { [weak self] in
      // Expiry can occur while the paywall/app remains open with no update.
      // StoreKit reads local entitlements; this does not prompt or sync/login.
      while !Task.isCancelled {
        do { try await Task.sleep(nanoseconds: 60_000_000_000) }
        catch { return }
        guard let self else { return }
        _ = await self.refreshEntitlements()
      }
    }
  }

  private func refreshEntitlements() async -> [String: Any] {
    revision += 1
    let currentRevision = revision
    var owned = Set<String>()
    var delivered: [Transaction] = []
    for await verification in Transaction.currentEntitlements {
      guard case .verified(let transaction) = verification else {
        NSLog("LandMeasure StoreKit: ignored unverified entitlement")
        continue
      }
      guard productIDs.contains(transaction.productID),
            transaction.productType == .autoRenewable,
            transaction.revocationDate == nil, !transaction.isUpgraded else { continue }
      // currentEntitlements includes subscribed and billing grace-period
      // access, excludes expired/revoked subscriptions. Do not reject a grace
      // period merely because the transaction's expirationDate is in the past.
      owned.insert(transaction.productID)
      delivered.append(transaction)
    }
    let snapshot: [String: Any] = [
      "productIds": owned.sorted(), "revision": currentRevision
    ]
    if currentRevision == revision {
      channel.invokeMethod("entitlementChanged", arguments: snapshot)
    }
    // Also completes verified unfinished purchases delivered on app relaunch.
    for transaction in delivered { await transaction.finish() }
    return snapshot
  }

  private func queryProducts() async throws -> [[String: Any]] {
    let fetched = try await Product.products(for: productIDs)
    products = Dictionary(uniqueKeysWithValues: fetched.filter {
      $0.type == .autoRenewable
    }.map { ($0.id, $0) })
    let missing = productIDs.subtracting(products.keys)
    if !missing.isEmpty {
      NSLog("LandMeasure StoreKit: products not returned: %@", missing.sorted().joined(separator: ", "))
    }
    var offers: [[String: Any]] = []
    for product in products.values {
      var offer: [String: Any] = [
        "productId": product.id,
        "price": product.displayPrice,
        "priceAmount": NSDecimalNumber(decimal: product.price).doubleValue,
        "currency": product.priceFormatStyle.currencyCode
      ]
      if let subscription = product.subscription,
         let intro = subscription.introductoryOffer,
         intro.paymentMode == .freeTrial,
         await subscription.isEligibleForIntroOffer {
        // The shared paywall expresses day/week trials in days. Calendar
        // month/year trials must not be advertised as an invented day count.
        switch intro.period.unit {
        case .day: offer["trialDays"] = intro.period.value * intro.periodCount
        case .week: offer["trialDays"] = intro.period.value * intro.periodCount * 7
        default: break
        }
      }
      offers.append(offer)
    }
    return offers
  }

  private func purchase(_ id: String) async throws -> [String: Any] {
    guard !purchasing else { throw BillingError.purchaseInProgress }
    purchasing = true
    defer { purchasing = false }
    // Re-fetch to use current pricing/offers and let Apple decide eligibility.
    guard let product = try await Product.products(for: [id]).first,
          product.type == .autoRenewable else { throw BillingError.invalidProduct }
    switch try await product.purchase() {
    case .success(let verification):
      guard case .verified(let transaction) = verification,
            productIDs.contains(transaction.productID),
            transaction.productType == .autoRenewable else {
        throw BillingError.unverified
      }
      let entitlement = await refreshEntitlements()
      await transaction.finish()
      return ["state": "purchased", "entitlement": entitlement]
    case .pending:
      return ["state": "pending"]
    case .userCancelled:
      return ["state": "cancelled"]
    @unknown default:
      return ["state": "failed"]
    }
  }

  private enum BillingError: LocalizedError {
    case invalidProduct, unverified, purchaseInProgress

    var errorDescription: String? {
      switch self {
      case .invalidProduct: return "Subscription product is unavailable."
      case .unverified: return "The App Store transaction could not be verified."
      case .purchaseInProgress: return "Another purchase is in progress."
      }
    }
  }
}
