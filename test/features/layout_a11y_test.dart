import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';
import 'package:gps_measurement/domain/models/measurement_summary.dart';
import 'package:gps_measurement/domain/models/photo.dart';
import 'package:gps_measurement/features/detail/detail_controller.dart';
import 'package:gps_measurement/features/detail/detail_screen.dart';
import 'package:gps_measurement/features/export/export_sheet.dart';
import 'package:gps_measurement/features/home/home_controller.dart';
import 'package:gps_measurement/features/home/home_screen.dart';
import 'package:gps_measurement/features/measure/area/area_result_panel.dart';
import 'package:gps_measurement/features/measure/common/measure_toolbar.dart';
import 'package:gps_measurement/features/measure/common/photo_strip.dart';
import 'package:gps_measurement/features/measure/walk/walk_result_panel.dart';
import 'package:gps_measurement/features/premium/paywall_screen.dart';
import 'package:gps_measurement/features/saved/saved_controller.dart';
import 'package:gps_measurement/features/saved/saved_screen.dart';
import 'package:gps_measurement/features/settings/language_screen.dart';
import 'package:gps_measurement/features/settings/map_style_screen.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:gps_measurement/features/settings/settings_screen.dart';
import 'package:gps_measurement/features/settings/units_screen.dart';
import 'package:gps_measurement/l10n/gen/app_localizations.dart';
import 'package:gps_measurement/services/purchases/purchase_service.dart';
import 'package:gps_measurement/services/support/support_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/data.dart';
import '../helpers/fakes.dart';
import '../helpers/golden.dart';

// P9-06 / P9-08: every app language at text scale 1.3 on a 360 dp phone
// lays out without overflow, and the main screens meet the tap-target and
// label guidelines.

final DateTime now = DateTime.utc(2026, 9, 28, 10);

MeasurementSummary summary(
  String id, {
  MeasurementType type = MeasurementType.area,
  MeasurementStatus status = MeasurementStatus.saved,
  String? name,
  double? areaM2,
  double? distanceM,
}) => MeasurementSummary(
  id: id,
  type: type,
  status: status,
  name: name,
  areaM2: areaM2,
  distanceM: distanceM,
  pointCount: 12,
  updatedAt: now.subtract(const Duration(hours: 3)),
  savedAt: status == MeasurementStatus.saved ? now : null,
);

final Measurement walk = Measurement(
  id: 'w1',
  name: 'Ruộng nhà ông Bảy — bờ kênh phía đông',
  type: MeasurementType.walk,
  status: MeasurementStatus.saved,
  mapStyle: MapStyle.satellite,
  createdAt: now,
  updatedAt: now,
  savedAt: now,
  notes: 'East side along the canal',
  stats: const MeasurementStats(
    distanceM: 12345.6,
    durationSec: 7265,
    areaM2: 1234567,
    isClosed: true,
    pointCount: 900,
    segmentCount: 3,
  ),
);

Photo photo(String id, {String? pointId}) => Photo(
  id: id,
  measurementId: 'w1',
  pointId: pointId,
  filePath: 'photos/w1/$id.jpg',
  thumbPath: 'photos/w1/${id}_t.jpg',
  takenAt: now,
  source: PhotoSource.camera,
  width: 2048,
  height: 1536,
  bytes: 500000,
  sortIndex: 0,
);

class _FixedDetail extends DetailController {
  @override
  Stream<Measurement?> build(String measurementId) => Stream.value(walk);
}

typedef ScreenCase = ({String name, Widget Function() build});

void main() {
  late SharedPreferences prefs;
  late TempDirectories dirs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    dirs = TempDirectories();
  });
  tearDown(() => dirs.dispose());

  final saved = [
    summary('s1', name: 'Đất vườn nhà bác Tư Long An', areaM2: 1234567),
    summary(
      's2',
      type: MeasurementType.distance,
      name: 'Road to the river and back again',
      distanceM: 123456,
    ),
  ];
  final drafts = [
    summary(
      'd1',
      type: MeasurementType.walk,
      status: MeasurementStatus.completed,
      distanceM: 300,
    ),
  ];

  List<Override> overrides() => [
    sharedPreferencesProvider.overrideWithValue(prefs),
    deviceLocaleProvider.overrideWithValue(const Locale('vi', 'VN')),
    clockProvider.overrideWithValue(FixedClock(now)),
    appDirectoriesProvider.overrideWithValue(dirs.dirs),
    supportServiceProvider.overrideWithValue(FakeSupport()),
    purchaseServiceProvider.overrideWithValue(
      FakePurchaseService(offers: testOffers),
    ),
    supportLinksProvider.overrideWithValue((
      supportEmail: 'help@example.com',
      privacyPolicyUrl: 'https://example.com/privacy',
      termsUrl: 'https://example.com/terms',
      appStoreId: '',
    )),
    draftListProvider.overrideWith((_) => Stream.value(drafts)),
    recentListProvider.overrideWith((_) => Stream.value(saved)),
    savedListProvider.overrideWith((_) => Stream.value(saved)),
    savedCountsProvider.overrideWith(
      (_) => Stream.value({
        MeasurementType.area: 1,
        MeasurementType.distance: 1,
      }),
    ),
    detailControllerProvider('w1').overrideWith(_FixedDetail.new),
  ];

  final screens = <ScreenCase>[
    (name: 'Settings', build: () => const SettingsScreen()),
    (name: 'Paywall', build: () => const PaywallScreen(source: 'test')),
    (
      name: 'Export sheet',
      build: () => ExportSheet(
        measurementId: 'w1',
        fallbackName: 'x',
        onResult: (_) {},
      ),
    ),
    (name: 'Units', build: () => const UnitsScreen()),
    (name: 'Language', build: () => const LanguageScreen()),
    (name: 'Map Style', build: () => const MapStyleScreen()),
    (name: 'Home', build: () => const HomeScreen()),
    (name: 'Saved', build: () => const SavedScreen()),
    (name: 'Detail', build: () => const DetailScreen(measurementId: 'w1')),
    (
      name: 'Area result + toolbar',
      build: () => Column(
        children: [
          MeasureToolbar(
            type: MeasurementType.area,
            onUndo: () {},
            onAddAtMyLocation: () {},
            onAddPoint: () {},
            onTrailing: () {},
          ),
          AreaResultPanel(
            stats: const MeasurementStats(
              areaM2: 1234567,
              perimeterM: 12345,
              pointCount: 24,
              isClosed: true,
            ),
            areaUnit: AreaUnit.squareMeter,
            distanceUnit: DistanceUnit.meter,
            onAreaUnitChanged: (_) {},
          ),
        ],
      ),
    ),
    (
      name: 'Photo strip',
      build: () => PhotoStrip(
        photos: [
          photo('a', pointId: 'p3'),
          photo('b'),
        ],
        resolve: (rel) => File('missing/$rel'), // → placeholder
        pointNumbers: const {'p3': 3},
        onAdd: () {},
        onRemove: (_) {},
        onOpen: (_) {},
      ),
    ),
    (
      name: 'Walk result',
      build: () => WalkResultPanel(
        stats: walk.stats,
        elapsedSec: 7265,
        runState: WalkRunState.recording,
        areaUnit: AreaUnit.hectare,
        distanceUnit: DistanceUnit.kilometer,
        onAreaUnitChanged: (_) {},
        onDistanceUnitChanged: (_) {},
      ),
    ),
  ];

  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    required Locale locale,
    double textScale = 1,
    Size size = const Size(360, 780),
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides(),
        child: testApp(child: child, locale: locale, textScale: textScale),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
  }

  group('no overflow at text scale 1.3 on 360 dp', () {
    for (final locale in AppLocalizations.supportedLocales) {
      for (final screen in screens) {
        testWidgets('${locale.languageCode} · ${screen.name}', (tester) async {
          await pump(tester, screen.build(), locale: locale, textScale: 1.3);
          expect(tester.takeException(), isNull);
        });
      }
    }
  });

  group('accessibility guidelines', () {
    for (final screen in screens) {
      testWidgets(screen.name, (tester) async {
        final semantics = tester.ensureSemantics();
        await pump(
          tester,
          screen.build(),
          locale: const Locale('en'),
          size: const Size(400, 900),
        );
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        semantics.dispose();
      });
    }
  });
}
