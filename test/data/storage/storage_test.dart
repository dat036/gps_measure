import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/data/storage/jpeg_size.dart';
import 'package:gps_measurement/data/storage/photo_storage.dart';
import 'package:gps_measurement/data/storage/thumbnail_storage.dart';
import 'package:gps_measurement/domain/geo/stats_calculator.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:image_picker/image_picker.dart';

import '../../helpers/data.dart';

void main() {
  late TempDirectories temp;
  late FakeCompressor compressor;
  late PhotoStorage storage;

  setUp(() {
    temp = TempDirectories();
    compressor = FakeCompressor();
    storage = PhotoStorage(
      directories: temp.dirs,
      compressor: compressor,
      ids: SequentialIds('ph'),
      clock: testClock(),
    );
  });

  tearDown(() => temp.dispose());

  File source(String name) =>
      File('${temp.dirs.temporary.path}/$name')..writeAsBytesSync([1, 2, 3]);

  group('PhotoStorage', () {
    test(
      'camera import: full + thumb, relative paths, temp file removed',
      () async {
        final src = source('capture.jpg');
        final photo = await storage.importFromCamera(
          XFile(src.path),
          'm1',
          pointId: 'p3',
          location: const GeoPoint(lat: 21, lng: 105),
        );
        expect(photo.filePath, 'photos/m1/ph0.jpg');
        expect(photo.thumbPath, 'photos/m1/ph0_t.jpg');
        expect(photo.source, PhotoSource.camera);
        expect(photo.pointId, 'p3');
        expect((photo.lat, photo.lng), (21.0, 105.0));
        expect((photo.width, photo.height), (2048, 1536));
        expect(photo.bytes, 2048 ~/ 8);
        expect(photo.takenAt, testClock().nowUtc());
        expect(temp.files(), ['photos/m1/ph0.jpg', 'photos/m1/ph0_t.jpg']);
        expect(storage.resolve(photo.filePath).existsSync(), isTrue);
        expect(src.existsSync(), isFalse);
        expect(compressor.calls.map((c) => c.$2), [2048, 320]);
      },
    );

    test('gallery import keeps the original', () async {
      final src = source('gallery.jpg');
      final photo = await storage.importFromGallery(XFile(src.path), 'm1');
      expect(photo.source, PhotoSource.gallery);
      expect(src.existsSync(), isTrue);
    });

    test('failed import leaves no partial files', () async {
      compressor.fail = true;
      await expectLater(
        storage.importFromCamera(XFile(source('x.jpg').path), 'm1'),
        throwsA(isA<StorageException>()),
      );
      expect(temp.files(), isEmpty);
    });

    test('delete and deleteForMeasurement', () async {
      final a = await storage.importFromGallery(
        XFile(source('a.jpg').path),
        'm1',
      );
      await storage.importFromGallery(XFile(source('b.jpg').path), 'm1');
      await storage.importFromGallery(XFile(source('c.jpg').path), 'm2');
      await storage.delete(a);
      expect(temp.files(), hasLength(4));
      await storage.deleteForMeasurement('m1');
      expect(temp.files(), ['photos/m2/ph2.jpg', 'photos/m2/ph2_t.jpg']);
      await storage.deleteForMeasurement('missing'); // no-op
    });
  });

  group('ThumbnailStorage', () {
    final t0 = DateTime.utc(2026, 9, 28);
    Measurement measurement(MeasurementType type, List<(double, double)> xy) {
      final points = [
        for (final (i, (lat, lng)) in xy.indexed)
          MeasurePoint(
            id: 'p$i',
            orderIndex: i,
            lat: lat,
            lng: lng,
            timestamp: t0,
            segmentIndex: i < 2 ? 0 : 1,
          ),
      ];
      return Measurement(
        id: 'm-${type.name}',
        type: type,
        status: MeasurementStatus.draft,
        mapStyle: MapStyle.satellite,
        createdAt: t0,
        updatedAt: t0,
        points: points,
        stats: StatsCalculator.compute(type, points),
      );
    }

    const shape = [
      (21.0, 105.0),
      (21.0, 105.002),
      (21.001, 105.002),
      (21.0012, 105.0),
    ];

    ({int width, int height}) pngSize(Uint8List b) => (
      width: ByteData.sublistView(b, 16, 20).getUint32(0),
      height: ByteData.sublistView(b, 20, 24).getUint32(0),
    );

    for (final type in MeasurementType.values) {
      test('renders a 400×400 PNG for ${type.name}', () async {
        final png = await ThumbnailStorage.renderPng(
          measurement(type, shape),
        );
        expect(png.sublist(1, 4), 'PNG'.codeUnits);
        expect(pngSize(png), (width: 400, height: 400));
      });
    }

    test('empty geometry still renders; save/delete files', () async {
      final thumbs = ThumbnailStorage(directories: temp.dirs);
      final rel = await thumbs.renderFallback(
        measurement(MeasurementType.area, const []),
      );
      expect(rel, 'thumbs/m-area.png');
      expect(thumbs.resolve(rel).existsSync(), isTrue);
      await thumbs.saveSnapshot('snap', Uint8List.fromList([1, 2]));
      expect(temp.files(), ['thumbs/m-area.png', 'thumbs/snap.png']);
      await thumbs.delete('m-area');
      await thumbs.delete('never-existed');
      expect(temp.files(), ['thumbs/snap.png']);
    });
  });

  group('readJpegSize', () {
    Uint8List fixture(String name) =>
        File('test/fixtures/images/$name').readAsBytesSync();

    test('baseline and progressive JPEGs', () {
      expect(readJpegSize(fixture('sample_40x30.jpg')), (
        width: 40,
        height: 30,
      ));
      expect(
        readJpegSize(fixture('progressive_123x77.jpg')),
        (width: 123, height: 77),
      );
    });

    test('non-JPEG or truncated data', () {
      expect(readJpegSize(Uint8List.fromList([0x89, 0x50, 0x4E])), isNull);
      final jpeg = fixture('sample_40x30.jpg');
      expect(readJpegSize(Uint8List.sublistView(jpeg, 0, 30)), isNull);
      expect(readJpegSize(Uint8List(0)), isNull);
    });
  });
}
