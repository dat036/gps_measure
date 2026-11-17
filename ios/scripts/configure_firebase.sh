#!/bin/sh
set -eu

destination="${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/GoogleService-Info.plist"
case "${CONFIGURATION}" in
  *-prod) ;;
  *)
    # Each iOS bundle ID needs its own registered Firebase app/config.
    rm -f "$destination"
    echo "Firebase: no configuration supplied for ${CONFIGURATION}; skipping."
    exit 0
    ;;
esac

source_plist="${SRCROOT}/Runner/GoogleService-Info.plist"
configured_bundle=$(/usr/libexec/PlistBuddy -c 'Print :BUNDLE_ID' "$source_plist")
if [ "$configured_bundle" != "${PRODUCT_BUNDLE_IDENTIFIER}" ]; then
  echo "error: Firebase BUNDLE_ID does not match PRODUCT_BUNDLE_IDENTIFIER."
  exit 1
fi
/bin/mkdir -p "$(dirname "$destination")"
/bin/cp "$source_plist" "$destination"
echo "Firebase: configured ${PRODUCT_BUNDLE_IDENTIFIER}."
