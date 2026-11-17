# Thiết lập Google Maps (P0-13 👤)

Mục tiêu: dùng **Maps SDK for Android + iOS** với chi phí 0đ, key bị giới hạn chặt để không ai dùng trộm được.
Tham chiếu: `architecture.md` §12 "Google Cloud".

> ⚠️ Chỉ bật đúng 2 API bên dưới. **Không** bật Places, Geocoding, Static Maps, Directions; **không** tạo Map ID. Mấy thứ này đều tính phí, còn app đã dùng geocoder native của hệ điều hành.

## 1. Tạo project & billing

1. Vào <https://console.cloud.google.com/> → chọn project → **New Project**, đặt tên ví dụ `landmeasure`.
2. **Billing** → gắn một billing account (Maps SDK bắt buộc có billing dù không tính phí map động).
3. Kiểm tra lại bảng giá hiện hành của Google Maps Platform (mục Maps SDK for Android/iOS – Dynamic Maps) để xác nhận vẫn miễn phí.

## 2. Bật API

**APIs & Services → Library**, bật:
- `Maps SDK for Android`
- `Maps SDK for iOS`

## 3. Lấy SHA-1 cho Android

Cần SHA-1 của **mọi** chứng chỉ ký app:

| Chứng chỉ | Cách lấy |
|---|---|
| Debug (máy dev) | `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android` → dòng `SHA1` |
| Upload key (release) | `keytool -list -v -keystore <upload-keystore>.jks -alias <alias>` (xem `docs/android_release.md`) |
| Play App Signing | Play Console → app → **Test and release → App integrity → App signing** |

Package name theo flavor (applicationId hiện tại, sẽ đổi khi chốt tên chính thức):

| Flavor | Android package | iOS bundle ID |
|---|---|---|
| dev | `com.avs.gpsareameasurement.dev` | `com.avs.gpsareameasurement.dev` |
| staging | `com.avs.gpsareameasurement.stg` | `com.avs.gpsareameasurement.stg` |
| prod | `com.avs.gpsareameasurement` | `com.avs.gpsareameasurement` |

## Trạng thái hiện tại (2026-09-28)

- [x] Key Android đã tạo và điền vào `env/dev.json`, `env/staging.json`, `env/prod.json` (không commit). Đã chạy thử: bản đồ vệ tinh tải bình thường trên emulator.
- [ ] **Giới hạn key** (Application restrictions → Android apps). Cần thêm các cặp dưới đây. SHA-1 debug của máy dev hiện tại:
  `07:AA:BC:44:26:42:DE:42:00:04:D7:98:CA:71:8D:35:74:CE:3D:7C`

  | Package | SHA-1 |
  |---|---|
  | `com.avs.gpsareameasurement.dev` | debug máy dev (ở trên) |
  | `com.avs.gpsareameasurement.stg` | debug máy dev (ở trên) |
  | `com.avs.gpsareameasurement` | debug máy dev (để chạy thử bản release ký debug) + upload key + App signing key (khi có) |

  Sau khi giới hạn, chạy lại app: nếu logcat có `Authorization failure` nghĩa là thiếu cặp package/SHA-1.
- [ ] API restrictions: chỉ `Maps SDK for Android`.
- [ ] Budget alert 1 USD.
- Khi đổi package name chính thức, phải thêm lại các cặp mới.

## 4. Tạo 2 API key

**APIs & Services → Credentials → Create credentials → API key**, tạo 2 key:

**Key Android** (`landmeasure-android`)
- Application restrictions: **Android apps** → thêm từng cặp *package name + SHA-1* (mọi flavor × mọi chứng chỉ ở bước 3).
- API restrictions: **Restrict key** → chỉ chọn `Maps SDK for Android`.

**Key iOS** (`landmeasure-ios`)
- Application restrictions: **iOS apps** → thêm bundle ID của 3 flavor.
- API restrictions: chỉ `Maps SDK for iOS`.

## 5. Budget alert

**Billing → Budgets & alerts → Create budget**: phạm vi project `landmeasure`, số tiền **1 USD**, cảnh báo ở 50% / 90% / 100%, gửi email cho chủ tài khoản billing.

## 6. Điền key vào app

Sửa `env/dev.json`, `env/staging.json`, `env/prod.json` (các file này đã được gitignore, **không commit**):

```json
{
  "MAPS_API_KEY_ANDROID": "<key Android>",
  "MAPS_API_KEY_IOS": "<key iOS>"
}
```

Cách key đi vào app:
- **Android**: Gradle giải mã `--dart-define-from-file` → `manifestPlaceholders["mapsApiKey"]` → meta-data `com.google.android.geo.API_KEY` trong `AndroidManifest.xml`.
- **iOS**: pre-action của scheme ghi `ios/Flutter/DartDefines.xcconfig` → build setting `MAPS_API_KEY_IOS` → khoá `MapsApiKey` trong `Info.plist`. (`AppDelegate` sẽ đọc khoá này để gọi `GMSServices.provideAPIKey` ở Phase 3.)

Chạy thử:

```bash
flutter run --flavor dev --dart-define-from-file=env/dev.json
```

## 7. Checklist

- [ ] Project có billing, chỉ bật 2 Maps SDK.
- [ ] Key Android giới hạn package + SHA-1, chỉ Maps SDK for Android.
- [ ] Key iOS giới hạn bundle ID, chỉ Maps SDK for iOS.
- [ ] Budget alert 1 USD.
- [ ] Đã điền key vào `env/*.json` (không commit).
