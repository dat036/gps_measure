import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_theme.dart';

const ValueKey<String> goldenKey = ValueKey('golden');

/// Wraps [child] in the app theme/localizations for widget & golden tests.
Widget testApp({
  required Widget child,
  Brightness brightness = Brightness.light,
  Locale locale = const Locale('en'),
  double textScale = 1,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    builder: textScale == 1
        ? null
        : (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
    theme: LmTheme.light,
    darkTheme: LmTheme.dark,
    themeMode: brightness == Brightness.light
        ? ThemeMode.light
        : ThemeMode.dark,
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Scaffold(body: child),
  );
}

/// Pumps [child] on a page-colored card of [width] and compares it with
/// `goldens/<name>_<light|dark>.png`, for both brightnesses.
Future<void> expectGoldenBothThemes(
  WidgetTester tester,
  String name,
  Widget child, {
  double width = 360,
}) async {
  tester.view
    ..physicalSize = const Size(420, 1000)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  for (final brightness in Brightness.values) {
    await tester.pumpWidget(
      testApp(
        brightness: brightness,
        child: Align(
          alignment: Alignment.topCenter,
          child: Builder(
            builder: (context) => RepaintBoundary(
              key: goldenKey,
              child: Container(
                width: width,
                color: LmColors.of(context).surfacePage,
                padding: const EdgeInsets.all(LmSpacing.s16),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
    // Fixed pump (not pumpAndSettle): loading spinners never settle.
    await tester.pump(const Duration(milliseconds: 400));
    await expectLater(
      find.byKey(goldenKey),
      matchesGoldenFile('goldens/${name}_${brightness.name}.png'),
    );
  }
}
