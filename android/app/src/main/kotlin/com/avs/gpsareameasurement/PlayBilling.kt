package com.avs.gpsareameasurement

import android.app.Activity
import com.android.billingclient.api.AcknowledgePurchaseParams
import com.android.billingclient.api.BillingClient
import com.android.billingclient.api.BillingClientStateListener
import com.android.billingclient.api.BillingFlowParams
import com.android.billingclient.api.BillingResult
import com.android.billingclient.api.PendingPurchasesParams
import com.android.billingclient.api.ProductDetails
import com.android.billingclient.api.Purchase
import com.android.billingclient.api.PurchasesUpdatedListener
import com.android.billingclient.api.QueryProductDetailsParams
import com.android.billingclient.api.QueryPurchasesParams
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Google Play Billing Library 9 bridge for the subscriptions (no
 * RevenueCat). Dart side: `PlayBillingPurchaseService`.
 *
 * Channel `com.avs.gpsareameasurement/billing`:
 *  - `queryProducts(ids)`  -> [{productId, offerToken, price, priceMicros,
 *                              currency, period, trialPeriod?}]
 *  - `purchase(productId, offerToken)` -> {state: purchased|pending|
 *                              cancelled|owned|failed}
 *  - `queryActive()`       -> {package, productIds: [..], pending: bool}
 *  - native -> Dart `entitlementChanged({productIds, pending})` whenever
 *    Play reports purchase updates.
 *
 * Every purchase in the PURCHASED state is acknowledged here (Play refunds
 * unacknowledged purchases after 3 days). There is no backend: the
 * entitlement is whatever Play says is active for the signed-in account.
 */
class PlayBilling(
    private val activity: Activity,
    messenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler, PurchasesUpdatedListener {

    private val channel = MethodChannel(messenger, CHANNEL).also {
        it.setMethodCallHandler(this)
    }

    private val client: BillingClient = BillingClient.newBuilder(activity.applicationContext)
        .setListener(this)
        .enablePendingPurchases(
            PendingPurchasesParams.newBuilder().enableOneTimeProducts().build(),
        )
        .enableAutoServiceReconnection()
        .build()

    private val waiting = mutableListOf<(Boolean) -> Unit>()
    private var connecting = false
    private val details = mutableMapOf<String, ProductDetails>()
    private var purchaseResult: MethodChannel.Result? = null

    // ------------------------------------------------------------ channel

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "queryProducts" -> {
                val ids = call.argument<List<String>>("ids") ?: emptyList()
                whenReady(result) { queryProducts(ids, result) }
            }
            "purchase" -> {
                val id = call.argument<String>("productId")
                val token = call.argument<String>("offerToken")
                if (id == null || token == null) {
                    result.error("bad_args", "productId and offerToken are required", null)
                } else {
                    whenReady(result) { purchase(id, token, result) }
                }
            }
            "queryActive" -> whenReady(result) { queryActive(result) }
            else -> result.notImplemented()
        }
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
        purchaseResult = null
        if (client.isReady) client.endConnection()
    }

    // --------------------------------------------------------- connection

    /** Runs [action] once the client is connected, else answers with an error. */
    private fun whenReady(result: MethodChannel.Result, action: () -> Unit) {
        if (client.isReady) {
            action()
            return
        }
        waiting += { ok ->
            if (ok) action() else result.error("unavailable", "Google Play Billing is not available", null)
        }
        if (connecting) return
        connecting = true
        client.startConnection(object : BillingClientStateListener {
            override fun onBillingSetupFinished(billingResult: BillingResult) {
                connecting = false
                val ok = billingResult.responseCode == BillingClient.BillingResponseCode.OK
                val callbacks = waiting.toList()
                waiting.clear()
                callbacks.forEach { it(ok) }
            }

            // Auto service reconnection is enabled: nothing to do.
            override fun onBillingServiceDisconnected() {}
        })
    }

    // ----------------------------------------------------------- products

    private fun queryProducts(ids: List<String>, result: MethodChannel.Result) {
        val products = ids.map {
            QueryProductDetailsParams.Product.newBuilder()
                .setProductId(it)
                .setProductType(BillingClient.ProductType.SUBS)
                .build()
        }
        if (products.isEmpty()) {
            result.success(emptyList<Map<String, Any?>>())
            return
        }
        val params = QueryProductDetailsParams.newBuilder().setProductList(products).build()
        client.queryProductDetailsAsync(params) { billingResult, queryResult ->
            if (billingResult.responseCode != BillingClient.BillingResponseCode.OK) {
                result.error("query_failed", billingResult.debugMessage, billingResult.responseCode)
                return@queryProductDetailsAsync
            }
            val list = queryResult.productDetailsList.mapNotNull { pd ->
                describe(pd)?.also { details[pd.productId] = pd }
            }
            result.success(list)
        }
    }

    /**
     * One entry per product: the offer with a free trial when Play returns
     * one (it only lists offers the user is eligible for), else the plain
     * base plan. Price = the recurring (last) phase.
     */
    private fun describe(pd: ProductDetails): Map<String, Any?>? {
        val offers = pd.subscriptionOfferDetails ?: return null
        if (offers.isEmpty()) return null
        fun hasTrial(o: ProductDetails.SubscriptionOfferDetails) =
            o.pricingPhases.pricingPhaseList.any { it.priceAmountMicros == 0L }
        val chosen = offers.firstOrNull(::hasTrial)
            ?: offers.firstOrNull { it.offerId == null }
            ?: offers.first()
        val phases = chosen.pricingPhases.pricingPhaseList
        val recurring = phases.last()
        val trial = phases.firstOrNull { it.priceAmountMicros == 0L }
        return mapOf(
            "productId" to pd.productId,
            "offerToken" to chosen.offerToken,
            "price" to recurring.formattedPrice,
            "priceMicros" to recurring.priceAmountMicros,
            "currency" to recurring.priceCurrencyCode,
            "period" to recurring.billingPeriod,
            "trialPeriod" to trial?.billingPeriod,
        )
    }

    // ----------------------------------------------------------- purchase

    private fun purchase(productId: String, offerToken: String, result: MethodChannel.Result) {
        val pd = details[productId]
        if (pd == null) {
            result.error("not_loaded", "Product $productId was not queried", null)
            return
        }
        if (purchaseResult != null) {
            result.success(mapOf("state" to "failed"))
            return
        }
        val flow = BillingFlowParams.newBuilder()
            .setProductDetailsParamsList(
                listOf(
                    BillingFlowParams.ProductDetailsParams.newBuilder()
                        .setProductDetails(pd)
                        .setOfferToken(offerToken)
                        .build(),
                ),
            )
            .build()
        val launched = client.launchBillingFlow(activity, flow)
        if (launched.responseCode == BillingClient.BillingResponseCode.OK) {
            purchaseResult = result // answered in onPurchasesUpdated
        } else {
            result.success(mapOf("state" to stateOf(launched.responseCode)))
        }
    }

    override fun onPurchasesUpdated(billingResult: BillingResult, purchases: MutableList<Purchase>?) {
        val code = billingResult.responseCode
        val list = purchases ?: emptyList()
        if (code == BillingClient.BillingResponseCode.OK) acknowledgeAll(list)
        val state = when {
            code == BillingClient.BillingResponseCode.OK -> when {
                list.any { it.purchaseState == Purchase.PurchaseState.PURCHASED } -> "purchased"
                list.any { it.purchaseState == Purchase.PurchaseState.PENDING } -> "pending"
                else -> "failed"
            }
            else -> stateOf(code)
        }
        purchaseResult?.success(mapOf("state" to state))
        purchaseResult = null
        if (code == BillingClient.BillingResponseCode.OK ||
            code == BillingClient.BillingResponseCode.ITEM_ALREADY_OWNED
        ) {
            // Re-read from Play so Dart gets the whole truth, not a delta.
            queryActive(null)
        }
    }

    private fun stateOf(code: Int): String = when (code) {
        BillingClient.BillingResponseCode.USER_CANCELED -> "cancelled"
        BillingClient.BillingResponseCode.ITEM_ALREADY_OWNED -> "owned"
        else -> "failed"
    }

    // ------------------------------------------------------------- active

    /** Answers [result], or pushes `entitlementChanged` to Dart when null. */
    private fun queryActive(result: MethodChannel.Result?) {
        val params = QueryPurchasesParams.newBuilder()
            .setProductType(BillingClient.ProductType.SUBS)
            .build()
        client.queryPurchasesAsync(params) { billingResult, purchases ->
            if (billingResult.responseCode != BillingClient.BillingResponseCode.OK) {
                result?.error("query_failed", billingResult.debugMessage, billingResult.responseCode)
                return@queryPurchasesAsync
            }
            acknowledgeAll(purchases)
            val body = mapOf(
                "package" to activity.packageName,
                "productIds" to purchases
                    .filter { it.purchaseState == Purchase.PurchaseState.PURCHASED }
                    .flatMap { it.products },
                "pending" to purchases.any { it.purchaseState == Purchase.PurchaseState.PENDING },
            )
            if (result != null) result.success(body) else channel.invokeMethod("entitlementChanged", body)
        }
    }

    private fun acknowledgeAll(purchases: List<Purchase>) {
        for (p in purchases) {
            if (p.purchaseState == Purchase.PurchaseState.PURCHASED && !p.isAcknowledged) {
                client.acknowledgePurchase(
                    AcknowledgePurchaseParams.newBuilder().setPurchaseToken(p.purchaseToken).build(),
                ) { /* Retried on the next queryActive if it failed. */ }
            }
        }
    }

    companion object {
        const val CHANNEL = "com.avs.gpsareameasurement/billing"
    }
}
