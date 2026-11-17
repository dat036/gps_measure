# Setup AdMob + Meta bidding + Consent (P11-05, P11-10)

Code quảng cáo nằm ở `lib/services/ads/`. Bản **dev/staging luôn dùng ad unit test của Google** (`ad_unit_ids.dart`), kể cả khi đã điền ID thật — chỉ bản `prod` dùng ID thật. Không bao giờ bấm quảng cáo thật khi phát triển.

## 1. AdMob
1. Tạo 2 app (Android, iOS) → lấy **App ID** (`ca-app-pub-…~…`).
2. Mỗi app tạo 4 ad unit: **Banner** (adaptive), **Interstitial**, **Rewarded**, **App open**.
3. Điền vào `env/prod.json`:
```json
"ADMOB_APP_ID_ANDROID": "ca-app-pub-…~…",
"ADMOB_APP_ID_IOS": "ca-app-pub-…~…",
"AD_UNIT_BANNER_ANDROID": "ca-app-pub-…/…",
"AD_UNIT_INTERSTITIAL_ANDROID": "…",
"AD_UNIT_REWARDED_ANDROID": "…",
"AD_UNIT_APP_OPEN_ANDROID": "…",
"AD_UNIT_BANNER_IOS": "…",
"AD_UNIT_INTERSTITIAL_IOS": "…",
"AD_UNIT_REWARDED_IOS": "…",
"AD_UNIT_APP_OPEN_IOS": "…"
```
   Thiếu App ID → app dùng App ID test của Google để không crash.
4. Thêm **app-ads.txt** trên website nhà phát triển (bắt buộc trước khi phát hành).

## 2. Privacy & messaging (UMP)
AdMob → Privacy & messaging:
1. **GDPR (EEA/UK/CH)**: tạo message, chọn ngôn ngữ (vi, en…), gắn 2 app. Bật mục "Manage options".
2. **US state regulations** (tuỳ chọn).
3. **IDFA explainer** (iOS) nếu muốn có màn giải thích trước ATT.

App gọi UMP **mỗi lần mở** trước mọi request quảng cáo; mục **"Lựa chọn quyền riêng tư"** trong Setting chỉ hiện khi UMP yêu cầu.

Thử form EEA trên máy dev: trong `env/dev.json` đặt `"UMP_DEBUG_EEA": true`; nếu máy thật không phải emulator, thêm `"UMP_TEST_DEVICE_ID"` (chuỗi hash UMP in ra logcat/Xcode, dòng `ConsentDebugSettings.Builder().addTestDeviceHashedId("…")`).

## 3. Meta Audience Network — bidding
1. Meta Business → Monetization Manager: tạo property + **placement** cho từng định dạng (banner, interstitial, rewarded). App open không có trên Meta.
2. AdMob → **Mediation** → tạo mediation group cho từng ad unit → **Bidding sources** → *Meta Audience Network* → map placement ID. Không dùng waterfall.
3. Adapter đã có trong app (`gma_mediation_meta`), R8 rules ở `android/app/proguard-rules.pro`.
4. iOS: Meta cần ATT; app hỏi ATT sau UMP, **không ở lần mở đầu** (từ lần mở thứ 2 hoặc sau lần lưu đầu).

## 4. iOS
- Native ads đã có factory Swift trong `ios/Runner/LmNativeAdFactory.swift`,
  đăng ký ở `didInitializeImplicitFlutterEngine` sau plugin registration.
  Ba ID `lm_native_compact`, `lm_native_medium`, `lm_native_full` dùng chung
  với Dart/Android; màu sắc được truyền từ theme Flutter. Compact iOS cao
  164pt và có MediaView để hiển thị cả video; medium cao 272pt.
- `env/prod.json`: dùng **App ID iOS thật** (`~`), cùng app AdMob với các
  ad unit iOS (`/`). ID `ca-app-pub-3940256099942544~1458002511` là ID mẫu,
  không dùng cho production. Khi đổi, cập nhật cả giá trị mặc định trong
  `ios/Flutter/Flavor-prod.xcconfig` để Archive từ Xcode dùng đúng app.
- Trong AdMob, cấu hình Privacy & messaging cho app iOS và kiểm tra trạng
  thái app/ad units. App chỉ request ads sau khi UMP cho phép; Firebase
  không phải điều kiện để tải quảng cáo.
- `Info.plist` đã có `GADApplicationIdentifier`, `NSUserTrackingUsageDescription`, `SKAdNetworkItems` (danh sách Google + Meta tại thời điểm viết). **Trước khi phát hành, đối chiếu lại** với danh sách mới nhất:
  - Google: https://developers.google.com/admob/ios/3p-skadnetworks
  - Meta: https://developers.facebook.com/docs/setting-up/platform-setup/ios/SKAdNetwork
- Chạy `cd ios && pod install` trên Mac.

### Kiểm thử iOS

1. Chạy dev bằng `flutter run --flavor dev --dart-define-from-file=env/dev.json`.
   Dev/staging dùng ad unit test Google. iPhone thật cần đăng ký test device
   nếu thử ad unit production; TestFlight không tự biến máy thành test device.
2. Cài mới: splash → App Open (nếu tải kịp) → language native → intro compact
   và full native. Kiểm tra AdChoices, nhãn Ad, CTA, đóng full ad, video,
   light/dark, màn hình nhỏ và VoiceOver. Không bấm quảng cáo production.
3. Home banner được chủ động ẩn trong phiên đầu tiên; đóng hẳn và mở lại app,
   đóng paywall nếu có, rồi kiểm tra banner. Native sau lưu dùng cùng factory.
4. Lỗi tải quảng cáo ghi `LM/warning` kèm domain/code ở device console, kể cả
   bản release chưa cấu hình Firebase. Tìm `UMP`, `Ads disabled`, `App open`,
   `Native ad`, `Banner`; nếu `canRequestAds=false`, kiểm tra App ID và UMP
   trước. Splash chờ consent/SDK tối đa 12s rồi chờ quảng cáo tối đa 8s.
5. Build prod bằng
   `flutter build ipa --release --flavor prod --dart-define-from-file=env/prod.json`.
   Kiểm tra `GADApplicationIdentifier` trong Info.plist **của archive** trước upload.

Đã kiểm tra local ngày 20/10/2026:
- 38 test native controller, onboarding, main shell và monetization pass;
  targeted analyzer không có issue.
- Xcode build dev cho simulator và Flutter build prod release không ký pass;
  `Info.plist` của app prod chứa đúng App ID iOS chủ app cung cấp.
- iOS 27 simulator: App Open splash, banner collapsible Home, native medium
  ở Detail/language, compact và full ở intro đã hiển thị quảng cáo test.
  Đóng native full tiếp tục được intro; language/intro vẫn tải quảng cáo test
  sau khi từ chối ATT. Native validator báo không có lỗi với medium ở Detail.
- Chưa kiểm tra quảng cáo production trên iPhone/TestFlight hoặc trạng thái
  AdMob Console. Build không ký không phải IPA có thể upload TestFlight.

## 5. Kiểm bằng Ad Inspector (P11-10)
Bản dev/staging: Setting → **Ad Inspector (dev)** (cuối nhóm Hỗ trợ & pháp lý). Máy phải là test device (emulator tự là test device; máy thật: đăng ký trong AdMob → Settings → Test devices).
- Mở từng ad unit → xem **Bidding**: Meta Audience Network phải có trong danh sách tham gia đấu giá.
- Kiểm consent: tab Privacy cho thấy trạng thái UMP.

## 6. Luật hiển thị (đã code, chỉnh qua Remote Config khi có Phase 10)
| Định dạng | Ở đâu | Điều kiện |
|---|---|---|
| Banner adaptive | Dưới bottom nav của Home/Saved/Settings; Detail có slot riêng | Free, đã có consent; banner chính từ lần mở sau onboarding, Detail mặc định tắt |
| Interstitial | Sau Save, trên Detail mới | Không phải lần lưu đầu (`interstitial_after_nth_save`=2), cách nhau ≥ 180 s, không khi Walk đang ghi |
| Rewarded | Mở 1 lần xuất KML khi đã dùng lượt free trong ngày | Không tải được → vẫn cho xuất |
| App open | Splash khi khởi động app | Free, UMP cho phép và SDK sẵn sàng, tải kịp thời hạn; không hiện khi chỉ quay lại từ background |

**Không có quảng cáo nào trên màn đo/Walk.** Mua Premium → mọi quảng cáo tắt ngay.

## 7. Meta SDK — log install (không liên quan bidding)
Bidding ở §3 chạy qua adapter `gma_mediation_meta`, **không cần** Facebook App ID. App ID + Client Token chỉ dùng để Meta ghi nhận **lượt cài** cho chiến dịch quảng cáo (plugin `facebook_app_events`, code ở `lib/services/meta/meta_service.dart`).

1. developers.facebook.com → tạo app → thêm nền tảng Android (package `com.avs.gpsareameasurement`, key hash) / iOS (bundle ID).
2. Lấy **App ID** (Settings → Basic) và **Client Token** (Settings → Advanced).
3. Điền vào `env/prod.json` (để trống ở dev/staging → SDK tắt hẳn, không log gì):
```json
"FACEBOOK_APP_ID_ANDROID": "…",
"FACEBOOK_CLIENT_TOKEN_ANDROID": "…",
"FACEBOOK_APP_ID_IOS": "…",
"FACEBOOK_CLIENT_TOKEN_IOS": "…"
```
4. Cách hoạt động: manifest/Info.plist tắt auto-init và auto-log. Sau UMP (+ ATT trên iOS), nếu `canRequestAds` là true thì app bật log và gọi `activateApp` → Meta nhận sự kiện cài đặt. Không có consent thì không gửi gì.
5. Kiểm: Meta Events Manager → Test events (hoặc `FacebookAppEvents().setDebugLoggingEnabled(true)` tạm thời), mở app bản prod sau khi chấp nhận consent.
6. Play Console → Data safety: khai báo thu thập Device ID / quảng cáo cho Meta. App Store: cập nhật App Privacy tương ứng.
