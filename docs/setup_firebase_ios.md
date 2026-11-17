# Firebase iOS

Production Firebase configuration is omitted from this public snapshot.
Download your own plist for `com.avs.gpsareameasurement` and place it at
`ios/Runner/GoogleService-Info.plist` (gitignored). The adjacent example plist
contains placeholders only.

## Build integration

- `ios/Runner/GoogleService-Info.plist` is visible in the Runner group. It is
  deliberately **not** an unconditional Copy Bundle Resources item.
- The Configure Firebase build phase validates `BUNDLE_ID`, then copies it into
  the built app for `*-prod` configurations only. Dev/staging omit it; register
  their `.dev`/`.stg` bundle IDs separately before enabling Firebase there.
- `Firebase.initializeApp()` already runs in `CrashReporter.init()` at startup.
  Native `FirebaseApp.configure()` must not be added as a second initializer.
- Native Analytics/Crashlytics collection defaults to off until the existing
  Dart initialization applies the environment's policy. Crashlytics collects
  for non-debug prod; Analytics collects for prod and debug builds where
  Firebase is configured. Flutter screen tracking supplies `screen_view`, so
  automatic native screen reporting is off.
- FCM auto-init is off. This change configures Analytics/Crashlytics, not push;
  push still needs APNs credentials/capabilities and the notification flow.

## Crashlytics symbols

Upload Crashlytics Symbols is the last Runner build phase. `Release-prod`
uses the complete Xcode input file list (app dSYM/DWARF/Info.plist, bundled
Firebase plist, executable); other configurations use an empty list.
Release already generates `dwarf-with-dsym` and User Script Sandboxing is off.

The upload wrapper locates Firebase's SDK tools through Swift Package Manager
in the build's own DerivedData directory, with a CocoaPods fallback. Unsigned
builds run the official tool's synchronous **validation only**, without upload.
Signed prod release builds run Firebase's `run` script: it validates, then
uploads in the background. A passing build confirms validation, not delivery
to Firebase. Check the Console for missing dSYMs after archive/upload.

The client Firebase config is not a service-account credential. Keep service
account keys and App Store Connect credentials out of this file/project.

## Runtime validation

1. Run a prod debug build to inspect the `Firebase initialized` entry in the
   Dart developer log, then navigate between screens. Release/TestFlight
   suppresses informational logs; verify its data on the Firebase Console.
2. Analytics: enable Google Analytics for the project/iOS stream if necessary.
   DebugView on iOS uses the Xcode launch argument `-FIRDebugEnabled`; remove it
   from normal release runs. The downloaded plist's `IS_ANALYTICS_ENABLED`
   value is kept unchanged; actual Console ingestion still needs verification.
3. Crashlytics: use a controlled test build to record a test error/crash; stop
   the Xcode debugger for a native crash, then reopen the app to send the report.
   Debug builds intentionally disable Crashlytics collection, so test the
   production release policy or explicitly enable it in a temporary test build.
4. Confirm the event/crash belongs to the **iOS** Firebase app and that stack
   traces are symbolicated. Do not leave a forced crash in release code.

No forced crash or remote Console access is part of this setup. App Privacy
and the published privacy policy must reflect the enabled Firebase SDKs.

## Local verification (22/10/2026)

- Unsigned prod release build passed; the built app contains the expected
  Firebase project/Bundle ID and native collection defaults.
- Firebase's `upload-symbols --validate` accepted the release dSYM/config.
  This is validation only, not confirmation of remote symbol ingestion.
- Prod debug build launched on the iPhone 17 simulator. Native logs confirm
  Firebase Analytics and Crashlytics initialized, then Analytics collection
  enabled by Dart. Crashlytics collection remains off under the debug policy.
- Startup logs warn that Meta's `FBSDKExceptionHandler` is also installed.
  Native crash capture/symbolication still needs a controlled release-device
  test; no deliberate crash was triggered during setup.
- The screen tracker test, shell syntax checks, and targeted Dart analyzer
  passed. Script checks covered Bundle ID rejection, non-prod exclusion,
  paths with spaces, and signed/unsigned symbol-tool branches using stubs.

Console Analytics/Crashlytics delivery, a signed release/archive, and a real
iPhone crash report have not been verified by these local checks.

Official documentation:

- [Firebase Apple setup](https://firebase.google.com/docs/ios/setup)
- [Flutter Crashlytics setup](https://firebase.google.com/docs/crashlytics/flutter/get-started)
- [Crashlytics symbols and Xcode input files](https://firebase.google.com/docs/crashlytics/ios/get-deobfuscated-reports)
