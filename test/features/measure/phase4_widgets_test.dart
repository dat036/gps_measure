import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/connectivity/connectivity_service.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';
import 'package:gps_measurement/features/measure/common/leave_measure_guard.dart';
import 'package:gps_measurement/features/measure/common/measure_help_sheet.dart';
import 'package:gps_measurement/features/measure/distance/distance_result_panel.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/data.dart';
import '../../helpers/golden.dart';

class MockRepository extends Mock implements MeasurementRepository {}

class FakeConnectivity implements ConnectivityService {
  FakeConnectivity({required this.initial});

  final bool initial;
  final StreamController<bool> changes = StreamController<bool>();

  @override
  Future<bool> isOnline() async => initial;

  @override
  Stream<bool> get onlineChanges => changes.stream;
}

void main() {
  final t0 = DateTime.utc(2026, 9, 28);
  final route = [
    for (final (i, lng) in [105.0, 105.002, 105.004, 105.0045].indexed)
      MeasurePoint(id: 'p$i', orderIndex: i, lat: 21, lng: lng, timestamp: t0),
  ];

  group('DistanceResultPanel', () {
    Widget panel({List<MeasurePoint>? points, MeasurementStats? stats}) =>
        DistanceResultPanel(
          stats:
              stats ?? const MeasurementStats(distanceM: 467.4, pointCount: 4),
          points: points ?? route,
          distanceUnit: DistanceUnit.meter,
          onDistanceUnitChanged: (_) {},
        );

    testWidgets('total, secondary, segments list', (tester) async {
      await tester.pumpWidget(
        testApp(child: SingleChildScrollView(child: panel())),
      );
      await tester.pumpAndSettle();
      expect(find.text('DISTANCE'), findsOneWidget);
      expect(find.text('467.4 m'), findsOneWidget);
      expect(find.text('0.47 km'), findsOneWidget);
      expect(find.text('3 segments'), findsOneWidget);
      expect(find.text('A → B'), findsOneWidget);
      expect(find.text('C → D'), findsOneWidget);
    });

    testWidgets('needs 2 points', (tester) async {
      await tester.pumpWidget(
        testApp(
          child: panel(
            points: route.take(1).toList(),
            stats: const MeasurementStats(pointCount: 1),
          ),
        ),
      );
      expect(find.text('—'), findsOneWidget);
      expect(
        find.text('Add at least 2 points to measure distance'),
        findsOneWidget,
      );
      expect(find.text('Segments'), findsNothing);
    });

    test('point letters', () {
      expect(
        [
          0,
          1,
          25,
          26,
          27,
          51,
          52,
          701,
          702,
        ].map(DistanceResultPanel.pointLetter),
        ['A', 'B', 'Z', 'AA', 'AB', 'AZ', 'BA', 'ZZ', 'AAA'],
      );
    });

    testWidgets(
      'golden',
      (tester) =>
          expectGoldenBothThemes(tester, 'distance_result_panel', panel()),
      tags: ['golden'],
    );
  });

  group('MeasureHelpSheet', () {
    testWidgets('steps with bold markup, per mode, Got it closes', (
      tester,
    ) async {
      await tester.pumpWidget(
        testApp(
          locale: const Locale('vi'),
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () =>
                  showMeasureHelpSheet(context, MeasurementType.area),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Cách đo diện tích'), findsOneWidget);
      expect(
        find.textContaining('Kéo bản đồ để tâm ngắm', findRichText: true),
        findsOneWidget,
      );
      expect(find.textContaining('**', findRichText: true), findsNothing);
      await tester.tap(find.text('Đã hiểu'));
      await tester.pumpAndSettle();
      expect(find.text('Cách đo diện tích'), findsNothing);
    });

    test('boldMarkup splits segments', () {
      final span = boldMarkup(
        'Tap **Close** then **Save**.',
        const TextStyle(),
      );
      final parts = span.children!.cast<TextSpan>();
      expect(parts.map((p) => p.text), [
        'Tap ',
        'Close',
        ' then ',
        'Save',
        '.',
      ]);
      expect(parts[1].style?.fontWeight, FontWeight.w700);
      expect(parts[0].style, isNull);
    });

    for (final type in MeasurementType.values) {
      testWidgets('renders ${type.name}', (tester) async {
        await tester.pumpWidget(
          testApp(child: MeasureHelpSheet(type: type)),
        );
        expect(find.text('Got it'), findsOneWidget);
      });
    }
  });

  group('LeaveMeasureGuard', () {
    late MockRepository repository;

    setUp(() {
      repository = MockRepository();
      when(() => repository.delete(any())).thenAnswer((_) async {});
      when(
        () => repository.get(any()),
      ).thenAnswer(
        (i) async => draftNamed(i.positionalArguments.first as String),
      );
    });

    Future<void> open(
      WidgetTester tester,
      Future<({String id, int pointCount})?> Function() onLeave,
    ) async {
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
                      type: MeasurementType.area,
                      onLeave: onLeave,
                      child: Scaffold(
                        appBar: AppBar(title: const Text('measure')),
                      ),
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
    }

    testWidgets('back leaves at once and offers Discard', (tester) async {
      var flushed = 0;
      await open(tester, () async {
        flushed++;
        return (id: 'd1', pointCount: 6);
      });
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('measure'), findsNothing); // no dialog, left
      expect(flushed, 1);
      expect(find.text('Draft saved · Area · 6 points'), findsOneWidget);
      await tester.tap(find.text('Discard'));
      await tester.pumpAndSettle();
      verify(() => repository.delete('d1')).called(1);
    });

    testWidgets('saved meanwhile (Save replaced the screen) → no Discard', (
      tester,
    ) async {
      when(() => repository.get('s1')).thenAnswer(
        (_) async => draftNamed('s1').copyWith(status: MeasurementStatus.saved),
      );
      await open(tester, () async => (id: 's1', pointCount: 4));
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('no draft → no snackbar', (tester) async {
      await open(tester, () async => null);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsNothing);
      verifyNever(() => repository.delete(any()));
    });
  });

  test('isOnline follows the connectivity service', () async {
    final fake = FakeConnectivity(initial: false);
    final container = ProviderContainer(
      overrides: [connectivityServiceProvider.overrideWithValue(fake)],
    );
    addTearDown(container.dispose);
    final values = <bool>[];
    container.listen(
      isOnlineProvider,
      (_, next) => next.whenData(values.add),
      fireImmediately: true,
    );
    await pumpEventQueue();
    fake.changes
      ..add(true)
      ..add(true)
      ..add(false);
    await pumpEventQueue();
    expect(values, [false, true, false]);
  });
}
