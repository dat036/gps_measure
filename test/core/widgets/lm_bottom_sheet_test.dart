import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/widgets/lm_bottom_sheet.dart';

import '../../helpers/golden.dart';

void main() {
  testWidgets('sheet content stays above the system navigation bar', (
    tester,
  ) async {
    const navBar = 48.0;
    tester.view
      ..physicalSize = const Size(400, 800)
      ..devicePixelRatio = 1
      ..padding = const FakeViewPadding(bottom: navBar)
      ..viewPadding = const FakeViewPadding(bottom: navBar);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      testApp(
        child: Builder(
          builder: (context) => TextButton(
            onPressed: () => showLmBottomSheet<void>(
              context: context,
              builder: (_) => const ListTile(title: Text('Last row')),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final bottom = tester.getBottomLeft(find.byType(ListTile)).dy;
    expect(bottom, lessThanOrEqualTo(800 - navBar));
  });
}
