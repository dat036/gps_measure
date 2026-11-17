import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/premium/feature_gate.dart';

void main() {
  const free = FeatureGate(isPremium: false);
  const premium = FeatureGate(isPremium: true);

  test('save limit (default 4)', () {
    expect(free.canSaveNew(3), isTrue);
    expect(free.canSaveNew(4), isFalse);
    expect(premium.canSaveNew(10000), isTrue);
  });

  test('photo limit (default 2)', () {
    expect(free.canAddPhoto(1), isTrue);
    expect(free.canAddPhoto(2), isFalse);
    expect(premium.canAddPhoto(99), isTrue);
  });

  test('limits follow Remote Config', () {
    const gate = FeatureGate(
      isPremium: false,
      config: GateConfig(freeMaxSaved: 2, freeMaxPhotos: 0),
    );
    expect(gate.canSaveNew(2), isFalse);
    expect(gate.canAddPhoto(0), isFalse);
  });

  test('export: CSV always free, KML once per day', () {
    expect(free.canExport(ExportFormat.csv, freeUsedToday: true), isTrue);
    expect(free.canExport(ExportFormat.kml, freeUsedToday: false), isTrue);
    expect(free.canExport(ExportFormat.kml, freeUsedToday: true), isFalse);
    expect(premium.canExport(ExportFormat.kml, freeUsedToday: true), isTrue);
    // The PDF report is Premium only.
    expect(free.canExport(ExportFormat.pdf, freeUsedToday: false), isFalse);
    expect(premium.canExport(ExportFormat.pdf, freeUsedToday: true), isTrue);
  });

  test('premium-only features and ads', () {
    expect(free.canUsePdf, isFalse);
    expect(free.canUseCustomUnit, isFalse);
    expect(free.showAds, isTrue);
    expect(premium.canUsePdf, isTrue);
    expect(premium.canUseCustomUnit, isTrue);
    expect(premium.showAds, isFalse);
  });
}
