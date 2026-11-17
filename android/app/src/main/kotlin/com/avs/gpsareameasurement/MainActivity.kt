package com.avs.gpsareameasurement

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity : FlutterActivity() {

    private var billing: PlayBilling? = null

    // factoryId (see NativeLayout in native_ad_controller.dart) -> layout, framed
    private val nativeFactories = mapOf(
        "lm_native_compact" to Pair(R.layout.lm_native_compact, true),
        "lm_native_medium" to Pair(R.layout.lm_native_medium, true),
        "lm_native_full" to Pair(R.layout.lm_native_full, false),
    )

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        for ((id, spec) in nativeFactories) {
            GoogleMobileAdsPlugin.registerNativeAdFactory(
                flutterEngine,
                id,
                LmNativeAdFactory(this, spec.first, spec.second),
            )
        }
        billing = PlayBilling(this, flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        billing?.dispose()
        billing = null
        for (id in nativeFactories.keys) {
            GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, id)
        }
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
