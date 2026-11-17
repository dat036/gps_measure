#!/bin/sh
set -eu

if [ "${CONFIGURATION}" != "Release-prod" ] || [ "${PLATFORM_NAME}" != "iphoneos" ]; then
  echo "Crashlytics: symbol upload only runs for Release-prod on iphoneos."
  exit 0
fi

# Flutter currently resolves Firebase through Swift Package Manager. Keep the
# CocoaPods path as a fallback if the project's dependency integration changes.
if [ -f "${PODS_ROOT}/FirebaseCrashlytics/run" ]; then
  crashlytics_dir="${PODS_ROOT}/FirebaseCrashlytics"
else
  derived_data="${BUILD_DIR%%/Build/*}"
  crashlytics_dir="${derived_data}/SourcePackages/checkouts/firebase-ios-sdk/Crashlytics"
fi
if [ ! -f "${crashlytics_dir}/run" ]; then
  echo "error: FirebaseCrashlytics symbol tools are missing. Resolve Xcode packages/Pods first."
  exit 1
fi

if [ "${CODE_SIGNING_ALLOWED:-YES}" = "NO" ]; then
  # Local unsigned validation must not be reported as a successful upload.
  "${crashlytics_dir}/upload-symbols" --build-phase --validate
  echo "Crashlytics: symbol configuration validated; unsigned build, no upload."
else
  # Firebase validates synchronously, then schedules upload in the background.
  "${crashlytics_dir}/run"
fi
