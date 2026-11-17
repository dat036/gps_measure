import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/app.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:gps_measurement/services/support/support_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/fakes.dart';

/// Launch flow (no ads here: the Mobile Ads SDK is not available in tests,
/// so the splash leaves at once, exactly as it does when an ad fails):
/// 1st launch splash → language → intro → Home; 2nd launch splash →
/// paywall → Home; from the 3rd launch splash → Home.
void main() {
  Future<SharedPreferences> pumpApp(
    WidgetTester tester,
    Map<String, Object> prefsValues,
  ) async {
    SharedPreferences.setMockInitialValues(prefsValues);
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
    return prefs;
  }

  Future<void> leaveSplash(WidgetTester tester) async {
    // Starts as the splash, then moves on without waiting for the 8 s cap.
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
  }

  double opacityOfCheck(WidgetTester tester) => tester
      .widget<AnimatedOpacity>(
        find.ancestor(
          of: find.byIcon(Icons.check_rounded),
          matching: find.byType(AnimatedOpacity),
        ),
      )
      .opacity;

  testWidgets('1st launch: splash → language → intro slides → Home', (
    tester,
  ) async {
    final prefs = await pumpApp(tester, {'app_open_count': 1});
    expect(find.text('LandMeasure'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);

    await leaveSplash(tester);
    expect(find.text('Choose your language'), findsOneWidget);
    expect(find.text('Tiếng Việt'), findsOneWidget);
    expect(find.text('🇻🇳'), findsOneWidget);
    // Nothing is selected by default (not even the device's language).
    expect(find.byIcon(Icons.radio_button_checked_rounded), findsNothing);
    // The check button is dimmed and does nothing until a language is picked.
    expect(opacityOfCheck(tester), 0.4);
    await tester.tap(find.byIcon(Icons.check_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Choose your language'), findsOneWidget);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(opacityOfCheck(tester), 1);
    expect(find.byIcon(Icons.radio_button_checked_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.check_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Measure Area Easily'), findsOneWidget);
    expect(find.text('Skip'), findsNothing); // no way to skip the intro
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Measure Distance & Routes'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Made for Real Field Work'), findsOneWidget);

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    expect(find.text('Start Area Survey'), findsOneWidget);
    expect(prefs.getBool('onboarding_seen'), isTrue);
    // Remembers which launch finished the intro (the paywall is next).
    expect(prefs.getInt('onboarding_done_at_open'), 1);
  });

  testWidgets('the language screen applies the chosen language at once', (
    tester,
  ) async {
    final prefs = await pumpApp(tester, {'app_open_count': 1});
    await leaveSplash(tester);
    await tester.tap(find.text('Tiếng Việt'));
    await tester.pumpAndSettle();
    expect(find.text('Chọn ngôn ngữ'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.check_rounded));
    await tester.pumpAndSettle();
    expect(prefs.getString('locale'), 'vi');
  });

  testWidgets('2nd launch: splash → paywall; closing it goes to Home', (
    tester,
  ) async {
    final prefs = await pumpApp(tester, {
      'onboarding_seen': true,
      'onboarding_done_at_open': 1,
      'app_open_count': 2,
    });
    await leaveSplash(tester);
    expect(find.text('Measure without limits'), findsOneWidget);
    expect(find.text('Start Area Survey'), findsNothing);
    expect(prefs.getBool('startup_paywall_shown'), isTrue);

    // ✕ appears after 10 s; the paywall is the only page, so it leads Home.
    await tester.pump(const Duration(seconds: 11));
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Start Area Survey'), findsOneWidget);
  });

  testWidgets('3rd launch and later: splash → Home, no paywall', (
    tester,
  ) async {
    await pumpApp(tester, {
      'onboarding_seen': true,
      'onboarding_done_at_open': 1,
      'startup_paywall_shown': true,
      'app_open_count': 3,
    });
    await leaveSplash(tester);
    expect(find.text('Measure without limits'), findsNothing);
    expect(find.text('Start Area Survey'), findsOneWidget);
  });

  testWidgets('a premium user skips the paywall', (tester) async {
    await pumpApp(tester, {
      'onboarding_seen': true,
      'onboarding_done_at_open': 1,
      'app_open_count': 2,
      'premium_cached': true,
    });
    await leaveSplash(tester);
    expect(find.text('Measure without limits'), findsNothing);
    expect(find.text('Start Area Survey'), findsOneWidget);
  });
}
