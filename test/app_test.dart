import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_measurement/app.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:gps_measurement/services/support/support_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/fakes.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'onboarding_seen': true});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          deviceLocaleProvider.overrideWithValue(const Locale('en', 'US')),
          supportServiceProvider.overrideWithValue(FakeSupport()),
        ],
        child: const LandMeasureApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows 3 tabs and switches between them', (tester) async {
    await pumpApp(tester);

    final nav = find.byType(NavigationBar);
    expect(nav, findsOneWidget);
    for (final label in ['Home', 'Saved', 'Setting']) {
      expect(
        find.descendant(of: nav, matching: find.text(label)),
        findsOneWidget,
      );
    }

    await tester.tap(find.text('Saved'));
    await tester.pumpAndSettle();
    expect(find.text('Saved Measurements'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Start Area Survey'), findsOneWidget);
  });

  testWidgets('full-screen routes hide the bottom nav', (tester) async {
    await pumpApp(tester);
    // Measure screens need the native map: use a placeholder route.
    unawaited(
      GoRouter.of(
        tester.element(find.byType(NavigationBar)),
      ).push(Routes.detailOf('x')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Measurement Detail'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('switching locale to Vietnamese relabels the app', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.text('Setting'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tiếng Việt'));
    await tester.pumpAndSettle();
    // Applied at once: the sub-screen is already translated.
    expect(find.text('Ngôn ngữ'), findsOneWidget);
    // pageBack() looks for the English "Back" tooltip.
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    final nav = find.byType(NavigationBar);
    for (final label in ['Trang chủ', 'Đã lưu', 'Cài đặt']) {
      expect(
        find.descendant(of: nav, matching: find.text(label)),
        findsOneWidget,
      );
    }
  });
}
