# Thiết lập IAP — Google Play Billing Library 9 (không qua RevenueCat)

App dùng thẳng **Play Billing Library 9.1.0** (`com.android.billingclient:billing`) qua cầu nối Kotlin
`android/app/src/main/kotlin/com/example/gps_measurement/PlayBilling.kt` ↔ `PlayBillingPurchaseService`
(`lib/services/purchases/purchase_service.dart`). Chỉ Android. Không có backend: quyền Premium = "tài khoản Google
này có đăng ký đang hoạt động cho 1 trong 2 sản phẩm", đọc từ Play lúc mở app, mỗi lần quay lại app và sau mỗi giao dịch.

## 1. Play Console (👤)
1. Monetize → **Subscriptions** → tạo 2 subscription:
   - `premium_monthly` — 1 base plan hằng tháng (auto-renewing) + **offer dùng thử 3 ngày** cho khách mới
     (eligibility: *New customer acquisition*, phase 1 = free trial 3 ngày). App tự chọn offer có phase giá 0 nếu Play trả về
     (Play chỉ trả offer mà người dùng đủ điều kiện).
   - `premium_yearly` — 1 base plan hằng năm.
   - Muốn đổi ID: sửa `IAP_PRODUCT_MONTHLY` / `IAP_PRODUCT_YEARLY` trong `env/<flavor>.json`.
2. Kích hoạt (Active) cả 2 base plan; phải upload ít nhất 1 bản AAB lên track Internal để Play trả sản phẩm.
3. Thêm tài khoản tester (License testing) để mua thử không tính tiền.

## 2. Hành vi
- Giá hiển thị là chuỗi Play đã định dạng theo tiền tệ/ngôn ngữ; "tương đương … / tuần" của gói năm = giá năm ÷ 52.
- Mọi purchase ở trạng thái PURCHASED được **acknowledge** ngay (Play hoàn tiền sau 3 ngày nếu không).
- Pending (thanh toán chậm) → báo "đang chờ", Premium mở khi Play báo hoàn tất.
- Khôi phục = đọc lại giao dịch của tài khoản Google (không cần "restore" riêng).

## 3. Chưa làm (khuyến nghị trước khi thu tiền thật)
- **Xác thực server-side** (Google Play Developer API + RTDN) — hiện chỉ tin Play trên máy (có thể bị app mod bypass).
- iOS: chưa có (StoreKit).
