# Checklist phát hành LandMeasure trên iOS

> Sửa Archive trực tiếp từ Xcode 22/10/2026: chạy
> `python3 ios/scripts/prepare_ios_env.py prod` trước khi mở/Archive workspace.
> Xcode dùng `ios/Flutter/Environment-prod.xcconfig` (gitignored) để có cả
> DART_DEFINES và các key native. Không còn phụ thuộc file DartDefines chung
> có thể bị pre-action ghi rỗng. Scheme cũng cập nhật file theo flavor; build
> sẽ báo lỗi sớm nếu env hiện tại không khớp, thay vì tạo archive thiếu key.

## Archive trực tiếp trong Xcode

1. Cập nhật `env/prod.json`, chạy `python3 ios/scripts/prepare_ios_env.py prod`.
2. Mở lại `ios/Runner.xcworkspace`, chọn scheme **prod**, rồi Archive.
3. Upload **archive mới**. Archive cũ không thay đổi khi sửa source/config.

File sinh ra chứa cùng env cho Dart (FLAVOR, ad units, IAP IDs, support URLs)
và native (Maps, Meta, AdMob). Không commit file này. Khi clone repo hoặc
thay đổi env phải chạy lại bước chuẩn bị; dùng `dev` / `staging` với file env
tương ứng. Flutter CLI vẫn dùng `--dart-define-from-file=env/prod.json`; các
giá trị production cần được duy trì trong file env là nguồn cấu hình chung.

Archive build 3 lúc 10:41 ngày 22/10 đã được kiểm tra: URL scheme bị thành
`fb`, Facebook App ID/token và MapsApiKey trống do không có DART_DEFINES.
Không sửa bằng cách xóa cảnh báo hoặc upload Firebase dSYM: đây là lỗi config
trong binary. Build mới phải có `fb` + App ID và Maps key thực tế.

Các cảnh báo thiếu dSYM của **FirebaseAnalytics.framework** và
**FBAudienceNetwork.framework** trong Organizer là symbol của SDK vendor.
Archive lỗi vẫn có Runner/App dSYM; đây không phải thiếu dSYM ứng dụng và
không phải lỗi URL scheme chặn upload. Không tạo dSYM giả hoặc bỏ SDK chỉ để
ẩn cảnh báo. Cần symbol đúng UUID do vendor cung cấp nếu muốn symbolicate
stack bên trong các framework này.

> Cập nhật Firebase 22/10/2026: đã tích hợp plist iOS prod, cấu hình chọn theo
> flavor và build phase Crashlytics dSYM. Xem `docs/setup_firebase_ios.md`.
> Nhận xét thiếu Firebase trong audit cũ bên dưới đã được xử lý ở code/config;
> dữ liệu thực tế trên Firebase Console vẫn cần xác nhận.

> Cập nhật IAP 22/10/2026: đã thêm StoreKit 2 dùng chung paywall Android/iOS,
> Product IDs Apple `monthly` / `Yearly`, mua/restore và đồng bộ entitlement.
> Xem `docs/setup_storekit.md` cho cấu hình và kiểm thử Sandbox còn cần làm.
> Các nhận xét IAP Android-only bên dưới là kết quả audit cũ ngày 19/10.

> Cập nhật ads 20/10/2026: đã bổ sung native factory Swift cho iOS và bật
> native language/intro/detail; xem `docs/setup_admob.md`. Các nhận xét
> Android-only ở bản audit 19/10 bên dưới là trạng thái trước thay đổi này.
> App ID AdMob iOS trong prod đã được cập nhật bằng ID chủ app cung cấp;
> các ad unit iOS đã có trong env/prod.json và được giữ nguyên.
> Người dùng đã upload thành công một build TestFlight; cấu hình Firebase
> và StoreKit chưa được bổ sung trong thay đổi ads.

Kiểm tra ngày 19/10/2026 trên nhánh `develop`, dựa trên tài liệu và code/config local. Chưa đăng nhập Apple/Google/Meta console, chưa build/archive, chưa thử trên iPhone. Các mục bên dưới là trạng thái quan sát được, không phải xác nhận ứng dụng đã sẵn sàng phát hành.

## 1. Kết quả kiểm tra

Sản phẩm: Flutter, đo Area/Distance/Walk, dữ liệu local, ảnh hiện trường, xuất KML/CSV, 7 ngôn ngữ, quảng cáo và Premium. Không cần đăng nhập.

Tài liệu có phần cũ: `architecture.md` §1/§11 và `plan.md` vẫn nhắc RevenueCat. Changelog 08/10 và `docs/setup_play_billing.md` xác nhận đã chuyển sang Play Billing trực tiếp. Code hiện tại là căn cứ để đánh giá iOS.

| Hạng mục | Hiện trạng | Việc cần làm |
|---|---|---|
| Công cụ | Xcode 27.1, CocoaPods đã có; Flutter local 3.45.0-0.1.pre beta, khác README 3.38.5 stable | Chốt SDK dùng để build và kiểm tra dependency thực tế |
| Flavor | Có dev/staging/prod, Archive prod dùng Release-prod | Dùng prod cùng env/prod.json khi release |
| Bundle ID | Đã đổi Runner sang `com.avs.gpsareameasurement$(BUNDLE_ID_SUFFIX)`; RunnerTests dùng `com.avs.gpsareameasurement.RunnerTests` | Đăng ký ID chính thức trên Apple, Maps và Firebase |
| Signing | Không thấy DEVELOPMENT_TEAM trong project | Chọn Team và cấu hình provisioning cho Runner/prod |
| Maps | Đã điền key trong env dev/prod; AppDelegate đã đọc MapsApiKey và gọi GMSServices.provideAPIKey (19/10) | Kiểm tra runtime và giới hạn Bundle ID trên Google Cloud |
| IAP | PlayBillingPurchaseService chỉ Android; iOS plans() trả danh sách rỗng | Bổ sung StoreKit nếu phát hành với Premium |
| AdMob | App ID iOS đang là Google test ID, các ad unit iOS trống | Tạo app/ad unit iOS, điền ID production |
| Native ads | NativeAdController.supported chỉ Android | Implement factory iOS nếu muốn các vị trí native tương đương Android; điền key riêng chưa đủ |
| Firebase | Không thấy GoogleService-Info.plist trong Runner, không thấy cấu hình Firebase Dart thay thế | Thêm app iOS vào Firebase, gắn config vào Runner, cấu hình upload dSYM |
| Walk nền | Có UIBackgroundModes=location và AppleSettings cho recording | Kiểm tra quyền geolocator và thử trên iPhone thật |
| Quyền | Có mô tả location When In Use, camera, photo library, ATT bằng tiếng Anh | Kiểm tra prompt, dịch native nếu muốn khớp ngôn ngữ app |
| Privacy manifest | Không thấy PrivacyInfo.xcprivacy riêng của Runner | Audit app/SDK, Required Reason APIs và manifest trong archive; bổ sung phần app cần khai báo |
| Hỗ trợ/pháp lý | SUPPORT_EMAIL, PRIVACY_POLICY_URL, TERMS_URL đã có giá trị trong prod | Kiểm tra URL truy cập được và nội dung bao phủ SDK iOS; chưa xác minh website |
| App Store ID | APP_STORE_ID trống | Lấy numeric Apple ID sau khi tạo app record |
| Thiết bị | TARGETED_DEVICE_FAMILY="1,2" | Đang nhắm iPhone + iPad; kiểm thử và chuẩn bị ảnh cả hai, hoặc chủ động chốt phạm vi thiết bị |

Repo đã có các thay đổi iOS/pubspec.lock chưa commit trước lần kiểm tra này. Không ghi đè những thay đổi đó khi chuẩn bị release.

## 2. Thông tin chủ ứng dụng cần chuẩn bị

### Apple Developer / App Store Connect

- [ ] Apple Developer Program đang hoạt động; tài khoản có quyền quản lý app và ký ứng dụng.
- [ ] Team ID; Bundle ID chính thức đã chốt và cập nhật trong repo: `com.avs.gpsareameasurement`. Cần đăng ký trên Apple. Dev dùng hậu tố `.dev`, staging dùng `.stg`.
- [ ] Tên app, primary language, SKU nội bộ, category. Tạo app record để lấy numeric Apple ID.
- [ ] Nếu bán Premium: hoàn tất Paid Apps Agreement, banking và tax theo yêu cầu tài khoản.
- [ ] Chốt quốc gia phát hành, giá app, iPhone/iPad; hoàn tất thông tin trader nếu phân phối ở EU và console yêu cầu.

### env/prod.json

Các trường cần điền/thay cho iOS:

```text
MAPS_API_KEY_IOS
ADMOB_APP_ID_IOS
AD_UNIT_BANNER_IOS
AD_UNIT_INTERSTITIAL_IOS
AD_UNIT_REWARDED_IOS
AD_UNIT_APP_OPEN_IOS
APP_STORE_ID
```

Maps key: bật Maps SDK for iOS, billing phù hợp; application restriction theo Bundle ID chính thức, API restriction chỉ SDK cần dùng. Thêm ID dev/staging nếu dùng cùng key để test.

AdMob App ID có dấu `~`; ad unit có dấu `/`. Tạo app iOS riêng, không lấy ID Android. Code hiện tại fallback về ad unit test khi key trống, kể cả prod; vì vậy app chạy không có nghĩa quảng cáo production đã được cấu hình.

Chỉ cần điền thêm các mục sau khi sử dụng tính năng tương ứng:

```text
# Sau khi implement native ads iOS:
AD_UNIT_NATIVE_LANGUAGE_IOS
AD_UNIT_NATIVE_INTRO_IOS
AD_UNIT_NATIVE_INTRO_FULL_IOS
AD_UNIT_NATIVE_SAVED_IOS

# Nếu dùng Meta App Events để đo chiến dịch cài đặt:
FACEBOOK_APP_ID_IOS
FACEBOOK_CLIENT_TOKEN_IOS
```

Meta App Events khác Meta Audience Network bidding. Bidding cấu hình placement/mediation trên console; không mặc định yêu cầu hai trường App Events trên. Liên kết app iOS vào UMP message, kiểm tra app-ads.txt, cập nhật SKAdNetwork theo tài liệu SDK.

Giữ và kiểm tra SUPPORT_EMAIL, PRIVACY_POLICY_URL, TERMS_URL đã có. Không cần điền REVENUECAT_KEY_IOS trong code hiện tại: SDK RevenueCat đã bị gỡ.

### Subscription trên Apple

- [ ] Một subscription group Premium, hai sản phẩm monthly/yearly cùng cấp quyền.
- [ ] Product IDs, duration, giá theo storefront, tên/mô tả bản địa hóa, availability, screenshot cho review.
- [ ] Chốt trial: tài liệu Play hiện dùng thử 3 ngày cho monthly; thiết lập introductory offer Apple theo lựa chọn thực tế, không hard-code lời hứa dùng thử.
- [ ] Có thể dùng `premium_monthly` / `premium_yearly` nếu tạo đúng trên Apple; hiện env chỉ có IAP_PRODUCT_MONTHLY/YEARLY dùng chung, chưa có biến iOS riêng.
- [ ] Tài khoản Sandbox để thử; gửi subscription đầu tiên cùng phiên bản app theo quy trình Apple.

### Firebase / Push

- [ ] Thêm app iOS trong Firebase project với đúng Bundle ID, tải GoogleService-Info.plist, đưa vào Runner target/resources.
- [ ] Cấu hình Crashlytics dSYM theo SDK đang dùng; xác nhận Analytics và crash test xuất hiện trên Firebase.
- [ ] Chỉ nếu cần push trong bản đầu: APNs authentication key (.p8), Key ID, Team ID, upload vào Firebase; bật Push Notifications, entitlement và remote-notification background mode khi dùng background push; implement luồng FCM.
- [ ] Push/local reminder chưa hoàn thiện trong bootstrap; APNs không phải điều kiện để phát hành tính năng đo GPS. Background location độc lập với push.

## 3. Những phần code cần hoàn thiện

1. **Maps:** đã bổ sung import GoogleMaps, đọc MapsApiKey từ Info.plist và gọi GMSServices.provideAPIKey trước khi tạo bản đồ (19/10). Kiểm tra key thực sự được truyền vào app đã build.
2. **Premium iOS:** thêm implementation PurchaseService cho StoreKit (native StoreKit 2 hoặc plugin phù hợp), chọn theo platform; giữ Play Billing Android. Cần đọc giá từ store, mua, restore, xác minh giao dịch, cập nhật entitlement lúc mở/quay lại app và khi trạng thái subscription đổi, xử lý cancel/pending/expiry/refund, finish giao dịch đã xử lý. Link quản lý subscription Apple đã có fallback trong premium_links.dart.
3. **Native ads nếu cần:** implement và đăng ký các factory iOS trước khi bật supported; hiện iOS chủ động bỏ qua native ads. Đây là chênh lệch monetization, không tự nó là lỗi chặn App Store.
4. **Walk:** rà soát geolocator đang build qua Pods/SPM và cấu hình quyền phù hợp với chỉ When In Use. Không tự thêm Always nếu sản phẩm không cần. Podfile hiện chưa khai báo BYPASS_PERMISSION_LOCATION_ALWAYS; kiểm tra cấu hình biên dịch thực tế và hành vi permission trên máy.
5. **Privacy:** audit Required Reason APIs của app/SDK; thêm manifest đúng với hành vi thực tế, kiểm tra report trong archive. Việc không có manifest riêng chưa đủ để kết luận Apple chắc chắn từ chối, vì SDK có manifest riêng.
6. **Paywall:** thử trial/giá/chu kỳ/Restore/Terms/Privacy trên iOS. Nếu quyết định phát hành free trước thì phải xử lý cả entry point paywall và giới hạn Premium; không chỉ để store trả danh sách gói rỗng.

## 4. Nội dung cần điền trên App Store Connect

- [ ] Tên, subtitle nếu dùng, description, keywords, category, copyright.
- [ ] Support URL công khai (khác SUPPORT_EMAIL trong app), Privacy Policy URL, Terms/EULA phù hợp. Marketing URL tùy chọn.
- [ ] Ảnh chụp app iOS đúng các nhóm kích thước console yêu cầu; hiện target cả iPad. Có icon 1024 trong repo nhưng vẫn cần kiểm tra asset/archive cuối.
- [ ] App Privacy: khai báo theo dữ liệu thực tế của cả SDK Maps/Ads/Meta/Firebase/IAP. Dữ liệu đo local không đồng nghĩa toàn app không thu thập dữ liệu.
- [ ] Age rating questionnaire, content rights, export compliance theo mã hóa thực tế; không mặc định trả lời mọi câu là No.
- [ ] App Review contact: tên, email, điện thoại; Sign-in required = No nếu vẫn không đăng nhập.
- [ ] Review notes: đường vào Area/Distance/Walk, cách bắt đầu/dừng GPS nền, cách vào Premium/restore. Có thể đính kèm video walk nếu cần giải thích; không phải luôn bắt buộc.
- [ ] Chỉ mô tả tính năng đã có; không đưa PDF/KMZ/GPX còn ở roadmap vào screenshot/paywall/store listing.

## 5. Thứ tự thực hiện

1. Chốt Bundle ID và Apple Team → đăng ký identifier → tạo App Store Connect app → lấy APP_STORE_ID.
2. Tạo Maps/AdMob/Firebase iOS theo Bundle ID → điền env/config; chốt sản phẩm Premium trên Apple.
3. Hoàn thiện Maps, StoreKit, privacy; native ads và push tùy phạm vi bản đầu.
4. Mở `ios/Runner.xcworkspace` trong Xcode → Runner → Signing & Capabilities → chọn Team, Bundle ID chính thức, automatic signing cho cấu hình prod; kiểm tra capabilities cần dùng.
5. Resolve dependency với Flutter SDK đã chọn; chạy analyze/test, chạy dev trên iPhone. Không tự hạ Flutter theo README vì dependency hiện tại cần được đối chiếu trước.
6. Test iPhone: Area/Distance, lưu/đọc/sửa/xóa, chụp/chọn ảnh, KML/CSV share, denied permissions, mất mạng, consent + ATT chấp nhận/từ chối, quảng cáo test, Premium/restore/trial/expiry. Walk cần ghi thực địa ít nhất 30 phút khi khóa màn hình; Pause/Finish phải ngừng GPS. Test iPad nếu vẫn hỗ trợ.
7. Build và ký IPA prod, validate archive rồi upload App Store Connect; kiểm tra manifest/privacy report, symbol upload, version/build number.
8. TestFlight internal → thử bản release thực tế trên thiết bị → hoàn thiện metadata/privacy/IAP → chọn build và subscription → Submit for Review → release thủ công hoặc tự động theo lựa chọn.

Các lệnh dự kiến sau khi cấu hình hoàn tất (chưa chạy trong lần audit):

```bash
flutter pub get
flutter analyze
flutter test --exclude-tags golden
flutter run --flavor dev --dart-define-from-file=env/dev.json -d <iphone-device-id>
flutter build ipa --release --flavor prod --dart-define-from-file=env/prod.json
```

IPA thường ở `build/ios/ipa/`, archive ở `build/ios/archive/`. Dùng Organizer/Transporter để upload. Chọn build number mới cho mỗi lần upload; không cần đồng bộ build number với Android. Version hiện trong pubspec là `1.0.1+2`.

## 6. Nguồn chính thức đã đối chiếu

- [Google Maps Flutter: cấu hình iOS và provideAPIKey](https://developers.google.com/maps/flutter-package/config)
- [Google Mobile Ads Flutter: setup](https://developers.google.com/admob/flutter/quick-start)
- [Firebase Flutter: setup](https://firebase.google.com/docs/flutter/setup)
- [Apple: App Privacy, gồm cả SDK bên thứ ba](https://developer.apple.com/app-store/app-privacy-details/)
- [Apple: privacy manifest](https://developer.apple.com/documentation/bundleresources/privacy-manifest-files)
- [Apple: metadata phiên bản app](https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information/)
- [Apple: screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/)
- [Apple: gửi IAP đầu tiên cùng app](https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/submit-an-in-app-purchase/)
- [Apple: SDK minimum requirements từ 28/04/2026](https://developer.apple.com/news/?id=ueeok6yw) — iOS/iPadOS SDK 26 trở lên; deployment target iOS 15 của app là một khái niệm khác.
