import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/services/analytics/screen_tracker.dart';

void main() {
  test('screen names drop path parameters', () {
    expect(screenNameForRoute(Routes.home), 'home');
    expect(screenNameForRoute(Routes.measureArea), 'measure_area');
    expect(screenNameForRoute(Routes.detail), 'detail');
    expect(screenNameForRoute('/detail/:id/map'), 'detail_map');
    expect(screenNameForRoute('/settings/units'), 'settings_units');
    expect(screenNameForRoute(Routes.photos), 'photos');
    expect(screenNameForRoute(''), 'unknown');
  });
}
