import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';
import 'package:gps_measurement/features/measure/area/area_result_panel.dart';
import 'package:gps_measurement/features/measure/common/marker_factory.dart';
import 'package:gps_measurement/features/measure/common/measure_toolbar.dart';
import 'package:gps_measurement/features/measure/common/point_actions_popup.dart';

import '../../helpers/golden.dart';

void main() {
  const stats = MeasurementStats(
    areaM2: 12450,
    perimeterM: 462.8,
    pointCount: 6,
    segmentCount: 1,
  );

  Widget panel({
    MeasurementStats s = stats,
    AreaUnit unit = AreaUnit.squareMeter,
    ValueChanged<AreaUnit>? onUnit,
  }) => AreaResultPanel(
    stats: s,
    areaUnit: unit,
    distanceUnit: DistanceUnit.meter,
    onAreaUnitChanged: onUnit ?? (_) {},
  );

  group('AreaResultPanel', () {
    testWidgets('shows area, perimeter and secondary units', (tester) async {
      await tester.pumpWidget(testApp(child: panel()));
      await tester.pumpAndSettle();
      expect(find.text('AREA'), findsOneWidget);
      expect(find.text('12,450 m²'), findsOneWidget);
      expect(find.text('1.25 ha'), findsOneWidget);
      expect(find.text('462.8 m'), findsOneWidget);
      expect(find.text('0.46 km'), findsOneWidget);
      expect(find.text('6 points'), findsOneWidget);
    });

    testWidgets('dash + hint before 3 points', (tester) async {
      await tester.pumpWidget(
        testApp(child: panel(s: const MeasurementStats(pointCount: 2))),
      );
      expect(find.text('—'), findsNWidgets(2));
      expect(
        find.text('Add at least 3 points to calculate area'),
        findsOneWidget,
      );
    });

    testWidgets('Vietnamese format and unit chips', (tester) async {
      AreaUnit? picked;
      await tester.pumpWidget(
        testApp(
          locale: const Locale('vi'),
          child: panel(unit: AreaUnit.acre, onUnit: (u) => picked = u),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('DIỆN TÍCH'), findsOneWidget);
      expect(find.text('3,08 acre'), findsOneWidget);
      await tester.tap(find.text('ha'));
      expect(picked, AreaUnit.hectare);
    });

    testWidgets(
      'golden',
      (tester) async {
        await expectGoldenBothThemes(tester, 'area_result_panel', panel());
      },
      tags: ['golden'],
    );
  });

  group('MeasureToolbar', () {
    testWidgets('null callbacks disable buttons', (tester) async {
      var adds = 0;
      await tester.pumpWidget(
        testApp(
          child: Center(
            child: MeasureToolbar(
              type: MeasurementType.area,
              onUndo: null,
              onAddAtMyLocation: null,
              onAddPoint: () => adds++,
              onTrailing: null,
            ),
          ),
        ),
      );
      await tester.tap(find.text('Add Point'));
      expect(adds, 1);
      final undo = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.undo_rounded),
      );
      expect(undo.onPressed, isNull);
      expect(find.byIcon(Icons.hexagon_outlined), findsOneWidget);
    });

    testWidgets('distance shows Reset; locating shows a spinner', (
      tester,
    ) async {
      await tester.pumpWidget(
        testApp(
          child: Center(
            child: MeasureToolbar(
              type: MeasurementType.distance,
              locating: true,
              onUndo: () {},
              onAddAtMyLocation: () {},
              onAddPoint: () {},
              onTrailing: () {},
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.restart_alt_rounded), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  testWidgets('PointActionsPopup', (tester) async {
    var deleted = false;
    var done = false;
    await tester.pumpWidget(
      testApp(
        child: Center(
          child: PointActionsPopup(
            pointNumber: 3,
            onDelete: () => deleted = true,
            onDone: () => done = true,
          ),
        ),
      ),
    );
    expect(find.text('Point 3'), findsOneWidget);
    await tester.tap(find.text('Delete point'));
    await tester.tap(find.text('Done'));
    expect((deleted, done), (true, true));
  });

  testWidgets('PointActionsPopup with Photo fits a narrow phone', (
    tester,
  ) async {
    var photo = 0;
    await tester.pumpWidget(
      testApp(
        locale: const Locale('vi'),
        child: Center(
          child: SizedBox(
            width: 328, // 360dp phone − 2×16 padding
            child: Center(
              child: PointActionsPopup(
                pointNumber: 12,
                onPhoto: () => photo++,
                onDelete: () {},
                onDone: () {},
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull); // no RenderFlex overflow
    await tester.tap(find.byTooltip('Ảnh'));
    expect(photo, 1);
  });

  group('MarkerFactory', () {
    test('renders and caches bitmaps', () async {
      final f = MarkerFactory(devicePixelRatio: 2);
      const green = Color(0xFF12A150);
      final a = await f.pointHandle(color: green);
      final b = await f.pointHandle(color: green);
      expect(identical(a, b), isTrue);
      await f.pointHandle(color: green, selected: true, hasPhoto: true);
      await f.startDot();
      await f.endPin();
      await f.resultPill('12,450 m²', '1.25 ha');
      await f.resultPill('860 m', null);
      await f.edgeLabel('120.5 m');
      expect(f.cacheSize, 7);
      expect(f.colors, LmColors.light);
    });

    test('cache is bounded', () async {
      final f = MarkerFactory(devicePixelRatio: 1);
      for (var i = 0; i < 300; i++) {
        await f.edgeLabel('$i m');
      }
      expect(f.cacheSize, 256);
    });
  });
}
