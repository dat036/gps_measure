import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/format/measurement_value.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/l10n/measurement_labels.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';
import 'package:gps_measurement/domain/models/measurement_summary.dart';
import 'package:gps_measurement/features/detail/detail_controller.dart';
import 'package:gps_measurement/features/detail/detail_screen.dart';
import 'package:gps_measurement/features/detail/result_grid.dart';
import 'package:gps_measurement/features/home/home_controller.dart';
import 'package:gps_measurement/features/home/home_screen.dart';
import 'package:gps_measurement/features/home/widgets/draft_banner.dart';
import 'package:gps_measurement/features/saved/saved_controller.dart';
import 'package:gps_measurement/features/saved/saved_screen.dart';
import 'package:gps_measurement/features/saved/widgets/measurement_list_tile.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/data.dart';
import '../helpers/golden.dart';

final DateTime now = DateTime.utc(2026, 9, 28, 10);

MeasurementSummary summary(
  String id, {
  MeasurementType type = MeasurementType.area,
  MeasurementStatus status = MeasurementStatus.saved,
  String? name,
  double? areaM2,
  double? distanceM,
  int points = 6,
  Duration age = const Duration(minutes: 14),
}) => MeasurementSummary(
  id: id,
  type: type,
  status: status,
  name: name,
  areaM2: areaM2,
  distanceM: distanceM,
  pointCount: points,
  updatedAt: now.subtract(age),
  savedAt: status == MeasurementStatus.saved ? now.subtract(age) : null,
);

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  /// App shell for screens: prefs, fixed clock, en-US units, streams.
  Widget scope(
    Widget child, {
    List<MeasurementSummary> drafts = const [],
    List<MeasurementSummary> recent = const [],
    List<MeasurementSummary> saved = const [],
    Map<MeasurementType, int> counts = const {},
    List<Override> extra = const [],
    Brightness brightness = Brightness.light,
    Locale locale = const Locale('en'),
  }) => ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      deviceLocaleProvider.overrideWithValue(const Locale('en', 'VN')),
      clockProvider.overrideWithValue(FixedClock(now)),
      draftListProvider.overrideWith((_) => Stream.value(drafts)),
      recentListProvider.overrideWith((_) => Stream.value(recent)),
      savedListProvider.overrideWith((_) => Stream.value(saved)),
      savedCountsProvider.overrideWith((_) => Stream.value(counts)),
      ...extra,
    ],
    child: testApp(child: child, brightness: brightness, locale: locale),
  );

  group('labels', () {
    testWidgets('titles and relative times', (tester) async {
      await tester.pumpWidget(testApp(child: const SizedBox()));
      final l10n = tester.element(find.byType(SizedBox)).l10n;
      expect(l10n.titleOf(null, MeasurementType.walk), 'Untitled Walk');
      expect(l10n.titleOf('  ', MeasurementType.area), 'Untitled Area');
      expect(l10n.titleOf(' Farm ', MeasurementType.area), 'Farm');
      String ago(Duration d) => l10n.relativeTime(now.subtract(d), now, 'en');
      expect(ago(const Duration(seconds: 20)), 'just now');
      expect(ago(const Duration(minutes: 14)), '14 min ago');
      expect(ago(const Duration(hours: 3)), '3 hours ago');
      expect(ago(const Duration(days: 1)), 'yesterday');
      expect(ago(const Duration(days: 12)), 'Sep 16, 2026');
    });

    test('MeasurementValue picks area or distance', () {
      String? v(MeasurementType t, {double? a, double? d}) =>
          MeasurementValue.primary(
            type: t,
            areaM2: a,
            distanceM: d,
            areaUnit: AreaUnit.hectare,
            distanceUnit: DistanceUnit.meter,
            locale: 'en',
          );
      expect(v(MeasurementType.area, a: 24800), '2.48 ha');
      expect(v(MeasurementType.area), isNull);
      expect(v(MeasurementType.distance, d: 860), '860.0 m');
      expect(v(MeasurementType.walk, a: 24800, d: 860), '2.48 ha');
      expect(v(MeasurementType.walk, d: 860), '860.0 m');
    });
  });

  group('MeasurementListTile', () {
    Widget tiles() => const Column(
      children: [
        MeasurementListTile(
          type: MeasurementType.area,
          title: 'My Farm',
          value: '2.48 ha',
          subtitle: 'Sep 22, 2026 · Area',
          showTypeChip: true,
          trailing: TileMenuButton(tooltip: 'More', actions: []),
        ),
        SizedBox(height: 8),
        MeasurementListTile(
          type: MeasurementType.walk,
          title: 'Untitled Walk',
          value: '860.0 m',
          subtitle: '42 points',
          draftLabel: 'Finished · not saved',
          trailing: TileMenuButton(tooltip: 'More', actions: []),
        ),
      ],
    );

    testWidgets(
      'golden',
      (tester) =>
          expectGoldenBothThemes(tester, 'measurement_list_tile', tiles()),
      tags: ['golden'],
    );

    testWidgets('menu runs the chosen action', (tester) async {
      var renamed = 0;
      await tester.pumpWidget(
        testApp(
          child: MeasurementListTile(
            type: MeasurementType.area,
            title: 'A',
            subtitle: 's',
            trailing: TileMenuButton(
              tooltip: 'More',
              actions: [TileMenuAction('Rename', () => renamed++)],
            ),
          ),
        ),
      );
      await tester.tap(find.byTooltip('More'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Rename'));
      await tester.pumpAndSettle();
      expect(renamed, 1);
    });
  });

  group('DraftBanner', () {
    Widget banner({VoidCallback? onResume, VoidCallback? onDiscard}) =>
        DraftBanner(
          type: MeasurementType.area,
          title: 'Untitled Area · 6 points',
          status: 'Draft',
          lastEdited: 'Last edited 14 min ago',
          onResume: onResume ?? () {},
          onDiscard: onDiscard ?? () {},
        );

    testWidgets(
      'golden',
      (tester) => expectGoldenBothThemes(tester, 'draft_banner', banner()),
      tags: ['golden'],
    );

    testWidgets('Resume / Discard', (tester) async {
      var resumed = 0;
      var discarded = 0;
      await tester.pumpWidget(
        testApp(
          child: banner(
            onResume: () => resumed++,
            onDiscard: () => discarded++,
          ),
        ),
      );
      await tester.tap(find.text('Resume'));
      await tester.tap(find.text('Discard'));
      expect((resumed, discarded), (1, 1));
    });
  });

  group('HomeScreen', () {
    final recent = [
      summary('r1', name: 'My Farm', areaM2: 24800),
      summary(
        'r2',
        type: MeasurementType.distance,
        name: 'Road to river',
        distanceM: 860,
        age: const Duration(days: 2),
      ),
      summary(
        'r3',
        type: MeasurementType.walk,
        name: 'Orchard walk',
        distanceM: 412,
        age: const Duration(days: 5),
      ),
    ];
    final drafts = [
      summary('d1', status: MeasurementStatus.draft),
      summary(
        'd2',
        status: MeasurementStatus.draft,
        age: const Duration(days: 1),
      ),
    ];

    Future<void> pumpHome(
      WidgetTester tester, {
      bool data = true,
      Brightness brightness = Brightness.light,
    }) async {
      tester.view
        ..physicalSize = const Size(400, 1100)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        scope(
          const HomeScreen(),
          drafts: data ? drafts : const [],
          recent: data ? recent : const [],
          brightness: brightness,
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));
    }

    testWidgets('mode selector drives the CTA', (tester) async {
      await pumpHome(tester, data: false);
      expect(find.text('Start Area Survey'), findsOneWidget);
      await tester.tap(find.text('Walk'));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Start Walk Measure'), findsOneWidget);
      expect(find.text('No recent measurements'), findsOneWidget);
      expect(find.text('Continue Measurement'), findsNothing);
    });

    testWidgets('latest draft and recent list', (tester) async {
      await pumpHome(tester);
      expect(find.text('Continue Measurement'), findsOneWidget);
      expect(find.text('See all drafts'), findsOneWidget);
      expect(find.text('Untitled Area · 6 points · Draft'), findsOneWidget);
      expect(find.text('Last edited 14 min ago'), findsOneWidget);
      expect(find.text('My Farm'), findsOneWidget);
      expect(find.text('2.48 ha'), findsNothing); // en-VN default unit m²
      expect(find.text('24,800 m²'), findsOneWidget);
    });

    for (final data in [true, false]) {
      testWidgets(
        'golden ${data ? 'with' : 'without'} data',
        (tester) async {
          for (final b in Brightness.values) {
            await pumpHome(tester, data: data, brightness: b);
            await expectLater(
              find.byType(HomeScreen),
              matchesGoldenFile(
                'goldens/home_${data ? 'data' : 'empty'}_${b.name}.png',
              ),
            );
          }
        },
        tags: ['golden'],
      );
    }
  });

  group('SavedScreen', () {
    Future<void> pumpSaved(
      WidgetTester tester, {
      List<MeasurementSummary> saved = const [],
      List<MeasurementSummary> drafts = const [],
      Map<MeasurementType, int> counts = const {},
    }) async {
      tester.view
        ..physicalSize = const Size(400, 900)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        scope(
          const SavedScreen(),
          saved: saved,
          drafts: drafts,
          counts: counts,
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }

    testWidgets('empty state', (tester) async {
      await pumpSaved(tester);
      expect(find.text('No measurements yet'), findsOneWidget);
      expect(find.text('Start Measuring'), findsOneWidget);
    });

    testWidgets('chips with counts, drafts section, list', (tester) async {
      await pumpSaved(
        tester,
        saved: [
          summary('s1', name: 'My Farm', areaM2: 24800),
          summary(
            's2',
            type: MeasurementType.distance,
            name: 'Road',
            distanceM: 860,
          ),
        ],
        drafts: [
          summary(
            'w1',
            type: MeasurementType.walk,
            status: MeasurementStatus.completed,
            distanceM: 300,
          ),
        ],
        counts: {MeasurementType.area: 1, MeasurementType.distance: 1},
      );
      expect(find.text('All (2)'), findsOneWidget);
      expect(find.text('Area (1)'), findsOneWidget);
      expect(find.text('Walk (0)'), findsOneWidget);
      expect(find.text('Drafts (1)'), findsOneWidget);
      expect(find.text('FINISHED · NOT SAVED'), findsOneWidget);
      expect(find.text('My Farm'), findsOneWidget);

      await tester.tap(find.text('Drafts (1)'));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Untitled Walk'), findsNothing);

      await tester.tap(find.byTooltip('Search'));
      await tester.pump();
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Drafts (1)'), findsNothing);
      await tester.tap(find.byTooltip('Close search'));
      await tester.pump();
      expect(find.byType(TextField), findsNothing);
    });

    testWidgets('no results', (tester) async {
      await pumpSaved(
        tester,
        counts: {MeasurementType.area: 3},
      );
      expect(find.text('No measurements found.'), findsOneWidget);
    });
  });

  group('Detail', () {
    final walk = Measurement(
      id: 'w1',
      name: 'Orchard walk',
      type: MeasurementType.walk,
      status: MeasurementStatus.saved,
      mapStyle: MapStyle.satellite,
      createdAt: now,
      updatedAt: now,
      savedAt: now,
      notes: 'East side along the canal',
      stats: const MeasurementStats(
        distanceM: 1200,
        durationSec: 900,
        areaM2: 23100,
        isClosed: true,
        pointCount: 90,
        segmentCount: 1,
      ),
    );

    late TempDirectories dirs;
    setUp(() => dirs = TempDirectories());
    tearDown(() => dirs.dispose());

    testWidgets('title, result grid with pace, notes, actions', (tester) async {
      tester.view
        ..physicalSize = const Size(400, 1400)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        scope(
          const DetailScreen(measurementId: 'w1'),
          extra: [
            appDirectoriesProvider.overrideWithValue(dirs.dirs),
            detailControllerProvider(
              'w1',
            ).overrideWith(() => _FixedDetail(walk)),
          ],
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Orchard walk'), findsOneWidget);
      expect(find.text('DURATION'), findsOneWidget);
      expect(find.text('00:15:00'), findsOneWidget);
      expect(find.text('12:30 /km'), findsOneWidget);
      expect(find.text('23,100 m²'), findsOneWidget);
      expect(find.text('East side along the canal'), findsOneWidget);
      // Notes "Edit" + action bar "Edit".
      expect(find.text('Edit'), findsNWidgets(2));
      expect(find.text('Site Photos (0)'), findsOneWidget);
      expect(find.text('Export'), findsOneWidget);

      await tester.tap(find.text('Export'));
      await tester.pumpAndSettle();
      expect(find.text('KML — Google Earth'), findsOneWidget);
      expect(find.text('CSV — Excel'), findsOneWidget);
    });

    testWidgets('pace uses miles for imperial units', (tester) async {
      await tester.pumpWidget(testApp(child: const SizedBox()));
      final context = tester.element(find.byType(SizedBox));
      expect(
        ResultGrid.pace(context, walk.stats, DistanceUnit.foot),
        '20:07 /mi',
      );
      expect(
        ResultGrid.pace(context, MeasurementStats.empty, DistanceUnit.meter),
        isNull,
      );
    });
  });
}

class _FixedDetail extends DetailController {
  _FixedDetail(this.m);

  final Measurement m;

  @override
  Stream<Measurement?> build(String measurementId) => Stream.value(m);
}
