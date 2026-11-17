# Android — ký bản release

Bản release đọc chữ ký từ `android/key.properties` (đã gitignore). Không có file này, Gradle vẫn build nhưng ký bằng **debug key** kèm cảnh báo → chỉ dùng thử trên máy, **không upload được lên Play**.

## 1. Tạo upload keystore (1 lần, giữ cẩn thận)

```bash
keytool -genkey -v -keystore ~/landmeasure-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

- Lưu file `.jks` và mật khẩu ở nơi an toàn (password manager + bản sao offline). Mất upload key thì phải xin Google reset.
- **Không** đặt file `.jks` trong repo (`*.jks` đã bị gitignore).

## 2. Tạo `android/key.properties`

```properties
storePassword=<mật khẩu keystore>
keyPassword=<mật khẩu key>
keyAlias=upload
storeFile=C:/Users/<you>/landmeasure-upload.jks
```

## 3. Build

```bash
flutter build appbundle --release --flavor prod --dart-define-from-file=env/prod.json
```

File ra: `build/app/outputs/bundle/prodRelease/app-prod-release.aab`.

Release đã bật R8 (`isMinifyEnabled`, `isShrinkResources`, rule ở `android/app/proguard-rules.pro`) và đóng gói native symbol (`SYMBOL_TABLE`) cho Play Console / Crashlytics.

## 4. SHA-1 cần thêm vào Google Maps key

Sau khi có upload key và bật Play App Signing, thêm SHA-1 của **cả hai** vào key Android (xem `docs/setup_google_maps.md` §3–4):

```bash
keytool -list -v -keystore ~/landmeasure-upload.jks -alias upload
```

SHA-1 của App signing key: Play Console → app → **Test and release → App integrity → App signing**.
