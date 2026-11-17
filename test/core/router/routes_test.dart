import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/domain/models/enums.dart';

void main() {
  test('measure paths per type, with optional draftId', () {
    expect(Routes.measure(MeasurementType.area), '/measure/area');
    expect(
      Routes.measure(MeasurementType.walk, draftId: 'abc'),
      '/measure/walk?draftId=abc',
    );
  });

  test('parameterized paths', () {
    expect(Routes.saveOf('1'), '/save/1');
    expect(Routes.detailOf('1'), '/detail/1');
    expect(Routes.detailMapOf('1'), '/detail/1/map');
    expect(Routes.editOf('1'), '/edit/1');
    expect(Routes.photosOf('m', index: 2), '/photos/m?index=2');
    expect(Routes.photosOf('m'), '/photos/m');
    expect(Routes.paywallFrom('export'), '/paywall?source=export');
    expect(
      Routes.settingsChild(Routes.settingsMapStyle),
      '/settings/map-style',
    );
  });
}
