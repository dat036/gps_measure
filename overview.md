# LandMeasure — Overview

> Tài liệu tổng quan: hiểu dự án, đánh giá khả năng triển khai, so sánh thị trường, đề xuất tính năng cạnh tranh, đánh giá stack Flutter + monetization.
> Đi kèm: `plan.md` (kế hoạch kỹ thuật chi tiết), `design.md` (design system + spec từng màn).
> Cập nhật: 28/09/2026

---

## 1. Tóm tắt sản phẩm

**LandMeasure** là app tiện ích đo đất bằng GPS / bản đồ vệ tinh, không cần tài khoản, dữ liệu lưu local.

Vòng lặp chính:

```
CHỌN CHẾ ĐỘ → ĐO → GHI CHÚ + ẢNH → LƯU → XEM LẠI → XUẤT FILE
```

| Chế độ | Cách nhập | Kết quả | Tối thiểu |
|---|---|---|---|
| **Area** (xanh lá) | Kéo bản đồ dưới tâm ngắm + nút **Add Point** (hoặc tap) | Diện tích, chu vi, số điểm | 3 điểm |
| **Distance** (xanh dương) | Như trên, các điểm nối tuần tự, không khép | Tổng quãng đường, từng đoạn | 2 điểm |
| **Walk** (cam) | GPS tự ghi khi đi bộ (như Strava) | Thời gian, quãng đường, diện tích nếu vòng khép | 1 vị trí hợp lệ |

Tính năng chung cho cả 3 chế độ: **Draft tự lưu** (không bao giờ mất dữ liệu), **ảnh** (camera/gallery, gắn theo cả phép đo và — mở rộng — theo từng điểm), **ghi chú**, **đổi tên**, **sửa hình học** (Area/Distance), **xuất KML/CSV**, **xoá**, **tìm kiếm theo tên**, **lọc theo loại**, **cài đặt đơn vị / kiểu bản đồ / ngôn ngữ**.

Điều hướng: 3 tab — **Home / Saved / Setting**. Màn đo ẩn bottom nav để tối đa bản đồ.

### 1.1 Những điểm cần chốt lại (mâu thuẫn giữa spec và ảnh mockup)

| Mục | Ảnh mockup | Spec | Đề xuất chốt |
|---|---|---|---|
| Bottom nav | Home / Saved / Projects / Profile | Home / Saved / Setting | **Theo spec** (3 tab). "Project" = chính là 1 measurement đã lưu. Nhóm/thư mục để v1.1 (Folder). |
| Search bar ở Home | Có ("Search location, address…") | Cấm | **Bỏ khỏi Home**, nhưng **giữ nút Search trên màn đo** (floating) để tìm địa điểm / nhập toạ độ — đối thủ bị review chê vì thiếu cái này. |
| Nút kính lúp trên bản đồ | Có | Không nhắc | **Giữ**, đổi nghĩa thành "Tìm địa điểm / toạ độ". |
| CTA Home | "Start Measure" chung | CTA đổi theo mode | **Theo spec**: "Start Area Survey / Start Distance Measure / Start Walk Measure", màu theo mode. |
| Ảnh theo point | Không có | "MVP chỉ note chung" | Mô hình dữ liệu **có sẵn `pointId` nullable** trong Photo. MVP: ảnh chụp khi đang chọn 1 điểm sẽ gắn vào điểm đó (hiện badge 📷 trên điểm). Chi phí thêm thấp, là điểm khác biệt bạn muốn từ đầu. |
| Dialog rời màn đo | 2 phiên bản (Discard/Save Draft/Continue và Stay/Leave) | Mâu thuẫn | **Bỏ dialog** (chốt 2026-09-28): draft đã autosave nên back là thoát ngay, sau đó hiện snackbar "Đã lưu nháp" + nút **Bỏ**. Nhanh, không bắt người dùng suy nghĩ, vẫn không mất dữ liệu. |

---

## 2. Đánh giá khả năng triển khai

### 2.1 Độ khó kỹ thuật theo module

| Module | Độ khó | Rủi ro | Ghi chú |
|---|---|---|---|
| Bản đồ + vẽ polygon/polyline + kéo điểm | Trung bình | Thấp | `google_maps_flutter` hỗ trợ Marker draggable, Polygon, Polyline. Hiệu năng ổn với < 500 marker. |
| Tính diện tích/chu vi trắc địa | Thấp | Thấp | Công thức spherical excess (như `SphericalUtil.computeArea` của Google) + haversine. Tự viết ~100 dòng Dart, test đơn vị được. |
| Draft + autosave + khôi phục khi crash | Trung bình | Trung bình | Ghi DB theo từng thao tác (debounce 300ms). Walk: ghi mỗi điểm GPS vào DB → crash cũng không mất. |
| **Walk mode chạy nền** | **Cao** | **Cao** | Android foreground service (type `location`, Android 14+ bắt buộc khai báo), iOS background location mode. Đây là phần tốn thời gian test nhất, đặc biệt trên máy Xiaomi/Oppo/Vivo (kill app tầm tay). |
| Lọc nhiễu GPS | Trung bình | Trung bình | Lọc theo accuracy, khoảng cách tối thiểu, tốc độ bất thường. Cần test thực địa. |
| Ảnh (camera/gallery, nén, copy vào app storage) | Thấp | Thấp | `image_picker` + `flutter_image_compress`. |
| Export KML/CSV + share sheet | Thấp | Thấp | Tự build XML/CSV string, `share_plus`. |
| Thumbnail bản đồ | Trung bình | Thấp | `GoogleMapController.takeSnapshot()`; fallback vẽ hình học bằng `CustomPainter` (không phụ thuộc tile). |
| IAP + AdMob + Meta bidding + Firebase + Notification | Trung bình | Trung bình | Kỹ thuật không khó nhưng nhiều cấu hình, review store, consent (UMP/ATT). |

### 2.2 Ước lượng nguồn lực

**1 dev Flutter có kinh nghiệm + 1 designer bán thời gian:**

| Giai đoạn | Thời gian |
|---|---|
| Phase 0 – Setup, kiến trúc, design system | 1 tuần |
| Phase 1 – Core đo Area/Distance + tính toán + draft | 2 tuần |
| Phase 2 – Walk mode + nền + khôi phục | 2 tuần |
| Phase 3 – Save/Saved/Detail/Edit/Photo/Note/Export | 2 tuần |
| Phase 4 – Settings, i18n, permission, error states | 1 tuần |
| Phase 5 – Monetization (IAP, Ads, Meta), Firebase, Notification | 1,5 tuần |
| Phase 6 – QA thực địa, tối ưu, submit store | 1,5 tuần |
| **Tổng MVP** | **~11 tuần** (2 dev song song: ~7 tuần) |

### 2.3 Kết luận khả thi

**Khả thi cao.** Không có thành phần nào đòi hỏi công nghệ hiếm. Rủi ro chính:

1. **Walk chạy nền ổn định trên Android Trung Quốc** → cần màn hướng dẫn tắt tối ưu pin, test trên máy thật.
2. **Chính sách store**: Google Play kiểm duyệt quyền vị trí nền rất gắt. Giải pháp: **chỉ xin quyền "While in use" + foreground service khởi động khi app đang mở** → không cần `ACCESS_BACKGROUND_LOCATION`, không phải nộp video khai báo.
3. **Chi phí bản đồ**: Maps SDK cho Android/iOS hiện không tính phí theo lượt tải map động (xác minh lại trên bảng giá Google Maps Platform khi setup). **Places API (tìm địa chỉ) có tính phí** → MVP dùng geocoder native của hệ điều hành (miễn phí) + nhập toạ độ.
4. **Thị trường đông đúc** → phải khác biệt bằng UX + bản địa hoá (xem mục 4).

---

## 3. So sánh thị trường

### 3.1 App tham chiếu bạn gửi — "Bản đồ thực địa - Kiểm tra GPS"

- Nhà phát triển cá nhân (Gorasiya Vishal Nanjibhai), app thuộc một "xưởng" nhiều app tiện ích khác loại.
- Chỉ **1 lượt đánh giá** trên store VN, bản 1.0 từ 03/2025, 4 lần cập nhật đều là "sửa lỗi".
- IAP: **Monthly 129.000đ, Yearly 499.000đ, Lifetime 1.199.000đ**, có quảng cáo, 25 ngôn ngữ.
- Mô tả tính năng chung chung, không có điểm độc đáo.

→ Đây là mô hình "clone + paywall + ads" điển hình. Giá tham khảo tốt, nhưng **không phải đối thủ mạnh** — dễ vượt về chất lượng.

### 3.2 Đối thủ chính

| App | Nền tảng | Điểm mạnh | Monetization | Điểm yếu |
|---|---|---|---|---|
| **GPS Fields Area Measure** (Farmis, `lt.noframe`) | Android + iOS | Lâu đời, 4.7★ ~194K review trên Play, offline, nhóm dự án, KML/KMZ/Shapefile, WMS layer, POI | Subscription ~$5.99/tháng, $29.99–69.99/năm | UI cũ, nặng tính năng, khó cho người mới |
| **Planimeter** (examobile) | Android | GPS accuracy hiển thị, export GPX/KML | No ads + export là premium | UI kỹ thuật, review chê không tìm theo toạ độ |
| **GPS Fields – Land Area Measure** (iOS, 2026) | iOS | 3 chế độ (tap, walk/drive, **Bezier curve**), PDF report, AR compass, UTM/MGRS | Tuần $1.99, tháng $4.99, lifetime $29.99 | Mới, ít review, paywall sớm |
| Hàng chục clone "Field Area Measure", "Land Area Calculator"… | Cả 2 | Rẻ, nhiều ngôn ngữ | Ads dày + paywall | Chất lượng thấp, review về lỗi GPS, khó huỷ subscription |

### 3.3 Nhận định

- Tính năng lõi (đo diện tích/khoảng cách/walk, lưu, KML) đã **commodity** — ai cũng có.
- Người dùng than phiền nhiều nhất về: **GPS walk không chính xác / glitch**, **mất dữ liệu**, **paywall lừa (trả tiền không khác bản free)**, **khó huỷ gói**, **không tìm được toạ độ**, **ảnh vệ tinh cũ**.
- Cơ hội: một app **đẹp, đơn giản, đáng tin (draft không mất), minh bạch paywall**, cộng với **bản địa hoá mạnh cho Việt Nam & Đông Nam Á**.

---

## 4. Đề xuất tính năng cạnh tranh

Xếp theo **Giá trị / Công sức**. ⭐ = đề xuất đưa vào MVP hoặc v1.1.

### 4.1 Khác biệt cho thị trường Việt Nam (lợi thế lớn nhất)

| # | Tính năng | Mô tả | Công sức |
|---|---|---|---|
| ⭐1 | ~~**Đơn vị đất truyền thống VN**~~ (đã bỏ — chỉ dùng đơn vị quốc tế m²/ha/acre/ft²) | Sào Bắc Bộ (360 m²), Mẫu Bắc Bộ (3.600 m²), Sào Trung Bộ (~497 m²), Mẫu Trung Bộ (~4.970 m²), Công Nam Bộ (1.000 m² / 1.296 m² "công tầm lớn"), Thước (24 m²). Cho phép tự định nghĩa đơn vị tuỳ chỉnh. Hiển thị "1,25 ha ≈ 34,7 sào". | 1–2 ngày |
| ⭐2 | **Tính giá trị đất** | Nhập đơn giá (VNĐ/m², triệu/sào…) → ra tổng giá trị. Dân môi giới/mua đất cực kỳ dùng. | 1 ngày |
| 3 | **Chia lô / cắt thửa** | Chia polygon theo đường thẳng, ra diện tích mỗi phần. | 1 tuần (v1.2) |
| 4 | **Ước tính hàng rào / vật tư** | Chu vi × đơn giá/m, số cột theo khoảng cách. | 1 ngày |

### 4.2 Khác biệt về UX / độ tin cậy

| # | Tính năng | Mô tả | Công sức |
|---|---|---|---|
| ⭐5 | **Add Point tại vị trí GPS hiện tại** trong Area/Distance | Nút phụ "📍 Điểm tại vị trí tôi" — đi tới từng góc đất, bấm. Chính xác hơn walk liên tục, ít nhiễu. Rất nhiều nông dân đo kiểu này. | 0,5 ngày |
| ⭐6 | **Ảnh gắn theo điểm** | Chọn 1 điểm → chụp ảnh → ảnh gắn với điểm (cột mốc, góc đất). Marker hiển thị badge. Đúng ý tưởng ban đầu của bạn. | 1–2 ngày |
| ⭐7 | **Tìm địa điểm / nhập toạ độ** | Geocoder native (free) + dán toạ độ `21.0285, 105.8542` hoặc link Google Maps. | 1 ngày |
| 8 | **Chế độ cong (curve/arc)** giữa 2 điểm | Đối thủ iOS đang quảng cáo. | 3–4 ngày (v1.1) |
| 9 | **Cảnh báo polygon tự cắt** | Hiện cảnh báo khi các cạnh cắt nhau → kết quả diện tích sai. Rẻ mà tăng độ tin cậy. | 0,5 ngày |
| 10 | **Nhãn độ dài từng cạnh trên bản đồ** (Area) | Hiện chiều dài mỗi cạnh ngay trên polygon. | 0,5 ngày |
| 11 | **Snap/magnifier khi kéo điểm** | Kính lúp phóng to vùng dưới ngón tay khi kéo. | 1 ngày |
| 12 | **Import KML/KMZ/GeoJSON** | Mở file từ app khác/Zalo → xem, sửa. | 2–3 ngày (v1.1) |

### 4.3 Chia sẻ & báo cáo (động lực trả tiền)

| # | Tính năng | Mô tả | Công sức |
|---|---|---|---|
| ⭐13 | **Báo cáo PDF / ảnh chia sẻ** | 1 trang: ảnh bản đồ + số liệu + ghi chú + ảnh hiện trường. Chia sẻ qua Zalo. Tính năng premium mạnh nhất. | 2–3 ngày |
| 14 | **Chia sẻ ảnh kết quả** (story-style) | Ảnh vuông có hình thửa + số liệu + watermark app → viral marketing miễn phí. | 1 ngày |
| 15 | Export GPX, GeoJSON, KMZ (kèm ảnh) | Premium. | 1–2 ngày |
| 16 | Thư mục / nhóm màu | "Dự án" như ảnh mockup của bạn. | 2 ngày (v1.1) |

### 4.4 Để sau (v2)

Bản đồ offline (tải vùng), sao lưu Google Drive/iCloud, lớp bản đồ quy hoạch/địa chính (WMS), độ cao/độ dốc, chế độ lái xe (Drive), đo bằng AR, widget.

---

## 5. Đánh giá Flutter cho Android + iOS

### 5.1 Kết luận: **Flutter phù hợp** ✅

| Tiêu chí | Đánh giá |
|---|---|
| Bản đồ | `google_maps_flutter` (chính chủ Flutter team) hỗ trợ satellite/hybrid/terrain, polygon, polyline, marker kéo được, snapshot. Đủ cho MVP. |
| GPS + nền | `geolocator` hỗ trợ stream vị trí, foreground notification Android, background updates iOS. |
| Ảnh, file, share | Plugin chính thức/ổn định. |
| Monetization | `google_mobile_ads` (chính chủ Google), adapter mediation Meta chính chủ (`gma_mediation_meta`), `purchases_flutter` (RevenueCat) hoặc `in_app_purchase`. |
| Firebase | FlutterFire đầy đủ (Analytics, Crashlytics, Messaging, Remote Config). |
| UI đẹp | Flutter là lợi thế lớn: 1 design system, pixel-perfect giống mockup trên cả 2 OS. |
| Tiết kiệm | ~1 codebase, tiết kiệm ~40–50% so với native 2 nền tảng. |

### 5.2 Điểm cần lưu ý với Flutter

1. **Platform view của Google Maps** tốn tài nguyên hơn native một chút; tránh đặt 2 map cùng lúc (Detail dùng ảnh thumbnail + mở full map khi tap).
2. **Marker tuỳ biến** (chấm trắng viền màu, label diện tích) phải render widget → `BitmapDescriptor` và cache lại, tránh tạo lại mỗi frame.
3. **Chạy nền**: plugin chỉ bọc native API — vẫn phải cấu hình AndroidManifest/Info.plist cẩn thận và test máy thật.
4. **Ads trên màn đo**: KHÔNG đặt banner/interstitial trên màn bản đồ đang đo (dễ click nhầm → vi phạm chính sách AdMob, và làm xấu trải nghiệm).

### 5.3 Monetization & dịch vụ

**IAP / Subscription** — khuyên dùng **RevenueCat (`purchases_flutter`)**:
- Xử lý xác thực receipt, trạng thái gói, restore, cross-platform mà không cần backend.
- Miễn phí ở quy mô nhỏ (kiểm tra lại ngưỡng doanh thu miễn phí hiện hành khi đăng ký).
- Có paywall UI + A/B test giá.
- Thay thế: `in_app_purchase` (miễn phí hoàn toàn nhưng phải tự verify receipt, tự xử lý edge case).

Gói đề xuất (tham chiếu đối thủ VN: 129k/499k/1.199k):

| Gói | Giá VN gợi ý | Giá USD gợi ý |
|---|---|---|
| Tuần (tuỳ chọn, chỉ test) | 39.000đ | $1.99 |
| Tháng | 79.000đ | $3.99 |
| Năm (có 3 ngày dùng thử) | 299.000đ | $19.99 |
| Trọn đời | 599.000đ | $39.99 |

**Free vs Premium** (minh bạch, không lừa):

| Tính năng | Free | Premium |
|---|---|---|
| Đo Area/Distance/Walk, draft, sửa | ✅ | ✅ |
| Số phép đo đã lưu | 10 (số lượng Remote Config) | Không giới hạn |
| Ảnh / phép đo | 3 | Không giới hạn |
| Export CSV | ✅ | ✅ |
| Export KML/KMZ/GPX/GeoJSON | 1 lần/ngày hoặc xem rewarded ad | ✅ |
| Báo cáo PDF | ❌ | ✅ |
| Tính giá trị đất, đơn vị tuỳ chỉnh | Đơn vị VN chuẩn free, đơn vị tuỳ chỉnh premium | ✅ |
| Quảng cáo | Có | Không |

**AdMob + Meta bidding**:
- `google_mobile_ads` + `gma_mediation_meta`; bật Meta Audience Network làm **bidding source** trong AdMob Mediation (không dùng waterfall).
- Định dạng: **Banner adaptive** (Home, Saved, Detail), **Interstitial** sau khi Save (tần suất: tối đa 1 lần/3 phút, không phải lần save đầu tiên), **Rewarded** (mở khoá export 1 lần), **App Open** khi quay lại app sau >4 giờ (không hiện lần đầu mở, không hiện khi Walk đang ghi).
- Bắt buộc: **UMP consent** (GDPR/khu vực có yêu cầu) + **ATT** trên iOS trước khi request ad (Meta rất phụ thuộc ATT trên iOS).

**Firebase**: Analytics (event funnel), Crashlytics (+ non-fatal cho lỗi GPS/DB), **Remote Config** (đề xuất thêm: giới hạn free, tần suất ads, biến thể paywall), Messaging (FCM).

**Notification**:
- Local: notification thường trực khi Walk ghi (bắt buộc với foreground service), nhắc draft chưa xong (sau 24h, tối đa 1 lần/draft).
- Remote (FCM): chiến dịch, cập nhật. Android 13+ cần xin `POST_NOTIFICATIONS`; iOS cần APNs key.

### 5.4 Quyền riêng tư & chính sách store

- Khai báo Data safety (Play) / Privacy Nutrition Label (iOS): Location (không rời thiết bị, trừ SDK ads nếu bật personalization), Device ID (ads, analytics), Crash data, Purchase history.
- Không claim "RTK / cm precision" trong mô tả store và UI.
- Có màn **Manage subscription** dẫn tới trang huỷ gói của store (giải quyết pain point của đối thủ).

---

## 6. Chỉ số thành công (KPI) & event chính

| KPI | Mục tiêu 3 tháng đầu |
|---|---|
| Tỉ lệ hoàn thành phép đo đầu tiên (first_measure_saved / first_open) | ≥ 45% |
| Crash-free users | ≥ 99,5% |
| D1 / D7 retention | 30% / 12% |
| Tỉ lệ chuyển đổi trả phí | 1,5–3% |
| Rating | ≥ 4,5★ |

Chi tiết danh sách event: xem `architecture.md` §11.1.

---

## 7. Lộ trình phát hành

| Mốc | Nội dung |
|---|---|
| **MVP 1.0** (~11 tuần) | 3 chế độ đo, draft, ảnh (kể cả theo điểm), note, saved/detail/edit, KML/CSV, đơn vị VN, tính giá đất, tìm địa điểm/toạ độ, add point tại GPS, IAP, Ads, Firebase, notification, 7 ngôn ngữ |
| 1.1 (+4 tuần) | Báo cáo PDF, ảnh chia sẻ, thư mục/nhóm màu, import KML/GeoJSON, KMZ/GPX export, curve mode |
| 1.2 | Chia lô, ước tính hàng rào, trim Walk đầu/cuối |
| 2.0 | Bản đồ offline, backup cloud, lớp WMS/quy hoạch, Drive mode |

---

## 8. Tài liệu liên quan

- `architecture.md` — stack đã chốt, cấu trúc thư mục, quy ước code, data model, thuật toán, cấu hình native, analytics.
- `plan.md` — 13 phase có ô tick, task chi tiết, tiêu chí hoàn thành, nhật ký tiến độ, hướng dẫn cho AI.
- `design.md` — design system (màu, typography, spacing, component) + spec từng màn hình dựa trên mockup.
