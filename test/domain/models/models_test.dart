import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/location_fix.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';
import 'package:gps_measurement/domain/models/measurement_summary.dart';
import 'package:gps_measurement/domain/models/photo.dart';

void main() {
  final t0 = DateTime.utc(2026, 9, 28);

  test('GeoPoint validity and value equality', () {
    expect(const GeoPoint(lat: 21, lng: 105).isValid, isTrue);
    expect(const GeoPoint(lat: 91, lng: 0).isValid, isFalse);
    expect(const GeoPoint(lat: 0, lng: -181).isValid, isFalse);
    expect(const GeoPoint(lat: double.nan, lng: 0).isValid, isFalse);
    expect(
      const GeoPoint(lat: 1, lng: 2),
      const GeoPoint(lat: 1, lng: 2),
    );
  });

  test('persisted enum order never changes', () {
    // Values are stored by index — appending is fine, reordering is not.
    expect(MeasurementType.values.map((e) => e.name), [
      'area',
      'distance',
      'walk',
    ]);
    expect(MeasurementStatus.values.map((e) => e.name), [
      'draft',
      'completed',
      'saved',
    ]);
    expect(AreaUnit.values.first, AreaUnit.squareMeter);
    expect(AreaUnit.values.last, AreaUnit.squareFoot);
    expect(MapStyle.values.map((e) => e.name), [
      'standard',
      'satellite',
      'terrain',
      'hybrid',
    ]);
  });

  test('minimum points per type', () {
    expect(MeasurementType.area.minPoints, 3);
    expect(MeasurementType.distance.minPoints, 2);
    expect(MeasurementType.walk.minPoints, 1);
  });

  test('positions and defaults', () {
    final p = MeasurePoint(
      id: 'p',
      orderIndex: 0,
      lat: 1,
      lng: 2,
      timestamp: t0,
    );
    expect(p.position, const GeoPoint(lat: 1, lng: 2));
    expect(p.segmentIndex, 0);
    final f = LocationFix(lat: 3, lng: 4, accuracy: 5, timestamp: t0);
    expect(f.position, const GeoPoint(lat: 3, lng: 4));
    expect(f.isMocked, isFalse);
  });

  test('Measurement defaults and immutable collections', () {
    final m = Measurement(
      id: 'm',
      type: MeasurementType.area,
      status: MeasurementStatus.draft,
      mapStyle: MapStyle.satellite,
      createdAt: t0,
      updatedAt: t0,
    );
    expect(m.points, isEmpty);
    expect(m.stats, MeasurementStats.empty);
    final photo = Photo(
      id: 'ph',
      measurementId: 'm',
      filePath: 'photos/m/ph.jpg',
      thumbPath: 'photos/m/ph_t.jpg',
      takenAt: t0,
      source: PhotoSource.camera,
      width: 10,
      height: 10,
      bytes: 100,
      sortIndex: 0,
      pointId: 'p1',
    );
    final withPhoto = m.copyWith(photos: [photo]);
    expect(withPhoto.photos.single.pointId, 'p1');
    expect(() => withPhoto.photos.add(photo), throwsUnsupportedError);

    final summary = MeasurementSummary(
      id: 'm',
      type: MeasurementType.walk,
      status: MeasurementStatus.completed,
      updatedAt: t0,
    );
    expect(summary.photoCount, 0);
  });
}
