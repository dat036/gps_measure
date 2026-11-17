import Flutter
import GoogleMaps
import UIKit
import google_mobile_ads

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var storeKitBilling: StoreKitBilling?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // MapsApiKey is populated from the flavor's dart-defines at build time.
    // Google Maps requires initialization before Flutter creates a map view.
    if let apiKey = Bundle.main.object(forInfoDictionaryKey: "MapsApiKey") as? String,
       !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      GMSServices.provideAPIKey(apiKey)
    } else {
      NSLog("LandMeasure: MAPS_API_KEY_IOS is missing from the build configuration.")
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "LandMeasureStoreKit") {
      storeKitBilling = StoreKitBilling(messenger: registrar.messenger())
    }
    for layout in LmNativeAdFactory.Layout.allCases {
      FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
        engineBridge.pluginRegistry,
        factoryId: layout.rawValue,
        nativeAdFactory: LmNativeAdFactory(layout: layout)
      )
    }
  }
}
