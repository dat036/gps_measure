import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/widgets/primary_cta.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/premium/feature_gate.dart';
import 'package:gps_measurement/features/home/home_controller.dart';
import 'package:gps_measurement/features/home/home_screen.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:gps_measurement/features/saved/saved_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/golden.dart';

class _FourProjects implements MeasurementRepository {
  @override
  Future<int> countSaved() async => 4;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  for (final mode in MeasurementType.values) {
    testWidgets('$mode start offers reward or Premium at four projects', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            measurementRepositoryProvider.overrideWithValue(_FourProjects()),
            featureGateProvider.overrideWithValue(
              const FeatureGate(isPremium: false),
            ),
            draftListProvider.overrideWith((_) => Stream.value([])),
            recentListProvider.overrideWith((_) => Stream.value([])),
          ],
          child: testApp(child: const HomeScreen()),
        ),
      );
      await tester.pumpAndSettle();
      final context = tester.element(find.byType(HomeScreen));
      ProviderScope.containerOf(
        context,
      ).read(homeControllerProvider.notifier).select(mode);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(PrimaryCta));
      await tester.pumpAndSettle();
      expect(find.text('Free project limit reached'), findsOneWidget);
      expect(find.text('Watch an ad'), findsOneWidget);
      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();
      expect(find.text('Free project limit reached'), findsNothing);
    });
  }
}
