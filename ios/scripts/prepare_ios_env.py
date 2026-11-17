#!/usr/bin/env python3
"""Prepare persistent per-flavor Xcode configuration from env/<flavor>.json.

Xcode Archive does not receive Flutter CLI dart-defines. Include the generated
file after Generated.xcconfig so both Dart and native SDKs use the same config.
Never print configuration values (which may contain client tokens/API keys).
"""
import argparse
import base64
import json
import os
from pathlib import Path
import sys

NATIVE_KEYS = (
    "ADMOB_APP_ID_IOS",
    "MAPS_API_KEY_IOS",
    "FACEBOOK_APP_ID_IOS",
    "FACEBOOK_CLIENT_TOKEN_IOS",
)


def config_string(value):
    return value if isinstance(value, str) else json.dumps(value, separators=(",", ":"))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("flavor", choices=("dev", "staging", "prod"))
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[2]
    source = root / "env" / (args.flavor + ".json")
    destination = root / "ios" / "Flutter" / ("Environment-" + args.flavor + ".xcconfig")
    if not source.is_file():
        raise ValueError("Missing env/" + args.flavor + ".json")
    config = {key: config_string(value) for key, value in json.loads(source.read_text()).items()}
    if config.get("FLAVOR") != args.flavor:
        raise ValueError("FLAVOR does not match the selected Xcode configuration")
    if args.flavor == "prod":
        for key in NATIVE_KEYS:
            if not config.get(key, "").strip():
                raise ValueError("Missing production setting: " + key)
    facebook_id = config.get("FACEBOOK_APP_ID_IOS", "")
    if facebook_id and not facebook_id.isdigit():
        raise ValueError("FACEBOOK_APP_ID_IOS must contain only digits")
    if bool(facebook_id) != bool(config.get("FACEBOOK_CLIENT_TOKEN_IOS")):
        raise ValueError("Facebook App ID and client token must be configured together")

    if args.check:
        actual = {}
        for item in os.environ.get("DART_DEFINES", "").split(","):
            if item:
                key, value = base64.b64decode(item, validate=True).decode().split("=", 1)
                actual[key] = value
        missing = [key for key, value in config.items() if actual.get(key) != value]
        missing += [key for key in NATIVE_KEYS if os.environ.get(key, "") != config.get(key, "")]
        if missing:
            raise ValueError(
                "Xcode configuration is missing/stale for: " + ", ".join(sorted(set(missing)))
                + ". Run: python3 ios/scripts/prepare_ios_env.py " + args.flavor
                + "; then reopen/rebuild the workspace."
            )
        print("iOS environment validated for " + args.flavor)
        return

    encoded = ",".join(
        base64.b64encode((key + "=" + value).encode()).decode()
        for key, value in config.items()
    )
    lines = [
        "// Generated from env/" + args.flavor + ".json. Do not commit.",
        "DART_DEFINES = " + encoded,
    ]
    for key in NATIVE_KEYS:
        value = config.get(key, "")
        if any(c in value for c in ("\n", "\r", "//", "$", "#")):
            raise ValueError("Unsupported xcconfig characters in " + key)
        lines.append(key + " = " + value)
    contents = "\n".join(lines) + "\n"
    if not destination.exists() or destination.read_text() != contents:
        destination.write_text(contents)
    print("Prepared iOS environment for " + args.flavor)


if __name__ == "__main__":
    try:
        main()
    except (ValueError, OSError) as error:
        print("error: " + str(error), file=sys.stderr)
        sys.exit(1)
