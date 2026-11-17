import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_measurement/services/analytics/analytics_service.dart';
import 'package:gps_measurement/services/crash/crash_reporter.dart';

/// Turns a route pattern into a screen name without ids:
/// `/detail/:id/map` → `detail_map`, `/settings/units` → `settings_units`.
String screenNameForRoute(String fullPath) {
  final parts = fullPath
      .split('/')
      .where((s) => s.isNotEmpty && !s.startsWith(':'));
  final name = parts.join('_');
  return name.isEmpty ? 'unknown' : name;
}

/// Logs a `screen_view` whenever the visible route changes: tab switches,
/// pushes (`context.push`) and pops. A `NavigatorObserver` would miss tab
/// switches, because the shell branches never push.
class ScreenTracker {
  ScreenTracker(this._router);

  final GoRouter _router;
  String? _current;

  void start() {
    _router.routerDelegate.addListener(_onChange);
    _onChange();
  }

  void dispose() => _router.routerDelegate.removeListener(_onChange);

  void _onChange() {
    var list = _router.routerDelegate.currentConfiguration;
    if (list.isEmpty) return;
    // A pushed route is an ImperativeRouteMatch wrapping its own match list;
    // `fullPath` of the outer list ignores it.
    while (list.matches.isNotEmpty &&
        list.matches.last is ImperativeRouteMatch) {
      list = (list.matches.last as ImperativeRouteMatch).matches;
    }
    if (list.isEmpty) return;
    final name = screenNameForRoute(list.fullPath);
    if (name == _current) return;
    _current = name;
    if (kDebugMode) debugPrint('[screen] $name');
    AnalyticsService.logScreenView(name);
    CrashReporter.setKey('screen', name);
  }
}
