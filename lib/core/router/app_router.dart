import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/features/detail/detail_screen.dart';
import 'package:gps_measurement/features/detail/full_map_screen.dart';
import 'package:gps_measurement/features/edit/edit_measurement_screen.dart';
import 'package:gps_measurement/features/home/home_screen.dart';
import 'package:gps_measurement/features/measure/area/area_measure_screen.dart';
import 'package:gps_measurement/features/measure/distance/distance_measure_screen.dart';
import 'package:gps_measurement/features/measure/walk/walk_screen.dart';
import 'package:gps_measurement/features/onboarding/intro_screen.dart';
import 'package:gps_measurement/features/onboarding/language_select_screen.dart';
import 'package:gps_measurement/features/onboarding/splash_screen.dart';
import 'package:gps_measurement/features/photos/photo_viewer_screen.dart';
import 'package:gps_measurement/features/premium/paywall_screen.dart';
import 'package:gps_measurement/features/premium/premium_first_screen.dart';
import 'package:gps_measurement/features/save/save_measurement_sheet.dart';
import 'package:gps_measurement/features/saved/saved_screen.dart';
import 'package:gps_measurement/features/settings/language_screen.dart';
import 'package:gps_measurement/features/settings/map_style_screen.dart';
import 'package:gps_measurement/features/settings/settings_screen.dart';
import 'package:gps_measurement/features/settings/units_screen.dart';
import 'package:gps_measurement/services/analytics/screen_tracker.dart';
import 'package:gps_measurement/shell/main_shell.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.splash,
    routes: buildAppRoutes(),
  );
  final screenTracker = ScreenTracker(router)..start();
  ref.onDispose(() {
    screenTracker.dispose();
    router.dispose();
  });
  return router;
}

List<RouteBase> buildAppRoutes() {
  return [
    GoRoute(path: '/', redirect: (_, _) => Routes.splash),
    GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
    GoRoute(
      path: Routes.language,
      builder: (_, _) => const LanguageSelectScreen(),
    ),
    GoRoute(path: Routes.intro, builder: (_, _) => const IntroScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => MainShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.home,
              builder: (_, _) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.saved,
              builder: (_, _) => const SavedScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.settings,
              builder: (_, _) => const SettingsScreen(),
              routes: [
                // Sub-screens cover the bottom nav.
                GoRoute(
                  path: Routes.settingsUnits,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, _) => const UnitsScreen(),
                ),
                GoRoute(
                  path: Routes.settingsMapStyle,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, _) => const MapStyleScreen(),
                ),
                GoRoute(
                  path: Routes.settingsLanguage,
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (_, _) => const LanguageScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    // Measure screens are full-screen (no bottom nav).
    GoRoute(
      path: Routes.measureArea,
      builder: (context, state) => AreaMeasureScreen(
        draftId: state.uri.queryParameters[Routes.queryDraftId],
      ),
    ),
    GoRoute(
      path: Routes.measureDistance,
      builder: (context, state) => DistanceMeasureScreen(
        draftId: state.uri.queryParameters[Routes.queryDraftId],
      ),
    ),
    GoRoute(
      path: Routes.measureWalk,
      builder: (context, state) => WalkScreen(
        draftId: state.uri.queryParameters[Routes.queryDraftId],
      ),
    ),
    GoRoute(
      path: Routes.save,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        fullscreenDialog: true,
        child: SaveMeasurementSheet(
          measurementId: state.pathParameters[Routes.paramId]!,
        ),
      ),
    ),
    GoRoute(
      path: Routes.detail,
      builder: (context, state) =>
          DetailScreen(measurementId: state.pathParameters[Routes.paramId]!),
      routes: [
        GoRoute(
          path: Routes.detailMap,
          builder: (context, state) => FullMapScreen(
            measurementId: state.pathParameters[Routes.paramId]!,
          ),
        ),
      ],
    ),
    GoRoute(
      path: Routes.edit,
      builder: (context, state) => EditMeasurementScreen(
        measurementId: state.pathParameters[Routes.paramId]!,
      ),
    ),
    GoRoute(
      path: Routes.photos,
      builder: (context, state) => PhotoViewerScreen(
        measurementId: state.pathParameters[Routes.paramMeasurementId]!,
        initialIndex:
            int.tryParse(state.uri.queryParameters[Routes.queryIndex] ?? '') ??
            0,
        readOnly: state.uri.queryParameters[Routes.queryReadOnly] == '1',
      ),
    ),
    GoRoute(
      path: Routes.paywallFirst,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        fullscreenDialog: true,
        child: const PremiumFirstScreen(),
      ),
    ),
    GoRoute(
      path: Routes.paywall,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        fullscreenDialog: true,
        child: PaywallScreen(
          source: state.uri.queryParameters[Routes.querySource] ?? 'unknown',
        ),
      ),
    ),
  ];
}
