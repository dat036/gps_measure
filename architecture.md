# LandMeasure — Architecture

> Nguồn sự thật về **cấu trúc code, data model, thuật toán, quy ước**. Mọi phiên AI đọc file này trước khi viết code.
> Thứ tự đọc: `overview.md` → `architecture.md` → `design.md` → `plan.md`.
> **Quy tắc cập nhật**: khi thêm/đổi thư mục, bảng DB, provider quan trọng, service, quy ước → sửa file này **trong cùng phase** và ghi vào mục §14 Changelog. Code và tài liệu không được lệch nhau.

---

## 1. Tech stack (đã chốt)

| Mục đích | Package | Ghi chú |
|---|---|---|
| State / DI | `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator` | Dùng code-gen `@riverpod` |
| Router | `go_router` | `StatefulShellRoute` cho 3 tab |
| Model | `freezed`, `json_serializable` | |
| Database | `drift`, `drift_flutter` | SQLite, stream query, migration |
| Preferences | `shared_preferences` | |
| Map | `google_maps_flutter` | **Không dùng Map ID** (Map ID bị tính phí). Style tối bằng JSON local |
| Vị trí | `geolocator` | Stream, foreground notification Android, background iOS |
| Quyền | `permission_handler` | |
| Tìm địa chỉ | `geocoding` | Geocoder native của OS, miễn phí. **Không dùng Places/Geocoding API** |
| Ảnh | `image_picker`, `flutter_image_compress` | Android dùng Photo Picker, không cần quyền storage |
| File/share | `path_provider`, `path`, `share_plus` | |
| Export | `xml`, `csv`, `pdf` (2026-10-19: báo cáo PDF, chỉ `pdf` — không dùng `printing`) | v1.1: `archive` |
| Khác | `wakelock_plus`, `connectivity_plus`, `uuid`, `intl`, `collection`, `url_launcher`, `package_info_plus`, `device_info_plus`, `in_app_review` | |
| i18n | `flutter_localizations` + gen-l10n (ARB) | |
| IAP | `purchases_flutter` (**RevenueCat** — đã chốt) | Entitlement `premium` |
| Ads | `google_mobile_ads`, `gma_mediation_meta` | Meta = bidding source trong AdMob mediation |
| ATT | `app_tracking_transparency` | iOS |
| Firebase | `firebase_core`, `firebase_analytics`, `firebase_crashlytics`, `firebase_remote_config`, `firebase_messaging` | |
| Notification | `flutter_local_notifications` | |
| Dev | `build_runner`, `drift_dev`, `very_good_analysis`, `mocktail`, `flutter_launcher_icons`, `flutter_native_splash` | |

Nền tảng: Android `minSdk 24` (mặc định của Flutter 3.38), `targetSdk` theo yêu cầu Play hiện hành. iOS 15.0+ (Firebase iOS SDK 12 yêu cầu). Flutter 3.38.5 stable (version khoá trong `pubspec.lock`, ghi lại ở §14).

Icon: dùng `Icons.*_rounded` (Material Icons Rounded có sẵn trong Flutter) thay cho Material Symbols để không thêm package/font.

---

## 2. Kiến trúc lớp

```
presentation (Widget)
   │ ref.watch / ref.read
   ▼
application (Controller = Riverpod Notifier/AsyncNotifier)
   │
   ├──▶ domain services (pure Dart: GeoCalculator, TrackFilter, GeometryEditor, FeatureGate…)
   │
   └──▶ repositories (interface trong data/repositories, impl Drift/File/Prefs)
                 │
                 ▼
          Drift DAO · PhotoStorage · SharedPreferences · SDK services (ads, purchases…)
```

Luật phụ thuộc (bắt buộc):
1. `domain/` **không import** `package:flutter`, Riverpod, Drift, plugin nào. Pure Dart → test thuần.
2. Widget không gọi repository/DAO trực tiếp — chỉ qua controller.
3. Controller không import widget. Điều hướng: controller trả kết quả/event, widget gọi `context.go`.
4. Chỉ `PhotoStorage` được xoá file ảnh; chỉ `MeasurementRepository.delete` được xoá measurement.
5. Mọi SDK bên thứ ba (ads, RevenueCat, Firebase) nằm sau 1 service class trong `lib/services/` để có thể mock và thay thế.
6. **Đơn vị nội bộ luôn**: mét, m², giây, WGS84 (lat/lng độ), `DateTime` UTC khi lưu. Chuyển đơn vị chỉ ở `core/format`.

---

## 3. Cấu trúc thư mục

```
lib/
├─ main.dart                      # gọi bootstrap(flavor)
├─ main_dev.dart / main_prod.dart # entry theo flavor (nếu dùng)
├─ bootstrap.dart                 # init theo thứ tự §9
├─ app.dart                       # LandMeasureApp: MaterialApp.router, theme, locale
├─ shell/main_shell.dart          # bottom nav 3 tab
├─ core/
│  ├─ config/       env.dart (đọc --dart-define), flavor.dart
│  ├─ theme/        lm_theme.dart, lm_colors.dart, lm_typography.dart, lm_spacing.dart, lm_radius.dart, lm_shadows.dart, mode_colors.dart
│  ├─ router/       app_router.dart, routes.dart
│  ├─ l10n/         arb/*.arb (generated → lib/l10n/gen/), l10n.dart (`context.l10n`), app_locale.dart (`appLocaleProvider` ← settings),
│  │                measurement_labels.dart (`titleOf` "Untitled Area", `relativeTime` "14 min ago")
│  ├─ utils/        debouncer.dart, throttler.dart, clock.dart, id_generator.dart, logger.dart, app_exception.dart
│  ├─ format/       unit_formatter.dart, date_formatter.dart, duration_formatter.dart, money_formatter.dart,
│  │                measurement_value.dart (số chính của 1 phép đo trong danh sách)
│  ├─ location/     location_service.dart (quyền + vị trí một lần cho màn đo; nhớ "chặn hẳn" qua pref `location_blocked`; interface để test)
│  ├─ permissions/  permission_service.dart (camera, thông báo; `PermissionAccess` granted/askable/blocked), permission_prompt_sheet.dart (pre-prompt),
│  │                permission_flows.dart (`PermissionFlows.location/camera/walkNotificationsOnce`: pre-prompt → hộp thoại hệ thống / Mở Cài đặt)
│  ├─ connectivity/ connectivity_service.dart
│  └─ widgets/      primary_cta.dart, map_fab.dart, status_banner.dart, lm_dialog.dart, type_chip.dart, unit_chips.dart, empty_state.dart,
│                   section_header.dart, dashed_border.dart, mode_icon.dart
├─ domain/
│  ├─ models/       enums.dart, geo_point.dart (+GeoBounds), measure_point.dart, photo.dart, measurement.dart, measurement_summary.dart, measurement_stats.dart, location_fix.dart
│  ├─ geo/          geo_calculator.dart, polygon_validator.dart, closure_detector.dart, track_filter.dart, geo_parse.dart, path_simplifier.dart,
│  │                local_projection.dart, stats_calculator.dart
│  ├─ units/        unit_converter.dart, land_units.dart, land_value.dart (ước tính giá trị, tiền tệ theo vùng)
│  ├─ editor/       geometry_editor.dart, geometry_command.dart
│  └─ premium/      feature_gate.dart
├─ data/
│  ├─ providers.dart  # mọi provider keepAlive của data layer (prefs & dirs override trong bootstrap)
│  ├─ db/           app_database.dart, tables.dart, converters.dart (row ↔ domain), search_text.dart (foldForSearch),
│  │                stream_utils.dart (combineLatest3), daos/{measurement_dao,point_dao,photo_dao}.dart
│  ├─ repositories/ measurement_repository.dart, photo_repository.dart, settings_repository.dart
│  ├─ storage/      app_directories.dart, photo_storage.dart, image_compressor.dart, jpeg_size.dart, thumbnail_storage.dart,
│  │                orphan_file_cleaner.dart, export_storage.dart (file tạm + slug tên file)
│  └─ prefs/        prefs_keys.dart
├─ features/
│  ├─ home/         home_screen.dart, home_controller.dart (+ `recentListProvider`), widgets/{hero_measure_card,mode_segmented_selector,draft_banner}.dart
│  ├─ measure/
│  │  ├─ common/    measure_screen.dart (khung chung Area/Distance), measure_floating_controls.dart, place_search_service.dart,
│  │  │             place_search_controller.dart, measure_map_view.dart, marker_factory.dart, map_style_mapper.dart, center_crosshair.dart, measure_toolbar.dart, animated_number.dart,
│  │  │             result_sheet.dart, photo_strip.dart, add_photo_sheet.dart, map_layer_sheet.dart, place_search_sheet.dart, map_snapshot.dart,
│  │  │             leave_measure_guard.dart (PopScope + snackbar "Đã lưu nháp · Bỏ"), measure_help_sheet.dart, point_actions_popup.dart
│  │  ├─ session/   measure_session_controller.dart, measure_session_state.dart
│  │  ├─ area/      area_measure_screen.dart, area_result_panel.dart
│  │  ├─ distance/  distance_measure_screen.dart, distance_result_panel.dart
│  │  └─ walk/      walk_screen.dart, walk_controller.dart (+ `trackFilterConfigProvider`), walk_state.dart (+ `GpsStatus`),
│  │                location_tracker.dart, walk_map_view.dart, walk_recovery_service.dart, walk_result_panel.dart,
│  │                battery_optimization_helper.dart (+ sheet)
│  ├─ save/         save_measurement_sheet.dart, save_controller.dart, name_suggester.dart, pending_thumbnails.dart (ảnh chụp bản đồ chờ Save),
│  │                land_value_field.dart (đơn giá + đơn vị + ước tính; dùng cả ở Detail)
│  ├─ saved/        saved_screen.dart, saved_controller.dart (+ `savedList`/`savedCounts`/`draftList` providers), measurement_actions.dart
│  │                (rename/delete qua repository), measurement_action_flows.dart (dialog → action → snackbar, dùng chung Home/Saved/Detail),
│  │                widgets/{measurement_list_tile,measurement_thumbnail,summary_tile,rename_dialog}.dart
│  ├─ detail/       detail_screen.dart, detail_controller.dart, full_map_screen.dart, result_grid.dart (lưới kết quả dùng cả ở Save)
│  ├─ edit/         edit_measurement_screen.dart (Area/Distance → `MeasureScreen(editing: true)`; Walk → chỉ Details), edit_controller.dart,
│  │                edit_details_form.dart
│  ├─ photos/       photo_viewer_screen.dart, photo_picker.dart (image_picker sau interface), photo_actions.dart (thêm / xoá có Undo /
│  │                xoá hẳn; `measurementPhotosProvider`, `photoImportsProvider`), photo_flows.dart (sheet → quyền → picker → import)
│  ├─ export/       export_sheet.dart, export_service.dart (+ `FileSharer`/share_plus), kml_encoder.dart, csv_encoder.dart (thuần Dart),
│  │                pdf_report_builder.dart (báo cáo PDF A4: `PdfReportBuilder.build(PdfReportInput)` không I/O; `PdfReportOptions` = ngôn ngữ + đơn vị)
│  ├─ settings/     settings_screen.dart, settings_controller.dart (+ `appInfoProvider`, `feedbackUri`), app_settings.dart,
│  │                settings_provider.dart (`settingsProvider`, `deviceLocaleProvider`), settings_labels.dart (tên đơn vị/ngôn ngữ bản ngữ),
│  │                units_screen.dart, map_style_screen.dart, language_screen.dart, widgets/{settings_section,map_style_preview}.dart
│  └─ premium/      paywall_screen.dart, premium_first_screen.dart (paywall lần 2: chỉ gói năm), paywall_parts.dart (phần chung + `PaywallFlow`), premium_controller.dart (gói, chọn, mua, khôi phục), feature_gate_provider.dart (entitlement + giới hạn
│                   từ `monetizationConfigProvider`), premium_flows.dart (`PremiumFlows.openPaywall` → pop true khi đã premium; `PaywallSource`),
│                   premium_links.dart (quản lý gói đăng ký / link điều khoản)
└─ services/
   ├─ ads/          ads_service.dart (`adsServiceProvider` = SDK đã init; `adsEnabledProvider` = SDK sẵn sàng && không premium), ad_unit_ids.dart
   │                (dev/staging luôn ID test), consent_service.dart (UMP + ATT; `privacyOptionsRequiredProvider`), interstitial_manager.dart,
   │                rewarded_manager.dart, app_open_manager.dart (chỉ ad ở splash, không hiện khi quay lại từ background), banner_ad_slot.dart.
   │                Luật hiện quảng cáo là hàm thuần `interstitialAllowed` / `appOpenAllowed` (có test)
   ├─ purchases/    purchase_service.dart (`PurchaseService` RevenueCat; `premiumProvider` = `PremiumStatus`; không key → free, không crash)
   ├─ analytics/    analytics_service.dart, analytics_events.dart
   ├─ crash/        crash_reporter.dart
   ├─ remote_config/rc_keys.dart (khoá + `MonetizationConfig` mặc định §11; Phase 10 thêm remote_config_service.dart)
   ├─ notifications/notification_service.dart, push_service.dart, draft_reminder_scheduler.dart
   ├─ review/       review_prompt_service.dart
   └─ support/      support_service.dart (app/device info, mở mailto/https, store listing; `supportLinksProvider` ← env)

test/                 # mirror lib/
test/fixtures/        # file GPX mẫu, JSON measurement mẫu, ảnh JPEG mẫu
test/drift/app/generated/  # helper schema do drift_dev sinh (không sửa tay)
drift_schemas/app/    # dump schema từng version (drift_dev make-migrations)
integration_test/
assets/{fonts,images,map_styles}/
env/{dev,staging,prod}.json   # KHÔNG commit key thật; commit env/example.json
tool/generate_icon.py         # icon/splash tạm
docs/                         # hướng dẫn setup (Google Maps, RevenueCat…)
```

Code sinh ra (`*.g.dart`, `*.freezed.dart`, `lib/l10n/gen/`) **được commit** để clone về chạy được ngay; CI vẫn sinh lại.

---

## 4. Quy ước code

- **Đặt tên**: file `snake_case.dart`; class `PascalCase`; provider sinh ra từ `@riverpod` tên `xxxProvider`. Controller tên `XxxController`, state `XxxState`.
- **Riverpod**:
  - Controller màn hình: `@riverpod class XxxController extends _$XxxController` (autoDispose mặc định).
  - Service/Repository dùng suốt đời app: `@Riverpod(keepAlive: true)`.
  - `WalkController`: `keepAlive: true` (ghi GPS không được dispose khi đổi màn).
  - Family theo tham số: `MeasureSessionController(MeasurementType type, String? draftId)`.
  - Widget dùng `ref.watch(provider.select(...))` để giảm rebuild khi state lớn.
- **Model**: `@freezed`, không mutable. List trong state luôn `List.unmodifiable`.
- **Repository update từng phần**: tham số kiểu `Value<T>` của drift — `Value.absent()` (mặc định) = không đổi, `Value(null)` = xoá giá trị.
- **Lỗi**: repository/service ném `AppException` (sealed: `StorageException`, `LocationException`, `PermissionDeniedException`, `ExportException`, `PurchaseException`). Controller bắt → state lỗi + `CrashReporter.recordError(nonFatal)`. Không nuốt lỗi im lặng.
- **Log**: `Log.d/i/w/e` trong `core/utils/logger.dart`; release chỉ `w/e` và chuyển sang Crashlytics log.
- **Chuỗi UI**: 100% qua ARB (`context.l10n.xxx`). Không hard-code text.
- **Màu/spacing**: chỉ lấy từ theme tokens (`design.md` §1). Không hard-code hex trong widget.
- **Thời gian**: inject `Clock` (`core/utils/clock.dart`) để test được.
- **ID**: `uuid v4` qua `IdGenerator`.
- **Test**: mỗi file trong `domain/` phải có test tương ứng. Golden test cho widget trong `core/widgets` và các panel chính.
- **Lint**: `very_good_analysis`; `flutter analyze` phải sạch trước khi đánh dấu task xong.
- **Codegen**: `dart run build_runner build --force-jit` sau khi đổi model/provider/table (`--force-jit` bắt buộc vì có dependency dùng build hooks).
- **Cấu hình theo flavor**: `env/<flavor>.json` → `--dart-define-from-file`. Key native theo nền tảng: `MAPS_API_KEY_ANDROID/IOS`, `ADMOB_APP_ID_ANDROID/IOS` (Android: Gradle `manifestPlaceholders`; iOS: `ios/Flutter/DartDefines.xcconfig` do pre-action của scheme sinh ra). Key Dart đọc qua `core/config/env.dart`.

---

## 5. Data model

### 5.1 Enums (`domain/models/enums.dart`)
```dart
enum MeasurementType { area, distance, walk }
enum MeasurementStatus { draft, completed, saved }       // ACTIVE/PAUSED chỉ là runtime
enum WalkRunState { idle, recording, paused, finished }
enum PhotoSource { camera, gallery }
enum MapStyle { standard, satellite, terrain, hybrid }
enum DistanceUnit { meter, kilometer, foot, mile }
enum AreaUnit { squareMeter, hectare, acre, squareFoot }
enum InputMode { crosshair, tap }
enum ExportFormat { csv, kml, pdf }   // v1.1: kmz, gpx, geojson
```
**Không bao giờ đổi thứ tự enum đã phát hành** (Drift `intEnum` lưu index). Thêm giá trị mới ở cuối.

### 5.2 Domain models (freezed)
```dart
GeoPoint { double lat; double lng; }

MeasurePoint {
  String id; int orderIndex; int segmentIndex;   // segmentIndex: Walk tăng sau mỗi Resume; Area/Distance = 0
  double lat, lng; double? altitude, accuracy, speed, bearing;
  DateTime timestamp;
}

Photo {
  String id; String measurementId; String? pointId;   // pointId: ảnh gắn theo điểm
  String filePath; String thumbPath;                  // đường dẫn TƯƠNG ĐỐI so với appDocuments
  DateTime takenAt; double? lat, lng; String? caption;
  PhotoSource source; int width, height, bytes; int sortIndex;
}

MeasurementStats {
  double? areaM2; double? perimeterM; double? distanceM; int? durationSec;
  int pointCount; int segmentCount; bool isClosed; bool selfIntersects;
}

Measurement {
  String id; String? name; MeasurementType type; MeasurementStatus status;
  List<MeasurePoint> points; List<Photo> photos; String? notes;
  MeasurementStats stats; MapStyle mapStyle;
  AreaUnit? displayAreaUnit; DistanceUnit? displayDistanceUnit;
  double? unitPrice; String? unitPriceCurrency; AreaUnit? unitPriceArea;
  String? thumbnailPath;
  DateTime createdAt, updatedAt; DateTime? savedAt;
  WalkRunState? walkState; DateTime? walkStartedAt; int? walkElapsedSec; DateTime? walkLastResumeAt;
}

MeasurementSummary {   // cho list, không load points
  String id; String? name; MeasurementType type; MeasurementStatus status;
  double? areaM2, perimeterM, distanceM; int? durationSec; int pointCount, segmentCount, photoCount;
  String? thumbnailPath; DateTime updatedAt; DateTime? savedAt; WalkRunState? walkState;
}
```
`stats` luôn **tính lại** từ `points` khi hình học đổi, và được **cache** trong DB để list nhanh.

### 5.3 Drift schema (`data/db/tables.dart`) — schemaVersion 1

**measurements**: `id` PK text · `name` text? · `name_lower` text? (khoá tìm kiếm: chữ thường, **bỏ dấu tiếng Việt**, `đ`→`d` — `foldForSearch`) · `type` int · `status` int · `notes` text? · `area_m2` real? · `perimeter_m` real? · `distance_m` real? · `duration_sec` int? · `point_count` int=0 · `segment_count` int=0 · `is_closed` bool=false · `self_intersects` bool=false · `map_style` int · `display_area_unit` int? · `display_distance_unit` int? · `unit_price` real? · `unit_price_currency` text? · `unit_price_area` int? · `thumbnail_path` text? · `min_lat/min_lng/max_lat/max_lng` real? · `walk_state` int? · `walk_started_at` datetime? · `walk_elapsed_sec` int? · `walk_last_resume_at` datetime? · `created_at` · `updated_at` · `saved_at`?
Index: `(status, updated_at DESC)`, `(type, status)`, `(name_lower)`.

**measure_points**: `id` PK · `measurement_id` FK → measurements ON DELETE CASCADE · `order_index` int · `segment_index` int=0 · `lat` · `lng` · `altitude`? · `accuracy`? · `speed`? · `bearing`? · `timestamp`.
Index: `(measurement_id, order_index)`.

**photos**: `id` PK · `measurement_id` FK CASCADE · `point_id` text? (không FK; xoá điểm → code set null) · `file_path` · `thumb_path` · `taken_at` · `lat`? · `lng`? · `caption`? · `source` int · `width` · `height` · `bytes` · `sort_index`.
Index: `(measurement_id, sort_index)`.

`beforeOpen`: `PRAGMA foreign_keys = ON`; WAL mode. DateTime lưu dạng text ISO-8601 UTC (`build.yaml` `store_date_time_values_as_text`) để giữ mili-giây. File DB: `<appDocuments>/landmeasure.sqlite`, mở trên isolate nền (drift_flutter). Migration: mỗi version 1 hàm `_migrateVxToVy`, có test bằng `drift_dev schema dump/generate`.

**Draft và Saved chung bảng** → chuyển trạng thái chỉ là `UPDATE status`, không copy dữ liệu.

### 5.4 File trên đĩa
```
<appDocuments>/photos/<measurementId>/<photoId>.jpg      # ≤ 2048px cạnh dài, JPEG q82
<appDocuments>/photos/<measurementId>/<photoId>_t.jpg    # thumb 320px q70
<appDocuments>/thumbs/<measurementId>.png                # thumbnail bản đồ 400×400
<temporary>/exports/<slug>_<yyyyMMdd_HHmm>.<ext>         # xoá khi khởi động
```
- DB chỉ lưu **đường dẫn tương đối** (container iOS đổi path sau update).
- Ảnh gallery **luôn copy** vào app storage; không bao giờ xoá ảnh gốc của người dùng.

### 5.5 SharedPreferences (`data/prefs/prefs_keys.dart`)
| Key | Kiểu | Mặc định |
|---|---|---|
| `distance_unit` | int | theo locale: US/UK/MM/LR → foot, còn lại meter |
| `area_unit` | int | US/UK → acre, còn lại squareMeter |
| `show_secondary_unit` | bool | true |
| `map_style` | int | satellite |
| `locale` | String? | null = theo hệ thống |
| `default_mode` | int | area |
| `show_gps_accuracy` | bool | true |
| `auto_center` | bool | true |
| `save_photos_to_measurement` | bool | true |
| `keep_screen_awake` | bool | true |
| `input_mode` | int | crosshair |
| `show_edge_labels` | bool | true |
| `recent_searches` | List<String> | [] (tối đa 5) |
| `oem_battery_hint_shown` | bool | false |
| `walk_notification_asked` | bool | false (đã xin POST_NOTIFICATIONS trước lần Start Walking đầu) |
| `saves_count_total` | int | 0 |
| `last_interstitial_at` | int ms | 0 |
| `last_background_at` | int ms | 0 |
| `export_free_used_on` | String yyyy-MM-dd | "" |
| `review_prompted_at` | int ms | 0 |
| `att_requested` | bool | false |
| `premium_cached` | bool | false |
| `app_open_count` | int | 0 |
| `orphan_cleanup_at` | int ms (UTC) | — (lần dọn file mồ côi gần nhất) |
| `help_seen_<mode>` | bool | false (sheet hướng dẫn tự mở 1 lần / chế độ) |
| `last_map_camera` | String `lat,lng,zoom` | — (chỗ bản đồ Area/Distance để lại; dùng khi Auto Center Map tắt) |
| `location_blocked` | bool | false (lần xin quyền vị trí gần nhất trả "chặn hẳn" — Android chỉ báo lúc xin) |

---

## 6. Vòng đời measurement

```
(none) ──add first point / Start Walking──▶ DRAFT (đang đo)
DRAFT ──rời màn / crash──▶ DRAFT (nghỉ) ──Resume──▶ DRAFT (đang đo)
DRAFT (Area/Distance) ──Save──▶ SAVED
DRAFT (Walk) ──Finish──▶ COMPLETED ──Save──▶ SAVED
DRAFT/COMPLETED ──Discard──▶ xoá DB + ảnh
SAVED ──Edit (bản sao trong EditController) ──Save Changes──▶ SAVED
SAVED ──Delete──▶ xoá DB + ảnh + thumbnail
Walk runtime: idle → recording ⇄ paused → finished
```
- Save bị chặn bởi giới hạn Free → vẫn là DRAFT, không mất.
- `COMPLETED` hiển thị cùng khu Drafts với nhãn "Finished · not saved".

---

## 7. Thuật toán lõi (`domain/`)

### 7.1 `GeoCalculator`
- `distance(a,b)`: haversine, R = 6371008.8 m.
- `pathLength`, `segmentLengths`, `perimeter(ring)` (= pathLength + đoạn khép).
- `area(ring)`: spherical excess giống `SphericalUtil.computeSignedArea` của Google, R = 6378137:
  ```
  total = 0; prev = ring.last
  for p in ring:
    total += polarTriangleArea(tan((π/2 − prev.latRad)/2), prev.lngRad, tan((π/2 − p.latRad)/2), p.lngRad)
    prev = p
  area = |total × R²|
  polarTriangleArea(tan1, lng1, tan2, lng2): deltaLng = lng1 − lng2; t = tan1·tan2
      return 2·atan2(t·sin(deltaLng), 1 + t·cos(deltaLng))
  ```
- `centroid`, `midpointAlongPath`, `bearing`, `bounds`.
- Chuẩn nghiệm thu: sai số ≤ 0,1% với các case tham chiếu trong `test/fixtures/area_cases.json`.

### 7.2 `PolygonValidator`
`selfIntersects(ring)` — kiểm cặp cạnh không kề nhau (O(n²); n > 300 bỏ qua trả false). `isDegenerate` — < 3 điểm phân biệt hoặc area < 0,5 m².

### 7.3 `TrackFilter` (Walk) — tham số lấy từ Remote Config
```
reject: accuracy > walk_max_accuracy_m (25)
reject: isMocked
reject: timestamp ≤ last.timestamp
reject: d/dt > walk_max_speed_mps (12)
accept: last == null
accept: d ≥ max(walk_min_distance_m (3), 0.5 × accuracy)
accept: dt ≥ 15s && d ≥ 1m
else reject
```
Làm mượt (nếu `walk_smoothing`): trung bình trọng số 1/accuracy² của 3 fix gần nhất **đã qua cổng chất lượng** (accuracy/mock/thời gian/tốc độ — kể cả fix bị loại vì quá gần). Khoảng cách so với fix thô được nhận gần nhất. `reset()` khi bắt đầu segment mới (Resume).

### 7.4 `ClosureDetector`
```
threshold = clamp(max(20, 0.05 × pathLength, 2 × medianAccuracy), 20, 60)  (mét)
isClosed = pathLength ≥ 50 && pointCount ≥ 4 && distance(first, last) ≤ threshold
```
Walk area = area(tất cả điểm mọi segment theo thứ tự) chỉ khi `isClosed`, ngược lại `null`.
Distance Walk = tổng pathLength **từng segment** (không nối giữa các segment).

### 7.5 `GeometryEditor` (undo stack ≤ 50)
Lệnh (sealed `GeometryCommand`): `AddPoint(point, atIndex?)`, `MovePoint(id, from, to)`, `DeletePoint(point, index)`, `ResetGeometry(previous)`, `CloseShape`, `ReopenShape`. `GeometryState` luôn reindex `orderIndex` và giữ list unmodifiable. Các hàm tiện ích của editor (`movePoint`, `close`…) trả `false` và không tạo mục undo khi thao tác vô nghĩa. Pure Dart.

### 7.6 Đơn vị (`domain/units`)
m² → ha 1e4 · acre 4046.8564224 · ft² 0.09290304.
m → km 1000 · ft 0.3048 · mile 1609.344.
Làm tròn hiển thị: < 10 → 2 số lẻ; < 1000 → 1; còn lại 0; ha/acre luôn 2. Secondary tự động: m² ≥ 10.000 → ha; ft² ≥ 43.560 → acre.
Secondary đầy đủ (`UnitConverter.secondaryAreaUnit`): m² → ha (≥ 10.000) hoặc không có; ft² → acre (≥ 43.560) hoặc không có; ha → m²; acre → ft². Khoảng cách: m ↔ km, ft ↔ mi.
Ký hiệu hiển thị (`core/format/unit_formatter.dart`): m², ha, acre, ft² · m, km, ft, mi. Đã bỏ đơn vị đất truyền thống VN (sào/mẫu/công).

### 7.7 `GeoParse`
Nhận: `lat, lng` · `lat lng` · `lat; lng` · hậu tố/tiền tố N/S/E/W · DMS `21°01'42.6"N 105°51'15.1"E` (cả `º ′ ″ ''` và dạng cách trống) · link Google Maps (`/@lat,lng`, `?q=`, `ll=`, `query=`, `/search/lat,+lng`) · `geo:`. Kết quả là freezed union `GeoQuery.coordinate` / `GeoQuery.address`. Ngoài phạm vi toạ độ hoặc link rút gọn `maps.app.goo.gl` (cần mạng) → `AddressQuery`.

### 7.8 `PathSimplifier`
Douglas–Peucker chỉ để **hiển thị** khi > 5.000 điểm; dữ liệu gốc không đổi.

### 7.9 `FeatureGate` (pure, nhận `isPremium` + giá trị RC)
`canSaveNew(savedCount)`, `canAddPhoto(count)`, `canExport(format, freeUsedToday)` (PDF luôn `false` cho free), `canUsePdf`, `canUseCustomUnit`, `showAds`. Không bao giờ chặn: đo, xem, sửa, xoá, draft.

---

## 8. Luồng dữ liệu chính

**Area/Distance**: gesture → `MeasureSessionController.addPointAt()` → `GeometryEditor` → tính `stats` → emit state → `_autosaveDebounced(300ms)` → `MeasurementRepository.replacePoints()` (transaction). Lần thêm điểm đầu → `createDraft()`. `AppLifecycleListener.onPause` → `flushNow()`.

**Walk**: `LocationTracker.stream` → `WalkController._onFix` → `TrackFilter` → append vào segment → cập nhật stats → buffer → flush DB mỗi 5 điểm hoặc 10s (`appendWalkPoints` + `walk_elapsed_sec`). Pause/Resume/Finish flush ngay. Timer UI 1s: `elapsed = walkElapsedSec + (now − walkLastResumeAt)`.

**Save**: màn đo flush → khung hình trên bản đồ → `takeSnapshot()` → cắt vuông 400 px (`ThumbnailStorage.squareFromSnapshot`) → `PendingThumbnails` → push `/save/:id`. `SaveController.save()` → validate → `FeatureGate` → `MeasurementRepository.markSaved` (1 transaction: name + name_lower + notes + status=saved + saved_at) → thumbnail (ảnh chụp, không có thì vẽ; không chặn, lỗi bỏ qua) → `saves_count_total`++ → analytics → `go('/home')` + `push('/detail/:id')` (thay stack đo) → `InterstitialManager.maybeShow()`. Guard rời màn đo không mời "Bỏ" với phép đo đã lưu.

**Ảnh**: `PhotoFlows.add` → gate (`remaining`) → sheet nguồn → (camera: pre-prompt + quyền; setting tắt → hỏi đính kèm) → `PhotoStorage.import*` (nén 2048/q82 + thumb 320) → `PhotoRepository.add`. Xoá trong phiên: `removeRow` + snackbar Undo (`restore`), file xoá sau 5 s (app chết trước → orphan cleaner). Xoá điểm → `detachPoint`.

**Edit**: `MeasureSessionController(type, id, editing: true)` sửa bản sao (không autosave, `geometryChanged`); `EditController` giữ tên/ghi chú/ảnh thêm-xoá. "Lưu thay đổi" → `MeasurementRepository.saveEdit` (1 transaction: điểm + stats + bounds + tên + ghi chú, tách ảnh của điểm đã xoá) → xoá ảnh đã bỏ → vẽ lại thumbnail. "Bỏ" → xoá ảnh thêm trong lúc Edit.

**Export**: `ExportSheet` → `ExportService.export(id, format)` → `FeatureGate.canExport` (free: 1 KML/ngày, pref `export_free_used_on`, chỉ tính khi share thành công) → `KmlEncoder`/`CsvEncoder` → `ExportStorage.write` (bytes UTF-8, không đổi xuống dòng) → `FileSharer` (share_plus) → snackbar khi lỗi/hết lượt.
**Báo cáo PDF** (Premium): free bấm dòng PDF → thẳng `/paywall?source=export_pdf`, mua xong mới xuất (service cũng chặn: `ExportResult.premiumRequired`). `ExportService._buildPdf` đọc font Inter (assets) + tối đa 8 ảnh (`PhotoStorage.resolve`, nhúng JPEG nguyên bản) → `PdfReportBuilder` → `ExportStorage.writeBytes`. Báo cáo viết bằng ngôn ngữ app nếu là en/vi/es/pt/id; hi/zh dùng tiếng Anh (font Inter không có glyph Devanagari/CJK). Bản vẽ hình là vector (không ảnh vệ tinh), bắc ở trên, có thanh tỉ lệ; bảng toạ độ tối đa 120 dòng (còn lại → CSV).

**List**: `watchSaved(type, query)` là Drift stream → UI tự cập nhật khi DB đổi.

---

## 9. Bootstrap order (`bootstrap.dart`)
1. `WidgetsFlutterBinding.ensureInitialized()`
2. `Firebase.initializeApp(options theo flavor)`
3. Crashlytics: `FlutterError.onError`, `PlatformDispatcher.instance.onError` (tắt collection ở dev)
4. `SharedPreferences`, `AppDatabase` (mở DB)
5. `RemoteConfigService.init()` — set defaults, fetch nền, không chờ quá 3s
6. `PurchaseService.init()` — chỉ configure, không await kết quả mạng; dùng `premium_cached`. Tăng `app_open_count`.
7. `WalkRecoveryService.check()` — chuyển walk recording → paused nếu app bị kill
8. `runApp(ProviderScope(overrides: [...]))`
9. Sau frame đầu: `AppOpenManager` (chỉ preload cho splash), `InterstitialManager` (preload khi ads bật); `AdsService.start()` = `ConsentService.gather()` → (iOS ATT khi đủ điều kiện) → `MobileAds.initialize()` nếu `canRequestAds` và không premium; `NotificationService.init()`; `PushService.init()`; `OrphanFileCleaner.runIfDue()`; dọn `temp/exports`.

---

## 10. Routes

| Path | Màn | Tham số |
|---|---|---|
| `/home`, `/saved`, `/settings` | Tab shell | |
| `/measure/area` | Area | `?draftId=` |
| `/measure/distance` | Distance | `?draftId=` |
| `/measure/walk` | Walk | `?draftId=` |
| `/save/:id` | Save sheet (modal page) | |
| `/detail/:id` | Detail | |
| `/detail/:id/map` | Full map | |
| `/edit/:id` | Edit | |
| `/photos/:measurementId` | Photo viewer | `?index=` |
| `/settings/units`, `/settings/map-style`, `/settings/language` | Settings con | |
| `/paywall` | Paywall | `?source=` |
| `/paywall-first` | Premium First (paywall lần 2, chỉ gói năm) | — |

Deep link từ notification dùng cùng path.

---

## 11. Monetization & services

- **RevenueCat**: entitlement `premium`; offering `default` gồm `$rc_monthly`, `$rc_annual` (trial 3 ngày), `$rc_lifetime`. `PurchaseService.statusStream` → `premiumProvider` là nguồn sự thật; cache `premium_cached`. Không cần đăng nhập — dùng anonymous app user ID.
- **Ads**: MainShell (banner collapsible ở đáy màn main, dưới bottom nav, giữ nguyên khi đổi tab; bỏ qua trong lần mở app đầu tiên = chưa xong language/intro hoặc vừa xong ở lần mở này; `SettingsRepository.inFirstRunSession`), Detail (banner + native dưới tên phép đo); Interstitial sau Save (điều kiện RC); Rewarded mở khoá export; App Open **chỉ ở splash** (quay lại từ background không hiện). **Không có ads trên màn đo/Walk.** Tắt toàn bộ khi premium.
- **Consent**: UMP trước mọi ad request; iOS ATT sau UMP, không hỏi ở lần mở đầu tiên.
- **Remote Config keys**: `free_max_saved`(10), `free_max_photos`(2), `interstitial_min_interval_sec`(180), `interstitial_after_nth_save`(2), `app_open_enabled`(true), `app_open_min_background_hours`(4), `banner_enabled`(true), `paywall_variant`("a"), `walk_max_accuracy_m`(25), `walk_min_distance_m`(3), `walk_max_speed_mps`(12), `walk_smoothing`(true), `review_after_saves`(3).
- **Notification channels**: `walk_recording` (do geolocator tạo), `reminders`, `general`.

### 11.1 Analytics events
`mode_selected{mode}` · `measure_start{mode,source}` · `point_added{mode,method,count}` (chỉ count 1,3,10) · `shape_closed{points}` · `walk_started` · `walk_paused` · `walk_resumed` · `walk_finished{duration_s,distance_m,closed,points,avg_accuracy}` · `walk_recovered{state}` · `draft_saved_on_exit{mode}` · `draft_resumed{mode,age_min}` · `draft_discarded{mode}` · `photo_added{mode,source,attached_to_point}` · `measurement_saved{mode,area_bucket,points,photos,has_notes,is_first}` · `measurement_edited{mode,geometry_changed}` · `measurement_renamed` · `measurement_deleted` · `export_done{format,mode,via}` · `search_used{kind,success}` · `unit_changed{kind,unit}` · `map_style_changed{style}` · `permission_result{type,result}` · `paywall_view{source,variant}` · `paywall_trigger{reason}` · `purchase_success{product,source}` · `purchase_fail{product,code}` · `review_prompt_shown`.
User properties: `is_premium`, `app_locale`, `default_mode`, `saved_count_bucket`.

---

## 12. Cấu hình native

### Android
- Quyền: `INTERNET`, `ACCESS_NETWORK_STATE`, `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`, `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_LOCATION`, `WAKE_LOCK`, `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED` (nhắc draft sau khi khởi động lại), `CAMERA`, `com.google.android.gms.permission.AD_ID`. **Không** `ACCESS_BACKGROUND_LOCATION`. `uses-feature` camera/GPS `required=false`.
- Service geolocator `foregroundServiceType="location"`. Receiver `ScheduledNotificationReceiver` + `ScheduledNotificationBootReceiver` (flutter_local_notifications).
- `<queries>`: PROCESS_TEXT, VIEW https, SENDTO mailto, IMAGE_CAPTURE.
- Icon thông báo đơn sắc `@drawable/ic_notification`, màu `@color/brand_primary` (`res/values/brand_colors.xml`); FCM mặc định channel `general`.
- Meta-data: Maps API key, AdMob App ID (từ `manifestPlaceholders` theo flavor).
- Release: `isMinifyEnabled` + `isShrinkResources`, rule ở `android/app/proguard-rules.pro` (Meta Audience Network, `-dontwarn` Play Core), `ndk.debugSymbolLevel = SYMBOL_TABLE`.
- Ký release: `android/key.properties` (gitignore); thiếu file → ký bằng debug key kèm cảnh báo. Hướng dẫn: `docs/android_release.md`.

### iOS (`Info.plist`)
- `NSLocationWhenInUseUsageDescription`, `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`, `NSUserTrackingUsageDescription`.
- `UIBackgroundModes`: `location`, `remote-notification`. **Không** xin Always.
- `GADApplicationIdentifier`, `SKAdNetworkItems` (Google + Meta, lấy danh sách mới nhất).
- `AppDelegate`: `GMSServices.provideAPIKey`.
- `PrivacyInfo.xcprivacy`.

### Google Cloud (Maps — chi phí 0đ)
- Chỉ bật **Maps SDK for Android** và **Maps SDK for iOS**.
- API key giới hạn theo package + SHA-1 (debug, upload, Play signing) / bundle ID.
- Budget alert 1 USD. Không Map ID, không Places/Geocoding/Static Maps API.

---

## 13. Hiệu năng & độ bền (bất biến)
- Không bao giờ mất dữ liệu đo: mọi thay đổi hình học ghi DB trong ≤ 300ms (Area/Distance) hoặc ≤ 10s (Walk), flush ngay khi app vào nền.
- `MeasureMapView` bọc `RepaintBoundary`; sheet kéo không rebuild map.
- Marker bitmap cache theo key.
- Nén ảnh trong isolate; list dùng thumbnail.
- Startup không chờ ads/RC/RevenueCat mạng.

---

## 14. Changelog kiến trúc
> AI ghi 1 dòng mỗi khi thay đổi cấu trúc/schema/quy ước.

| Ngày | Phase | Thay đổi |
|---|---|---|
| 2026-10-19 | iOS Maps | AppDelegate đọc `MapsApiKey` từ Info.plist và gọi `GMSServices.provideAPIKey` trước khi Flutter tạo map view, sửa crash SIGABRT ở `GMSServices.checkServicePreconditions`. |
| 2026-10-19 | iOS release | Chốt Bundle ID Runner `com.avs.gpsareameasurement$(BUNDLE_ID_SUFFIX)` cho mọi build configuration; giữ dev `.dev`, staging `.stg`, prod không hậu tố. RunnerTests đổi sang `com.avs.gpsareameasurement.RunnerTests`. |
| 2026-10-08 | 11 | Native thứ 2 ở dưới màn `/language` (`AdFormat.nativeLanguage`, env `AD_UNIT_NATIVE_LANGUAGE_*`, layout compact, CTA cùng màu nút Continue). Map style Premium mở được bằng **rewarded**: `PremiumFlows.unlockMapStyle` (popup: Xem quảng cáo / Nâng cấp / Để sau) + `unlockedMapStylesProvider` (chỉ trong bộ nhớ → mở đến khi đóng app) → `FeatureGate.unlockedMapStyles`; không có quảng cáo (no fill/offline) thì vẫn mở như export KML, đóng ad sớm thì không. |
| 2026-10-08 | 11 | **Kịch bản monetization Android** (thay đổi lớn). (1) IAP bỏ RevenueCat (`purchases_flutter` gỡ): Play Billing Library **9.1.0** gọi trực tiếp qua `PlayBilling.kt` + `PlayBillingPurchaseService` (MethodChannel `com.example.gps_measurement/billing`); 2 gói `IAP_PRODUCT_MONTHLY/YEARLY`; không backend. Docs `setup_play_billing.md` thay `setup_play_billing.md`. (2) Luồng khởi động: Splash (App Open ad, tối đa 8 s, không bao giờ kẹt) → `/language` (lần 1) → `/intro` → Home; lần 2 → `/paywall?source=startup` → Home; từ lần 3 → Home (`onboarding_done_at_open`, `startup_paywall_shown`). (3) Ads: `AdCoordinator` (cờ full-screen ad đang chạy, chống App Open ngay sau khi đóng ad khác); `AppOpenManager.runSplash` + resume (cách nhau 30 s); `InterstitialManager.showIfReady()` (cache 1 ad, null-check trước khi load, về null sau khi show, cách nhau 30 s, preload khi vào màn đo, hiện sau Save/Save Changes rồi mới điều hướng); native ads Android (`NativeAdController`/`NativeAdCache`, factory Kotlin `LmNativeAdFactory` + 3 layout XML compact/medium/full, màu truyền từ `LmColors`, CTA cùng màu nút chính); banner tắt mặc định. (4) Premium gating: ảnh > 3 và bản đồ Satellite/Hybrid → popup `PremiumFlows.promptUpgrade` → Paywall; mặc định bản đồ Standard (`FeatureGate.effectiveMapStyle`). Paywall 2 gói (monthly có trial 3 ngày + yearly), nền tối nhấn vàng (`LmPremiumColors`). |
| 2026-10-13 | 11 | Native `nativeSaved` chuyển tiếp từ màn Save sang màn Detail (`DetailNativeAd`, ngay dưới tên; vẫn preload khi vào màn đo). Giới hạn ảnh miễn phí 3 → 2 (`GateConfig.freeMaxPhotos`). |
| 2026-10-13 | 11 | Chỉnh lại: banner collapsible chuyển từ Home xuống `MainShell` (dưới bottom nav, `BannerAdSlot.bottomInset` giữ chỗ thanh điều hướng hệ thống); `/paywall-first` ẩn ✕ cho tới 10 s hoặc khi bấm "Start free trial" (`PaywallFlow.closeDelay`/`revealClose`); Paywall: badge "Most popular" sang gói tháng, gói có trial hiện dòng "{n}-day free trial" + giá năm, bỏ dòng giá/tuần (xoá key `paywallPerWeek`, `paywallTodayAmount`). |
| 2026-10-13 | 11 | (1) Native `AdFormat.nativeSaved` chuyển từ tab Saved sang màn Save (`SaveNativeAd`, dưới ô tên, trên kết quả; preload khi vào màn đo, màu nút theo mode). (2) Home: banner collapsible (`BannerAdSlot(collapsible: true)`, `homeBannerEnabled`), không load ở lần mở đầu. (3) Settings: card Premium lên đầu. (4) Màn `/paywall-first` (`PremiumFirstScreen`, `premiumControllerProvider(source, preferAnnual: true)`): launch 2 chỉ bán gói năm, nút "Start free trial" + "{n}-day free trial, then {price}/year" + "Cancel anytime"; phần dùng chung tách ra `paywall_parts.dart`. (5) App Open chỉ ở splash: gỡ resume (`skipNextResume`, `appOpenAllowed`, `lastBackgroundAt`, `appOpenMinInterval/Background`). (6) `showLmBottomSheet` (core/widgets): bottom sheet tự chừa thanh điều hướng hệ thống (`useSafeArea` của Flutter bỏ qua cạnh dưới). |
| 2026-09-28 | – | Khởi tạo tài liệu. Chốt RevenueCat, Google Maps SDK (không Map ID), geocoder native. |
| 2026-09-28 | 0 | Flutter **3.38.5** / Dart 3.10.4. Vì SDK này, một số package ghim bản thấp hơn bản mới nhất: `drift_flutter ^0.2.8`, `drift/drift_dev ^2.31`, `flutter_riverpod ^3.1`, `riverpod_generator ^4.0.0+1`, `xml ^6` (nâng khi nâng Flutter). build_runner cần `--force-jit`. |
| 2026-09-28 | 0 | `minSdk` 23 → **24** (mặc định Flutter 3.38); iOS 14 → **15.0** (Firebase iOS SDK 12). Bật core library desugaring (cần cho `flutter_local_notifications`). |
| 2026-09-28 | 0 | Tên package tạm giữ `gps_measurement` / `com.example.gps_measurement` (Android) · `com.example.gpsMeasurement` (iOS), chờ chốt tên chính thức. Flavor thêm hậu tố `.dev` / `.stg`. |
| 2026-09-28 | 0 | Thêm `core/utils/app_exception.dart` (thay `result.dart` chưa dùng), `core/l10n/l10n.dart` + `locale_controller.dart` (sẽ gộp vào Settings ở Phase 2/9), `core/router/placeholder_screen.dart` + `phase0_tabs.dart` (tạm). `ModeColors.of(context, type)` nhận `BuildContext` vì container khác nhau giữa light/dark. |
| 2026-09-28 | 0 | Thêm dev dependency `fake_async` (test Debouncer/Throttler). Golden test gắn tag `golden`, CI chạy `--exclude-tags golden` vì raster font khác nhau giữa các OS. |
| 2026-10-01 | 11 | Monetization (Phase 10 hoãn — chưa có Firebase). `PurchaseService` (RevenueCat, `premiumProvider`), `featureGateProvider` thật, `rc_keys.dart` + `monetizationConfigProvider` (mặc định §11, chờ RC). Ads: `AdsService`/`adsEnabledProvider`, `ConsentService` (UMP mỗi lần mở + ATT từ lần mở thứ 2 / sau lần lưu đầu), banner/interstitial/rewarded/app open manager. `ExportService.export(unlocked:)` (rewarded mở 1 lần, không tính lượt free). Paywall thật thay `placeholder_screen.dart` (đã xoá). Env thêm `UMP_DEBUG_EEA`, `UMP_TEST_DEVICE_ID`. iOS: `NSUserTrackingUsageDescription`, `SKAdNetworkItems`. Docs: `setup_play_billing.md`, `setup_admob.md`. |
| 2026-10-01 | 9 | Settings: `SettingsScreen` + Units/Map Style/Language, `SettingsController`, `services/support/support_service.dart` (env `SUPPORT_EMAIL`, `PRIVACY_POLICY_URL`, `TERMS_URL`, `APP_STORE_ID`; trống → ẩn mục). `PermissionService` đổi `CameraAccess` → `PermissionAccess`, thêm thông báo; `PermissionFlows` dùng chung (Walk không tự xin quyền khi mở). `GeolocatorLocationService` nhận `SettingsRepository` (pref `location_blocked`). Pref `last_map_camera`. `LmColors` thêm `map*` (ảnh vẽ xem trước Map Style). ARB thêm es/pt/hi/id/zh (dịch máy, `@@x-machine-translated`), bỏ 19 key không dùng. Bỏ `phase0_tabs.dart`. Sheet mở từ tab dùng `useRootNavigator: true` để phủ bottom nav. |
| 2026-09-29 | 8 | Export + giá trị đất. `markSaved` nhận `unitPrice/unitPriceCurrency/unitPriceArea`. `MoneyFormatter.parse/input`. `ResultGrid(landValue:)` thêm ô VALUE. `SettingsRepository.exportFreeUsedOn`. Fixture export so từng byte; `.gitattributes` `test/fixtures/export/** -text`. Bỏ chuỗi "sắp có" của Save/Export. |
| 2026-09-29 | 7 | Ảnh/ghi chú/Edit. `PhotoRepository.removeRow/restore` (Undo), `PhotoStorage.discardCapture`, `MeasurementRepository.saveEdit`. `MeasureSessionController` có tham số `editing` + `ensureDraft()` (ảnh trước điểm đầu), draft còn ảnh không tự xoá. `Routes.photosOf(readOnly:)`. iOS: `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`, Podfile `PERMISSION_CAMERA=1`. |
| 2026-09-29 | 6 | Home/Saved/Save/Detail/Full map. Repository thêm `markSaved`, `namesWithPrefix`, `updateMeta(touch:)` (thay đổi chỉ để hiển thị không đổi `updated_at`). `ThumbnailStorage.squareFromSnapshot`. `MeasureMapView.readOnly`. `LmDialog.onAction` (form kiểm tra trước khi đóng). `LmColors` thêm `heroBase/heroFieldA/heroFieldB/heroRoad` cho hình vẽ hero (thay ảnh vệ tinh tới khi có ảnh bản quyền). `SaveController` tắt retry của Riverpod 3 (không tìm thấy thì báo lỗi ngay). Placeholder Home trong `phase0_tabs.dart` đã bỏ (còn Setting). |
| 2026-09-29 | 5 | Walk: `LocationTracker` (preview/ghi, chỉ 1 stream một lúc — giới hạn của geolocator), `WalkController` keepAlive, `WalkMapView` riêng (track theo segment, vùng khép, halo, bám camera), `WalkRecoveryService` chạy ở bước 7 bootstrap qua `MeasurementRepository.pauseInterruptedWalks()` (mới). `core/permissions/permission_service.dart` bản tối thiểu (xin thông báo 1 lần). Pref `walk_notification_asked`. Sheet tối ưu pin mở trang thông tin ứng dụng (`openAppSettings`) — không khai báo `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` (Play hạn chế). Rời màn Walk luôn Pause + tắt GPS; back khi đang ghi bị chặn (`LeaveMeasureGuard.canPop/onPopBlocked`). iOS: `NSLocationWhenInUseUsageDescription`, `UIBackgroundModes: location` (remote-notification thêm ở Phase 10), Podfile `PERMISSION_NOTIFICATIONS=1`. Snackbar có action phải đặt `persist: false` (Flutter ≥ 3.29 mặc định giữ mãi). |
| 2026-09-28 | 4 | `MeasureScreen` dùng chung cho Area/Distance (`area_measure_screen.dart`, `distance_measure_screen.dart` chỉ còn là wrapper). Tìm địa điểm: `PlaceSearchService` (toạ độ/link parse cục bộ; link rút gọn `maps.app.goo.gl`/`goo.gl` → 1 lần theo redirect, chỉ gọi đúng các host đó; địa chỉ → `AddressGeocoder` bọc geocoder của OS, đặt tên cho tối đa 3 kết quả) + `PlaceSearchController` (5 tìm kiếm gần đây; lỗi geocoder khi đang online = `failed`, không đổ cho mạng). `ConnectivityService` + `isOnlineProvider`. Chọn kiểu bản đồ cũng lưu làm mặc định. Chế độ chạm: chạm nhãn cạnh = chèn điểm giữa cạnh đó. Nhãn tổng của Distance nổi phía trên đường (`MarkerFactory.aboveAnchor`). |
| 2026-09-28 | 4 (chốt trước) | Rời màn đo không dùng dialog: flush → thoát → snackbar "Đã lưu nháp" + Bỏ. `leave_measure_dialog.dart` → `leave_measure_guard.dart`. Cập nhật plan P4-05, design §5.17, overview §1.1. |
| 2026-09-28 | 3 | Thêm `core/location/location_service.dart` (`LocationService` + `GeolocatorLocationService`, provider). `MarkerFactory` vẽ marker bằng Canvas (không render widget) + cache LRU 256. `PointActionsPopup` là thanh cố định phía trên toolbar (bám theo marker cần gọi platform mỗi frame). `MapLayerSheet` bản cơ bản làm luôn ở Phase 3 (P4-03 chỉ còn lưu pref). Input mode / nhãn cạnh lưu vào settings. `MeasureSessionController` giữ bản sao state để flush sau khi provider dispose; draft còn 0 điểm bị xoá khi rời màn. |
| 2026-09-28 | 3 | Bỏ `assets/images/` khỏi pubspec (thư mục rỗng không được git lưu → clone mới build lỗi); thêm `assets/map_styles/dark.json`. Thêm `.gitattributes` (LF). |
| 2026-09-28 | 2 | Data layer: Drift schema v1 (dump `drift_schemas/app/drift_schema_v1.json`), 3 DAO, `MeasurementRepository`/`PhotoRepository` (interface + Drift), `SettingsRepository` + `settingsProvider`, `PhotoStorage` (nén qua interface `ImageCompressor`; bản native dùng flutter_image_compress — mã hoá chạy trên thread native nền, không cần isolate Dart), `ThumbnailStorage` (snapshot hoặc tự vẽ PNG 400×400), `OrphanFileCleaner` (chỉ xoá file ≥ 1 giờ tuổi). `name_lower` lưu dạng bỏ dấu. |
| 2026-09-28 | 2 | `locale_controller.dart` → `core/l10n/app_locale.dart` (`appLocaleProvider` suy ra từ settings; đổi bằng `settingsProvider.notifier.setLocaleCode`). Bootstrap dùng `ProviderContainer` + `UncontrolledProviderScope` để chạy dọn dẹp sau frame đầu. |
| 2026-09-28 | 2 | Thêm dev dependency `sqlite3` (test dùng SQLite của hệ điều hành: `winsqlite3.dll` trên Windows, `libsqlite3-dev` trên CI). Thêm pref `orphan_cleanup_at`. `watchCountByType()` là Stream (chip đếm cập nhật trực tiếp) thay cho `countByType()`. build_runner bỏ cờ `-d` (đã bị bỏ, chỉ còn `--force-jit`). |
| 2026-09-28 | – | Cấu hình Android đầy đủ theo §12 (làm sớm theo yêu cầu, trước P5-02/P10/P11): quyền, service, receiver, queries, icon thông báo, R8, ký release qua `key.properties`. Maps key Android đã điền vào `env/*.json` và chạy thử OK. iOS tạm hoãn. |
| 2026-09-28 | 1 | Thêm `domain/geo/local_projection.dart` (chiếu phẳng cục bộ cho kiểm cắt cạnh / centroid / đơn giản hoá), `domain/geo/stats_calculator.dart` (tính `MeasurementStats` theo loại — nguồn duy nhất cho controller), `domain/models/location_fix.dart` (fix GPS thô cho `TrackFilter`), `GeoBounds` trong `geo_point.dart`, `MeasurementType.minPoints`. |
| 2026-09-28 | 1 | Không dùng `json_serializable` cho domain model (lưu bằng Drift, không cần JSON). Fixture sinh bằng `tool/gen_fixtures.py`; coverage kiểm bằng `tool/coverage_report.py` (CI chặn khi `lib/domain` < 90%). |
| 2026-09-28 | 0 | Env key tách theo nền tảng (`MAPS_API_KEY_ANDROID/IOS`, `ADMOB_APP_ID_ANDROID/IOS`). Khi chưa có key, AdMob dùng app ID test của Google để app không crash lúc khởi động. |
