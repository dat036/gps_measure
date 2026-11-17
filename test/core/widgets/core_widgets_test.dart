import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/widgets/lm_dialog.dart';
import 'package:gps_measurement/core/widgets/primary_cta.dart';
import 'package:gps_measurement/core/widgets/type_chip.dart';
import 'package:gps_measurement/domain/models/enums.dart';

import '../../helpers/golden.dart';

void main() {
  group('PrimaryCta', () {
    testWidgets('calls onPressed when enabled', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        testApp(
          child: PrimaryCta(label: 'Go', onPressed: () => taps++),
        ),
      );
      await tester.tap(find.text('Go'));
      expect(taps, 1);
    });

    testWidgets('ignores taps while loading', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        testApp(
          child: PrimaryCta(
            label: 'Go',
            loading: true,
            onPressed: () => taps++,
          ),
        ),
      );
      await tester.tap(find.text('Go'));
      expect(taps, 0);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    test('forMode maps each measurement type', () {
      expect(
        MeasurementType.values.map(PrimaryCtaVariant.forMode),
        [
          PrimaryCtaVariant.area,
          PrimaryCtaVariant.distance,
          PrimaryCtaVariant.walk,
        ],
      );
    });
  });

  testWidgets('TypeChip is localized and upper-cased', (tester) async {
    await tester.pumpWidget(
      testApp(
        locale: const Locale('vi'),
        child: const TypeChip(type: MeasurementType.area),
      ),
    );
    expect(find.text('DIỆN TÍCH'), findsOneWidget);
  });

  group('showLmConfirm', () {
    Future<bool?> run(WidgetTester tester, String tapLabel) async {
      bool? result;
      await tester.pumpWidget(
        testApp(
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                result = await showLmConfirm(
                  context,
                  title: 'Delete measurement?',
                  confirmLabel: 'Delete',
                  cancelLabel: 'Cancel',
                  destructive: true,
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(tapLabel));
      await tester.pumpAndSettle();
      return result;
    }

    testWidgets('returns true on confirm', (tester) async {
      expect(await run(tester, 'Delete'), isTrue);
    });

    testWidgets('returns false on cancel', (tester) async {
      expect(await run(tester, 'Cancel'), isFalse);
    });
  });
}
