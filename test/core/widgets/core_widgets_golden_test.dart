@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/widgets/empty_state.dart';
import 'package:gps_measurement/core/widgets/lm_dialog.dart';
import 'package:gps_measurement/core/widgets/map_fab.dart';
import 'package:gps_measurement/core/widgets/primary_cta.dart';
import 'package:gps_measurement/core/widgets/status_banner.dart';
import 'package:gps_measurement/core/widgets/type_chip.dart';
import 'package:gps_measurement/core/widgets/unit_chips.dart';
import 'package:gps_measurement/domain/models/enums.dart';

import '../../helpers/golden.dart';

// Goldens are OS-dependent (font rasterization). Regenerate on the same OS
// with: flutter test --tags golden --update-goldens
void main() {
  Widget column(List<Widget> children) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final c in children) ...[c, const SizedBox(height: LmSpacing.s12)],
    ],
  );

  testWidgets('PrimaryCta variants', (tester) async {
    await expectGoldenBothThemes(
      tester,
      'primary_cta',
      column([
        PrimaryCta(
          label: 'Start Area Survey',
          icon: Icons.arrow_forward_rounded,
          showChevron: true,
          onPressed: () {},
        ),
        PrimaryCta(
          label: 'Save Route',
          variant: PrimaryCtaVariant.distance,
          onPressed: () {},
        ),
        PrimaryCta(
          label: 'Start Walking',
          variant: PrimaryCtaVariant.walk,
          icon: Icons.directions_walk_rounded,
          onPressed: () {},
        ),
        Row(
          children: [
            Expanded(
              child: PrimaryCta(
                label: 'Pause',
                variant: PrimaryCtaVariant.tonalDanger,
                icon: Icons.pause_rounded,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: LmSpacing.s12),
            Expanded(
              child: PrimaryCta(
                label: 'Finish',
                variant: PrimaryCtaVariant.danger,
                icon: Icons.stop_rounded,
                onPressed: () {},
              ),
            ),
          ],
        ),
        const PrimaryCta(label: 'Save Measurement', onPressed: null),
        PrimaryCta(label: 'Saving…', loading: true, onPressed: () {}),
      ]),
    );
  });

  testWidgets('MapFab states', (tester) async {
    await expectGoldenBothThemes(
      tester,
      'map_fab',
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MapFab(
            icon: Icons.layers_rounded,
            tooltip: 'Layers',
            onPressed: () {},
          ),
          MapFab(
            icon: Icons.my_location_rounded,
            tooltip: 'Recenter',
            active: true,
            activeColor: const Color(0xFFF58A07),
            onPressed: () {},
          ),
          const MapFab(
            icon: Icons.search_rounded,
            tooltip: 'Search',
            onPressed: null,
          ),
          MapFab(
            icon: Icons.photo_camera_rounded,
            tooltip: 'Camera',
            large: true,
            onPressed: () {},
          ),
        ],
      ),
    );
  });

  testWidgets('StatusBanner kinds', (tester) async {
    await expectGoldenBothThemes(
      tester,
      'status_banner',
      column([
        const StatusBanner(
          kind: StatusBannerKind.success,
          title: 'GPS Ready',
          message: 'Accuracy ±4 m',
        ),
        const StatusBanner(
          kind: StatusBannerKind.warning,
          title: 'Edges cross — area may be incorrect',
        ),
        StatusBanner(
          kind: StatusBannerKind.error,
          title: 'Location is off',
          message: 'Turn on location to record your walk.',
          actionLabel: 'Open Settings',
          onAction: () {},
        ),
        const StatusBanner(
          kind: StatusBannerKind.neutral,
          title: 'Map connection unavailable — your points are safe',
          leading: Icon(Icons.cloud_off_rounded, size: 20),
        ),
      ]),
    );
  });

  testWidgets('TypeChip and UnitChips', (tester) async {
    await expectGoldenBothThemes(
      tester,
      'chips',
      column([
        const Row(
          children: [
            TypeChip(type: MeasurementType.area),
            SizedBox(width: LmSpacing.s8),
            TypeChip(type: MeasurementType.distance),
            SizedBox(width: LmSpacing.s8),
            TypeChip(type: MeasurementType.walk),
          ],
        ),
        UnitChips<String>(
          units: const ['m²', 'ha', 'acre', 'ft²'],
          selected: 'ha',
          labelOf: (u) => u,
          onSelected: (_) {},
          padding: EdgeInsets.zero,
        ),
        UnitChips<String>(
          units: const ['m', 'km', 'ft', 'mi'],
          selected: 'km',
          labelOf: (u) => u,
          onSelected: (_) {},
          mode: MeasurementType.distance,
          padding: EdgeInsets.zero,
        ),
      ]),
    );
  });

  testWidgets('EmptyState variants', (tester) async {
    await expectGoldenBothThemes(
      tester,
      'empty_state',
      column([
        const EmptyState.compact(
          title: 'No recent measurements',
          message: 'Your measurements will appear here.',
        ),
        EmptyState(
          title: 'No measurements yet',
          message: 'Measure your first piece of land and it will appear here.',
          action: PrimaryCta(label: 'Start Measuring', onPressed: () {}),
        ),
      ]),
    );
  });

  testWidgets('LmDialog with three actions', (tester) async {
    tester.view
      ..physicalSize = const Size(400, 600)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    for (final brightness in Brightness.values) {
      await tester.pumpWidget(
        testApp(
          brightness: brightness,
          child: Builder(
            builder: (context) => Center(
              child: TextButton(
                onPressed: () => showLmDialog<String>(
                  context,
                  title: 'Save as draft?',
                  message: 'You can continue this measurement later.',
                  actions: const [
                    LmDialogAction(label: 'Discard', value: 'discard'),
                    LmDialogAction(label: 'Continue measuring', value: 'stay'),
                    LmDialogAction(
                      label: 'Save Draft',
                      value: 'save',
                      style: LmDialogActionStyle.primary,
                    ),
                  ],
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(AlertDialog),
        matchesGoldenFile('goldens/lm_dialog_${brightness.name}.png'),
      );
      await tester.tapAt(const Offset(5, 5)); // dismiss
      await tester.pumpAndSettle();
    }
  });
}
