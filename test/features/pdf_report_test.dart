import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/domain/geo/stats_calculator.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:gps_measurement/domain/models/photo.dart';
import 'package:gps_measurement/features/export/pdf_report_builder.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdf/widgets.dart' as pw;

/// Set PDF_SAMPLE_DIR to write the generated reports there for a look.
final String? _sampleDir = Platform.environment['PDF_SAMPLE_DIR'];

final DateTime _t0 = DateTime.utc(2026, 10, 19, 7, 54);

MeasurePoint _pt(
  int i,
  double lat,
  double lng, {
  int segment = 0,
}) => MeasurePoint(
  id: 'p$i',
  orderIndex: i,
  segmentIndex: segment,
  lat: lat,
  lng: lng,
  timestamp: _t0.add(Duration(seconds: i * 2)),
);

// The sample report's farm (Chicago), 6 corners.
final List<MeasurePoint> _farm = [
  _pt(0, 41.878124, -87.630214),
  _pt(1, 41.878842, -87.629764),
  _pt(2, 41.878793, -87.628311),
  _pt(3, 41.877904, -87.627865),
  _pt(4, 41.877221, -87.628731),
  _pt(5, 41.877395, -87.630041),
];

Measurement _measurement(
  MeasurementType type,
  List<MeasurePoint> points, {
  String? name = 'My Farm',
  String? notes,
  List<Photo> photos = const [],
  bool closed = true,
}) => Measurement(
  id: '3f2a9c10-aaaa-bbbb-cccc-000000000001',
  name: name,
  type: type,
  status: MeasurementStatus.saved,
  mapStyle: MapStyle.satellite,
  createdAt: _t0,
  updatedAt: _t0,
  savedAt: _t0,
  notes: notes,
  points: points,
  photos: photos,
  stats: StatsCalculator.compute(
    type,
    points,
    closed: closed,
    durationSec: type == MeasurementType.walk ? 754 : null,
  ),
);

Photo _photo(int i, {String? pointId, String? caption}) => Photo(
  id: 'ph$i',
  measurementId: 'm1',
  pointId: pointId,
  filePath: 'photos/m1/ph$i.jpg',
  thumbPath: 'photos/m1/ph${i}_t.jpg',
  takenAt: _t0.add(Duration(minutes: i)),
  caption: caption,
  source: PhotoSource.camera,
  width: 160,
  height: 120,
  bytes: 1053,
  sortIndex: i,
);

void main() {
  late pw.Font regular;
  late pw.Font bold;
  late Uint8List jpeg;

  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('vi');
    pw.Font load(String name) => pw.Font.ttf(
      ByteData.sublistView(File('assets/fonts/$name').readAsBytesSync()),
    );
    regular = load('Inter-Regular.ttf');
    bold = load('Inter-Bold.ttf');
    jpeg = File('test/fixtures/report_photo.jpg').readAsBytesSync();
  });

  PdfReportOptions options({
    String lang = 'en',
    AreaUnit area = AreaUnit.hectare,
    DistanceUnit distance = DistanceUnit.meter,
  }) => PdfReportOptions.forLocale(
    Locale(lang),
    areaUnit: area,
    distanceUnit: distance,
  );

  Future<Uint8List> build(
    Measurement m, {
    String? name,
    PdfReportOptions? opts,
    List<PdfReportPhoto> photos = const [],
    int hidden = 0,
    String sample = '',
  }) async {
    final bytes = await PdfReportBuilder.build(
      PdfReportInput(
        measurement: m,
        name: name ?? m.name ?? 'Untitled',
        options: opts ?? options(),
        exportedAt: DateTime.utc(2026, 10, 19, 8, 2),
        regularFont: regular,
        boldFont: bold,
        photos: photos,
        hiddenPhotoCount: hidden,
      ),
    );
    final dir = _sampleDir;
    if (dir != null && sample.isNotEmpty) {
      Directory(dir).createSync(recursive: true);
      File('$dir/$sample.pdf').writeAsBytesSync(bytes);
    }
    return bytes;
  }

  int pages(Uint8List pdf) => RegExp(
    r'/Type\s*/Page(?!s)',
  ).allMatches(latin1.decode(pdf, allowInvalid: true)).length;

  test('helpers: coordinate, report id, scale bar length', () {
    expect(
      PdfReportBuilder.formatCoordinate(
        const GeoPoint(lat: 41.8781, lng: -87.6298),
      ),
      '41.8781° N, 87.6298° W',
    );
    expect(
      PdfReportBuilder.formatCoordinate(
        const GeoPoint(lat: -21.0285, lng: 105.8542),
      ),
      '21.0285° S, 105.8542° E',
    );
    expect(
      PdfReportBuilder.reportId(_measurement(MeasurementType.area, _farm)),
      matches(RegExp(r'^LM-AREA-2026\d{4}-3F2A$')),
    );
    expect(PdfReportBuilder.niceFloor(137), 100);
    expect(PdfReportBuilder.niceFloor(0.37), 0.2);
    expect(PdfReportBuilder.niceFloor(8), 5);
    expect(PdfReportBuilder.niceFloor(2), 2);
    expect(PdfReportBuilder.niceFloor(0), 1);
  });

  test('Hindi and Chinese fall back to an English report', () {
    for (final lang in ['hi', 'zh']) {
      final o = options(lang: lang);
      expect(o.locale, 'en');
      expect(o.l10n.pdfReportTitleArea, 'Land Measurement Report');
    }
    expect(options(lang: 'vi').l10n.pdfReportTitleArea, 'Báo cáo đo đất');
  });

  test('area report: a valid PDF', () async {
    final pdf = await build(
      _measurement(
        MeasurementType.area,
        _farm,
        notes: 'North field, corn plantation. Measured along the fence line.',
      ),
      sample: 'area_en',
    );
    expect(latin1.decode(pdf.sublist(0, 5)), '%PDF-');
    expect(pages(pdf), greaterThanOrEqualTo(1));
  });

  test('Vietnamese name, notes and labels', () async {
    final pdf = await build(
      _measurement(
        MeasurementType.area,
        _farm,
        name: 'Ruộng Đông — thửa số 3',
        notes: 'Bờ tây giáp mương; “cột mốc” số 3.',
      ),
      opts: options(lang: 'vi'),
      sample: 'area_vi',
    );
    expect(latin1.decode(pdf.sublist(0, 5)), '%PDF-');
  });

  test('distance route and open walk', () async {
    final route = [_farm[0], _farm[1], _farm[2]];
    final distance = await build(
      _measurement(MeasurementType.distance, route, name: 'Fence line'),
      opts: options(distance: DistanceUnit.foot),
      sample: 'distance',
    );
    expect(pages(distance), greaterThanOrEqualTo(1));

    // A walk with a pause: two segments, not closed → "Not closed".
    final walk = [
      for (var i = 0; i < 20; i++)
        _pt(i, 21.0285 + i * 0.00005, 105.8542 + i * 0.00002, segment: i ~/ 10),
    ];
    final walkPdf = await build(
      _measurement(MeasurementType.walk, walk, name: 'Walk', closed: false),
      sample: 'walk_open',
    );
    expect(pages(walkPdf), greaterThanOrEqualTo(1));
  });

  test('closed walk with thousands of points stays short', () async {
    // 2,000-point loop: only the first rows are listed, file stays small.
    final loop = [
      for (var i = 0; i < 2000; i++)
        _pt(
          i,
          21.0285 + 0.001 * (1 - (i / 1000 - 1).abs()).clamp(0, 1),
          105.8542 + 0.001 * (i < 1000 ? i / 1000 : 2 - i / 1000),
        ),
    ];
    final pdf = await build(
      _measurement(MeasurementType.walk, loop, name: 'Big walk'),
      sample: 'walk_big',
    );
    expect(pages(pdf), lessThan(8));
    expect(pdf.length, lessThan(400 * 1024));
  });

  test('single point and no points do not crash', () async {
    expect(
      await build(
        _measurement(MeasurementType.walk, [_farm.first], closed: false),
      ),
      isNotEmpty,
    );
    expect(
      await build(_measurement(MeasurementType.area, const [], closed: false)),
      isNotEmpty,
    );
  });

  test('photos are embedded; a broken file keeps its caption', () async {
    final m = _measurement(
      MeasurementType.area,
      _farm,
      photos: [
        _photo(0, pointId: 'p0', caption: 'North boundary / fence marker'),
        _photo(1),
        _photo(2),
      ],
    );
    final plain = await build(m);
    final withPhotos = await build(
      m,
      photos: [
        (photo: m.photos[0], bytes: jpeg),
        (photo: m.photos[1], bytes: jpeg),
        (photo: m.photos[2], bytes: Uint8List.fromList([1, 2, 3])),
      ],
      hidden: 2,
      sample: 'area_photos',
    );
    // Two 1 KB JPEGs are embedded as they are.
    expect(withPhotos.length, greaterThan(plain.length));
  });

  test('long notes flow onto more pages', () async {
    final pdf = await build(
      _measurement(
        MeasurementType.area,
        _farm,
        notes: List.filled(120, 'Site condition line.').join('\n'),
      ),
    );
    expect(pages(pdf), greaterThanOrEqualTo(2));
  });
}
