import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_theme.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/shell/main_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<Rect> pumpShell(
    WidgetTester tester,
    Map<String, Object> prefsValues,
  ) async {
    // A status bar on top and a system navigation bar at the bottom.
    tester.view
      ..physicalSize = const Size(400, 800)
      ..devicePixelRatio = 1
      ..padding = const FakeViewPadding(top: 24, bottom: 48)
      ..viewPadding = const FakeViewPadding(top: 24, bottom: 48);
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues(prefsValues);
    final prefs = await SharedPreferences.getInstance();
    final router = GoRouter(
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (_, _, shell) => MainShell(navigationShell: shell),
          branches: [
            for (final path in ['/', '/b', '/c'])
              StatefulShellBranch(
                routes: [
                  GoRoute(path: path, builder: (_, _) => const SizedBox()),
                ],
              ),
          ],
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: MaterialApp.router(
          routerConfig: router,
          theme: LmTheme.light,
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return tester.getRect(find.byType(NavigationBar));
  }

  testWidgets('first launch: no banner slot, the bar keeps its own inset', (
    tester,
  ) async {
    final nav = await pumpShell(tester, {'app_open_count': 1});
    expect(nav.height, 72 + 48); // bar + system navigation bar
    expect(nav.bottom, 800);
  });

  testWidgets('with the banner slot: the bar is 72 dp, 4 dp above the banner', (
    tester,
  ) async {
    final nav = await pumpShell(tester, {
      'onboarding_seen': true,
      'onboarding_done_at_open': 1,
      'app_open_count': 2,
    });
    // Not taller because of the status bar or the system bar's inset.
    expect(nav.height, 72);
    // 4 dp gap, then the system bar's area under the (empty) banner.
    expect(nav.bottom, 800 - 4 - 48);
  });
}
