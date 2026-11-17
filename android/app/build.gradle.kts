import java.io.FileInputStream
import java.util.Base64
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // Firebase: reads android/app/google-services.json (one app for every flavor).
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Values passed via `--dart-define` / `--dart-define-from-file=env/<flavor>.json`
// arrive as a comma-separated list of base64 "KEY=VALUE" entries.
val dartDefines: Map<String, String> =
    (project.findProperty("dart-defines") as String?)
        ?.split(",")
        ?.filter { it.isNotBlank() }
        ?.associate { entry ->
            val decoded = String(Base64.getDecoder().decode(entry), Charsets.UTF_8)
            val key = decoded.substringBefore("=")
            key to decoded.substringAfter("=", "")
        }
        ?: emptyMap()

// Release signing: android/key.properties (gitignored), see docs/android_release.md.
// Without it, release builds fall back to the debug key (fine for local testing,
// NOT uploadable to Play).
val keystoreProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) FileInputStream(file).use { load(it) }
}
val hasReleaseKeystore = keystoreProperties.getProperty("storeFile") != null

// Google's public AdMob test app ID — the Ads SDK crashes on launch without an app ID.
val admobTestAppId = "ca-app-pub-3940256099942544~3347511713"

// The Meta SDK throws on init without a valid app ID, so builds without
// FACEBOOK_APP_ID_ANDROID get a placeholder. The Dart side never activates the
// SDK when the ID is empty, and auto-init/auto-log are off in the manifest.
val facebookPlaceholderAppId = "000000000000000"

android {
    namespace = "com.avs.gpsareameasurement"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.avs.gpsareameasurement"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        manifestPlaceholders["mapsApiKey"] = dartDefines["MAPS_API_KEY_ANDROID"] ?: ""
        manifestPlaceholders["admobAppId"] =
            dartDefines["ADMOB_APP_ID_ANDROID"]?.takeIf { it.isNotBlank() } ?: admobTestAppId
        // "fb" prefix keeps the value a string (the SDK strips it); a bare numeric
        // ID would be parsed as a number by the manifest merger.
        manifestPlaceholders["facebookAppId"] =
            "fb" + (dartDefines["FACEBOOK_APP_ID_ANDROID"]?.takeIf { it.isNotBlank() }
                ?: facebookPlaceholderAppId)
        manifestPlaceholders["facebookClientToken"] =
            dartDefines["FACEBOOK_CLIENT_TOKEN_ANDROID"] ?: ""
    }

    flavorDimensions += "env"
    productFlavors {
        // dev/staging share the prod applicationId: the Firebase project only has
        // the prod Android app, so a suffix would break google-services.json.
        create("dev") {
            dimension = "env"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "GPS Area Measure Dev")
        }
        create("staging") {
            dimension = "env"
            versionNameSuffix = "-stg"
            resValue("string", "app_name", "GPS Area Measure Stg")
        }
        create("prod") {
            dimension = "env"
            resValue("string", "app_name", "GPS Area Measure: Land & Field")
        }
    }

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                storeFile = file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig =
                if (hasReleaseKeystore) {
                    signingConfigs.getByName("release")
                } else {
                    logger.warn("android/key.properties not found: signing release with the DEBUG key.")
                    signingConfigs.getByName("debug")
                }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
            // Native symbols in the AAB for Play Console / Crashlytics stack traces.
            ndk { debugSymbolLevel = "SYMBOL_TABLE" }
        }
    }
}

dependencies {
    // Google Play Billing Library 9 (subscriptions), used by PlayBilling.kt.
    implementation("com.android.billingclient:billing:9.1.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

flutter {
    source = "../.."
}
