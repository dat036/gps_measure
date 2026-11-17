import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:gps_measurement/data/repositories/settings_repository.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';
import 'package:gps_measurement/features/measure/common/leave_measure_guard.dart';
import 'package:gps_measurement/features/measure/common/marker_factory.dart';
import 'package:gps_measurement/features/measure/walk/battery_optimization_helper.dart';
import 'package:gps_measurement/features/measure/walk/walk_result_panel.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/data.dart';
import '../../helpers/fakes.dart';
import '../../helpers/golden.dart';

class MockRepository extends Mock implements MeasurementRepository {}

void main() {
  group('WalkResultPanel', () {
    const closed = MeasurementStats(
      distanceM: 860,
      areaM2: 23100,
      perimeterM: 860,
      durationSec: 756,
      pointCount: 120,
      segmentCount: 1,
      isClosed: true,
    );
    const open = MeasurementStats(
      distanceM: 420,
      durationSec: 300,
      pointCount: 40,
      segmentCount: 2,
    );

    Widget panel({
      MeasurementStats stats = closed,
      WalkRunState runState = WalkRunState.recording,
      int elapsedSec = 756,
    }) => WalkResultPanel(
      stats: stats,
      elapsedSec: elapsedSec,
      runState: runState,
      areaUnit: AreaUnit.hectare,
      distanceUnit: DistanceUnit.meter,
      onAreaUnitChanged: (_) {},
      onDistanceUnitChanged: (_) {},
    );

    testWidgets('duration, distance, area and the close-to-start hint', (
      tester,
    ) async {
      await tester.pumpWidget(testApp(child: panel()));
      await tester.pumpAndSettle();
      expect(find.text('DURATION'), findsOneWidget);
      expect(find.text('00:12:36'), findsOneWidget);
      expect(find.textContaining('860'), findsOneWidget);
      expect(find.text('2.31 ha'), findsOneWidget);
      expect(
        find.text('Close to start — finish to calculate area'),
        findsOneWidget,
      );
    });

    testWidgets('open track: dash while walking, note after Finish', (
      tester,
    ) async {
      await tester.pumpWidget(testApp(child: panel(stats: open)));
      await tester.pumpAndSettle();
      expect(find.text('—'), findsOneWidget);
      expect(
        find.text('Walk back to your start to close the loop.'),
        findsOneWidget,
      );

      await tester.pumpWidget(
        testApp(
          child: panel(stats: open, runState: WalkRunState.finished),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Route not closed — distance only'), findsOneWidget);
    });

    testWidgets('Vietnamese', (tester) async {
      await tester.pumpWidget(
        testApp(locale: const Locale('vi'), child: panel()),
      );
      await tester.pumpAndSettle();
      expect(find.text('THỜI GIAN'), findsOneWidget);
      expect(find.text('2,31 ha'), findsOneWidget);
    });

    testWidgets(
      'golden',
      (tester) => expectGoldenBothThemes(tester, 'walk_result_panel', panel()),
      tags: ['golden'],
    );
  });

  group('BatteryOptimizationHelper', () {
    late SettingsRepository settings;
    late FakePermissions permissions;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      settings = SettingsRepository(await SharedPreferences.getInstance());
      permissions = FakePermissions();
    });

    BatteryOptimizationHelper helper(String? maker, {bool android = true}) =>
        BatteryOptimizationHelper(
          settings: settings,
          permissions: permissions,
          manufacturer: () async => maker,
          isAndroid: android,
        );

    test('aggressive makers see the hint once', () async {
      expect(await helper('Xiaomi').shouldShowHint(), isTrue);
      expect(await helper('samsung ').shouldShowHint(), isTrue);
      await helper('Xiaomi').markShown();
      expect(await helper('Xiaomi').shouldShowHint(), isFalse);
    });

    test('other makers, iOS and unknown never see it', () async {
      expect(await helper('Google').shouldShowHint(), isFalse);
      expect(await helper(null).shouldShowHint(), isFalse);
      expect(await helper('Xiaomi', android: false).shouldShowHint(), isFalse);
      final failing = BatteryOptimizationHelper(
        settings: settings,
        permissions: permissions,
        manufacturer: () => throw StateError('no plugin'),
        isAndroid: true,
      );
      expect(await failing.shouldShowHint(), isFalse);
    });

    test('opens the app settings page', () async {
      await helper('oppo').openSettings();
      expect(permissions.appSettingsOpened, 1);
    });

    testWidgets('sheet returns the choice', (tester) async {
      BatteryHintChoice? choice;
      await tester.pumpWidget(
        testApp(
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () async =>
                  choice = await showBatteryHintSheet(context),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(
        find.text('Allow LandMeasure to run in background'),
        findsOneWidget,
      );
      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();
      expect(choice, BatteryHintChoice.notNow);

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Settings'));
      await tester.pumpAndSettle();
      expect(choice, BatteryHintChoice.openSettings);
    });
  });

  testWidgets('LeaveMeasureGuard blocks back while canPop is false', (
    tester,
  ) async {
    var blocked = 0;
    var left = 0;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          measurementRepositoryProvider.overrideWithValue(MockRepository()),
        ],
        child: testApp(
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => LeaveMeasureGuard(
                    type: MeasurementType.walk,
                    canPop: false,
                    onPopBlocked: () => blocked++,
                    onLeave: () async {
                      left++;
                      return null;
                    },
                    child: Scaffold(appBar: AppBar(title: const Text('walk'))),
                  ),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('walk'), findsOneWidget);
    expect(blocked, 1);
    expect(left, 0);

    // A direct pop (snackbar "Pause & leave") still runs onLeave.
    Navigator.of(tester.element(find.text('walk'))).pop();
    await tester.pumpAndSettle();
    expect(find.text('walk'), findsNothing);
    expect(left, 1);
  });

  testWidgets('"Draft saved" snackbar goes away by itself', (tester) async {
    final repository = MockRepository();
    when(() => repository.get('w1')).thenAnswer((_) async => draftNamed('w1'));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          measurementRepositoryProvider.overrideWithValue(repository),
        ],
        child: testApp(
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => LeaveMeasureGuard(
                    type: MeasurementType.walk,
                    onLeave: () async => (id: 'w1', pointCount: 3),
                    child: Scaffold(appBar: AppBar(title: const Text('walk'))),
                  ),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Draft saved · Walk · 3 points'), findsOneWidget);
    await tester.pump(LeaveMeasureGuard.snackDuration);
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsNothing);
  });

  test('MarkerFactory current location icons are cached', () async {
    final factory = MarkerFactory(devicePixelRatio: 2);
    final a = await factory.currentLocation(heading: false);
    final b = await factory.currentLocation(heading: true);
    expect(identical(a, await factory.currentLocation(heading: false)), isTrue);
    expect(identical(a, b), isFalse);
    expect(factory.cacheSize, 2);
  });
}
