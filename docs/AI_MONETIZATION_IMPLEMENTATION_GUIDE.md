# Hướng dẫn cho AI: triển khai Ads và IAP cho ứng dụng Flutter

Ngày soạn: 12/11/2026. Ngôn ngữ hướng dẫn: tiếng Việt.

## 1. Mục tiêu và cách sử dụng

Tài liệu này là đặc tả triển khai có thể mang sang ứng dụng Flutter khác. AI cần đọc repository đích, hoàn thành hồ sơ cấu hình ở mục 3, rồi triển khai theo kiến trúc và tiêu chí nghiệm thu bên dưới. Tài liệu có thể dùng độc lập; source GPS Measurement là nguồn tham khảo tùy chọn.

Đây là hướng dẫn, chưa phải package hoặc API đã được tạo. Tên model, đường dẫn đề xuất và YAML bên dưới là thiết kế minh họa; AI phải hiện thực hoặc ánh xạ sang cấu trúc của app đích. Không giả định chỉ thêm YAML là code tự hoạt động.

Mục tiêu: tái sử dụng cách quản lý SDK, consent, vòng đời quảng cáo và giao dịch; cho phép mỗi app tự cấu hình sản phẩm, quyền lợi, placement, giao diện và chiến lược doanh thu.

### Quy tắc cho AI triển khai

1. Đọc `AGENTS.md`, cấu trúc app, theme, localization, state management, flavor và tích hợp sẵn trước khi sửa.
2. Giữ kiến trúc hiện có nếu đáp ứng yêu cầu; không ép app dùng Riverpod, Firebase, Meta hay native billing bridge chỉ vì app tham khảo đang dùng.
3. Không chép package name, bundle ID, product ID, ad unit ID, URL pháp lý, tên thương hiệu hoặc màu của GPS Measurement sang app mới.
4. Thông tin thiếu: tìm trong cấu hình/source/tài liệu app trước. Tiếp tục phần độc lập; đánh dấu `TODO_APP_CONFIG` và hỏi phần không thể suy ra. Không tự đặt ID production, giá, trial hoặc quyền lợi thương mại.
5. Không thay đổi luồng nghiệp vụ, quota hoặc hành vi thu tiền ngoài phạm vi yêu cầu. Giữ các thay đổi có sẵn của người dùng.
6. Kiểm tra tài liệu chính thức tương ứng phiên bản SDK trước khi tích hợp; không coi phiên bản hay API trong source tham khảo là chuẩn vĩnh viễn.
7. Báo cáo tách biệt: code đã hoàn thành, kiểm tra tự động, kiểm tra thiết bị, kiểm tra Console/store và những mục chưa xác minh.

## 2. Phần dùng chung và phần riêng của app

| Phần dùng chung về kỹ thuật | Đầu vào riêng của app |
| --- | --- |
| Consent và điều kiện được request ads | Cấu hình đối tượng người dùng, timing ATT, privacy text |
| Load/show/dispose, timeout, retry, quản lý cache | Format và placement được bật, TTL theo SDK, giới hạn chờ |
| Điều phối toàn màn hình và lifecycle | Màn hình cấm ads, cooldown, giới hạn mỗi phiên |
| Query sản phẩm, mua, restore, theo dõi giao dịch | Danh sách sản phẩm, loại sản phẩm, offer, quyền lợi |
| Đồng bộ quyền lợi để điều khiển ads | Gói nào bỏ ads, gói nào chỉ mở một tính năng |
| Truyền style Flutter sang native factory | Màu CTA, chữ, nền, viền, font, kích thước, layout |
| Các hook sự kiện | Backend analytics được dùng và quy tắc ghi doanh thu |

Không đưa các điều kiện kiểu “sau lần lưu thứ hai”, “mở KML”, “monthly/yearly”, màu xanh hoặc màn intro vào phần lõi. Đó là lựa chọn của app tham khảo.

## 3. Hồ sơ cấu hình bắt buộc cho mỗi app

AI tạo hồ sơ riêng, ví dụ `docs/monetization_app_profile.md`. Ghi nguồn xác nhận và các mục chưa có; không lưu thông tin bí mật ở đây.

| Nhóm | Cần xác định |
| --- | --- |
| Nền tảng | Android/iOS được hỗ trợ, applicationId/bundle ID theo flavor |
| SDK | Phiên bản Flutter, ads SDK, billing plugin/native bridge, mediation nếu có |
| Ads IDs | AdMob App ID từng nền tảng, ad unit ID theo placement và môi trường |
| Placement | Key, format, route/event kích hoạt, điều kiện, cooldown, session cap, timeout, fallback |
| Consent | UMP message, privacy options, ATT nếu dùng tracking, cấu hình trẻ em/độ tuổi nếu áp dụng |
| Catalog IAP | Key nội bộ, product ID từng store, loại, base plan/offer nếu áp dụng, quyền lợi |
| Paywall | Danh sách/thứ tự gói, gói mặc định, trial, nội dung, theme và localization |
| Entitlement | Bỏ ads, mở tính năng, quota, thời hạn và quy tắc offline/cache |
| Native style | Resolver theo theme/màn hình/placement; layout và kích thước theo nền tảng |
| Hạ tầng | Verification tại đâu, backend nếu có, cache, analytics, Remote Config nếu có |
| Pháp lý | Privacy Policy, Terms/EULA, màn quản lý subscription, thông tin store |
| QA | Thiết bị, tài khoản tester, track/sandbox và tình trạng xác minh |

### Ví dụ cấu hình trung lập

YAML này là mẫu cấu trúc, không phải file runtime có sẵn. `<...>` và `TODO_APP_CONFIG` phải được thay hoặc mục đó phải tắt. Không dùng mẫu này làm production config trực tiếp.

```yaml
schemaVersion: 1
app:
  androidApplicationId: '<ANDROID_APPLICATION_ID>'
  iosBundleId: '<IOS_BUNDLE_ID>'
ads:
  enabled: true
  mode: test # Chọn rõ cho từng môi trường; không suy ra từ debug/release.
  appIds:
    android: '<ANDROID_ADMOB_APP_ID>'
    ios: '<IOS_ADMOB_APP_ID>'
  placements:
    content_footer: # Key ví dụ, đổi theo app.
      enabled: false # Chỉ bật khi đã xác định vị trí và cấu hình.
      format: native
      units:
        android: '<ANDROID_NATIVE_AD_UNIT_ID>'
        ios: '<IOS_NATIVE_AD_UNIT_ID>'
      layoutKey: '<REGISTERED_NATIVE_LAYOUT_KEY>'
      styleKey: '<APP_STYLE_RESOLVER_KEY>'
    natural_break:
      enabled: false
      format: interstitial
      units:
        android: '<ANDROID_INTERSTITIAL_AD_UNIT_ID>'
        ios: '<IOS_INTERSTITIAL_AD_UNIT_ID>'
      cooldownSeconds: TODO_APP_CONFIG
      maxPerSession: TODO_APP_CONFIG
      loadTimeoutSeconds: TODO_APP_CONFIG
billing:
  enabled: false # Bật sau khi catalog/store đã cấu hình.
  verificationStrategy: TODO_APP_CONFIG
  products:
    - key: '<INTERNAL_PRODUCT_KEY>'
      kind: subscription # Hoặc nonConsumable / consumable nếu có triển khai.
      stores:
        android:
          productId: '<PLAY_PRODUCT_ID>'
          basePlanId: '<PLAY_BASE_PLAN_ID_IF_APPLICABLE>'
          offerSelection: TODO_APP_CONFIG
        ios:
          productId: '<APP_STORE_PRODUCT_ID>'
      grants: ['<ENTITLEMENT_KEY>']
  paywall:
    productKeys: ['<INTERNAL_PRODUCT_KEY>']
    defaultProductKey: '<INTERNAL_PRODUCT_KEY>'
    styleKey: '<APP_PAYWALL_STYLE_KEY>'
entitlements:
  removeAdsKey: '<ENTITLEMENT_KEY_OR_NULL_IF_NOT_OFFERED>'
```

Catalog là danh sách có thể có một hoặc nhiều sản phẩm; không giới hạn hai gói. Có thể có sản phẩm chỉ tồn tại trên một store. Phân biệt subscription, mua vĩnh viễn và vật phẩm tiêu hao; chỉ khai báo loại mà adapter thực sự hỗ trợ. Không diễn giải một gói subscription thành lifetime hay dùng `isPremium` để biểu diễn số dư vật phẩm.

Validation cấu hình:

- Kiểm tra trùng key, product được paywall tham chiếu phải tồn tại, default phải nằm trong danh sách hợp lệ.
- Placement bật phải có format, ID đúng nền tảng và factory nếu dùng native.
- Tách AdMob App ID (`~`) và ad unit ID (`/`); không sử dụng thay nhau.
- Bản production bật kiếm tiền phải có bước kiểm tra cấu hình trước phát hành: không còn placeholder/test ID hoặc thiếu ID. Không âm thầm thay production ID bị thiếu bằng test ID.
- Khi runtime gặp cấu hình lỗi: tắt placement hoặc tính năng mua liên quan, ghi lỗi có ngữ cảnh và để app tiếp tục hoạt động.
- Khi test: dùng test ads chính thức hoặc test device đã cấu hình. TestFlight/release không tự đồng nghĩa với production ads hoặc test ads. Xem [hướng dẫn test ads của Google](https://developers.google.com/admob/flutter/test-ads).

## 4. Kiến trúc đề xuất

```text
App config + Theme + Localization + Business rules
                 ↓
       App monetization integration
          ↙                    ↘
     Ads services         Purchase services
          ↑                    ↓
          └──── Entitlement state ────┘
```

Có thể tổ chức trong app trước, chưa cần tạo package:

```text
lib/monetization/
  config/          # Catalog, placements, validation, kiểu cấu hình
  consent/         # UMP và adapter ATT
  ads/             # Coordinator, managers, native style contract
  purchases/       # Interface, adapter store, offer và kết quả giao dịch
  entitlements/    # Trạng thái quyền lợi và đồng bộ
lib/features/...   # Paywall, vị trí ads và quy tắc của app
```

Các dependency như logger, clock, storage, analytics và quyền được hiển thị ads được truyền qua interface/callback/provider của app. Không import model nghiệp vụ của app vào lõi ads/billing. Ads chỉ nhận `adsAllowed` hoặc tập entitlement, không trực tiếp gọi store.

Nếu tái sử dụng native bridge, phải mang đủ Kotlin/Swift, dependency và đăng ký channel; copy Dart là chưa đủ. Dùng channel/factory namespace nhất quán với thiết kế app hoặc plugin đích, không giữ namespace GPS Measurement do sao chép.

## 5. Consent và điều kiện ads

- Cập nhật consent information mỗi lần khởi chạy; hiển thị UMP form khi cần và kiểm tra `canRequestAds()` trước khi request. Không dùng một boolean tự lưu thay cho trạng thái SDK.
- Chỉ khởi động luồng ads một lần khi bootstrap và splash gọi đồng thời. Chống request/load trùng.
- Có điểm mở privacy options khi SDK yêu cầu; sau khi người dùng đổi lựa chọn, đọc lại trạng thái và cập nhật ads đang chờ/cache theo quyền mới.
- ATT là quyền tracking trên iOS, khác với UMP. Không đồng nhất “từ chối ATT” với “cấm mọi quảng cáo”. Thời điểm hỏi do app quyết định, không khóa theo số lần mở hoặc lần lưu của GPS Measurement.
- `adsAllowed` cần xét: nền tảng hỗ trợ, cấu hình bật, trạng thái consent, SDK sẵn sàng, entitlement và ngữ cảnh hiện tại. Recheck trước cả load và show.
- Không mặc định bật Meta attribution/analytics chỉ vì được request ads. Mỗi tích hợp dữ liệu phải có điều kiện phù hợp riêng.
- Nếu khởi tạo hoặc consent lỗi: app vẫn tiếp tục; quyền request dựa trên giá trị SDK thực sự trả về. Có timeout điều phối UI, nhưng không tự đóng hoặc chồng màn lên một consent form đang hiển thị.

Tham chiếu: [Google UMP cho Flutter](https://developers.google.com/admob/flutter/privacy). AI kiểm tra lại API và điều kiện áp dụng trong phiên bản đang tích hợp.

## 6. Quản lý vòng đời và placement quảng cáo

### Luật chung

1. Mỗi ad instance có chủ sở hữu và được dispose đúng một lần khi hết dùng; callback đến sau timeout/dispose không được cập nhật UI đã chết.
2. Cache có thời hạn theo format/SDK hiện hành; không chép chung một TTL cho mọi loại. Ad hết hạn phải bỏ và tải lại khi đủ điều kiện.
3. Retry có giới hạn/backoff; không lặp request liên tục khi no-fill, offline hoặc consent không cho phép.
4. Có trạng thái phân biệt idle/loading/ready/showing/unavailable/disposed hoặc tương đương; lời gọi đồng thời không được show trùng instance.
5. Coordinator phải cấp quyền hiển thị độc quyền trước khi show ads toàn màn hình; không chỉ đếm số ads đang mở. Khóa còn bao phủ consent, ATT, paywall/store sheet và flow quan trọng theo app.
6. Mọi nhánh thành công, dismiss, failed-to-show và exception đều phải giải phóng khóa, dispose và hoàn thành Future/callback một lần. Không dùng timeout để cho một ad khác xuất hiện khi ad đầu vẫn đang hiện.
7. Khi mua được quyền bỏ ads: ngừng request mới, hủy lịch show, bỏ cache và gỡ banner/native khỏi UI. Ad toàn màn hình đã hiện tuân theo vòng đời SDK; không tự tạo nút ép đóng SDK ad. Kiểm tra lại quyền trước khi show một ad vừa tải xong.

### Theo format

| Format | Yêu cầu |
| --- | --- |
| Banner | Tính kích thước theo vùng hiển thị, safe area, không che điều khiển; loading/failure không làm hỏng bố cục |
| Interstitial | Chỉ ở điểm nghỉ phù hợp do app khai báo; không chen ngang tác vụ; cap/cooldown được cấu hình |
| App Open | Cấu hình cold start và/hoặc foreground riêng; giới hạn thời gian đợi, chống quay lại từ ad/store sheet rồi hiện tiếp; không hiện muộn sau khi người dùng đã vào nội dung |
| Native | Factory và layout đúng nền tảng, truyền style từ app, asset binding đúng SDK, xử lý asset thiếu |
| Rewarded | Chỉ bắt đầu sau hành động chủ động của người dùng; cấp thưởng một lần theo callback earned; dismiss và unavailable là hai kết quả riêng |

Rewarded fallback thuộc chính sách sản phẩm: `earnedOnly`, `allowWhenUnavailable` hoặc phương án khác đã xác nhận. Không mặc định miễn phí khi no-fill chỉ vì GPS Measurement cho phép xuất KML trong trường hợp đó. Đồng thời xác định quy tắc khi mất mạng/đóng app sau khi đã earned để tránh mất thưởng hoặc nhận thưởng lặp.

## 7. Native ads: CTA và style theo từng app

“CTA” là nút hành động quảng cáo; “CTR” là chỉ số tỷ lệ nhấp. Màu nút CTA phải lấy từ app, có thể khác nhau theo màn hình, placement và light/dark theme.

### Hợp đồng style

App cung cấp resolver kiểu `resolveNativeStyle(context, placementKey)` trả về tối thiểu:

| Token | Ý nghĩa |
| --- | --- |
| `background`, `stroke` | Mặt nền và viền |
| `title`, `body` | Màu chữ quảng cáo |
| `cta`, `ctaText` | Nền và chữ nút CTA, lấy theo nút chính của màn hoặc token app chỉ định |
| `badge`, `badgeText` | Màu nhãn quảng cáo dễ nhận biết |

Font, radius, padding, CTA height, media ratio và chiều cao container có thể cấu hình thêm. Nếu thêm token phải triển khai đọc token đó ở cả Android/iOS; Dart gửi key mới không làm native factory tự hỗ trợ.

Ví dụ minh họa dùng theme app, không dùng mã màu thương hiệu cố định:

```dart
final scheme = Theme.of(context).colorScheme;
final options = <String, Object>{
  'background': scheme.surface.toARGB32(),
  'stroke': scheme.outlineVariant.toARGB32(),
  'title': scheme.onSurface.toARGB32(),
  'body': scheme.onSurfaceVariant.toARGB32(),
  'cta': scheme.primary.toARGB32(), // App có thể override theo placement.
  'ctaText': scheme.onPrimary.toARGB32(),
  'badge': scheme.secondaryContainer.toARGB32(),
  'badgeText': scheme.onSecondaryContainer.toARGB32(),
};
// Truyền options vào customOptions của NativeAd trong API SDK tương thích.
```

- Truyền cặp nền/chữ cùng nhau để giữ độ tương phản; không thay riêng CTA rồi giữ màu chữ cũ.
- Dùng ARGB 32 bit nhất quán; Android đọc qua `Number.toInt()`, iOS xử lý bit bằng `UInt32` phù hợp. Kiểm tra cả hai nền tảng.
- Các key trong Dart/Kotlin/Swift và factory ID phải khớp. Native fallback chỉ dùng khi cần phục hồi; luồng bình thường luôn truyền style app, không dựa vào màu fallback GPS Measurement.
- Theme hoặc placement đổi: cache phải phân biệt style/layout hoặc invalidation và tạo lại ad phù hợp. Không giữ quảng cáo light theme trong dark theme vì đã preload trước đó.
- Không hardcode chiều cao compact/medium của app tham khảo; layout có thể khác Android/iOS và phải thử màn nhỏ, chữ lớn, video, asset thiếu.
- Dùng asset SDK trả về cho headline/body/CTA. Không tự thay nội dung CTA quảng cáo bằng nội dung nút mua Premium của app.
- Đăng ký asset views và để SDK xử lý click; không đặt Flutter overlay chặn click hoặc tự điều hướng thay click quảng cáo. Giữ nhãn quảng cáo và AdChoices rõ ràng; nếu có nút đóng của app, không che các phần này hoặc tạo nhấp nhầm.

Tham chiếu: [native ads Android/iOS trong Flutter](https://developers.google.com/admob/flutter/native/platforms). Tùy biến hình thức vẫn phải đáp ứng yêu cầu native ads hiện hành của Google.

## 8. IAP: catalog linh hoạt, không khóa monthly/yearly

### Model và phân tách trách nhiệm

- `ProductDefinition`: key nội bộ ổn định, loại sản phẩm, store mapping và quyền lợi được cấp.
- `StoreOffer`: metadata thật từ store: product/base plan/offer, giá bản địa hóa, tiền tệ, kỳ thanh toán, introductory offer và eligibility nếu có. Handle/token để mua chỉ nằm trong adapter, không tự tạo từ UI.
- `PurchaseResult`: purchased/pending/cancelled/failed hoặc tương đương.
- `EntitlementState`: quyền lợi theo key, nguồn xác minh, thời hạn và trạng thái refresh. Cần phân biệt unknown/loading với free đã xác nhận; tránh hiển thị ads trong lúc còn đang kiểm tra người từng trả tiền.
- Subscription và non-consumable cấp quyền; consumable cần sổ giao nhận/số dư riêng có tính idempotent, không chỉ boolean.

Không dùng enum cố định `monthly, annual` trong phần dùng chung. Không giả định mọi sản phẩm cùng mở một Premium hoặc mọi Premium đều tắt ads. Ví dụ app có thể bán riêng quyền bỏ ads và quyền xuất file; mapping quyền lợi do app xác định.

### Hành vi bắt buộc

1. Query catalog từ store, ánh xạ đúng ID phân biệt hoa/thường và môi trường. Không lấy giá/trial/độ dài kỳ thanh toán từ chuỗi tên product.
2. Sản phẩm không trả về hoặc không mua được: hiển thị trạng thái phù hợp, không nút mua giá giả và không crash. Chỉ render gói đang khả dụng.
3. Chống double tap; theo dõi giao dịch ngoài vòng đời paywall để pending, approval và giao dịch lúc khởi động lại vẫn được xử lý.
4. Chỉ cấp quyền sau trạng thái đã mua và bước xác minh tương ứng; pending/cancelled không mở quyền. Xử lý lại cùng transaction không cấp thưởng/lợi ích thêm lần nữa.
5. Android: chọn đúng base plan/offer người dùng đủ điều kiện; acknowledge sau khi xác minh và giao quyền cho sản phẩm không tiêu hao, consume theo quy trình cho sản phẩm tiêu hao. Có retry/reconciliation khi bước cuối lỗi.
6. iOS: xử lý giao dịch verified, cập nhật quyền lợi, finish sau giao nhận; quan sát transaction updates, current entitlements, revoked/expired theo loại sản phẩm. Không suy diễn consumable balance từ current entitlements.
7. Refresh lúc startup/resume và khi có transaction update; có cách cập nhật quyền hết hạn khi app mở liên tục. Hủy gia hạn khác hết quyền đã trả tiền; grace period/hold/refund xử lý theo store và verification strategy.
8. Restore là hành động người dùng, có kết quả restored/nothing/error. Không hiện prompt đồng bộ tài khoản ở mọi lần resume. Consumable không được hứa restore như subscription/non-consumable; phục hồi số dư cần nguồn dữ liệu riêng.
9. Cache chỉ phục vụ trải nghiệm khởi động/offline theo chính sách app; không coi boolean local là chứng cứ giao dịch vĩnh viễn. Ghi rõ thời hạn cache và cách xử lý khi refresh lỗi, tránh vừa khóa nhầm người trả tiền vừa mở quyền vô hạn.
10. App có tài khoản, số dư tiêu hao, quyền dùng trên nhiều thiết bị hoặc yêu cầu chống gian lận cao cần thiết kế backend verification, ledger và thông báo store tương ứng. Không tuyên bố client-only có độ bảo đảm tương đương server. Khóa API/service account/shared secret không nằm trong app.

Tham chiếu: [quy trình Play Billing](https://developer.android.com/google/play/billing/integrate), [StoreKit current entitlements](https://developer.apple.com/documentation/storekit/transaction/currententitlements). AI phải đọc tài liệu đúng loại sản phẩm; hướng dẫn này không khẳng định native bridge GPS Measurement đã hỗ trợ consumable/lifetime hay backend.

## 9. Paywall và analytics

- Render danh sách sản phẩm có thể thay đổi; app cấu hình thứ tự, gói mặc định, badge và style. Không hardcode hai card, luôn có annual hoặc luôn chọn monthly.
- Giá hiển thị dùng dữ liệu store đã định dạng. Không đặt giá fallback production. Các giá quy đổi “mỗi tuần/tháng” nếu cần phải ghi rõ là quy đổi, tính đúng kỳ hạn và locale; không coi đó là kỳ thu tiền thực tế.
- Trial/ưu đãi chỉ được quảng bá khi store báo offer phù hợp và người dùng đủ điều kiện. Không khóa “3 ngày miễn phí”, “tiết kiệm X%”, “best value” khi chưa có dữ liệu chứng minh.
- CTA mua, màu nút, typography, khoảng cách, illustration, danh sách lợi ích và localization lấy theo app. Nội dung thay đổi theo loại subscription/mua một lần, không dùng cùng câu “gia hạn tự động” cho lifetime.
- Xử lý rõ loading, không có gói, offline, mua/restore đang chạy, pending, cancelled và failure. Có Restore, liên kết quản lý đăng ký, Privacy Policy và Terms/EULA phù hợp sản phẩm/nền tảng.
- Theo dõi sự kiện qua interface tùy chọn: paywall_view, product_load_failed, purchase_result, restore_result, entitlement_changed, ad_load/show/failure, reward_earned. Payload không chứa receipt/token hoặc dữ liệu cá nhân không cần thiết.
- Không ghi nhận doanh thu subscription mới ở mỗi lần refresh/restore. Nếu tự ghi purchase revenue, xác định nguồn và chống ghi trùng với SDK/store/backend. Sự kiện “purchase success” trên client không tự chứng minh báo cáo doanh thu production chính xác.

## 10. Quy trình triển khai cho AI

1. Khảo sát repo và lập hồ sơ mục 3; ghi rõ quyết định đã có, thiếu và phạm vi nền tảng.
2. Chọn adapter theo hạ tầng hiện có. Đọc tài liệu chính thức và chốt phiên bản tương thích; không tự migrate SDK toàn app khi không cần.
3. Tạo config/catalog/placement/style contracts và validator. Chưa có production IDs vẫn có thể triển khai/test ads ở chế độ test rõ ràng.
4. Xây entitlement state và store adapter, sau đó nối adsAllowed. Giữ UI app độc lập với native channel/offer token.
5. Tích hợp consent, coordinator và các format đã được yêu cầu. Không mặc định thêm mọi format hoặc placement onboarding.
6. Nối native factory Android/iOS và style resolver app; tích hợp paywall động, localization và liên kết.
7. Thêm kiểm tra có ý nghĩa cho state transition, callback race, cấu hình và nghiệp vụ mua/quyền lợi. Chạy analyzer, test và build phù hợp nền tảng được hỗ trợ.
8. Thực hiện QA thiết bị/sandbox khi có điều kiện; cập nhật tài liệu cấu hình, lệnh build, báo cáo kết quả. Việc ký/phát hành hoặc thao tác Console theo quyền được giao trong phiên làm việc.

## 11. Tiêu chí nghiệm thu

### Cấu hình và giao diện

- [ ] Thêm/bớt gói qua catalog không phải sửa enum hay số lượng card cố định; adapter chỉ nhận loại đã hỗ trợ.
- [ ] Product IDs Android/iOS độc lập; không chứa ID/thương hiệu/URL của app tham khảo do sao chép.
- [ ] Đổi theme/CTA app cập nhật native style trên Android và iOS, kể cả ad đã preload.
- [ ] Native có nhãn quảng cáo, AdChoices, asset binding đúng; thử asset thiếu, video, màn nhỏ, text scale và light/dark.
- [ ] Flavor runtime và giá trị App ID trong Manifest/Info.plist của artifact build khớp. Build từ Xcode cũng cần kiểm tra, không chỉ Flutter CLI.

### Ads và vòng đời

- [ ] UMP cần/không cần form; đồng ý/từ chối; lỗi mạng; privacy options thay đổi; ATT denied vẫn tuân theo điều kiện SDK thay vì tự cấm mọi ads.
- [ ] Cold start/resume, đóng ad/store sheet, chuyển route, show đồng thời không gây ads chồng hoặc Future treo.
- [ ] Offline/no-fill/late callback/failed-to-show/dispose không crash; cap/cooldown và vùng cấm ads đúng hồ sơ app.
- [ ] Reward earned cấp đúng một lần; dismiss không bị coi earned; unavailable thực hiện đúng fallback đã chọn.
- [ ] Mua bỏ ads khi banner/native đang mở, fullscreen đang chờ và callback load đang về không làm ads xuất hiện lại.

### IAP

- [ ] Query đúng catalog/giá/locale; sản phẩm thiếu và tài khoản hết trial không bị quảng cáo sai ưu đãi.
- [ ] Mua thành công, hủy sheet, pending, lỗi, restore có/không giao dịch, khởi động lại trong giao dịch.
- [ ] Subscription: gia hạn, hết hạn khi app mở, hủy renewal còn thời hạn, refund/revoke, resume và reinstall theo store.
- [ ] Non-consumable/consumable nếu được yêu cầu: kiểm tra giao quyền/tiêu thụ/sổ giao nhận và chống cấp trùng riêng.
- [ ] Quyền bỏ ads không bị đánh đồng với quyền lợi khác; cache/offline đúng chính sách.

### Bằng chứng hoàn thành

Ghi từng hạng mục kèm môi trường, nền tảng, ngày kiểm tra và kết quả. Build/test giả lập không chứng minh live ads, sản phẩm đã duyệt, giao dịch store, signing hoặc doanh thu thực. Chỉ đánh dấu QA store/device khi đã quan sát trực tiếp ở môi trường đó; phần chưa có điều kiện ghi rõ `Chưa xác minh`.

## 12. Bản đồ source tham khảo GPS Measurement

Các đường dẫn dưới đây tương đối với repo GPS Measurement. Khi mang riêng tài liệu sang app khác, không giả định các file này tồn tại ở repo đích.

| Source | Có thể học lại | Cần bỏ phụ thuộc/đổi khi áp dụng |
| --- | --- | --- |
| `lib/services/ads/ads_service.dart` | Bootstrap consent/SDK, trạng thái ads | Feature gate, Meta attribution, logger/provider của GPS |
| `lib/services/ads/consent_service.dart` | UMP/privacy options và adapter ATT | SettingsRepository, timing theo lần mở/lần lưu |
| `lib/services/ads/ad_unit_ids.dart` | Resolver theo platform/environment | IDs và enum placement riêng GPS; fallback production thiếu ID |
| `lib/services/ads/ad_coordinator.dart` | Theo dõi fullscreen/lần đóng | Hiện dùng bộ đếm, cần bảo đảm khóa độc quyền và thêm store/permission guard ở app đích |
| `lib/services/ads/*_manager.dart` | Cache, callback và xử lý load/show | Timeout/cap/trigger, rewarded fallback, kiểm tra đầy đủ exception/race |
| `lib/services/ads/native_ad_controller.dart` | NativeAdStyle và customOptions ARGB | LmColors, factory IDs, chiều cao và TTL theo SDK đích |
| `lib/services/ads/native_ad_view.dart` | Placement style, widget và preload | MeasurementType, theme, màn language/intro/detail và cache theo style |
| `android/app/src/main/kotlin/com/avs/gpsareameasurement/LmNativeAdFactory.kt` | Đọc customOptions, gắn assets | Package, resource/layout, màu fallback, kích thước |
| `ios/Runner/LmNativeAdFactory.swift` | Factory Swift, MediaView và style | Factory IDs, màu fallback, layout, nhãn/accessibility localization |
| `lib/services/purchases/purchase_service.dart` | PurchaseService, trạng thái/result, bridge Play | Enum monthly/annual, hai product IDs, channel, storage, mô hình Premium boolean |
| `lib/services/purchases/storekit_purchase_service.dart` | StoreKit adapter | Hai gói cố định, channel, storage và mapping quyền |
| `android/app/src/main/kotlin/com/avs/gpsareameasurement/PlayBilling.kt` | Bridge Play, query/purchase/reconcile | Chỉ tái sử dụng phạm vi subscription đã đọc và kiểm chứng; không tự coi hỗ trợ mọi loại |
| `ios/Runner/StoreKitBilling.swift` | Verified transaction/updates/finish | Phạm vi subscription và verification strategy |
| `lib/features/premium/` | Paywall controller, luồng purchase/restore | Theme, nội dung, lựa chọn gói và quy tắc quyền lợi của app |

Tài liệu `setup_admob.md`, `setup_play_billing.md`, `setup_storekit.md` trong repo tham khảo có thông tin riêng app và có thể chứa mốc lịch sử đã cũ. Ví dụ tài liệu Play cũ nói iOS chưa có, trong khi source hiện đã có StoreKit. Không dùng các câu này làm kết luận về trạng thái hiện tại; đối chiếu owning source và môi trường thực tế.

## 13. Prompt dùng cho app tiếp theo

```text
Hãy đọc AI_MONETIZATION_IMPLEMENTATION_GUIDE.md và AGENTS.md của repository này.
Triển khai Ads/IAP trong phạm vi yêu cầu của app, dựa trên kiến trúc hiện có.

Trước tiên tạo docs/monetization_app_profile.md theo mục 3 từ source/config hiện có.
Tìm thông tin còn thiếu trong repo; đánh dấu và hỏi các quyết định thương mại hoặc
IDs chưa có, đồng thời tiếp tục phần độc lập. Không tự tạo dữ liệu production.

Không khóa số lượng/tên gói IAP, giá, trial, entitlement, placement hoặc màu CTA.
Native CTA và các token style phải lấy từ theme/placement của app và truyền đúng
sang Android/iOS. Chỉ triển khai loại sản phẩm và định dạng được app yêu cầu.

Giữ thay đổi hiện có của người dùng. Kiểm tra theo mục 11, ghi lệnh/kết quả và
phân biệt code/build pass với device/sandbox/live ads đã xác minh.
Bàn giao code, app profile, hướng dẫn setup/build và danh sách việc Console/QA
còn thiếu. Không mặc định rằng source GPS Measurement tồn tại trong repo này.
```
