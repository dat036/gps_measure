# LandMeasure — Design System & Screen Spec

> Dựa trên mockup bạn tạo (Home / Measure Area / Measure Distance / Walk & Measure) + spec chức năng.
> Nguyên tắc: **map-first, sạch, đáng tin, đọc số liệu trong 1 giây**. Material 3, cảm giác "premium utility" chứ không phải dashboard.

---

## 0. Phân tích mockup — giữ gì, sửa gì

**Giữ lại (rất tốt):**
- Hero card Home nền ảnh vệ tinh + polygon minh hoạ, overlay tối, chữ trắng.
- Segmented selector 3 chế độ nằm trong hero card, có icon.
- Floating buttons tròn trắng bên phải bản đồ (Layers / My location / Search / Camera tách riêng ở dưới).
- Bottom sheet bo góc lớn có drag handle, số liệu 2 cột với đường kẻ dọc mảnh.
- Pill label kết quả đen mờ ở giữa polygon ("12,450 m² / 1.25 ha").
- Ô "Add Photo" viền đứt nét, thumbnail ảnh có nút ✕ tròn đen.
- CTA full-width bo tròn màu theo mode (xanh lá Save Measurement, xanh dương Save Route, Pause hồng nhạt + Finish đỏ).
- Walk: đường cam có chấm, fill xanh khi khép vòng, điểm hiện tại xanh dương có halo, mũi tên hướng đỏ.

**Sửa:**
1. Bottom nav 4 tab → **3 tab: Home / Saved / Setting** (bỏ Projects, Profile). Bỏ icon ⚙️ trên header Home nếu đã có tab Setting (hoặc giữ làm shortcut — chọn **bỏ** để tránh trùng điều hướng).
2. Bỏ search bar ở Home. Search chuyển thành floating button trên màn đo (đúng như mockup đã có kính lúp).
3. CTA Home: thay nền trắng "Start Measure" bằng **nút đặc màu theo mode** + text động. Nút trắng trên nền tối kém nổi bật hơn.
4. Selector: segment đang chọn nền trắng đặc + icon/label màu mode; mockup đang viền xanh khiến segment chọn và không chọn khá giống nhau.
5. Màn Area thiếu **thanh công cụ Undo / Add Point / Close** và **tâm ngắm** — phải thêm (xem §5.2).
6. Màn Distance thiếu nhãn độ dài từng đoạn và chip đơn vị.
7. Thêm chip đơn vị (m² · ha · acre · ft²) trong bottom sheet.
8. Helper banner hướng dẫn nhỏ phía trên bản đồ khi chưa có điểm.

---

## 1. Design tokens

### 1.1 Màu

```yaml
# Brand / mode
brand.primary:        "#0F8A5F"   # xanh lá chủ đạo (logo, Area)
area.main:            "#12A150"   # CTA Area, viền polygon
area.fill:            "#12A150" @ 28% opacity  # fill polygon
area.container:       "#E3F6EA"
distance.main:        "#1E6BFF"   # CTA Distance, polyline
distance.container:   "#E4EDFF"
walk.main:            "#F58A07"   # track Walk
walk.container:       "#FFF1DF"
danger.main:          "#E5383B"   # Finish, Delete
danger.container:     "#FDE8E8"   # nền Pause (mockup)
success.start:        "#12A150"   # marker Start
end.marker:           "#E5383B"   # marker End

# Neutral (light)
text.primary:         "#0E1A2B"   # navy gần đen
text.secondary:       "#5B6577"
text.tertiary:        "#8A93A3"
surface.page:         "#F4F7FA"   # nền trang xám lạnh
surface.card:         "#FFFFFF"
surface.sheet:        "#FFFFFF"
divider:              "#E6EAF0"
outline.dashed:       "#C9D1DC"
overlay.map-pill:     "#0E1A2B" @ 78%
scrim:                "#000000" @ 40%

# Neutral (dark — v1.0 hỗ trợ luôn, chi phí thấp)
dark.surface.page:    "#0B1220"
dark.surface.card:    "#151E2E"
dark.text.primary:    "#EEF2F7"
dark.text.secondary:  "#A7B0BF"
dark.divider:         "#243044"
```

Quy tắc:
- Màu mode chỉ dùng cho: CTA chính, hình học trên map, segment đang chọn, type chip. Không dùng màu mode cho text dài.
- Không gradient, trừ overlay tối trên ảnh hero (linear đen 0% → 55%, từ phải sang trái).
- Tương phản text ≥ 4.5:1 (WCAG AA). Trắng trên `area.main` đạt ~4.6 ở 16sp bold.

### 1.2 Typography

Font: **Inter** (fallback Roboto / SF). Chữ số dùng `fontFeatures: tabular-nums` cho số đo & đồng hồ.

| Token | Size / Line | Weight | Dùng cho |
|---|---|---|---|
| `display.result` | 32 / 38 | 700 | Số chính trong sheet ("12,450 m²") |
| `display.hero` | 26 / 32 | 700 | "Start Measuring" |
| `title.screen` | 20 / 28 | 700 | Tiêu đề app bar |
| `title.section` | 16 / 22 | 600 | "Recent Measurements", "Site Photos (2)" |
| `body.lg` | 16 / 24 | 500 | Tên item, CTA |
| `body.md` | 14 / 20 | 400 | Nội dung |
| `result.secondary` | 16 / 22 | 400, text.secondary | "1.25 ha", "0.46 km" |
| `label.caps` | 12 / 16 | 600, letter-spacing 0.6 | "AREA", "PERIMETER", chip type |
| `caption` | 12 / 16 | 400 | Ngày giờ, helper |
| `timer` | 28 / 34 | 700 tabular | "00:12:36" |

### 1.3 Spacing, radius, elevation

```yaml
spacing: [4, 8, 12, 16, 20, 24, 32, 40]   # lưới 4dp
page.padding.h: 16
radius.xs: 8     # chip, thumbnail nhỏ
radius.sm: 12    # thumbnail ảnh, text field
radius.md: 16    # card, list item, CTA
radius.lg: 24    # bottom sheet top, hero card
radius.full: 999 # floating button, pill
elevation.card:   0 1 3 rgba(14,26,43,0.06), 0 1 2 rgba(14,26,43,0.04)
elevation.float:  0 4 12 rgba(14,26,43,0.16)   # nút tròn trên map
elevation.sheet:  0 -4 24 rgba(14,26,43,0.10)
touch.min: 48
```

### 1.4 Icon

Material Symbols **Rounded**, weight 500, size 24 (nút map 22). Icon đặc thù:
- Area: `pentagon` / custom polygon có chấm ở đỉnh
- Distance: `timeline` (các chấm nối)
- Walk: `directions_walk`
- Layers `layers`, My location `my_location`, Search `search`, Camera `photo_camera`, Undo `undo`, Add point `add_location_alt`, Close shape `hexagon` (hoặc `check_circle`), GPS point `gps_fixed`.

### 1.5 Motion

- Thời lượng: 150ms (nhấn), 250ms (sheet, chuyển segment), 350ms (chuyển màn).
- Easing: `Curves.easeOutCubic` (vào), `easeInCubic` (ra).
- Số đo thay đổi: animate đếm số 200ms (`TweenAnimationBuilder`) — tạo cảm giác "sống".
- Add point: marker scale 0 → 1.15 → 1 (spring) + haptic `lightImpact`.
- Walk đang ghi: chấm đỏ nhấp nháy cạnh "Recording" (opacity 1 → 0.3, 1s loop).
- Tôn trọng "Reduce motion" của hệ thống.

---

## 2. Components

### 2.1 `ModeSegmentedSelector`
- Container: nền trắng 16% opacity + blur (trên ảnh hero), radius 16, padding 4, cao 64.
- Segment: icon 24 trên + label 2 dòng 12sp (mockup) → đề xuất **1 dòng** "Area / Distance / Walk", icon bên trái, cao 56.
- Selected: nền trắng đặc, icon + label màu mode, animate trượt nền (AnimatedAlign 250ms).
- Unselected: icon + label trắng 85%.

### 2.2 `PrimaryCta`
- Cao 56, radius 16, full width, text `body.lg` 600 trắng, icon mũi tên/tròn bên trái (như mockup), chevron phải tuỳ chọn.
- Biến thể: `area` / `distance` / `walk` / `danger` / `tonalDanger` (Pause: nền `danger.container`, chữ `danger.main`).
- Disabled: nền `#D5DBE3`, chữ `#8A93A3` (VD: Save khi Area < 3 điểm).
- Loading: spinner trắng 20dp thay icon.

### 2.3 `MapFab` (nút tròn trên bản đồ)
- 48×48, nền trắng, icon navy, `elevation.float`. Cột dọc cách mép phải 12, khoảng cách 12.
- Trạng thái active (VD: auto-follow đang bật): icon màu mode.
- Camera FAB tách riêng ở dưới cột, 56×56 (như mockup).

### 2.4 `MapResultPill`
- Nền `overlay.map-pill`, radius 14, padding 12×8. Dòng 1: 20sp 700 trắng; dòng 2: 13sp trắng 80%.
- Đặt tại centroid polygon (Area) / điểm giữa tuyến (Distance). Render thành marker bitmap.

### 2.5 `PointHandle` (marker điểm)
- Tròn trắng 18dp, viền 3dp màu mode, bóng nhẹ. Điểm đang chọn: 24dp, viền 4dp + vòng halo 30% màu mode.
- Distance: Start = tròn xanh lá 22dp viền trắng; End = pin đỏ (như mockup).
- Có ảnh gắn: badge tròn 12dp 📷 góc trên phải.
- Walk hiện tại: tròn xanh dương 20dp viền trắng + halo accuracy (bán kính = accuracy mét, 15% xanh dương).

### 2.6 `EdgeLengthLabel`
- Chip nhỏ nền trắng 90%, text 11sp 600, đặt ở giữa mỗi cạnh. Ẩn khi zoom < 15 hoặc cạnh ngắn hơn 40px trên màn.

### 2.7 `CenterCrosshair`
- Dấu "+" 32dp màu trắng viền đen 1dp (đọc được trên mọi ảnh vệ tinh) + chấm 4dp tâm. Khi map đang di chuyển: phóng 1.1.
- Chỉ hiện ở chế độ nhập "Crosshair" (mặc định).

### 2.8 `MeasureToolbar` (Area/Distance)
- Thanh ngang nổi phía trên sheet, nền trắng, radius full, cao 52, 3–4 nút:
  `[↶ Undo]  [ ＋ Add Point ]  [⬡ Close]` — nút giữa là pill đặc màu mode, rộng hơn.
  Distance: `[↶ Undo] [＋ Add Point] [⟲ Reset]`.
- Nút phụ bên trái nút giữa: `📍` "Add at my location" (icon-only, tooltip).
- Disabled: Undo khi 0 điểm, Close khi < 3 điểm hoặc đã đóng.

### 2.9 `ResultSheet` (DraggableScrollableSheet)
- Snap: 0.22 (thu gọn — chỉ số liệu), 0.45 (mặc định — số liệu + ảnh + CTA), 0.9 (đầy đủ — thêm note, đơn vị, danh sách điểm/đoạn).
- Drag handle 36×4 `divider`, radius top 24.
- Hàng số liệu: 2–3 cột, label caps + số `display.result` (co về 26 khi 3 cột) + phụ `result.secondary`, đường kẻ dọc 1dp giữa cột.
- CTA ghim đáy (không cuộn theo), padding safe area.

### 2.10 `UnitChips`
- Horizontal scroll chip: `m² · ha · acre · ft²`. Chip chọn: nền `mode.container`, chữ màu mode.

### 2.11 `PhotoStrip`
- Header: "Site Photos (n)" + "See All ›".
- Thumbnail 96×96 (mockup ~96×90), radius 12, nút ✕ tròn đen 22dp góc trên phải (chỉ khi editable).
- Ô Add Photo: cùng kích thước, viền đứt nét 1.5dp `outline.dashed`, icon camera + "Add Photo" 12sp.
- Ảnh gắn điểm: nhãn nhỏ "P3" góc dưới trái.

### 2.12 `MeasurementListTile`
- Card trắng radius 16, padding 12, cao ~84. Thumbnail 64×64 radius 12 (vệ tinh + hình học).
- Cột text: tên (`body.lg` 600) · giá trị chính (`body.md` 500, text.secondary) · "Sep 22, 2026 · Area" (`caption`).
- Saved list: thêm `TypeChip` (AREA/DISTANCE/WALK, label caps 10sp, nền container màu mode).
- Nút ⋯ bên phải: icon như nút 40×40, vùng chạm 48×48 (`touch.min`, sát mép phải card).

### 2.13 `DraftBanner` (Continue Measurement)
- Card viền trái 4dp màu mode, icon mode, "Untitled Area · 6 points · Draft", "Last edited 14 min ago", 2 nút text: **Resume** (màu mode) · Discard (text.secondary).

### 2.14 Dialog, BottomSheet chọn, Snackbar
- Dialog M3 radius 24, title 20/700, message 14 text.secondary, nút phải: secondary text, primary filled. Nút destructive đỏ.
- Action sheet (Add Photo, Export): bottom sheet radius 24, list item 56 cao có icon.
- Snackbar nổi, radius 12, có "Undo" cho xoá ảnh trong phiên đo.

### 2.15 `StatusBanner` (trên bản đồ)
- Pill full width - 32, nền trắng, icon trái, 1–2 dòng: GPS Ready (xanh), Low accuracy (vàng `#F2A900` icon), Location off (đỏ + nút "Open Settings"), Offline map (xám).

---

## 3. Layout & navigation

- Bottom nav M3: cao 72, 3 item, indicator pill màu `area.container`, icon active `brand.primary`. Label luôn hiện.
- Màn đo: full-screen, status bar trong suốt trên map, app bar trắng 56 (như mockup) hoặc app bar nổi trong suốt — **chọn app bar trắng** như mockup cho dễ đọc.
- Safe area: sheet + CTA chừa gesture bar.
- Tablet/iPad: sheet thành side panel 380dp bên phải khi width ≥ 700.

---

## 4. Localization & format

- Số theo locale: `12,450 m²` (en) / `12.450 m²` (vi). Dùng `NumberFormat.decimalPattern(locale)`.
- Ngày: `Sep 22, 2026 · 10:24` (en) / `22/09/2026 · 10:24` (vi).
- Chuỗi dài hơn ~30% (tiếng Việt, Đức) → không cố định chiều rộng nút; label segment tối đa 1 dòng, auto-shrink đến 11sp.

---

## 5. Spec từng màn hình

### 5.1 Home

```
┌─────────────────────────────────┐
│ 📍 LandMeasure                   │  header 56, logo 28
├─────────────────────────────────┤
│ ┌─────────────────────────────┐ │
│ │ [ảnh vệ tinh + polygon]     │ │  Hero card h≈260, radius 24
│ │ Start Measuring              │ │
│ │ Choose a method to measure…  │ │
│ │ ┌───────┬──────────┬──────┐ │ │
│ │ │▣ Area │ ⋰Distance│🚶Walk│ │ │  selector
│ │ └───────┴──────────┴──────┘ │ │
│ │ [ ➜  Start Area Survey   › ] │ │  CTA màu mode
│ └─────────────────────────────┘ │
│ ┌ Continue Measurement ───────┐ │  (chỉ khi có draft)
│ │ ▌Untitled Area · 6 pts      │ │
│ │  14 min ago    Discard Resume│ │
│ └─────────────────────────────┘ │
│ Recent Measurements      See All›│
│ [thumb] My Farm        ⋯        │
│         2.48 ha                  │
│         Sep 22, 2026 · Area      │
│ …×3                              │
├─────────────────────────────────┤
│  🏠 Home   🔖 Saved   ⚙ Setting │
│ [Banner collapsible]             │  free user, từ lần mở app thứ 2
└─────────────────────────────────┘
```
- Ảnh hero thay đổi nhẹ theo mode (polygon xanh / tuyến xanh dương / track cam) — crossfade 250ms. 3 ảnh asset tĩnh. *Hiện tại (Phase 6)*: hình vẽ ruộng/đường + hình học ở góc phải trên (`HeroBackdropPainter`, token `hero*`) cho tới khi có ảnh bản quyền.
- Empty recent: 1 dòng icon + "No recent measurements" + caption, cao ≤ 96.
- Banner collapsible nằm dưới cùng màn main, **dưới** bottom nav (cả 3 tab đều thấy, không riêng Home). Không load trong lần mở app đầu tiên (splash → language → intro → Home), từ lần mở thứ 2 mới load.

### 5.2 Measure Area

```
┌ ← Measure Area            ? ⋮ ┐
│ ┌ GPS/hint banner ───────────┐ │
│ │ Add points around boundary │ │
│ └────────────────────────────┘ │
│        [bản đồ vệ tinh]   (◎)  │ Layers
│      ●───────●            (⌖)  │ My location
│     ╱ 12,450m² ╲          (🔍) │ Search
│    ●  1.25 ha   ●              │
│     ╲    +     ╱               │ crosshair tâm
│      ●───────●           (📷)  │
│  ( ↶ ) (📍) [ ＋ Add Point ] (⬡)│ toolbar
├──────────── ▬ ─────────────────┤
│ AREA          │ PERIMETER       │
│ 12,450 m²     │ 462.8 m         │
│ 1.25 ha       │ 0.46 km         │
│ [m²][ha][acre][ft²]            │ (snap 0.9 mới hiện)
│ Site Photos (2)        See All ›│
│ [img✕][img✕][⊕ Add Photo]       │
│ [    Save Measurement    ]      │
└─────────────────────────────────┘
```
- Overflow ⋮: Reset, Input mode (Crosshair / Tap on map), Hide edge labels.
- Chế độ Tap: chạm vào nhãn độ dài cạnh = chèn một điểm vào giữa cạnh đó (nhãn nằm đè lên bản đồ nên không để nó "nuốt" mất lần chạm).
- Chọn điểm (tap marker): điểm to lên, xuất hiện mini-toolbar nổi cạnh điểm: `🗑 Delete · 📷 Photo · ✎ Note(v1.1)`. *Thực tế*: thanh cố định trên toolbar "Điểm 3 · 📷 · 🗑 Xoá điểm · Xong" (📷 chỉ icon, thanh tự co khi chật).
- < 3 điểm: số liệu hiển thị "—" + caption "Add at least 3 points to calculate area". Save disabled.
- Polygon tự cắt: viền đổi đứt nét vàng + banner "Edges cross — area may be incorrect".
- Help `?` → bottom sheet 3 bước minh hoạ.

### 5.3 Measure Distance
Như Area, khác:
- Polyline xanh dương 5dp, Start xanh lá, End pin đỏ, điểm giữa trắng viền xanh dương.
- Pill "860 m" ở trung điểm tuyến (nổi phía trên đường để không che điểm), nhãn từng đoạn trên mỗi đoạn.
- Toolbar: Undo · 📍 · Add Point · Reset.
- Sheet: DISTANCE `860 m` / `0.86 km`, "3 segments"; snap 0.9: danh sách "A → B 210 m"…
- CTA: **Save Route** (xanh dương).

### 5.4 Walk & Measure — Ready
- Map follow user, halo accuracy.
- Banner: `● GPS Ready · Accuracy ±4 m` (xanh) / Searching… (xám, spinner) / Low (vàng).
- Sheet thu gọn: helper "Walk around the boundary to record your path." + icon minh hoạ.
- CTA: **Start Walking** cam, disabled khi chưa có fix hoặc location off.
- Toggle nhỏ: "Keep screen on" (đọc từ setting, cho đổi nhanh).

### 5.5 Walk & Measure — Recording / Paused
- Banner trên: `● Recording GPS…` chấm đỏ nhấp nháy · `±5 m`. Paused: `❚❚ Paused` nền vàng nhạt.
- Track cam 5dp, các đoạn tách (segment) không nối nhau; khi gần khép (khoảng cách tới Start < ngưỡng) → vòng tròn quanh Start sáng lên + hint "Close to start — finish to calculate area".
- Sheet 3 cột: DURATION `00:12:36` · DISTANCE `860 m` · AREA `2.31 ha` (hoặc "—" nếu chưa đủ).
- Captured Photos (n).
- Bottom: `[❚❚ Pause]` tonalDanger + `[■ Finish]` danger (như mockup). Paused: `[▶ Resume]` cam.
- Finish → dialog xác nhận nhẹ "Finish recording?" (tránh bấm nhầm) → màn kết quả = sheet mở 0.9 với CTA "Save Measurement".
- Pan map → tắt follow, FAB ⌖ đổi màu cam "Recenter".
- Back khi đang **ghi**: không thoát (tránh bấm nhầm làm dừng phép đo) — snackbar "Recording in progress. Pause or finish before leaving." + nút **Pause & leave**. Khi Paused/Finished: back thoát ngay như Area/Distance. Rời màn Walk luôn tạm dừng + tắt GPS.

### 5.6 Save Measurement (bottom sheet toàn màn, 0.95)
- Header: "Save Measurement", ✕.
- Mini map thumbnail 16:9 radius 16.
- Name field (prefill "Area · Sep 28" — đổi được), counter 0/80, lỗi "Name is required".
- Type (read-only chip) + Result card (số liệu).
- Land value (tuỳ chọn, đề xuất VN): "Unit price" + dropdown đơn vị → "Estimated value ≈ 1.87 tỷ". Chỉ hiện khi có diện tích; dropdown nhãn "Per / Tính theo", mục là ký hiệu đơn vị; tiền tệ theo vùng máy (hậu tố trong ô).
- Notes (multiline, counter /2000).
- Photos strip.
- CTA ghim đáy: **Save** (màu mode) + text "Cancel".

### 5.7 Saved Measurements
- Header: logo + "Saved Measurements" + 🔍 (tap → search field thay header, autofocus, nút ✕).
- Chips: `All (14)` `Area (8)` `Distance (4)` `Walk (2)` — chỉ đếm bản đã lưu; chip cũng lọc mục Drafts. Khi đang tìm kiếm, ẩn mục Drafts.
- Thẻ nháp: dòng phụ chỉ ghi số điểm (chip "DRAFT" / "FINISHED · NOT SAVED" đã chiếm chỗ); chạm thẻ nháp = Resume.
- Section "Drafts (2)" (thu gọn được) nằm trên, card nền `surface.page` viền đứt nét + chip "DRAFT".
- List `MeasurementListTile` + TypeChip. Không có quảng cáo trong tab này (native ad nằm ở màn Detail).
- Menu ⋯: Rename · Export · Delete (đỏ).
- Empty: minh hoạ polygon nét đứt + "No measurements yet" + mô tả + CTA "Start Measuring".
- No results: "No measurements found."

### 5.8 Measurement Detail
- App bar: ← · "Measurement Detail" · ⋮ (Rename, Delete).
- Map preview 16:10 (ảnh snapshot; tap → full map read-only có Layers).
- Tên 22/700 + TypeChip + ngày.
- Native ad (free user, cỡ medium; chỉ hiện khi đã tải xong) ngay dưới phần tên, trên kết quả.
- Result card: grid 2 cột (Area: Area, Perimeter, Points, [Value]; Distance: Distance, Points, Segments; Walk: Distance, Duration, Area, Avg pace). [Value] = "1,87 tỷ" + dòng phụ "50 triệu / ha"; dưới chip đơn vị có mục "Land value" (Add / Edit → sheet có Save / Remove).
- Export sheet: 2 mục 64dp "KML — Google Earth" / "CSV — Excel" kèm mô tả; đang tạo file → spinner + "Preparing file…"; xong → share sheet hệ thống.
- Unit chips ngay dưới result (đổi hiển thị, không lưu geometry).
- Site Photos, Notes ("Add notes" nếu trống).
- Action bar đáy 3 nút: `✎ Edit` (outlined) · `⇪ Export` (outlined) · `🗑` (icon đỏ).

### 5.9 Edit Measurement
- Area/Distance: màn map giống màn đo (dữ liệu nạp sẵn), app bar "Edit Measurement", CTA **Save Changes**; tab thứ 2 trong sheet "Details" (name, notes, photos).
- Walk: chỉ form Details.
- Tab trong sheet là `SegmentedButton` [Kết quả | Thông tin]; "Lưu thay đổi" chỉ bật khi có thay đổi và tên hợp lệ. Area đã khép: menu ⋮ "Mở lại hình" để thêm điểm. Xoá ảnh trong Edit = ẩn + "Hoàn tác", áp dụng khi lưu.
- Rời màn khi có thay đổi → "Discard changes?" (Keep editing / Discard).

### 5.10 Setting
Như spec: header logo + "Setting" + subtitle. 3 section card (radius 16, list item 64 cao, icon tròn 36 nền container):
1. **Measurement Preferences**: Units ›, Map Style ›, Language ›
2. **Measurement & Map**: Default Measurement Type ›, GPS Accuracy Display [toggle], Auto Center Map [toggle], Save Photos to Measurement [toggle], Keep Screen Awake [toggle]
0. **Premium** (đầu trang, ngay dưới header): card nền `area.container` viền brand (không gradient — §1.1) "LandMeasure Premium — No ads, unlimited saves and photos, KML any time" → Paywall; nếu đã premium: "Premium active · Manage subscription" (trọn đời: "Premium active · Lifetime", không có mục quản lý).
4. **Support & Legal**: Help & Feedback, Rate Us, Privacy Policy, Terms, Privacy choices (UMP — chỉ hiện khi cần).
- Footer: logo, "LandMeasure", "Version 1.0.0 (build)".

### 5.11 Units / 5.12 Map Style / 5.13 Language
- Units: 2 nhóm radio (Distance, Area) + toggle "Show secondary unit". Chỉ dùng đơn vị quốc tế (không có sào/mẫu/công).
- Map Style: grid 2×2 card preview 1:1 ảnh, chọn có viền 2dp brand + check; CTA **Apply**. *Hiện tại*: ảnh xem trước vẽ bằng code (`MapStylePreviewPainter`, token `map*`) tới khi có 4 ảnh thật.
- Language: list radio, tên bản ngữ (Tiếng Việt, English, Español, Português, हिन्दी, Bahasa Indonesia, 中文).

### 5.14 Photo Viewer
- Nền đen, PageView, pinch-zoom, top: ← · "1 / 4"; bottom: ngày chụp · "Point 3" (nếu gắn) · 🗑 · ⇪ Share.

### 5.15 Paywall
- Ảnh vệ tinh mờ trên cùng + ✕ góc (hiện sau 2s).
- Title "Measure without limits", 4 bullet ✓ (No ads, Unlimited saves & photos, KML/KMZ/GPX export, PDF reports).
- 3 plan card dọc: Yearly (badge "Best value · 3-day free trial", mặc định chọn), Lifetime, Monthly. Hiển thị giá/tháng quy đổi.
- CTA "Start free trial" / "Continue". Link: Restore · Terms · Privacy. Ghi rõ gia hạn tự động.
- *Hiện tại (Phase 11)*: ảnh trên cùng dùng hình vẽ hero (`HeroBackdropPainter`) + lớp tối từ trên xuống. Bullet chỉ liệt kê **tính năng đã có**: No ads, Unlimited saves, Unlimited photos, KML any time (PDF/KMZ/GPX là v1.1 — thêm vào khi xong, tránh "paywall lừa"). Gói năm: badge "Best value · {n}-day free trial" (chỉ khi store còn cho dùng thử) + "{giá}/month · Save N%". Điều khoản gia hạn ngay trên CTA. ✕ hiện sau 2 s, nút Back hệ thống luôn đóng được. Không tải được gói → thẻ "Chưa tải được các gói" + Thử lại.

- Paywall 2 gói: badge "Most popular" ở gói tháng; gói có dùng thử hiện dòng "{n}-day free trial" rồi giá năm (không có giá/tuần).
- **Premium First** (`/paywall-first`, màn đầu tiên của lần mở thứ 2): cùng trang với Paywall nhưng bỏ chọn gói; chỉ gói năm. ✕ ẩn cho tới 10 s hoặc khi bấm CTA. CTA "Start free trial", dưới là "{n}-day free trial, then {giá}/year" rồi "Cancel anytime". Gói năm không còn dùng thử → CTA "Continue" + "{giá}/year".

### 5.16 Permission & state screens
- **Location permission (pre-prompt)**: bottom sheet, minh hoạ pin trên bản đồ, title "Allow Location Access", mô tả, CTA "Continue", text "Not now".
- **Camera permission**: tương tự, minh hoạ camera.
- **Denied vĩnh viễn**: "Open Settings".
- **Notification permission (Android 13+/iOS)**: hỏi khi bấm Start Walking lần đầu: "Allow notifications so you can see recording status".
- **Low GPS accuracy**: StatusBanner vàng.
- **GPS disabled**: StatusBanner đỏ + CTA, Start Walking disabled.
- **No internet**: banner xám "Map connection unavailable — your points are safe".
- **Battery optimization (Android OEM)**: sheet 1 lần khi Start Walking lần đầu trên Xiaomi/Oppo/Vivo/Huawei/Samsung: "Allow LandMeasure to run in background".

### 5.17 Dialogs (copy)
| Dialog | Title | Message | Actions |
|---|---|---|---|
| Reset | Reset measurement? | This will remove all points. | Cancel · **Reset** (đỏ) |
| Leave | *(không có dialog — chốt 2026-09-28)* | Snackbar sau khi thoát: "Draft saved · Area · 6 points" | **Discard** (xoá draft) |
| Discard draft | Discard this draft? | All points and unsaved changes will be removed. | Cancel · **Discard** (đỏ) |
| Delete | Delete measurement? | This measurement, its photos and notes will be permanently deleted. | Cancel · **Delete** (đỏ) |
| Finish walk | Finish recording? | GPS tracking will stop. | Keep recording · **Finish** |
| Back khi Walk đang ghi | *(không có dialog — snackbar)* | "Recording in progress. Pause or finish before leaving." | **Pause & leave** |
| Rename | Rename Measurement | [field] | Cancel · **Save** |

### 5.18 Help content (`MeasureHelpSheet`)

Mở từ nút `?` trên app bar màn đo. Bottom sheet radius 24, gồm: tiêu đề, 3 bước đánh số (icon tròn 32dp nền `mode.container`, số màu mode), đoạn Photo tip, dòng disclaimer độ chính xác (caption, `text.secondary`), nút **Got it** (PrimaryCta màu mode). Hiện tự động **1 lần** ở lần đầu mở mỗi chế độ (pref `help_seen_<mode>`).

**Câu tóm tắt (dùng cả làm hint banner khi chưa có điểm):**

| Key ARB | en | vi |
|---|---|---|
| `helpAreaSummary` | Add points around the boundary of your land. | Thêm các điểm quanh ranh giới mảnh đất của bạn. |
| `helpDistanceSummary` | Add points along the route you want to measure. | Thêm các điểm dọc theo tuyến đường bạn muốn đo. |
| `helpWalkSummary` | Walk around the boundary while LandMeasure records your GPS path. | Đi bộ quanh ranh giới, LandMeasure sẽ ghi lại đường đi GPS của bạn. |
| `helpPhotoTip` | Use photos to document landmarks, boundaries, or site conditions. | Chụp ảnh để ghi lại cột mốc, ranh giới hoặc hiện trạng khu đất. |
| `helpAccuracyNote` | GPS and map measurement accuracy may vary depending on device, map imagery, and environment. | Độ chính xác của GPS và bản đồ có thể khác nhau tùy thiết bị, ảnh bản đồ và môi trường. |

**3 bước theo chế độ:**

| Chế độ | Bước 1 | Bước 2 | Bước 3 |
|---|---|---|---|
| Area — en | Move the map so the crosshair sits on a corner, then tap **Add Point**. | Add at least 3 points around the boundary. Drag a point to adjust it. | Tap **Close** to finish the shape, then **Save Measurement**. |
| Area — vi | Kéo bản đồ để tâm ngắm nằm đúng góc đất, rồi bấm **Thêm điểm**. | Thêm ít nhất 3 điểm quanh ranh giới. Kéo điểm để chỉnh vị trí. | Bấm **Khép hình** để hoàn tất, rồi **Lưu phép đo**. |
| Distance — en | Place the crosshair on the start of your route and tap **Add Point**. | Keep adding points along the route. Each segment length is shown on the map. | Tap **Save Route** when you're done. |
| Distance — vi | Đặt tâm ngắm tại điểm bắt đầu và bấm **Thêm điểm**. | Tiếp tục thêm điểm dọc tuyến đường. Độ dài từng đoạn hiện trên bản đồ. | Bấm **Lưu tuyến đường** khi xong. |
| Walk — en | Wait for **GPS Ready**, then tap **Start Walking**. | Walk along the boundary. Use **Pause** if you need to stop. | Return to your starting point and tap **Finish** to calculate the area. |
| Walk — vi | Chờ **GPS sẵn sàng**, rồi bấm **Bắt đầu đi**. | Đi dọc theo ranh giới. Bấm **Tạm dừng** nếu cần nghỉ. | Quay về điểm xuất phát và bấm **Kết thúc** để tính diện tích. |

Mẹo phụ (chỉ hiện ở Area/Distance, 1 dòng dưới bước 3):
- en: "Tip: tap 📍 to add a point at your current GPS location."
- vi: "Mẹo: bấm 📍 để thêm điểm tại vị trí GPS hiện tại của bạn."

Mẹo phụ Walk:
- en: "Tip: stay in open areas for better GPS accuracy."
- vi: "Mẹo: đứng ở nơi thoáng để GPS chính xác hơn."

---

## 6. Asset checklist

- Logo: pin xanh lá chứa polygon trắng (như mockup). App icon adaptive Android (foreground + nền `#0F8A5F`), iOS 1024.
- 3 ảnh hero vệ tinh (bản quyền tự do: tự chụp màn hình từ nguồn cho phép hoặc ảnh drone có license) + overlay hình học vẽ bằng code.
- 4 ảnh preview Map Style.
- Minh hoạ empty state (SVG tối giản, nét đứt).
- Splash: nền `#0F8A5F`, logo trắng.
- Store screenshots: 6 khung, dùng chính các màn Home / Area / Distance / Walk / Detail / Export PDF, caption lớn phía trên.

---

## 7. Flutter implementation notes

- `ThemeData(useMaterial3: true)` + `ThemeExtension<LmColors>` chứa màu mode; `ModeColors.of(MeasurementType)` trả main/container/fill.
- Tokens đặt ở `lib/core/theme/`: `lm_colors.dart`, `lm_typography.dart`, `lm_spacing.dart`, `lm_radius.dart`, `lm_shadows.dart`.
- Font Inter bundle trong `assets/fonts` (không dùng `google_fonts` runtime để chạy offline).
- Marker bitmap: `MarkerFactory` render widget → `BitmapDescriptor.bytes`, cache theo key (type, selected, hasPhoto, devicePixelRatio).
- Kiểm thử golden cho: ModeSegmentedSelector, ResultSheet, MeasurementListTile, PhotoStrip, dialogs — light & dark, en & vi.
