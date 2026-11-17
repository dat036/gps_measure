# LandMeasure — Implementation Plan

> Kế hoạch triển khai chia theo phase, mỗi phase làm trong 1 (hoặc vài) phiên AI.
> Tài liệu liên quan: `overview.md` (sản phẩm, phạm vi) · `architecture.md` (cấu trúc code, data model, thuật toán, quy ước) · `design.md` (UI).

---

## 🤖 Hướng dẫn cho AI (đọc trước mỗi phiên)

1. **Đọc theo thứ tự**: `overview.md` → `architecture.md` → `design.md` → `plan.md`.
2. **Chọn phase**: làm phase **đầu tiên còn `[ ]`** trong bảng Trạng thái bên dưới, trừ khi người giao việc chỉ định phase khác. Không bắt đầu phase mới khi phase trước chưa đạt "Tiêu chí hoàn thành".
3. **Kiểm tra code hiện có** trước khi viết: đọc cấu trúc `lib/`, đối chiếu `architecture.md`. Nếu code lệch tài liệu → báo lại, sửa theo tài liệu hoặc cập nhật tài liệu (có lý do).
4. **Làm task theo thứ tự**, tick `[x]` từng task ngay khi xong. Task đánh dấu 👤 là việc **người phải làm** (console, key, thiết bị thật) → AI chuẩn bị hướng dẫn/placeholder, để `[ ]` và ghi vào "Việc chờ người".
5. **Mỗi task xong** phải: `flutter analyze` sạch, test liên quan pass, không hard-code text/màu.
6. **Hết phase**:
   - Tick toàn bộ "Tiêu chí hoàn thành" đã đạt; tick ô phase trong bảng Trạng thái.
   - Cập nhật `architecture.md` nếu có thay đổi cấu trúc/schema (ghi §14 Changelog).
   - Ghi 1 mục vào **Nhật ký tiến độ** cuối file: ngày, phase, đã làm, còn lại, lỗi/nợ kỹ thuật, việc chờ người.
7. **Không làm ngoài phạm vi phase** (không "tiện tay" làm tính năng phase sau). Ý tưởng mới → ghi vào Backlog.
8. **Không** thêm package ngoài danh sách `architecture.md` §1 nếu chưa ghi lý do vào Changelog.

Ký hiệu: `[ ]` chưa làm · `[x]` xong · `[~]` làm dở (ghi lý do trong nhật ký) · 👤 cần người · 🧪 cần test thiết bị thật.

---

## 📊 Trạng thái các phase

- [ ] **Phase 0** — Khởi tạo project & khung app
- [x] **Phase 1** — Domain core (thuật toán, pure Dart) — còn chờ GPX thật (P1-04 👤)
- [x] **Phase 2** — Data layer (DB, repository, lưu file)
- [~] **Phase 3** — Nền bản đồ + Measure Area — chờ 👤 đối chiếu thước Google Maps
- [~] **Phase 4** — Measure Distance + tính năng chung màn đo — chờ 👤 thử tìm địa chỉ trên máy thật + đối chiếu thước Google Maps
- [~] **Phase 5** — Walk & Measure (GPS, chạy nền, khôi phục) — chờ 👤 test thực địa trên máy thật (P5-11)
- [x] **Phase 6** — Save, Home, Saved, Detail
- [x] **Phase 7** — Ảnh, Ghi chú, Edit
- [~] **Phase 8** — Export & Giá trị đất — chờ 👤 mở KML bằng Google Earth, CSV bằng Excel, share trên máy thật
- [x] **Phase 9** — Settings, quyền, trạng thái lỗi, đa ngôn ngữ, dark mode — còn 👤 email/URL chính sách/App Store ID, review bản dịch máy, kiểm iOS
- [ ] **Phase 10** — Firebase (Analytics, Crashlytics, Remote Config) & Notification — **tạm hoãn** (2026-10-01, theo yêu cầu: chưa tạo được Firebase); làm Phase 11 trước
- [~] **Phase 11** — Monetization (RevenueCat, Paywall, AdMob + Meta, Consent) — code + test xong; chờ 👤 key RevenueCat/AdMob, sandbox, Meta bidding, iOS
- [ ] **Phase 12** — QA, tối ưu & phát hành

---

## [ ] PHASE 0 — Khởi tạo project & khung app

**Mục tiêu**: app chạy được với 3 tab rỗng, theme đúng design, router, l10n, DB rỗng, 3 flavor.
**Đọc**: `architecture.md` §1–4, §9, §10 · `design.md` §1–3.

### Task
- [x] **P0-01** Tạo project `flutter create --org <com.yourco> --platforms android,ios landmeasure`. Thêm toàn bộ package `architecture.md` §1 (bản mới nhất tương thích). Cấu hình `analysis_options.yaml` với `very_good_analysis`. Ghi version Flutter vào Changelog.
- [~] **P0-02** Flavor `dev` / `staging` / `prod`: Android `productFlavors` (applicationIdSuffix `.dev`, `.stg`), iOS schemes + xcconfig. `core/config/env.dart` đọc `--dart-define-from-file=env/<flavor>.json` (MAPS_API_KEY, ADMOB_APP_ID_*, AD_UNIT_*, REVENUECAT_KEY_*). Commit `env/example.json`, gitignore file thật.
- [x] **P0-03** Tạo cây thư mục đúng `architecture.md` §3 (file rỗng/placeholder cho các phần chưa làm là không cần — chỉ tạo khi dùng).
- [x] **P0-04** Theme: `lm_colors.dart` (`LmColors extends ThemeExtension`, light + dark), `mode_colors.dart` (`ModeColors.of(MeasurementType)` → main/container/fill), `lm_typography.dart` (Inter bundle trong `assets/fonts`, tabular figures), `lm_spacing.dart`, `lm_radius.dart`, `lm_shadows.dart`, `lm_theme.dart`.
- [x] **P0-05** Core widgets theo `design.md` §2: `PrimaryCta` (biến thể area/distance/walk/danger/tonalDanger, disabled, loading), `MapFab`, `StatusBanner`, `TypeChip`, `UnitChips`, `EmptyState`, `showLmConfirm()` trong `lm_dialog.dart`.
- [x] **P0-06** `app_router.dart`: `StatefulShellRoute` 3 tab + toàn bộ route `architecture.md` §10 trỏ tới màn placeholder.
- [x] **P0-07** `main_shell.dart`: bottom nav 3 tab (Home/Saved/Setting) theo `design.md` §3, giữ state từng tab.
- [x] **P0-08** l10n: `l10n.yaml`, `app_en.arb`, `app_vi.arb`, extension `context.l10n`. Locale lấy từ pref (tạm hard-code null).
- [x] **P0-09** `core/utils`: `Debouncer`, `Throttler`, `Clock`, `IdGenerator`, `Log`, `AppException` (sealed).
- [x] **P0-10** `bootstrap.dart` khung theo `architecture.md` §9 (các bước Firebase/Ads/RC/RevenueCat để TODO có comment trỏ tới phase tương ứng).
- [x] **P0-11** Icon & splash tạm (`flutter_launcher_icons`, `flutter_native_splash`) theo `design.md` §6.
- [x] **P0-12** CI GitHub Actions: `flutter analyze`, `flutter test`, build APK dev.
- [~] **P0-13** 👤 Google Cloud: tạo project, gắn billing, bật **chỉ** Maps SDK for Android + iOS, tạo 2 API key giới hạn package/SHA-1 & bundle ID, đặt budget alert 1 USD. Điền key vào `env/*.json`. (AI viết hướng dẫn từng bước vào `docs/setup_google_maps.md`.)
- [x] **P0-14** Golden test cho các core widget (light/dark).

### Tiêu chí hoàn thành
- [~] `flutter run --flavor dev` chạy trên Android emulator & iOS simulator. — Android ✅ (emulator API 31); iOS chưa kiểm (cần Mac).
- [x] 3 tab chuyển qua lại, đổi ngôn ngữ en/vi bằng code thử được.
- [~] `flutter analyze` sạch, CI xanh. — analyze sạch ✅; CI chưa chạy (repo chưa có remote GitHub).

---

## [x] PHASE 1 — Domain core (pure Dart)

**Mục tiêu**: toàn bộ logic tính toán, không phụ thuộc Flutter, test đầy đủ.
**Đọc**: `architecture.md` §2, §5.1–5.2, §7.

### Task
- [x] **P1-01** Models freezed: `GeoPoint`, `MeasurePoint`, `Photo`, `MeasurementStats`, `Measurement`, `MeasurementSummary` + `enums.dart`.
- [x] **P1-02** `GeoCalculator` (§7.1) + `test/fixtures/area_cases.json` (≥ 6 case: vuông 100m ở xích đạo, ở 21°N, ở 60°N; tam giác; đa giác lõm; thửa thật ở VN đo bằng Google Maps).
- [x] **P1-03** `PolygonValidator` (§7.2).
- [~] **P1-04** `TrackFilter` (§7.3) — nhận `TrackFilterConfig` (từ RC sau này) + test với 3 file GPX thật trong `test/fixtures/gpx/`.
- [x] **P1-05** `ClosureDetector` (§7.4).
- [x] **P1-06** `GeometryEditor` + `GeometryCommand` (§7.5) — test undo cho mọi lệnh, reindex.
- [x] **P1-07** `UnitConverter`, `land_units.dart` (§7.6).
- [x] **P1-08** `core/format`: `UnitFormatter.area/distance(value, unit, locale, {secondary})`, `DurationFormatter` (`HH:MM:SS`), `DateFormatter` (en `Sep 22, 2026 · 10:24`, vi `22/09/2026 · 10:24`), `MoneyFormatter` (vi: "1,87 tỷ", "350 triệu").
- [x] **P1-09** `GeoParse` (§7.7) — test đủ định dạng.
- [x] **P1-10** `PathSimplifier` (§7.8).
- [x] **P1-11** `FeatureGate` (§7.9) — nhận `GateConfig` + `isPremium`.

### Tiêu chí hoàn thành
- [x] Coverage `lib/domain` ≥ 90%. — 99,6% (510/512 dòng); `core/format` 100%.
- [x] Diện tích sai số ≤ 0,1% so với fixtures. — 8 case, giá trị tham chiếu tính bằng phương pháp độc lập.
- [x] `lib/domain` không import `package:flutter` (kiểm bằng grep trong CI).

---

## [x] PHASE 2 — Data layer

**Mục tiêu**: lưu/đọc measurement, điểm, ảnh, settings; draft bền vững.
**Đọc**: `architecture.md` §5.3–5.5, §6, §8.

### Task
- [x] **P2-01** `tables.dart`, `converters.dart`, `app_database.dart` (schemaVersion 1, `beforeOpen` FK + WAL, `MigrationStrategy`), `drift_dev schema dump` vào `drift_schemas/`.
- [x] **P2-02** DAO: `MeasurementDao`, `PointDao`, `PhotoDao` (query + stream).
- [x] **P2-03** `MeasurementRepository` (interface + `DriftMeasurementRepository`):
  `createDraft(type, mapStyle)` · `watch(id)` · `get(id)` · `replacePoints(id, points, stats)` (transaction, cập nhật bbox, updated_at) · `appendWalkPoints(id, points, stats, elapsedSec)` · `updateWalkState(id, state, {startedAt, elapsedSec, lastResumeAt})` · `updateMeta(id, {name, notes, displayUnits, unitPrice…})` · `setStatus(id, status, {savedAt})` · `watchSaved({type, query})` · `watchDrafts()` · `watchRecent(limit)` · `countSaved()` · `countByType()` · `delete(id)` (DB + `PhotoStorage.deleteForMeasurement` + thumbnail).
- [x] **P2-04** `PhotoStorage`: `importFromCamera/Gallery(XFile, measurementId, {pointId, GeoPoint?})` (nén trong isolate theo §5.4, thumb 320px), `delete`, `deleteForMeasurement`, `resolve(relative) → File`.
- [x] **P2-05** `PhotoRepository`: `add`, `remove`, `watchForMeasurement`, `reorder`, `setCaption`, `detachPoint(pointId)`.
- [x] **P2-06** `ThumbnailStorage`: API `saveSnapshot(id, Uint8List)` + `renderFallback(measurement)` (CustomPainter → PNG 400×400, nền `mode.container`).
- [x] **P2-07** `SettingsRepository` + `AppSettings` (freezed) + `settingsProvider` với mặc định theo locale (§5.5).
- [x] **P2-08** `OrphanFileCleaner` (7 ngày/lần) + dọn `temp/exports` khi khởi động.
- [x] **P2-09** Providers keepAlive cho DB/repo/storage.
- [x] **P2-10** Test: DB in-memory cho repository (CRUD, cascade, stream), migration test, PhotoStorage với thư mục tạm.

### Tiêu chí hoàn thành
- [x] Xoá measurement không để lại file ảnh/thumbnail (test đếm file).
- [x] Stream `watchSaved` phát lại khi rename/delete.
- [x] Toàn bộ test pass. — 177 test.

---

## [ ] PHASE 3 — Nền bản đồ + Measure Area

**Mục tiêu**: đo diện tích hoàn chỉnh (chưa có Save thật — nút Save tạm snackbar), draft tự lưu.
**Đọc**: `design.md` §2.3–2.10, §5.2 · `architecture.md` §8.

### Task
- [x] **P3-01** `MeasureSessionState` + `MeasureSessionController(type, draftId?)`: load draft; `addPointAt(GeoPoint, {method, accuracy})`, `movePoint`, `selectPoint`, `deleteSelected`, `undo`, `reset`, `closeShape`, `reopenShape`, `setMapStyle`; tính stats; autosave debounce 300ms; tạo draft ở điểm đầu tiên; `flushNow()` khi `AppLifecycleListener.onPause`.
- [x] **P3-02** `MarkerFactory`: render `PointHandle` (thường/chọn/có ảnh), `MapResultPill`, `EdgeLengthLabel`, Start/End → `BitmapDescriptor.bytes`, cache theo key + DPR.
- [x] **P3-03** `MeasureMapView`: bọc `GoogleMap`, props hình học, `mapType` từ `MapStyleMapper`, padding theo chiều cao sheet, `onCameraIdle`, `onTap`, marker draggable (`onDrag` throttle 30ms cập nhật polygon tạm, `onDragEnd` → controller), `myLocationEnabled` khi có quyền, dark JSON style cho Standard.
- [x] **P3-04** `CenterCrosshair` + `MeasureToolbar` (Undo · 📍 · Add Point · Close) theo `design.md` §2.7–2.8; trạng thái disabled đúng.
- [x] **P3-05** `ResultSheet` (DraggableScrollableSheet snap 0.22/0.45/0.9) + `AreaResultPanel` (AREA/PERIMETER, số animate, UnitChips, placeholder "Add at least 3 points…").
- [x] **P3-06** `AreaMeasureScreen`: ghép map + FAB (Layers, My location, Search, Camera — Search/Camera tạm disabled tới Phase 4/7) + toolbar + sheet + CTA "Save Measurement" (disabled < 3 điểm).
- [x] **P3-07** Chọn điểm → `PointActionsPopup` (Delete; Photo để Phase 7).
- [x] **P3-08** Cảnh báo polygon tự cắt (viền đứt nét vàng + StatusBanner).
- [x] **P3-09** Overflow menu: Reset (confirm), Input mode (Crosshair/Tap), Show edge labels.
- [x] **P3-10** Nút 📍 "Add at my location": `Geolocator.getCurrentPosition(high, timeLimit 10s)`, accuracy > 20m → snackbar cảnh báo nhưng vẫn thêm. (Xin quyền tối giản ở đây; luồng quyền hoàn chỉnh ở Phase 9.)
- [x] **P3-11** Không có quyền vị trí vẫn đo được: camera mặc định = vị trí cuối biết hoặc theo locale (vi: Hà Nội 21.0285,105.8542, zoom 15).
- [x] **P3-12** Widget test controller + golden `AreaResultPanel`.

### Tiêu chí hoàn thành
- [~] Đo 1 thửa bất kỳ, kết quả khớp công cụ đo của Google Maps ±0,5%. — Công thức giống hệt `SphericalUtil.computeArea` của Google, fixture sai < 0,1% (Phase 1). Còn 👤 đo cùng một thửa bằng thước Google Maps để đối chiếu.
- [x] Kill app sau khi thêm điểm → mở lại, draft còn đủ điểm (kiểm bằng DB/log; UI Resume ở Phase 6). — force-stop trên emulator, đọc file DB: đủ 4 điểm, đúng thứ tự, `is_closed=1`.
- [x] Pan/zoom mượt với 100 điểm. — emulator, 100 điểm: 372 frame, 3,8% janky, p50 5 ms, p90 17 ms, p99 48 ms.

---

## [ ] PHASE 4 — Measure Distance + tính năng chung màn đo

**Đọc**: `design.md` §5.3, §5.2 (overflow, help), §5.17.

### Task
- [x] **P4-01** `DistanceResultPanel`: DISTANCE + secondary, số segment, danh sách "A → B 210 m" ở snap 0.9.
- [x] **P4-02** `DistanceMeasureScreen`: polyline xanh dương, Start xanh lá, End pin đỏ, pill tổng ở trung điểm, nhãn từng đoạn; toolbar Undo · 📍 · Add Point · Reset; CTA "Save Route" (≥ 2 điểm).
- [x] **P4-03** `MapLayerSheet`: Standard/Satellite/Terrain/Hybrid → lưu vào measurement + pref `map_style`.
- [x] **P4-04** `PlaceSearchSheet`: `GeoParse` → animate camera; địa chỉ → `geocoding.locationFromAddress` (chỉ gọi khi bấm tìm, không theo từng phím); 5 tìm kiếm gần đây; trạng thái loading/không có kết quả.
- [x] **P4-05** Rời màn đo **không hỏi** (chốt 2026-09-28, hướng B): back (kể cả back cứng Android, `PopScope`) → `flushNow` → thoát. 0 điểm → không có draft. Có draft → về màn trước hiện snackbar "Đã lưu nháp '<tên> · n điểm'" + nút **Bỏ** (→ `repository.delete`, không hỏi thêm vì đây là thao tác chủ động ngay sau khi thoát). Resume qua `DraftBanner` ở Home (Phase 6). Không tự xoá draft ít điểm, không tự dọn draft cũ (ưu tiên không mất dữ liệu).
- [x] **P4-06** `MeasureHelpSheet theo mode — nội dung, layout và chuỗi en/vi ở design.md §5.18. Tự hiện 1 lần ở lần đầu mở mỗi chế độ (pref help_seen_<mode>); câu tóm tắt dùng lại làm hint banner khi chưa có điểm. Walk dùng chung component (nối vào màn Walk ở Phase 5).`
- [x] **P4-07** `ConnectivityService` + StatusBanner "Map connection unavailable — your points are safe".
- [x] **P4-08** Keep screen awake (`wakelock_plus`) theo setting khi ở màn đo.

### Tiêu chí hoàn thành
- [~] Distance đo khớp Google Maps ±0,5%. — Haversine đã kiểm với fixture (Phase 1); còn 👤 đối chiếu thước Google Maps.
- [~] Tìm được bằng toạ độ, link Google Maps, địa chỉ tiếng Việt. — Toạ độ ✅, link đầy đủ ✅ (emulator); link rút gọn ✅ (unit test); **địa chỉ: chưa kiểm được** — geocoder Google Play trên emulator bị từ chối ("Application credential header not valid"), cần 👤 thử trên máy thật.
- [x] Back ở mọi trạng thái không mất dữ liệu. — back cứng/app bar: DB có đủ điểm, snackbar "Đã lưu nháp · Bỏ", Bỏ → draft bị xoá (emulator).

---

## [~] PHASE 5 — Walk & Measure

**Đọc**: `design.md` §5.4–5.5, §5.16 · `architecture.md` §7.3–7.4, §8, §12.

### Task
- [x] **P5-01** `LocationTracker`: `previewStream()` (không ghi, để hiện accuracy), `start()` với `AndroidSettings(accuracy best, intervalDuration 2s, foregroundNotificationConfig: title "LandMeasure is recording your measurement", enableWakeLock, setOngoing)` và `AppleSettings(bestForNavigation, activityType fitness, pauseLocationUpdatesAutomatically false, allowBackgroundLocationUpdates true, showBackgroundLocationIndicator true)`, `stop()`, `serviceStatusStream`.
- [x] **P5-02** Cấu hình native theo `architecture.md` §12 (quyền Android, foregroundServiceType, `UIBackgroundModes`).
- [x] **P5-03** `WalkState` + `WalkController` (keepAlive): `prepare`, `start` (tạo draft, walkState=recording, segment 0), `_onFix` (TrackFilter → append → stats → buffer), flush mỗi 5 điểm/10s, `pause` (flush, cộng dồn elapsed), `resume` (segmentIndex++), `finish` (confirm → status=completed), timer UI 1s.
- [x] **P5-04** `WalkScreen` Ready: GPS status banner (searching/ready/low/off), accuracy, CTA Start Walking (disabled khi chưa fix/location off), helper text.
- [x] **P5-05** `WalkScreen` Recording/Paused: track cam theo segment (không nối giữa segment), fill xanh khi `isClosed`, halo accuracy, hint "Close to start", sheet 3 cột Duration/Distance/Area, nút Pause/Resume + Finish, follow camera + recenter khi user pan.
- [x] **P5-06** Xử lý GPS tắt giữa chừng (banner + `openLocationSettings`, giữ state), accuracy thấp, mock location (không ghi điểm, cảnh báo).
- [x] **P5-07** `WalkRecoveryService` (gọi trong bootstrap): walk draft đang `recording` khi app khởi động → chuyển `paused`, giữ `walk_elapsed_sec`.
- [x] **P5-08** `BatteryOptimizationHelper`: máy Xiaomi/Oppo/Vivo/Realme/Huawei/Honor/OnePlus/Samsung → sheet hướng dẫn 1 lần, nút mở cài đặt tối ưu pin.
- [x] **P5-09** Xin `POST_NOTIFICATIONS` (Android 13+) trước lần Start đầu (từ chối vẫn ghi được).
- [x] **P5-10** `WalkResultPanel` sau Finish (Distance, Duration, Area hoặc "Route not closed — distance only") + CTA Save.
- [ ] **P5-11** 🧪 Test thực địa: 30 phút màn hình tắt trên 1 Android + 1 iPhone; pause 5 phút rồi đi chỗ khác → resume không có đường nối thẳng.

### Tiêu chí hoàn thành
- [~] Ghi liên tục 30 phút khi tắt màn hình (Android có notification thường trực, iOS có chấm xanh). — Emulator API 31: tắt màn hình vẫn ghi điểm, foreground service `location` + notification ongoing (màu brand). Còn 👤 30 phút trên Android thật + iPhone.
- [x] Force-stop khi đang ghi → mở lại khôi phục đúng (paused, đủ điểm). — emulator: 62 điểm / 3 segment, `recording` → `paused`, giữ `walk_elapsed_sec`.
- [~] Đi 1 vòng sân bóng → Area sai số ≤ 5% so với đo tay trên vệ tinh. — Mô phỏng vòng 40 × 40 m trên emulator: 1.590 m² (−0,6%). Còn 👤 đi thật.

---

## [x] PHASE 6 — Save, Home, Saved, Detail

**Đọc**: `design.md` §2.12–2.13, §5.1, §5.6–5.8.

### Task
- [x] **P6-01** `NameSuggester` ("Area · Sep 28" / "Diện tích · 28/09", trùng trong ngày thêm " (2)").
- [x] **P6-02** `SaveMeasurementSheet` + `SaveController`: mini thumbnail, Name (trim, 1–80, bắt buộc), Type/Result read-only, Notes (≤ 2000), Photos (hiển thị; thêm ở Phase 7). `save()` theo `architecture.md` §8 (FeatureGate để hook sẵn, luôn true tới Phase 11). Thumbnail: `takeSnapshot()` nếu map còn sống, fallback painter; lỗi không chặn save.
- [x] **P6-03** Nối CTA Save ở Area/Distance/Walk → `/save/:id` → sau lưu `go('/detail/:id')` thay stack đo.
- [x] **P6-04** `HomeController` + `HomeScreen`: hero card (ảnh đổi theo mode, crossfade), `ModeSegmentedSelector`, CTA động, `DraftBanner` (draft mới nhất + "See all drafts"), Recent 3 bản SAVED, empty state; mode mặc định từ setting.
- [x] **P6-05** `SavedController` + `SavedScreen`: search toggle (debounce 200ms, `name_lower LIKE`), chips có count, `DraftsSection` (collapsible, gồm COMPLETED), list `MeasurementListTile`, empty/no-result, sắp xếp `updated_at DESC`.
- [x] **P6-06** Menu ⋯: `RenameDialog`, Export (mở sheet — nội dung Phase 8), Delete (confirm → xoá → snackbar).
- [x] **P6-07** Draft actions: Resume (route theo type + draftId), Rename, Discard (confirm).
- [x] **P6-08** `DetailController` + `DetailScreen`: thumbnail 16:10 (tap → `FullMapScreen` read-only có Layers), tên + TypeChip + ngày, result grid theo type, UnitChips (lưu `display_*_unit`), khu Photos/Notes (hiển thị), action bar Edit/Export/Delete.
- [x] **P6-09** `FullMapScreen`.
- [x] **P6-10** Golden: `MeasurementListTile`, `DraftBanner`, `HomeScreen` (có/không data).

### Tiêu chí hoàn thành
- [x] Vòng lặp chính chạy trọn: Home → đo → Save → Detail → Saved → Rename → Delete. — emulator: Area 4 điểm → Save (ảnh chụp bản đồ) → Detail → back về Home → Saved → đổi tên "Ruong Dong" → tìm "ruong" → Delete (xoá cả file thumbnail).
- [x] Draft xuất hiện đúng ở Home & Saved, Resume mở đúng trạng thái. — Distance nháp 2 điểm: "Tiếp tục đo" ở Home, mục Drafts ở Saved; chạm → màn đo nạp đủ 2 điểm → Save Route. Walk đã Finish hiện "Finished · not saved".
- [x] Record mới xuất hiện ngay ở Saved và Recent (stream). — Area/Distance/Walk vừa lưu hiện ngay ở Recent.

---

## [x] PHASE 7 — Ảnh, Ghi chú, Edit

**Đọc**: `design.md` §2.11, §5.9, §5.14.

### Task
- [x] **P7-01** `AddPhotoSheet` (Take Photo / Choose from Gallery multi-select): pre-prompt quyền camera, gắn lat/lng hiện có, gắn `pointId` nếu đang chọn điểm; hook `FeatureGate.canAddPhoto`.
- [x] **P7-02** `PhotoStrip` (thumbnail + ✕ + ô Add Photo + nhãn "P3") dùng ở Area/Distance/Walk/Save/Detail.
- [x] **P7-03** Xoá ảnh: trong phiên đo xoá ngay + snackbar Undo (trì hoãn xoá file 5s); ở Detail confirm dialog.
- [x] **P7-04** Ảnh theo điểm: marker có badge 📷; `PointActionsPopup` thêm "Photo"; xoá điểm → `detachPoint`.
- [x] **P7-05** `PhotoViewerScreen`: PageView, pinch zoom, "1 / 4", ngày chụp, "Point 3", Delete, Share (`share_plus`).
- [x] **P7-06** Setting "Save Photos to Measurement" OFF → sau chụp hỏi "Attach this photo to measurement?".
- [x] **P7-07** Notes: trường ở Save; ở Detail tap → sheet sửa → lưu; autosave notes vào draft (debounce 500ms).
- [x] **P7-08** `EditController` + `EditMeasurementScreen`: Area/Distance dùng lại map + `GeometryEditor` với bản sao, **không autosave**; tab Details (name, notes, photos); `saveChanges()` transaction + regenerate thumbnail; back khi dirty → "Discard changes?". Walk: chỉ Details.

### Tiêu chí hoàn thành
- [x] Ảnh chụp 12MP lưu ≤ 700KB, mở lại app vẫn hiển thị (đường dẫn tương đối). — emulator: ảnh 4000×3000 (2,46 MB) chọn từ thư viện → lưu 409 KB (2048 px, q82) + thumb 9 KB; DB chỉ lưu đường dẫn tương đối. Còn 👤 thử ảnh camera 12MP thật (camera emulator chỉ ra ảnh nhỏ).
- [x] Ảnh gallery không bị xoá khỏi máy khi xoá measurement. — emulator: xoá phép đo → `photos/` của app trống, ảnh gốc trong `Pictures/` còn nguyên; có test.
- [x] Huỷ Edit → dữ liệu gốc nguyên vẹn. — emulator: Edit → thêm điểm → back → "Bỏ thay đổi?" → Bỏ → vẫn 4 điểm; có test (kể cả ảnh thêm trong lúc Edit bị xoá khi Bỏ).

---

## [~] PHASE 8 — Export & Giá trị đất

**Đọc**: `architecture.md` §5 · spec Export trong `overview.md`.

### Task
- [x] **P8-01** `KmlEncoder`: KML 2.2, Style theo màu mode (aabbggrr), `ExtendedData` (type, area_m2, perimeter_m, distance_m, duration_s, created_at, notes); Area → Polygon (lặp điểm đầu cuối, `lng,lat,0`); Distance → LineString; Walk → MultiGeometry theo segment (+ Polygon nếu closed); điểm có ảnh → Placemark Point "P3".
- [x] **P8-02** `CsvEncoder`: header `measurement_name,measurement_type,created_at,segment_index,point_index,latitude,longitude,altitude,accuracy,timestamp,area_m2,perimeter_m,distance_m,duration_s`; UTF-8 **có BOM**; ISO-8601.
- [x] **P8-03** `ExportService.export(id, format)` → file `temp/exports/<slug>_<time>.<ext>` → `Share.shareXFiles`. `ExportSheet` (KML/CSV) từ Saved ⋯ và Detail. Hook `FeatureGate.canExport` (Phase 11 nối rewarded/paywall).
- [x] **P8-04** Giá trị đất: ở Save & Detail nhập đơn giá + đơn vị (m²/ha/acre…) → "Estimated value ≈ …" theo `MoneyFormatter`; lưu `unit_price*`.
- [~] **P8-05** Test golden file cho KML/CSV; 🧪 mở KML bằng Google Earth, CSV bằng Excel. — golden file xong (`test/fixtures/export/`); còn 👤 mở thử.

### Tiêu chí hoàn thành
- [~] KML mở đúng hình trên Google Earth; CSV tiếng Việt không lỗi font trên Excel. — KML 2.2 hợp lệ (parse lại được, vòng khép, màu aabbggrr); CSV có BOM UTF-8 + CRLF (kéo file từ emulator: đọc lại đúng tiếng Việt). Còn 👤 mở bằng Google Earth / Excel.
- [~] Share sheet hiện Zalo/Drive/Mail trên máy thật. — emulator: share sheet hệ thống hiện Drive, Gmail, Quick Share với đúng file. Còn 👤 máy thật có Zalo.

---

## [x] PHASE 9 — Settings, quyền, trạng thái lỗi, đa ngôn ngữ, dark mode

**Đọc**: `design.md` §5.10–5.13, §5.16–5.17, §4.

### Task
- [x] **P9-01** `SettingsController` + `SettingsScreen` (3 section + Support & Legal + app info; mục Premium để placeholder ẩn tới Phase 11).
- [x] **P9-02** `UnitsScreen` (Distance, Area, nhóm đơn vị Việt Nam, toggle secondary), `MapStyleScreen` (grid preview + Apply), `LanguageScreen` (tên bản ngữ, đổi locale runtime).
- [x] **P9-03** Default Measurement Type, GPS Accuracy Display, Auto Center Map, Save Photos, Keep Screen Awake — nối vào các màn đã làm.
- [x] **P9-04** `PermissionService` + `PermissionPromptSheet`: pre-prompt location/camera/notification, denied vĩnh viễn → "Open Settings"; thay các chỗ xin quyền tạm ở Phase 3/5/7.
- [x] **P9-05** Help & Feedback (`mailto:` kèm version/device), Rate Us (`openStoreListing`), Privacy Policy, Terms (`url_launcher`). 👤 cung cấp URL chính sách. — giá trị lấy từ env (`SUPPORT_EMAIL`, `PRIVACY_POLICY_URL`, `TERMS_URL`, `APP_STORE_ID`), trống thì ẩn mục; còn 👤 điền giá trị thật.
- [x] **P9-06** Dịch đủ en + vi; thêm es, pt, hi, id, zh (dịch máy, đánh dấu cần review). Kiểm overflow với text scale 1.3 và chuỗi dài.
- [x] **P9-07** Dark mode toàn app + map style tối cho Standard.
- [x] **P9-08** Accessibility: Semantics cho FAB/số đo, touch ≥ 48dp.
- [x] **P9-09** Rà toàn bộ dialog/copy theo `design.md` §5.17.

### Tiêu chí hoàn thành
- [x] Mọi mục Setting có tác dụng thật (không dead button). — emulator API 35: Units/Map Style/Language/Default type đổi là thấy ngay ở Home, màn đo, Saved; tắt GPS Accuracy → banner Walk mất ±m và vòng độ chính xác; tắt Auto Center → Area/Distance mở ở chỗ bản đồ lần trước, Walk không bám; Save Photos có test (Phase 7); Help & Feedback mở Gmail, Rate Us / Privacy / Terms mở đúng link (env thử); mục chưa cấu hình bị ẩn.
- [x] Từ chối mọi quyền: app không crash, Area/Distance vẫn dùng được. — cài mới, từ chối vị trí (2 lần), camera (2 lần), thông báo: Area đo được bằng kéo bản đồ (snackbar giải thích), camera bị chặn → sheet "Open Settings", vị trí bị chặn → banner Walk "Open Settings" → bật quyền ở Cài đặt → quay lại tự nhận; Walk vẫn ghi khi không có quyền thông báo. iOS chưa kiểm (cần Mac).
- [x] Chuyển vi ↔ en không vỡ layout. — đổi ngay không cần mở lại app; Setting/Home/Saved/Language bằng vi, es trên máy; test tự động 7 ngôn ngữ × chữ 1.3 × màn 360 dp không tràn.

---

## [ ] PHASE 10 — Firebase & Notification

**Đọc**: `architecture.md` §9, §11, §11.1.

### Task
- [ ] **P10-01** 👤 Tạo Firebase project (dev + prod), chạy `flutterfire configure` theo flavor; upload APNs key.
- [ ] **P10-02** `CrashReporter` (Crashlytics, custom keys `screen`, `walk_state`, non-fatal cho lỗi DB/export/photo/location); tắt ở dev.
- [ ] **P10-03** `AnalyticsService` + `analytics_events.dart` (hằng số tên event/param); gắn toàn bộ event §11.1 vào controller tương ứng; user properties.
- [ ] **P10-04** `RemoteConfigService` + `rc_keys.dart` (defaults §11); nối `TrackFilterConfig`, `GateConfig`.
- [ ] **P10-05** `NotificationService` (channels, tap → deep link `architecture.md` §10).
- [ ] **P10-06** `DraftReminderScheduler`: rời màn để lại draft → nhắc sau 24h (1 lần/draft), huỷ khi save/discard.
- [ ] **P10-07** `PushService` (FCM): xin quyền sau lần save đầu (iOS), token, topic `all`, `lang_<code>`, `free`/`premium`; foreground message → local notification; payload `route` → deep link.
- [ ] **P10-08** `ReviewPromptService`: sau save thứ N (RC), 1 lần/90 ngày.

### Tiêu chí hoàn thành
- [ ] Event hiện trong DebugView; crash test hiện trên Crashlytics.
- [ ] Đổi giá trị RC trên console → app nhận sau khi mở lại.
- [ ] Gửi push test từ console → nhận được, tap mở đúng màn.

---

## [~] PHASE 11 — Monetization

**Đọc**: `overview.md` §5.3 · `architecture.md` §7.9, §11.

### Task
- [ ] **P11-01** 👤 App Store Connect: subscription group "Premium" (monthly, yearly + trial 3 ngày), non-consumable lifetime. Play Console: 2 subscription + base plan, 1 in-app lifetime. RevenueCat: project, upload In-App Purchase Key (iOS) + Service Account JSON (Android), entitlement `premium`, offering `default`. (AI viết `docs/setup_play_billing.md`.) — AI đã viết `docs/setup_play_billing.md`; còn 👤 làm trên console.
- [x] **P11-02** `PurchaseService`: `init`, `isPremiumStream` (từ `customerInfoStream`), `offerings`, `purchase`, `restore`, `manageSubscriptionUrl`, cache `premium_cached`; lỗi hủy mua → im lặng.
- [x] **P11-03** `PaywallScreen` + `PremiumController` theo `design.md` §5.15 (source, ✕ sau 2s, restore, điều khoản gia hạn).
- [x] **P11-04** Nối `FeatureGate` thật: save limit, photo limit, export KML (1 lần/ngày hoặc rewarded), mục Premium trong Settings (Manage subscription).
- [ ] **P11-05** 👤 AdMob: app + ad unit (banner, interstitial, rewarded, app open) × 2 nền tảng; bật Meta Audience Network **bidding** trong Mediation, map placement ID. — AI đã viết `docs/setup_admob.md`; còn 👤.
- [x] **P11-06** `ConsentService` (UMP mỗi lần mở app; Privacy choices trong Settings khi required) + ATT iOS (sau UMP, từ lần mở thứ 2 hoặc sau save đầu). — ATT iOS chưa kiểm (cần Mac).
- [x] **P11-07** `AdsService` init sau consent, test IDs ở dev, tắt khi premium; thêm `gma_mediation_meta`, SKAdNetwork IDs, R8 rules.
- [x] **P11-08** `BannerAdSlot` (Home, Saved, Detail — giữ chỗ chiều cao).
- [x] **P11-09** `InterstitialManager` (sau Save theo RC, không khi Walk đang ghi), `RewardedManager` (lỗi load → vẫn cho export), `AppOpenManager` (quay lại sau N giờ; không lần mở đầu, không ở màn đo, không sau share/camera/paywall). — luật hiện là hàm thuần có test; chưa kiểm interstitial/app open trên máy (emulator hỏng giữa chừng).
- [~] **P11-10** Kiểm bằng Ad Inspector: Meta bidding có tham gia đấu giá. — có mục "Ad Inspector (dev)" trong Setting; cần 👤 ad unit thật + Meta bidding để kiểm.

### Tiêu chí hoàn thành
- [ ] Sandbox: mua / khôi phục / hết hạn đúng trên cả iOS và Android; ads biến mất ngay khi mua. — 👤 cần key RevenueCat + sản phẩm trên store (`docs/setup_play_billing.md`). Đã có widget test: mua → premium → Paywall đóng; huỷ mua im lặng; khôi phục; gate tắt quảng cáo + bỏ giới hạn ngay khi entitlement đổi.
- [~] UMP hiện khi test địa lý EEA; ATT hiện đúng thời điểm. — emulator API 35 với `UMP_DEBUG_EEA`: form đồng ý hiện khi mở app, bấm Đồng ý → SDK khởi tạo → banner test hiện. ATT (iOS) chưa kiểm — cần Mac.
- [x] Không có ad nào trên màn đo/Walk. — banner chỉ ở Home/Saved/Detail; interstitial/app open bị chặn ở màn đo/Walk/Edit/Save/Paywall và khi Walk đang ghi (có test); emulator: màn Measure Area không có quảng cáo.

---

## [ ] PHASE 12 — QA, tối ưu & phát hành

### Task
- [ ] **P12-01** Integration test: Area 4 điểm → Save → Detail → Rename → Export CSV → Delete; Distance tương tự; Draft resume.
- [ ] **P12-02** 🧪 Test thực địa Walk: 5 khu (ruộng mở, cạnh nhà cao, cây rậm, đường làng, sân bóng) × 4 máy (Samsung, Xiaomi, Oppo, iPhone).
- [ ] **P12-03** 🧪 Kịch bản sự cố: kill app khi đo, tắt GPS, chế độ máy bay, đầy bộ nhớ, từ chối mọi quyền, xoay màn, text scale lớn, đổi ngôn ngữ khi có draft.
- [ ] **P12-04** Hiệu năng (DevTools): cold start < 1,5s máy tầm trung; 300 điểm pan mượt; 50 ảnh không tràn RAM; App Bundle mỗi ABI ≤ 30MB.
- [ ] **P12-05** Rà "Definition of Done" dưới đây.
- [ ] **P12-06** 👤 Store: icon, 6 screenshot × (en, vi), mô tả (không claim RTK/cm), privacy policy URL, Data safety, App Privacy, age rating, khai báo foreground service `location` (kèm video).
- [ ] **P12-07** 👤 Phát hành: Play internal → closed testing (đủ tester/ngày theo quy định hiện hành) → production staged 20%; iOS TestFlight → review.

### Definition of Done — MVP
- [ ] Mọi nút hiển thị đều có hành vi.
- [ ] Không mất dữ liệu trong mọi kịch bản P12-03.
- [ ] Area/Distance ±0,5% so với Google Maps; Walk khu mở ±5%.
- [ ] Crash-free ≥ 99,5% ở closed testing.
- [ ] Không claim RTK/cm trong app & store.
- [ ] Premium mua/khôi phục/hết hạn đúng; ads tắt khi premium.
- [ ] en + vi hoàn chỉnh.

---

## 🗂 Backlog (sau MVP)

| Version | Hạng mục | Ghi chú |
|---|---|---|
| 1.1 | Báo cáo PDF | ✅ làm 2026-10-19 (chỉ `pdf`, mẫu `LandMeasure_Measurement_Report_Sample.pdf`). Còn: ảnh nền bản đồ thật (hiện vẽ vector), QR Google Maps, font hi/zh |
| 1.1 | Ảnh kết quả để chia sẻ | `RepaintBoundary.toImage` 1080×1080 |
| 1.1 | Thư mục / màu | bảng `folders`, cột `folder_id` (migration v2) |
| 1.1 | Import KML/KMZ/GeoJSON | mở file từ app khác |
| 1.1 | Export GPX, GeoJSON, KMZ kèm ảnh | |
| 1.1 | Curve mode | cung qua 3 điểm |
| 1.2 | Chia lô, ước tính hàng rào, trim Walk, ghi chú theo điểm | |
| 2.0 | Offline maps, backup cloud, lớp WMS/quy hoạch, Drive mode, độ cao | |

---

## 👤 Việc chờ người

> AI thêm vào đây những gì cần người làm (key, tài khoản, thiết bị, URL, quyết định).

- [ ] Chọn package name / bundle ID chính thức (`com.<yourco>.landmeasure`).
- [ ] **Phase 10**: tạo Firebase project (dev + prod), chạy `flutterfire configure` — đang hoãn.
- [ ] **P11-01**: sản phẩm IAP trên App Store Connect + Play Console, project RevenueCat, điền `REVENUECAT_KEY_*` (`docs/setup_play_billing.md`); thử sandbox mua / khôi phục / hết hạn.
- [ ] **P11-05 / P11-10**: app + 4 ad unit × 2 nền tảng trên AdMob, message GDPR trong Privacy & messaging, Meta bidding, app-ads.txt; điền `ADMOB_APP_ID_*`, `AD_UNIT_*` vào `env/prod.json`; kiểm Meta bidding bằng Ad Inspector (`docs/setup_admob.md`).
- [ ] **Phase 11 iOS** (Mac): `pod install`, kiểm ATT (không ở lần mở đầu), UMP, mua sandbox; đối chiếu `SKAdNetworkItems` với danh sách mới nhất của Google/Meta.
- [ ] URL Privacy Policy & Terms, email hỗ trợ, App Store ID (iOS) → điền `PRIVACY_POLICY_URL`, `TERMS_URL`, `SUPPORT_EMAIL`, `APP_STORE_ID` trong `env/<flavor>.json` (trống thì mục tương ứng trong Setting bị ẩn).
- [ ] **P9-06**: người bản ngữ review bản dịch máy es, pt, hi, id, zh (`lib/core/l10n/arb/app_<lang>.arb`); xong thì bỏ `@@x-machine-translated` và bỏ ngôn ngữ đó khỏi `machineTranslatedLanguages` (`settings_labels.dart`).
- [ ] **P0-02 iOS** (tạm hoãn theo yêu cầu, làm sau): trên máy Mac chạy `cd ios && pod install`, rồi `flutter run --flavor dev --dart-define-from-file=env/dev.json` trên simulator. Flavor iOS được cấu hình bằng script (không có Xcode) → cần mở `Runner.xcworkspace` kiểm tra 4 scheme (Runner/dev/staging/prod) và 12 build configuration.
- [ ] **P0-12**: tạo repo GitHub, push để CI chạy lần đầu.
- [ ] **P0-13**: key Android đã có và chạy được. Còn: giới hạn key theo package + SHA-1 (danh sách trong `docs/setup_google_maps.md` mục "Trạng thái hiện tại"), chỉ bật Maps SDK for Android, budget alert 1 USD.
- [ ] Tạo upload keystore + `android/key.properties` (`docs/android_release.md`) trước khi phát hành.
- [ ] **P1-04**: ghi 3 file GPX thật (đi quanh ruộng/sân, đứng yên 3 phút, đi đường dưới cây) có accuracy mỗi điểm, bỏ vào `test/fixtures/gpx/`. Hiện dùng file mô phỏng.
- [ ] **P5-11 / tiêu chí Phase 5** (máy thật): (1) Android (ưu tiên Xiaomi/Oppo/Samsung) + iPhone: Walk 30 phút màn hình tắt, kiểm notification thường trực (Android) / chấm xanh (iOS), số điểm liên tục; (2) Pause 5 phút, đi chỗ khác, Resume → không có đường nối thẳng; (3) đi 1 vòng sân bóng, so diện tích với đo tay trên vệ tinh (≤ 5%); (4) iOS: `pod install` + build để kiểm `UIBackgroundModes location`. Nên kèm file GPX/log để tinh chỉnh `TrackFilter` (nợ Phase 1).
- [ ] **Phase 8** (máy thật): Saved/Detail → Export → KML: mở bằng Google Earth (đúng hình, màu, điểm "P3" nếu có ảnh theo điểm) ; CSV: gửi qua Zalo/Drive, mở bằng Excel trên Windows — tên tiếng Việt phải đúng dấu. Nếu Excel dồn cả dòng vào một cột (máy đặt dấu phẩy thập phân), báo lại để cân nhắc đổi sang dấu `;`.
- [ ] **P4 tiêu chí 2**: trên máy thật (có Google Play), tìm "Vũ Thư, Thái Bình" và "Hồ Hoàn Kiếm" → phải ra kết quả và bay tới đúng khu vực.
- [ ] **P4 tiêu chí 1**: đo cùng một tuyến trong app và bằng thước Google Maps, chênh ≤ 0,5%.
- [ ] **P3 tiêu chí 1**: đo một thửa trong app và bằng thước Google Maps (cùng các góc), chênh lệch phải ≤ 0,5%.
- [ ] **P1-02**: đo thửa `rice_field_thai_binh` (toạ độ trong `test/fixtures/area_cases.json`) bằng thước của Google Maps để đối chiếu.
- [ ] Ảnh hero vệ tinh có bản quyền hợp lệ (3 ảnh) + 4 ảnh preview Map Style.

---

## 📝 Nhật ký tiến độ

> Mỗi phiên AI thêm 1 mục **ở đầu danh sách** theo mẫu.

### 2026-10-19 — Phase 11: Premium map chỉ mua + Báo cáo PDF
- Yêu cầu: (1) tạm ẩn đường xem quảng cáo reward để mở map style, bắt mua và đi thẳng tới màn mua; (2) làm báo cáo PDF theo mẫu `LandMeasure_Measurement_Report_Sample.pdf`. **Giả định cần xác nhận**: tài liệu mẫu là *báo cáo xuất ra* (có mục "Export Information") nên tôi làm **xuất** PDF, không phải nhập (import) PDF — nếu thật sự cần đọc PDF vào app thì báo lại.
- Đã làm: `PremiumFlows.unlockMapStyle` đi thẳng paywall (`source=map_style`), code reward giữ sau cờ `_mapStyleRewardEnabled` (3 test reward được `skip`, test popup đổi thành "thẳng paywall"). Báo cáo PDF A4 nhiều trang, bám mẫu: header LM + tên app, tiêu đề theo loại (Land/Distance/Walk Measurement Report), bảng Name/Type/Date saved/Report ID (`LM-AREA-yyyyMMdd-xxxx`), Measurement summary (4 ô theo loại, màu theo mode), Map & Shape (vector, hướng bắc, thanh tỉ lệ, nhãn P1…, Start/End cho tuyến), Coordinates (lat/lng 6 số, độ dài đoạn, ghi chú Start/End/có ảnh; tối đa 120 dòng, header lặp lại mỗi trang), Survey notes, Site photos (lưới 2 cột, tối đa 8 ảnh, chú thích + điểm + giờ chụp), Export information, Accuracy notice, footer có số trang. Dòng "PDF — Report" trong Export sheet có huy hiệu Premium; free bấm → thẳng paywall (`source=export_pdf`), mua xong tự xuất.
- Kiểm chứng: `flutter analyze` sạch; toàn bộ test pass (thêm `pdf_report_test.dart`, test sheet/service PDF, test gate, Export sheet vào `layout_a11y_test` 7 ngôn ngữ × chữ 1.3). Render PDF ra ảnh để xem: area / distance / walk / vi / có ảnh.
- Chưa kiểm được: chia sẻ PDF qua share sheet trên máy thật; PDF với ảnh camera thật (test dùng JPEG nhỏ); mở bằng Zalo/Drive.
- Nợ / lưu ý: bản đồ trong PDF là vẽ vector chứ không phải ảnh vệ tinh (thumbnail lưu 400×400 quá mờ khi in); hi/zh xuất báo cáo tiếng Anh (Inter không có glyph) và tên/ghi chú CJK/Devanagari sẽ không hiện; ảnh bị cắt ở 8; bản dịch es/pt/id của báo cáo là dịch máy cần người bản ngữ xem.
- Thay đổi kiến trúc: có (§1, §3, §5.1, §7.9, §8, §14).

### 2026-10-01 — Phase 11 (Phase 10 tạm hoãn)
- Quyết định (người giao việc): **hoãn Phase 10** vì chưa tạo được Firebase, làm Phase 11 trước. Hệ quả: giá trị Remote Config dùng mặc định §11 qua `monetizationConfigProvider` (`rc_keys.dart`); analytics để `TODO(phase-10)`. Thêm `CLAUDE.md` với quy tắc: mọi việc giao diện dùng skill ui-ux-pro-max + design system (Paywall/thẻ Premium làm theo checklist của skill: 1 CTA chính, lối thoát rõ, loading/lỗi có cách khắc phục, không chỉ dùng màu để báo trạng thái chọn).
- Đã làm: P11-02 → P11-09. `PurchaseService` (RevenueCat, anonymous; không key → free, không crash; cache `premium_cached`; huỷ mua im lặng). `PaywallScreen` + `PremiumController` (gói năm chọn sẵn + dùng thử + "Tiết kiệm N%", trọn đời, tháng; điều khoản gia hạn ngay trên nút; ✕ sau 2 s; Khôi phục; đã premium → "Quản lý"). `FeatureGate` thật: hết lượt lưu/ảnh → Paywall, mua xong làm tiếp luôn; KML hết lượt ngày → "Xem quảng cáo / Nâng cấp Premium" (không có quảng cáo → vẫn cho xuất). Thẻ Premium + "Lựa chọn quyền riêng tư" (chỉ khi UMP yêu cầu) + "Ad Inspector (dev)" trong Setting. Quảng cáo: UMP mỗi lần mở → ATT (iOS, từ lần mở 2 / sau lần lưu đầu) → SDK; banner Home/Saved/Detail; interstitial sau Save (không lần đầu, ≥ 180 s, không khi Walk ghi); rewarded; app open (sau ≥ 4 h, không phiên đầu, không ở màn đo, không sau share/camera/store). Dev/staging luôn dùng ad unit test. iOS: `NSUserTrackingUsageDescription`, `SKAdNetworkItems`. Docs: `setup_play_billing.md`, `setup_admob.md`.
- Kiểm chứng: 453 test pass, analyze sạch; `test/features/monetization_test.dart` (luật interstitial/app open, gate theo entitlement, Paywall: trial/điều khoản/✕ 2 s/mua/huỷ/khôi phục/không tải được/đã premium, thẻ Premium); export rewarded (xem hết / không có ad / đóng sớm / huỷ); ảnh hết lượt → Paywall; Paywall vào bộ test tràn layout 7 ngôn ngữ + accessibility. Emulator API 35: form UMP (EEA thử) → banner test ở Home và Saved; màn đo không có quảng cáo; lần lưu đầu không có interstitial.
- Chưa kiểm được: rewarded/interstitial/app open trên máy (emulator gặp lỗi không khởi động lại được giữa phiên); mua thật (chưa có key); iOS.
- Lưu ý: slot banner 90 dp ("large anchored adaptive"); quảng cáo test 60 dp nên còn khoảng trống — quảng cáo thật lấp đầy. Danh sách SKAdNetwork cần đối chiếu bản mới nhất trước khi phát hành.
- Thay đổi kiến trúc: có (§3, §9, §11, §14).
- Việc chờ người: xem mục Phase 11 trong "Việc chờ người".
- Gợi ý phiên tiếp theo: khi có Firebase → Phase 10 (nối `monetizationConfigProvider` với Remote Config, analytics paywall/purchase); hoặc 👤 điền key RevenueCat/AdMob để kiểm sandbox.

### 2026-10-01 — Phase 9
- Đã làm: P9-01 → P9-09. `SettingsScreen` (3 nhóm + Support & Legal + footer phiên bản; Premium để Phase 11), `UnitsScreen` (khoảng cách, diện tích, nhóm đơn vị Việt Nam kèm số m², đơn vị phụ), `MapStyleScreen` (lưới 2×2 ảnh vẽ tạm + Áp dụng), `LanguageScreen` (7 ngôn ngữ bằng tên bản ngữ, đổi ngay; ngôn ngữ dịch máy có ghi chú). `SettingsController`, `services/support/support_service.dart` (mail góp ý kèm phiên bản/thiết bị, Rate Us, Privacy/Terms). `PermissionFlows`: pre-prompt vị trí/camera/thông báo, bị chặn hẳn → "Mở Cài đặt"; Walk không tự bật hộp thoại hệ thống khi mở màn. Auto Center tắt → Area/Distance mở ở chỗ bản đồ lần trước (pref `last_map_camera`), Walk không tự bám. Dịch máy es/pt/hi/id/zh (`@@x-machine-translated`), bỏ 19 chuỗi không dùng. Accessibility: selector Home, nút ⋯, nút Thêm điểm, ✕ ảnh đều có vùng chạm 48 dp; trình đọc màn hình không đọc lặp nhãn kết quả. Dark mode + bản đồ Standard tối kiểm trên máy.
- Kiểm chứng: 419 test pass, analyze sạch; `test/features/settings_test.dart`, `test/features/layout_a11y_test.dart` (7 ngôn ngữ × chữ 1.3 × 360 dp không tràn; guideline vùng chạm 48 dp + nhãn). Emulator Android 15 (API 35): xem 3 tiêu chí ở trên.
- Lỗi phát hiện khi chạy thật và đã sửa: (1) Android chỉ báo "chặn hẳn" ngay sau khi xin quyền, lần sau lại báo "denied" → sheet vị trí cứ hiện Continue mà không có tác dụng (ngõ cụt); nay `LocationService` nhớ lần trả lời "chặn hẳn" (pref `location_blocked`) → sheet/banner hiện "Mở Cài đặt", tự xoá khi được cấp. (2) Cấp quyền vị trí ở Cài đặt rồi quay lại: lệnh di chuyển bản đồ gửi lúc app ở nền bị mất → Walk không bám về người dùng; nay quay lại app / bấm Bắt đầu sẽ căn lại. (3) Sheet "Kiểu đo mặc định" và sheet Export (mở từ tab Saved) nằm dưới bottom nav → mở trên root navigator. (4) Tràn chip "FINISHED · NOT SAVED" (es/id/vi, chữ 1.3). (5) Màn Units không lưu khi chọn (đọc controller auto-dispose lúc build). (6) Thẻ đầu màn Ngôn ngữ dính sát app bar.
- Quyết định nhỏ: mục Support & Legal chưa có giá trị trong env thì ẩn (không có nút chết). Rate Us mở trang store (không dùng sheet đánh giá trong app — OS có thể không hiện). Ảnh xem trước Map Style vẽ bằng code cho tới khi có 4 ảnh thật. Nút ⋯ ở danh sách 48 dp (design ghi 40) — bỏ lề phải nên icon giữ nguyên vị trí.
- Chưa làm / tạm: iOS (hộp thoại quyền, ATT) cần Mac. Emulator không có Play Store nên Rate Us mở trình duyệt.
- Thay đổi kiến trúc: có (§3, §5.5, §14).
- Việc chờ người: email hỗ trợ, URL Privacy/Terms, App Store ID (điền vào `env/*.json`); người bản ngữ review 5 bản dịch máy.
- Gợi ý phiên tiếp theo: Phase 10 (Firebase & Notification) — cần 👤 tạo Firebase project trước (P10-01).

### 2026-09-29 — Phase 8
- Đã làm: P8-01 → P8-04, P8-05 phần test. `KmlEncoder` (KML 2.2; Area → Polygon khép vòng, Distance → LineString, Walk → MultiGeometry mỗi đoạn một LineString + Polygon nếu khép; màu mode dạng aabbggrr lấy từ token; `ExtendedData` type/area_m2/perimeter_m/distance_m/duration_s/created_at/notes; điểm có ảnh → Placemark "P3"). `CsvEncoder` (đúng header trong plan, mỗi điểm một dòng, số liệu tổng lặp lại mỗi dòng, BOM UTF-8, CRLF, ISO-8601 UTC). `ExportService` (FeatureGate → mã hoá → `temp/exports/<slug>_<yyyyMMdd_HHmm>.<ext>` → share sheet; free: 1 KML/ngày tính khi share thành công, CSV luôn miễn phí). `ExportSheet` thật (KML / CSV, đang tạo file, báo lỗi/giới hạn) từ Saved ⋯ và Detail. Giá trị đất: ở Save và Detail nhập đơn giá + "tính theo" (m²/ha/acre/ft²/sào/mẫu/công…) → "Giá trị ước tính ≈ 1,87 tỷ"; lưu `unit_price*` (tiền tệ theo vùng của máy: VN → VND…); Detail có ô GIÁ TRỊ trong lưới kết quả + sheet sửa/xoá.
- Kiểm chứng: 320 test pass, analyze sạch; so KML (area/distance/walk) và CSV với file mẫu từng byte. Emulator: đo 3,36 acre, nhập 25.000 USD/acre → "$84K"; Detail ô Giá trị "$84K · $25K / acre"; Export KML/CSV → share sheet hệ thống (Drive, Gmail) với file `area_sep_29_20260929_0953.kml/.csv`; kéo file ra: KML đúng vòng khép + màu, CSV có BOM, 5 dòng; xoá giá trị đất.
- Lỗi phát hiện khi chạy thật và đã sửa: dropdown "Tính theo" tràn 11 px ("per acre") → mục chỉ còn ký hiệu đơn vị + `isExpanded` (có test màn 360 dp). Mục Giá trị đất ở Detail chuyển xuống dưới chip đơn vị cho đúng nhóm.
- Lưu ý: `.gitattributes` ép LF cho file text → thêm `test/fixtures/export/** -text` để CSV mẫu giữ CRLF + BOM khi clone.
- Quyết định nhỏ: CSV dùng dấu phẩy như header trong plan (Excel ở máy đặt dấu phẩy thập phân có thể không tách cột — xem việc chờ người). Giá trị đất chỉ có khi có diện tích (Area, Walk khép vòng). Tiền tệ tự chọn theo vùng máy, chưa cho đổi (Phase 9 nếu cần).
- Chưa làm / tạm: rewarded ad / paywall khi hết lượt KML (Phase 11). Mở thử bằng Google Earth / Excel / Zalo cần máy thật.
- Thay đổi kiến trúc: có (§3, §5.4, §8, §14).
- Việc chờ người: xem mục Phase 8 trong "Việc chờ người".
- Gợi ý phiên tiếp theo: Phase 9 (Settings, quyền, trạng thái lỗi, đa ngôn ngữ, dark mode).

### 2026-09-29 — Phase 7
- Đã làm: P7-01 → P7-08. Thêm ảnh (sheet Chụp ảnh / Chọn từ thư viện, nhiều ảnh, giới hạn theo `FeatureGate` — hiện chưa chặn): pre-prompt quyền camera (bị chặn hẳn → Mở Cài đặt), gắn toạ độ (điểm đang chọn, không thì vị trí GPS gần nhất), gắn điểm. `PhotoStrip` đủ (✕, ô "Thêm ảnh" viền đứt, ô đang tải, "P3", "Xem tất cả") ở Area/Distance/Walk/Save/Detail/Edit. Xoá: trong phiên đo / Save xoá ngay + "Hoàn tác" (file giữ 5 s); Detail và trình xem hỏi xác nhận. Ảnh theo điểm: badge trên marker, nút 📷 trong thanh thao tác điểm, xoá điểm → tách ảnh khỏi điểm. Trình xem ảnh (lướt, phóng to, "1 / 4", ngày chụp, "Điểm 3", Xoá, Chia sẻ). Setting "Lưu ảnh vào phép đo" tắt → sau khi chụp hỏi đính kèm. Ghi chú: ở Save tự lưu vào draft sau 500 ms; ở Detail chạm → sheet sửa. Edit: Area/Distance dùng lại màn đo ở chế độ edit (không autosave, tab Kết quả / Thông tin, "Lưu thay đổi" chỉ bật khi có thay đổi, back → "Bỏ thay đổi?"), Walk chỉ có Thông tin; lưu trong 1 transaction + vẽ lại ảnh bản đồ; menu ⋮ thêm "Mở lại hình" để sửa hình Area đã khép.
- Kiểm chứng: 302 test pass, analyze sạch, golden `PhotoStrip`. Emulator: camera FAB khi chưa có điểm → tạo draft → pre-prompt → quyền hệ thống → chụp → ảnh vào dải; chọn điểm 3 → 📷 → thư viện → ảnh có "P3", marker có badge; xoá + Hoàn tác; Save → Detail (ảnh, ghi chú) → trình xem; Edit thêm điểm + đổi tên → Lưu thay đổi (ảnh bản đồ vẽ lại); Edit → Bỏ; xoá phép đo; xem 3 tiêu chí ở trên.
- Lỗi phát hiện khi chạy thật và đã sửa: thanh thao tác điểm tràn 22 px khi thêm nút Ảnh → Ảnh thành nút icon + thanh tự co (có test cho máy 360 dp tiếng Việt).
- Quyết định nhỏ: ảnh chụp/chọn khi chưa có điểm sẽ tạo draft ngay (draft còn ảnh thì không bị tự xoá khi rời màn). Walk chỉ thêm ảnh sau khi bấm Bắt đầu. Trình xem mở từ Edit là chỉ xem (xoá ảnh trong Edit chờ "Lưu thay đổi"). `PermissionService` + `PermissionPromptSheet` có phần camera (Phase 9 mở rộng cho vị trí/thông báo).
- Chưa làm / tạm: màn Setting để bật/tắt "Lưu ảnh vào phép đo" là Phase 9 (logic đã có). Hộp thoại quyền camera iOS chưa kiểm (cần Mac).
- Thay đổi kiến trúc: có (§3, §8, §14).
- Việc chờ người: như cũ + thử camera 12MP trên máy thật.
- Gợi ý phiên tiếp theo: Phase 8 (Export KML/CSV, giá trị đất).

### 2026-09-29 — Phase 6
- Đã làm: P6-01 → P6-10. `NameSuggester` ("Area · Sep 29" / "Diện tích · 29/09", trùng → " (2)"); màn Save (ảnh bản đồ, tên bắt buộc ≤ 80, loại + lưới kết quả, ghi chú ≤ 2000, ảnh nếu có) + `SaveController` (FeatureGate hook — luôn cho lưu tới Phase 11; `markSaved` 1 transaction; thumbnail không chặn lưu; đếm `saves_count_total`); nút Save ở Area/Distance/Walk: khung hình → chụp bản đồ → cắt vuông 400 px → mở `/save/:id`; lưu xong: Home → Detail (thay stack đo). Home: hero (hình vẽ theo chế độ, đổi mượt 250 ms), selector 3 chế độ, CTA theo chế độ, "Tiếp tục đo" (bản nháp mới nhất + "Xem tất cả bản nháp"), 3 phép đo gần đây, trạng thái rỗng. Saved: tìm kiếm (debounce 200 ms, bỏ dấu), chip loại có số đếm, mục Drafts thu gọn được (gồm Walk đã kết thúc), danh sách, rỗng / không có kết quả. Menu ⋯: Đổi tên / Xuất file (sheet tạm, nội dung Phase 8) / Xoá; nháp: Tiếp tục / Đổi tên / Bỏ. Detail: ảnh 16:10 → bản đồ đầy đủ (chỉ xem, Layers, khung lại), tên + loại + ngày lưu, lưới kết quả theo loại (Walk có tốc độ TB /km hoặc /mi), chip đơn vị (lưu vào phép đo, không đổi thứ tự danh sách), ảnh, ghi chú, thanh Sửa / Xuất / Xoá.
- Kiểm chứng: 278 test pass, analyze sạch; golden `MeasurementListTile`, `DraftBanner`, `HomeScreen` (có/không dữ liệu) sáng/tối. Emulator: xem các tiêu chí ở trên.
- Lỗi phát hiện khi chạy thật và đã sửa: (1) guard rời màn đo sẽ mời "Bỏ" cả khi phép đo vừa được lưu (Save thay stack) → bấm Bỏ sẽ xoá bản đã lưu; nay guard kiểm trạng thái trước. (2) Ảnh bản đồ vuông bị cắt mất đỉnh khi hiện 16:10 → khung hình rộng hơn (lề 22%). (3) Nhãn selector lệch lên trên. (4) Chip "FINISHED · NOT SAVED" bị cắt → dòng phụ của nháp chỉ còn số điểm.
- Quyết định nhỏ (không có trong spec): đổi đơn vị / kiểu bản đồ ở Detail không cập nhật `updated_at` (không đẩy phép đo lên đầu danh sách); chip đếm ở Saved chỉ đếm bản đã lưu; ô ghi chú trống ở Detail hiện "Chưa có ghi chú" (sửa ghi chú ở Phase 7, tránh nút chết).
- Chưa làm / tạm: Hero dùng hình vẽ (`HeroBackdropPainter`) thay 3 ảnh vệ tinh (👤 chưa có ảnh bản quyền). Nút Sửa mở màn placeholder (Phase 7); Xuất file là sheet "sắp có" (Phase 8); banner quảng cáo (Phase 11).
- Thay đổi kiến trúc: có (§3, §5.3, §8, §14; design §5.1, §5.7).
- Việc chờ người: như cũ + ảnh hero.
- Gợi ý phiên tiếp theo: Phase 7 (ảnh, ghi chú, Edit).

### 2026-09-29 — Phase 5
- Đã làm: P5-01 → P5-10. `LocationTracker` (preview không chạy nền; ghi: Android 2 s + foreground service + notification ongoing + wakelock, iOS bestForNavigation/fitness/background + chấm xanh; chỉ 1 stream một lúc vì geolocator dùng chung stream native); `WalkController` keepAlive (TrackFilter → segment → stats; flush 5 điểm/10 s/Pause/Finish/app vào nền; đồng hồ = giây đã cộng dồn + (now − lần Resume); Resume tăng segment; Finish → `completed`); `WalkScreen` Ready/Recording/Paused/Finished (banner GPS: tìm/sẵn sàng/thấp/tắt/chưa cấp quyền/vị trí giả; bản đồ tự bám theo, kéo bản đồ → tắt bám, nút ⌖ cam để về lại; vòng tròn quanh điểm đầu sáng xanh khi đủ gần; tô xanh khi khép vòng; halo độ chính xác); `WalkResultPanel` (3 cột + "Route not closed — distance only"); `WalkRecoveryService` trong bootstrap; `BatteryOptimizationHelper` + sheet (Xiaomi/Oppo/Vivo/Realme/Huawei/Honor/OnePlus/Samsung, 1 lần, mở trang thông tin ứng dụng); xin `POST_NOTIFICATIONS` 1 lần trước lần Start đầu; iOS `NSLocationWhenInUseUsageDescription` + `UIBackgroundModes location`.
- Quyết định mới (cần bạn xem lại): **back khi đang ghi bị chặn**, hiện snackbar "Đang ghi… · Dừng & thoát" thay vì thoát ngay như Area/Distance — một lần bấm back nhầm khi đang đi không được làm dừng phép đo. Khi đã Pause/Finish thì back thoát ngay như cũ (snackbar "Đã lưu nháp · Bỏ"). Rời màn Walk luôn tạm dừng + tắt GPS (không ghi ngầm khi không có màn hình nào hiển thị).
- Kiểm chứng: 251 test pass (20 test controller với tracker giả + DB thật: lọc điểm, flush, đồng hồ, segment, khép vòng, GPS tắt/bật lại, rời màn, khôi phục), analyze sạch, golden `WalkResultPanel` sáng/tối. Emulator API 31: xin quyền khi mở màn (từ chối → banner "Cho phép"), GPS Ready ±5 m, Start → service foreground + notification; vòng 40 × 40 m → 1.590 m² và hint "gần điểm xuất phát"; tắt màn hình vẫn ghi; Pause → dịch 50 m → Resume không nối; force-stop → mở lại: `paused`, đủ 62 điểm; back khi đang ghi → snackbar → "Dừng & thoát" → draft `paused`, service dừng; Finish → `completed`, sheet mở 0.9.
- Lỗi phát hiện khi chạy thật và đã sửa: (1) snackbar "Đã lưu nháp · Bỏ" (Phase 4) **không bao giờ tự tắt** và đi theo sang màn khác — từ Flutter 3.29 SnackBar có action mặc định `persist: true`; nay `persist: false` + test. (2) Finish với tuyến ngắn zoom quá sát → tuyến < 60 m giữ zoom 18.
- Chưa kiểm được: 30 phút thực địa, máy OEM thật (sheet pin chỉ kiểm bằng test), iOS (cần Mac), Android 13+ (hộp thoại thông báo).
- Nợ kỹ thuật: `TrackFilterConfig` cố định (RC ở Phase 10); chưa có đường vào Resume draft Walk từ UI (DraftBanner ở Phase 6); nút Camera trên màn Walk vẫn tắt (Phase 7).
- Thay đổi kiến trúc: có (§3, §5.5, §9, §14; design §5.5, §5.17).
- Việc chờ người: P5-11 thực địa (xem "Việc chờ người").
- Gợi ý phiên tiếp theo: Phase 6 (Save, Home + DraftBanner để Resume Walk, Saved, Detail).

### 2026-09-28 — Phase 4
- Đã làm: P4-01 → P4-08. Tách `MeasureScreen` dùng chung (Area + Distance); `DistanceResultPanel` (tổng, đơn vị phụ, số đoạn, chip m/km/ft/mi, danh sách A → B); Distance: đường xanh dương, điểm đầu xanh lá, pin đỏ cuối, Reset có xác nhận, "Lưu tuyến đường"; chọn kiểu bản đồ lưu cả vào draft và làm mặc định; tìm địa điểm (toạ độ, DMS, link, link rút gọn, địa chỉ qua geocoder của OS, 5 tìm kiếm gần đây); rời màn không hỏi (hướng B) + snackbar "Đã lưu nháp · Bỏ"; sheet hướng dẫn theo `design.md` §5.18 (tự mở 1 lần / chế độ, nút ?); banner mất mạng; giữ màn sáng theo setting.
- Thêm ngoài danh sách (đã báo trước): chạm nhãn cạnh ở chế độ Tap = chèn điểm giữa cạnh (sửa lỗi nhãn nuốt lần chạm từ Phase 3).
- Kiểm chứng: 220 test pass, analyze sạch; golden `DistanceResultPanel`. Trên emulator: hướng dẫn tự mở, `KEEP_SCREEN_ON` bật ở màn đo và tắt khi rời màn, đo Distance, tìm bằng toạ độ + link, back → snackbar → Bỏ xoá draft khỏi DB, chế độ máy bay → banner.
- Lỗi phát hiện khi chạy thật và đã sửa: (1) geocoder lỗi khi đang online bị báo nhầm là "cần mạng"; (2) nhãn tổng của Distance bị tay cầm điểm giữa che.
- Chưa kiểm được: tìm địa chỉ thật (geocoder Google Play trên emulator bị từ chối) → cần máy thật.
- Thay đổi kiến trúc: có (§3, §5.5, §14; design §5.2–5.3).
- Việc chờ người: thử tìm địa chỉ trên máy thật; đối chiếu thước Google Maps (P3, P4).
- Gợi ý phiên tiếp theo: Phase 5 (Walk & Measure) — cần máy thật để test chạy nền.

### 2026-09-28 — Phase 3
- Đã làm: P3-01 → P3-12. `MeasureSessionController` (thêm/kéo/chọn/xoá điểm, undo, reset, khép/mở hình, kiểu bản đồ, đơn vị hiển thị; autosave debounce 300 ms, ghi tuần tự; tạo draft ở điểm đầu; flush khi app vào nền/rời màn; draft rỗng bị xoá); `MarkerFactory`; `MeasureMapView` (polygon, viền đứt vàng khi tự cắt, nhãn cạnh ẩn khi zoom < 15 hoặc cạnh < 40 px, nhãn kết quả ở trọng tâm, kéo điểm throttle 30 ms); `CenterCrosshair`, `MeasureToolbar`, `ResultSheet` (0.22/0.45/0.9), `AreaResultPanel` (số chạy 200 ms, chip đơn vị); `AreaMeasureScreen` (FAB Layers/Vị trí; Search/Camera tạm tắt tới Phase 4/7); `PointActionsPopup`; menu ⋮ (Reset có xác nhận, chế độ nhập, nhãn cạnh); thêm điểm tại vị trí GPS (cảnh báo khi độ chính xác > 20 m); camera mặc định khi không có quyền vị trí (vi: Hà Nội).
- Kiểm chứng: 195 test pass, analyze sạch; golden `AreaResultPanel` sáng/tối. Trên emulator: đo 4 điểm → 4,31 acre, nhãn cạnh + nhãn kết quả hiển thị, khép hình khoá Thêm điểm; force-stop → DB còn đủ điểm; 100 điểm vẫn mượt.
- Lỗi phát hiện khi chạy thật và đã sửa: (1) có quyền vị trí nhưng máy chưa có vị trí đã lưu → bản đồ ở chế độ toàn cầu; nay lấy fix mới rồi căn lại. (2) Màn hình thấp: nút Camera đè cột FAB/toolbar; nay cột FAB đẩy lên khi không có banner và Camera chuyển sang trái khi thiếu chỗ. (3) `pubspec` khai báo thư mục asset rỗng → clone mới build lỗi.
- Chưa kiểm được: kéo tay cầm điểm trên emulator (adb không mô phỏng tốt long-press-drag của Google Maps; logic `movePoint` có test). Chế độ chạm: marker (nhãn cạnh/nhãn kết quả) nhận chạm nên chạm trúng nhãn sẽ không thêm điểm — cân nhắc tắt nhận chạm của nhãn ở Phase 4.
- Thay đổi kiến trúc: có (§3, §14).
- Việc chờ người: đối chiếu thước Google Maps (tiêu chí 1).
- Gợi ý phiên tiếp theo: Phase 4 (Distance + tìm địa điểm + dialog rời màn).

### 2026-09-28 — Phase 2
- Đã làm: P2-01 → P2-10. Schema Drift v1 (3 bảng, 5 index gồm `(status, updated_at DESC)`, FK cascade, WAL) + dump schema; DAO; `MeasurementRepository` đủ API trong plan (+ `watch(id)` gộp 3 stream, lỗi DB bọc thành `StorageException`); `PhotoRepository`; `PhotoStorage` (ảnh ≤ 2048 px q82 + thumb 320 px q70, đường dẫn tương đối, xoá file tạm của camera, không đụng ảnh gốc trong gallery, lỗi giữa chừng thì dọn file dở); `ThumbnailStorage`; `SettingsRepository` + `AppSettings` + `settingsProvider` (mặc định theo quốc gia); `OrphanFileCleaner` + dọn `temp/exports`, nối vào bootstrap; providers keepAlive.
- Kiểm chứng: 177 test pass, analyze sạch; test schema so với dump v1; test đếm file khi xoá; stream `watchSaved` phát lại khi rename/delete; tìm kiếm "ruong" ra "Ruộng…", ký tự `%`/`_` không bị hiểu là wildcard. Trên emulator: DB `landmeasure.sqlite` được tạo (WAL), `orphan_cleanup_at` được ghi, chọn Tiếng Việt → force-stop → mở lại vẫn giữ tiếng Việt.
- Lỗi phát hiện nhờ test và đã sửa: cleaner xét tuổi thư mục mồ côi theo mtime của thư mục (đổi mỗi khi nội dung đổi) → nay xét theo file bên trong.
- Thay đổi kiến trúc: có (§3, §4, §5.3, §5.5, §14).
- Nợ kỹ thuật / lỗi đã biết:
  - `NativeImageCompressor` (gọi plugin native) chưa có test tự động — sẽ kiểm trên máy thật ở Phase 7 (tiêu chí "ảnh 12MP ≤ 700KB").
  - `takenAt` ảnh gallery lấy theo thời gian sửa file, chưa đọc EXIF.
  - Coverage `lib/data` ~81% (phần thiếu chủ yếu là code gọi plugin native).
- Việc chờ người: như cũ (giới hạn Maps key, GPX thật, keystore).
- Gợi ý phiên tiếp theo: Phase 3 (bản đồ + Measure Area).

### 2026-09-28 — Cấu hình Android (ngoài phase, theo yêu cầu)
- Đã làm: manifest theo `architecture.md` §12 (quyền vị trí "while in use" + foreground service `location`, không có vị trí nền; thông báo, camera, AD_ID, receiver nhắc draft, `<queries>`, meta-data FCM); icon thông báo `ic_notification`; release bật R8 + shrink + native symbols; ký release qua `android/key.properties`; Maps key Android điền vào `env/*.json`. P5-02 phần Android coi như xong ([~] vì iOS chưa làm).
- Kiểm chứng: đọc manifest đã merge trong APK (đủ quyền, không có `ACCESS_BACKGROUND_LOCATION`, service type = location, Maps key đã chèn); build tạm một màn bản đồ → ảnh vệ tinh Hà Nội hiển thị, logcat không có lỗi xác thực key (file tạm đã xoá); `app-prod-release.apk` build với R8 thành công (59 MB gộp 3 ABI) và khởi động không crash.
- Việc chờ người: giới hạn Maps key theo package + SHA-1; upload keystore.

### 2026-09-28 — Phase 1
- Đã làm: P1-01 → P1-11 (P1-04 là [~]: fixture GPX là dữ liệu mô phỏng). Models freezed; `GeoCalculator` (haversine, spherical excess kiểu Google, centroid, midpoint, bearing, bounds); `PolygonValidator`; `TrackFilter` + `TrackFilterConfig`; `ClosureDetector`; `StatsCalculator`; `GeometryEditor` + 6 lệnh; `UnitConverter` + `land_units`; `core/format` (Unit/Duration/Date/Money); `GeoParse`; `PathSimplifier`; `FeatureGate` + `GateConfig`.
- Kiểm chứng: 135 test pass; `flutter analyze` sạch; coverage `lib/domain` 99,6%. Diện tích 8 case (vuông 100 m ở 0°/21°/60°, 1 km², tam giác, chữ L, ruộng Thái Bình, vùng 10 km) sai < 0,1% so với tham chiếu **độc lập** (công thức dải vĩ độ, L'Huilier, chiếu Lambert đẳng diện) — không so với chính công thức đang test. Track GPX mô phỏng: vòng ruộng 100×60 m sai diện tích +1,7%, đường 400 m sai +1%.
- Thay đổi kiến trúc: có (§3, §7.3, §7.5, §7.6, §7.7, §14).
- Nợ kỹ thuật / lỗi đã biết:
  - **TrackFilter khi đứng yên**: đúng spec §7.3 nhưng 3 phút đứng yên với nhiễu σ≈3 m vẫn sinh ~20 điểm / ~59 m quãng đường giả, chủ yếu do quy tắc "≥ 15 s và ≥ 1 m". Cần tinh chỉnh bằng dữ liệu thật ở P5-11 (vd. nâng ngưỡng idle lên ~accuracy, hoặc bỏ). Test hiện chỉ chặn trên (≤ 25 điểm, < 80 m).
  - Fixture GPX là mô phỏng (nhiễu AR(1)), chưa phải bản ghi thật.
  - `GeoParse` không mở được link rút gọn `maps.app.goo.gl` (cần mạng để theo redirect) → coi như địa chỉ; có thể xử lý ở Phase 4.
  - `DateFormatter` cần dữ liệu ngôn ngữ của intl: app có sẵn qua `GlobalMaterialLocalizations`; nơi khác phải gọi `initializeDateFormatting`.
- Việc chờ người: GPX thật (P1-04), đối chiếu thửa ruộng với thước Google Maps (P1-02); các việc Phase 0 còn lại.
- Gợi ý phiên tiếp theo: Phase 2 (Drift). Nên nâng Flutter trước để dùng `drift_flutter` 0.3 / `drift` mới nhất (hiện ghim 0.2.8 / 2.31).

### 2026-09-28 — Phase 0
- Đã làm: P0-01, P0-03 → P0-12, P0-14. P0-02 Android xong (flavor dev/staging/prod, `.dev`/`.stg`, key giải mã từ dart-defines); iOS đã cấu hình 12 build configuration + 3 scheme + xcconfig + Podfile bằng script, **chưa build được trên Mac**. Xoá `web/`, `macos/`, `windows/`; `git init` (chưa commit). Icon/splash tạm sinh từ `tool/generate_icon.py`. Viết `docs/setup_google_maps.md`.
- Kiểm chứng: `flutter analyze` sạch; 24 test pass (12 golden light/dark cho core widgets); build `app-dev-debug.apk` và chạy trên emulator Android API 31: 3 tab chạy, đổi en↔vi runtime OK, không crash lúc khởi động (AdMob dùng app ID test).
- Chưa xong / [~]: P0-02 iOS (cần Mac), CI chưa chạy lần nào (chưa có remote), P0-13 👤.
- Thay đổi kiến trúc: có, đã ghi `architecture.md` §14 (Flutter 3.38.5 + ghim version package, minSdk 24, iOS 15, build_runner `--force-jit`, file mới trong core/, `fake_async`, env key theo nền tảng).
- Nợ kỹ thuật / lỗi đã biết:
  - Flutter 3.38.5 cũ hơn hệ sinh thái hiện tại → phải ghim `drift_flutter 0.2.x`, `riverpod_generator 4.0.0`, `permission_handler ^12` (bản 13 kéo `permission_handler_android` 14 cần AGP 9). Nên nâng Flutter + AGP trước Phase 2 để dùng Drift mới.
  - Golden phụ thuộc OS (sinh trên Windows); CI bỏ qua tag `golden`.
  - `placeholder_screen.dart`, `phase0_tabs.dart`, `locale_controller.dart` là tạm (thay ở Phase 2/6/9).
  - Chưa khai báo quyền Android/iOS (để Phase 3/5 theo `architecture.md` §12).
- Việc chờ người: chốt package name/bundle ID; kiểm iOS trên Mac; push GitHub để chạy CI; P0-13 Google Maps key.
- Gợi ý phiên tiếp theo: Phase 1 (domain thuần Dart) có thể làm song song với việc người kiểm iOS/CI vì không phụ thuộc native. Cân nhắc nâng Flutter trước Phase 2.

```
### YYYY-MM-DD — Phase N
- Đã làm: P?-01, P?-02 …
- Chưa xong / [~]: … (lý do)
- Thay đổi kiến trúc: … (đã ghi architecture.md §14? có/không)
- Nợ kỹ thuật / lỗi đã biết: …
- Việc chờ người: …
- Gợi ý phiên tiếp theo: …
```


### 2026-10-08 — Phase 11 (kịch bản monetization Android theo yêu cầu)
- Đã làm: Splash App Open (≤ 8 s, có watchdog), màn chọn ngôn ngữ lần đầu, luồng splash → language → intro → home / lần 2 paywall / lần 3 home; Intro có native compact dưới nút (ẩn ở slide 2 + refresh ngầm) và trang native full-screen chèn giữa (shimmer khi đang tải, bỏ trang nếu lỗi, nút ✕ + vuốt biên); Saved có native medium trên cùng; Interstitial cache chuẩn AdMob, cách nhau 30 s, hiện sau Save và Save Changes (cả Walk) rồi mới điều hướng; App Open khi quay lại app (cách nhau 30 s); giới hạn 3 ảnh + khoá Satellite/Hybrid → popup Premium → Paywall; Paywall mới 2 gói; IAP chuyển sang Play Billing 9.1.0 trực tiếp (bỏ RevenueCat).
- Kiểm chứng: `flutter analyze` sạch, 464 test pass; build `dev` OK; emulator API 36: App Open ở splash, language → intro, native compact khớp màu nút (validator "No implementation issues"), trang native full-screen + ✕ + vuốt biên, ẩn native ở slide 2, native medium ở Saved, App Open khi quay lại sau 35 s.
- Nợ kỹ thuật: chưa xác thực purchase phía server; iOS chưa có native ads/StoreKit; native refresh ở intro theo đúng yêu cầu (không giãn 60 s) — nếu AdMob cảnh báo, tăng khoảng giãn; chưa kiểm thật luồng mua (cần sản phẩm trên Play Console, `docs/setup_play_billing.md`); ad unit thật cho native chưa có (đang dùng unit test của Google).
- Việc chờ người: tạo 2 subscription + ad unit (App Open, Interstitial, 3 Native) và điền `env/prod.json` (`IAP_PRODUCT_*`, `AD_UNIT_*`); tên gói (đang là chuỗi tạm); package name chính thức.

### 2026-10-08 (2) — Phase 11: native màn Language + rewarded mở khoá map style
- Đã làm: native compact ở dưới cùng màn chọn ngôn ngữ (skeleton khi tải, thu lại nếu lỗi, ẩn khi màn thấp < 600 dp); Satellite/Hybrid mở được bằng quảng cáo rewarded (popup 3 lựa chọn, mở đến khi đóng app) ở cả sheet Layers (Area/Distance/Walk/Detail map) và Settings → Map Style; thay chuỗi `premiumPromptMapStyle` bằng `premiumPromptMapStyleReward`, thêm `mapStyleUnlocked`, `mapStyleAdDismissed` (7 ngôn ngữ).
- Kiểm chứng: analyze sạch, 467 test pass (3 test rewarded mới: xem hết → mở, đóng sớm → không mở, không có ad → mở). Chưa chạy lại trên thiết bị (emulator đang bị phiên khác dùng).
- Việc chờ người: ad unit `AD_UNIT_NATIVE_LANGUAGE_*` và rewarded thật trong `env/prod.json`.
