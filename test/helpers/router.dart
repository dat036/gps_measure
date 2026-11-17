import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/core/theme/lm_theme.dart';

/// [child] under a GoRouter whose `/paywall` is a stub: "stub buy" pops
/// `true` (premium now), "stub close" pops `false`. [paywallOpened]
/// records each source.
Widget routerTestApp({
  required Widget child,
  List<String>? paywallOpened,
}) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => Scaffold(body: child),
      ),
      GoRoute(
        path: Routes.paywall,
        builder: (context, state) {
          paywallOpened?.add(
            state.uri.queryParameters[Routes.querySource] ?? '',
          );
          return Scaffold(
            body: Column(
              children: [
                TextButton(
                  onPressed: () => context.pop(true),
                  child: const Text('stub buy'),
                ),
                TextButton(
                  onPressed: () => context.pop(false),
                  child: const Text('stub close'),
                ),
              ],
            ),
          );
        },
      ),
    ],
  );
  return MaterialApp.router(
    routerConfig: router,
    theme: LmTheme.light,
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
  );
}
