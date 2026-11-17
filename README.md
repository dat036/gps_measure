# LandMeasure

## Public source snapshot for App Review

This repository contains the LandMeasure source snapshot prepared on 17 November 2026,
including local UI updates present at export. It has an independent Git history.
It is supplied for source inspection; it is not an exact copy of a submitted binary.

Production Firebase configuration, Maps keys, Meta tokens, signing credentials,
and the Apple development team setting are excluded. Service configuration examples
contain placeholders; the default AdMob app IDs are Google test IDs.

To run with working services, supply your own Maps keys in `env/dev.json` and
your own Android Firebase config at `android/app/google-services.json`. For iOS
production builds, supply `ios/Runner/GoogleService-Info.plist` and select your
own signing team in Xcode. Register the bundle/package identifiers shown in the
project in your own service consoles. These local config files are gitignored.
The Firebase example files document structure and do not provide working services.

Production release/setup notes below describe the app integration; they are not
a claim that this public snapshot has been tested against production services.

Đo diện tích, khoảng cách và quãng đi bộ bằng GPS / bản đồ vệ tinh. Flutter · Android + iOS.

Tài liệu (đọc theo thứ tự): [overview.md](overview.md) → [architecture.md](architecture.md) → [design.md](design.md) → [plan.md](plan.md).

## Yêu cầu

- Flutter **3.38.5** stable (Dart 3.10) — xem `architecture.md` §14.
- Android SDK (minSdk 24), Xcode + CocoaPods cho iOS (iOS 15+).

## Chạy app

```bash
cp env/example.json env/dev.json   # rồi điền key (xem docs/setup_google_maps.md)
# Android: download your own google-services.json into android/app/ before building.
flutter pub get
dart run build_runner build --force-jit
flutter run --flavor dev --dart-define-from-file=env/dev.json
flutter run --flavor prod --dart-define-from-file=env/prod.json

```

Flavor: `dev`, `staging`, `prod` (cùng applicationId `com.avs.gpsareameasurement` vì Firebase chỉ có 1 app Android; khác nhau ở tên app và `versionNameSuffix`). Luôn truyền `--flavor` **và** file env tương ứng. VS Code: dùng cấu hình trong `.vscode/launch.json`.

> `--force-jit` là bắt buộc: một dependency dùng build hooks mà chế độ biên dịch AOT mặc định của build_runner không hỗ trợ.

## Build release (AAB để đưa lên Google Play)

```bash
flutter build appbundle --release --flavor prod --dart-define-from-file=env/prod.json
```

Kết quả: `build/app/outputs/bundle/prodRelease/app-prod-release.aab`.

Trước khi build:

- Có `env/prod.json` với key thật (ad unit, Maps, AdMob app ID, IAP product…); thiếu thì build dùng ID test của Google.
- Có `android/key.properties` (keystore upload, không commit) — nếu không, bản release bị ký bằng debug key và **Play sẽ từ chối**. Xem `docs/android_release.md`.
- Tăng số build trong `pubspec.yaml` (`version: x.y.z+BUILD`) — Play không nhận `versionCode` trùng; hoặc ghi đè khi build: thêm `--build-number=<N> --build-name=<x.y.z>`.
- `flutter analyze` và `flutter test --exclude-tags golden` sạch.

## Lệnh thường dùng

| Việc | Lệnh |
|---|---|
| Sinh code (Riverpod, Freezed, Drift) | `dart run build_runner build --force-jit` |
| Sinh l10n (ARB → `lib/l10n/gen`) | `flutter gen-l10n` |
| Lint | `flutter analyze` |
| Test (không golden) | `flutter test --exclude-tags golden` |
| Cập nhật golden | `flutter test --tags golden --update-goldens` |
| Icon / splash tạm | `python tool/generate_icon.py && dart run flutter_launcher_icons && dart run flutter_native_splash:create` |

Golden test phụ thuộc hệ điều hành (cách raster font), nên CI bỏ qua; hãy chạy và cập nhật chúng trên cùng một OS.

## Cấu hình & bí mật

- `env/<flavor>.json` chứa key thật và **không được commit**; mẫu ở `env/example.json`.
- Android đọc Maps key / AdMob app ID qua Gradle `manifestPlaceholders` (giải mã từ dart-defines).
- iOS: pre-action của scheme sinh `ios/Flutter/DartDefines.xcconfig` → `Info.plist` (`MapsApiKey`, `GADApplicationIdentifier`).
- Khi chưa điền, AdMob dùng app ID test công khai của Google.
