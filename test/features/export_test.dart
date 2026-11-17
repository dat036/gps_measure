import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/format/money_formatter.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/core/utils/id_generator.dart';
import 'package:gps_measurement/data/db/app_database.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/storage/export_storage.dart';
import 'package:gps_measurement/domain/geo/stats_calculator.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:gps_measurement/domain/models/photo.dart';
import 'package:gps_measurement/domain/premium/feature_gate.dart';
import 'package:gps_measurement/domain/units/land_value.dart';
import 'package:gps_measurement/features/export/csv_encoder.dart';
import 'package:gps_measurement/features/export/export_service.dart';
import 'package:gps_measurement/features/export/export_sheet.dart';
import 'package:gps_measurement/features/export/kml_encoder.dart';
import 'package:gps_measurement/features/export/pdf_report_builder.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:gps_measurement/features/premium/premium_flows.dart';
import 'package:gps_measurement/features/save/land_value_field.dart';
import 'package:gps_measurement/services/ads/rewarded_manager.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

import '../helpers/data.dart';
import '../helpers/fakes.dart';
import '../helpers/golden.dart';
import '../helpers/router.dart';

/// Set UPDATE_EXPORT_FIXTURES=1 to rewrite the expected files.
final bool _update = Platform.environment['UPDATE_EXPORT_FIXTURES'] == '1';

void expectFixture(String name, String actual) {
  final file = File('test/fixtures/export/$name');
  if (_update || !file.existsSync()) {
    file
      ..createSync(recursive: true)
      ..writeAsBytesSync(utf8.encode(actual));
  }
  // Bytes, not text: utf8.decode drops the BOM the CSV must keep.
  expect(file.readAsBytesSync(), utf8.encode(actual), reason: name);
}

final DateTime t0 = DateTime.utc(2026, 9, 29, 8);

MeasurePoint pt(int i, double lat, double lng, {int segment = 0}) =>
    MeasurePoint(
      id: 'p$i',
      orderIndex: i,
      segmentIndex: segment,
      lat: lat,
      lng: lng,
      accuracy: 4.5,
      altitude: 12,
      timestamp: t0.add(Duration(seconds: i * 2)),
    );

Measurement fixture(MeasurementType type, List<MeasurePoint> points) {
  final closed = type != MeasurementType.distance;
  return Measurement(
    id: 'm1',
    name: 'Ruộng Đông',
    type: type,
    status: MeasurementStatus.saved,
    mapStyle: MapStyle.satellite,
    createdAt: t0,
    updatedAt: t0,
    notes: 'Bờ tây giáp mương, "cột mốc" số 3',
    points: points,
    photos: [
      Photo(
        id: 'ph1',
        measurementId: 'm1',
        pointId: 'p2',
        filePath: 'photos/m1/ph1.jpg',
        thumbPath: 'photos/m1/ph1_t.jpg',
        takenAt: t0,
        source: PhotoSource.camera,
        width: 10,
        height: 10,
        bytes: 10,
        sortIndex: 0,
      ),
    ],
    stats: StatsCalculator.compute(
      type,
      points,
      closed: closed,
      durationSec: type == MeasurementType.walk ? 754 : null,
    ),
  );
}

final List<MeasurePoint> square = [
  pt(0, 21.0285, 105.8542),
  pt(1, 21.0285, 105.8552),
  pt(2, 21.0294, 105.8552),
  pt(3, 21.0294, 105.8542),
];

const KmlColors green = (line: 0xFF12A150, fill: 0x4712A150);

void main() {
  group('KmlEncoder', () {
    test('aabbggrr colors', () {
      expect(KmlEncoder.kmlColor(0xFF12A150), 'ff50a112');
      expect(KmlEncoder.kmlColor(0x471E6BFF), '47ff6b1e');
    });

    test('area: closed polygon ring, data, photo point', () {
      final kml = KmlEncoder.encode(
        fixture(MeasurementType.area, square),
        name: 'Ruộng Đông',
        colors: green,
      );
      final doc = XmlDocument.parse(kml);
      final ring = doc
          .findAllElements('coordinates')
          .first
          .innerText
          .split(' ');
      expect(ring, hasLength(5));
      expect(ring.first, ring.last);
      expect(ring.first, '105.8542,21.0285,0');
      final data = {
        for (final d in doc.findAllElements('Data'))
          d.getAttribute('name'): d.innerText.trim(),
      };
      expect(data['type'], 'area');
      expect(double.parse(data['area_m2']!), greaterThan(10000));
      expect(data['created_at'], '2026-09-29T08:00:00.000Z');
      expect(data.containsKey('distance_m'), isFalse);
      expect(
        doc.findAllElements('name').map((e) => e.innerText),
        contains('P3'),
      );
      expectFixture('area.kml', kml);
    });

    test('distance: LineString', () {
      final kml = KmlEncoder.encode(
        fixture(MeasurementType.distance, square.take(3).toList()),
        name: 'Road',
        colors: (line: 0xFF1E6BFF, fill: 0x471E6BFF),
      );
      final doc = XmlDocument.parse(kml);
      expect(doc.findAllElements('LineString'), hasLength(1));
      expect(doc.findAllElements('Polygon'), isEmpty);
      expectFixture('distance.kml', kml);
    });

    test('walk: one LineString per segment + polygon when closed', () {
      final walk = [
        pt(0, 21.0285, 105.8542),
        pt(1, 21.0285, 105.8552),
        pt(2, 21.0294, 105.8552, segment: 1),
        pt(3, 21.0294, 105.8542, segment: 1),
        pt(4, 21.02852, 105.85421, segment: 1),
      ];
      final m = fixture(MeasurementType.walk, walk);
      expect(m.stats.isClosed, isTrue);
      final kml = KmlEncoder.encode(
        m,
        name: 'Walk',
        colors: (line: 0xFFF58A07, fill: 0x4712A150),
      );
      final doc = XmlDocument.parse(kml);
      expect(doc.findAllElements('MultiGeometry'), hasLength(1));
      expect(doc.findAllElements('LineString'), hasLength(2));
      expect(doc.findAllElements('Polygon'), hasLength(1));
      expectFixture('walk.kml', kml);
    });

    test('no points: still a valid document', () {
      final kml = KmlEncoder.encode(
        fixture(MeasurementType.area, const []),
        name: 'Empty',
        colors: green,
      );
      expect(() => XmlDocument.parse(kml), returnsNormally);
    });
  });

  group('CsvEncoder', () {
    test('BOM, header, one row per point, repeated summary', () {
      final csv = CsvEncoder.encode(
        fixture(MeasurementType.area, square),
        name: 'Ruộng Đông, "Bắc"',
      );
      expect(csv.codeUnitAt(0), 0xFEFF);
      final lines = csv.substring(1).split('\r\n')
        ..removeWhere((l) => l.isEmpty);
      expect(lines.first, CsvEncoder.header.join(','));
      expect(lines, hasLength(5));
      expect(lines[1], startsWith('"Ruộng Đông, ""Bắc""",area,2026-09-29'));
      expect(lines[1], contains(',0,0,21.0285,105.8542,12,4.5,'));
      expectFixture('area.csv', csv);
    });

    test('no points → one summary row', () {
      final csv = CsvEncoder.encode(
        fixture(MeasurementType.distance, const []),
        name: 'x',
      );
      expect(csv.substring(1).trim().split('\r\n'), hasLength(2));
    });
  });

  test('slug', () {
    expect(ExportStorage.slug('Ruộng Đông (2)'), 'ruong_dong_2');
    expect(ExportStorage.slug('  ***  '), 'measurement');
    expect(ExportStorage.slug('a' * 60), hasLength(40));
  });

  group('ExportService', () {
    late AppDatabase db;
    late TempDirectories temp;
    late SharedPreferences prefs;
    late FixedClock clock;
    late ProviderContainer container;
    late _FakeSharer sharer;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      db = newTestDatabase();
      temp = TempDirectories();
      clock = FixedClock(DateTime(2026, 9, 29, 14, 5));
      sharer = _FakeSharer();
      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          appDirectoriesProvider.overrideWithValue(temp.dirs),
          appDatabaseProvider.overrideWithValue(db),
          imageCompressorProvider.overrideWithValue(FakeCompressor()),
          clockProvider.overrideWithValue(clock),
          idGeneratorProvider.overrideWithValue(SequentialIds()),
          fileSharerProvider.overrideWithValue(sharer),
        ],
      );
      addTearDown(container.dispose);
    });

    tearDown(() async {
      await db.close();
      temp.dispose();
    });

    Future<String> saved({String? name = 'Ruộng Đông'}) async {
      final repo = container.read(measurementRepositoryProvider);
      final m = await repo.createDraft(
        MeasurementType.area,
        MapStyle.satellite,
      );
      await repo.replacePoints(
        m.id,
        square,
        StatsCalculator.compute(MeasurementType.area, square, closed: true),
      );
      if (name != null) await repo.markSaved(m.id, name: name);
      return m.id;
    }

    ExportService service({bool premium = true}) => ExportService(
      repository: container.read(measurementRepositoryProvider),
      storage: ExportStorage(directories: temp.dirs, clock: clock),
      sharer: sharer,
      gate: FeatureGate(isPremium: premium),
      settings: container.read(settingsRepositoryProvider),
      photos: container.read(photoStorageProvider),
      clock: clock,
      loadFonts: () async => (
        pw.Font.ttf(
          ByteData.sublistView(
            File('assets/fonts/Inter-Regular.ttf').readAsBytesSync(),
          ),
        ),
        pw.Font.ttf(
          ByteData.sublistView(
            File('assets/fonts/Inter-Bold.ttf').readAsBytesSync(),
          ),
        ),
      ),
    );

    test('writes temp/exports/<slug>_<time>.<ext> and shares it', () async {
      final id = await saved();
      expect(
        await service().export(id, ExportFormat.csv, fallbackName: 'x'),
        ExportResult.shared,
      );
      final (file, mime, origin) = sharer.calls.single;
      expect(
        file.path.replaceAll(r'\', '/'),
        endsWith('/exports/ruong_dong_20260929_1405.csv'),
      );
      expect(mime, 'text/csv');
      expect(origin, isNull);
      final bytes = file.readAsBytesSync();
      expect(bytes.take(3), [0xEF, 0xBB, 0xBF]); // UTF-8 BOM
      expect(utf8.decode(bytes), contains('Ruộng Đông'));
    });

    test(
      'PDF report: premium writes <slug>_<time>.pdf and shares it',
      () async {
        final id = await saved();
        expect(
          await service().export(
            id,
            ExportFormat.pdf,
            fallbackName: 'x',
            pdf: PdfReportOptions.forLocale(
              const Locale('vi'),
              areaUnit: AreaUnit.hectare,
              distanceUnit: DistanceUnit.meter,
            ),
          ),
          ExportResult.shared,
        );
        final (file, mime, _) = sharer.calls.single;
        expect(
          file.path.replaceAll(r'\', '/'),
          endsWith('/exports/ruong_dong_20260929_1405.pdf'),
        );
        expect(mime, 'application/pdf');
        expect(utf8.decode(file.readAsBytesSync().take(5).toList()), '%PDF-');
      },
    );

    test('PDF report is Premium: a free user gets nothing', () async {
      final id = await saved();
      expect(
        await service(premium: false).export(
          id,
          ExportFormat.pdf,
          fallbackName: 'x',
        ),
        ExportResult.premiumRequired,
      );
      // Not even an ad-unlocked export opens it.
      expect(
        await service(premium: false).export(
          id,
          ExportFormat.pdf,
          fallbackName: 'x',
          unlocked: true,
        ),
        ExportResult.premiumRequired,
      );
      expect(sharer.calls, isEmpty);
    });

    test('unnamed draft uses the fallback name', () async {
      final id = await saved(name: null);
      await service().export(
        id,
        ExportFormat.kml,
        fallbackName: 'Untitled Area',
      );
      final (file, mime, _) = sharer.calls.single;
      expect(file.path, endsWith('untitled_area_20260929_1405.kml'));
      expect(mime, 'application/vnd.google-earth.kml+xml');
      expect(file.readAsStringSync(), contains('<name>Untitled Area</name>'));
    });

    test('free: one KML a day once shared; CSV always', () async {
      final id = await saved();
      final free = service(premium: false);
      sharer.accept = false;
      expect(
        await free.export(id, ExportFormat.kml, fallbackName: 'x'),
        ExportResult.dismissed,
      );
      sharer.accept = true;
      expect(
        await free.export(id, ExportFormat.kml, fallbackName: 'x'),
        ExportResult.shared,
      );
      expect(
        await free.export(id, ExportFormat.kml, fallbackName: 'x'),
        ExportResult.limitReached,
      );
      expect(
        await free.export(id, ExportFormat.csv, fallbackName: 'x'),
        ExportResult.shared,
      );
      clock.advance(const Duration(days: 1));
      expect(
        await free.export(id, ExportFormat.kml, fallbackName: 'x'),
        ExportResult.shared,
      );
    });

    test('missing measurement / share error → failed', () async {
      expect(
        await service().export('nope', ExportFormat.csv, fallbackName: 'x'),
        ExportResult.failed,
      );
      final id = await saved();
      sharer.fail = true;
      expect(
        await service().export(id, ExportFormat.csv, fallbackName: 'x'),
        ExportResult.failed,
      );
    });

    test('markSaved stores the land price; null clears it', () async {
      final repo = container.read(measurementRepositoryProvider);
      final id = await saved();
      await repo.markSaved(
        id,
        name: 'A',
        unitPrice: 50000000,
        unitPriceCurrency: 'VND',
        unitPriceArea: AreaUnit.hectare,
      );
      var m = (await repo.get(id))!;
      expect(
        (m.unitPrice, m.unitPriceCurrency, m.unitPriceArea),
        (
          50000000,
          'VND',
          AreaUnit.hectare,
        ),
      );
      await repo.markSaved(id, name: 'A');
      m = (await repo.get(id))!;
      expect(m.unitPrice, isNull);
      expect(m.unitPriceCurrency, isNull);
    });
  });

  group('land value', () {
    test('estimate', () {
      expect(
        LandValue.estimate(
          areaM2: 1080,
          unitPrice: 50000000,
          priceUnit: AreaUnit.hectare,
        ),
        closeTo(5400000, 1e-6),
      );
      expect(
        LandValue.estimate(
          areaM2: null,
          unitPrice: 1,
          priceUnit: AreaUnit.squareMeter,
        ),
        isNull,
      );
      expect(
        LandValue.estimate(
          areaM2: 10,
          unitPrice: 0,
          priceUnit: AreaUnit.squareMeter,
        ),
        isNull,
      );
      expect(LandValue.currencyForRegion('vn'), 'VND');
      expect(LandValue.currencyForRegion(null), 'USD');
    });

    test('price parsing and input formatting', () {
      expect(MoneyFormatter.parse('50.000.000', locale: 'vi'), 50000000);
      expect(MoneyFormatter.parse('50 000 000', locale: 'vi'), 50000000);
      expect(MoneyFormatter.parse('1,250.5', locale: 'en'), 1250.5);
      expect(MoneyFormatter.parse('abc', locale: 'en'), isNull);
      expect(MoneyFormatter.parse('', locale: 'en'), isNull);
      expect(MoneyFormatter.input(50000000, locale: 'vi'), '50.000.000');
    });

    testWidgets('field shows the estimate as you type (vi)', (tester) async {
      LandPrice? last;
      await tester.pumpWidget(
        testApp(
          locale: const Locale('vi'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LandValueField(
              areaM2: 1080,
              initial: (
                price: null,
                unit: AreaUnit.hectare,
                currency: 'VND',
              ),
              onChanged: (p) => last = p,
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), '50.000.000');
      await tester.pump();
      expect(find.text('Giá trị ước tính ≈ 5,4 triệu'), findsOneWidget);
      expect(last?.price, 50000000);
      await tester.enterText(find.byType(TextField), '0');
      await tester.pump();
      expect(find.text('Nhập đơn giá lớn hơn 0'), findsOneWidget);
    });
  });

  testWidgets('land value field fits a 360dp phone', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 700)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      testApp(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LandValueField(
            areaM2: 13603,
            initial: (price: 25000, unit: AreaUnit.squareFoot, currency: 'USD'),
            onChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull); // no RenderFlex overflow
    expect(find.textContaining('Estimated value'), findsOneWidget);
  });

  testWidgets('Export sheet runs the chosen format', (tester) async {
    final fake = _FakeExport();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          exportServiceProvider.overrideWithValue(fake),
        ],
        child: testApp(
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () => showExportSheet(
                context,
                'm1',
                type: MeasurementType.walk,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('KML — Google Earth'), findsOneWidget);
    await tester.tap(find.text('CSV — Excel'));
    await tester.pumpAndSettle();
    expect(fake.calls, [('m1', ExportFormat.csv, 'Untitled Walk')]);
    expect(find.text('KML — Google Earth'), findsNothing); // sheet closed
  });

  group('PDF row in the Export sheet', () {
    late SharedPreferences prefs;
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    Future<(_FakeExport, List<String>)> open(
      WidgetTester tester, {
      required bool premium,
    }) async {
      final fake = _FakeExport();
      final opened = <String>[];
      tester.view
        ..physicalSize = const Size(400, 900)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            exportServiceProvider.overrideWithValue(fake),
            featureGateProvider.overrideWithValue(
              FeatureGate(isPremium: premium),
            ),
          ],
          child: routerTestApp(
            paywallOpened: opened,
            child: Builder(
              builder: (context) => TextButton(
                onPressed: () => showExportSheet(context, 'm1'),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return (fake, opened);
    }

    testWidgets('free: badge, and a tap goes straight to the paywall', (
      tester,
    ) async {
      final (fake, opened) = await open(tester, premium: false);
      expect(find.text('PDF — Report'), findsOneWidget);
      expect(find.text('Premium'), findsOneWidget); // The badge.
      await tester.tap(find.text('PDF — Report'));
      await tester.pumpAndSettle();
      expect(opened, [PaywallSource.exportPdf]);
      expect(fake.calls, isEmpty);
      // Closing the paywall without buying: nothing is exported.
      await tester.tap(find.text('stub close'));
      await tester.pumpAndSettle();
      expect(fake.calls, isEmpty);
    });

    testWidgets('free: buying on the paywall runs the export', (tester) async {
      final (fake, _) = await open(tester, premium: false);
      await tester.tap(find.text('PDF — Report'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('stub buy'));
      await tester.pumpAndSettle();
      expect(fake.calls.map((c) => c.$2), [ExportFormat.pdf]);
      expect(fake.pdfOptions.single, isNotNull);
      expect(fake.pdfOptions.single!.locale, 'en');
    });

    testWidgets('premium: no badge, exports at once', (tester) async {
      final (fake, opened) = await open(tester, premium: true);
      expect(find.text('Premium'), findsNothing);
      await tester.tap(find.text('PDF — Report'));
      await tester.pumpAndSettle();
      expect(opened, isEmpty);
      expect(fake.calls.map((c) => c.$2), [ExportFormat.pdf]);
    });
  });

  group('KML limit reached', () {
    late SharedPreferences prefs;
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    Future<(_FakeExport, FakeRewarded)> openKml(
      WidgetTester tester,
      RewardOutcome reward,
    ) async {
      final fake = _FakeExport()..queue.add(ExportResult.limitReached);
      final rewarded = FakeRewarded(reward);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            exportServiceProvider.overrideWithValue(fake),
            rewardedManagerProvider.overrideWithValue(rewarded),
          ],
          child: testApp(
            child: Builder(
              builder: (context) => TextButton(
                onPressed: () => showExportSheet(context, 'm1'),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('KML — Google Earth'));
      // The tile spinner never settles: fixed pumps.
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text("Today's free KML export is used"), findsOneWidget);
      return (fake, rewarded);
    }

    testWidgets('a watched ad unlocks this one export', (tester) async {
      final (fake, rewarded) = await openKml(tester, RewardOutcome.earned);
      await tester.tap(find.text('Watch an ad'));
      await tester.pump(const Duration(milliseconds: 400));
      expect(rewarded.shown, 1);
      expect(fake.unlockedCalls, [false, true]);
    });

    testWidgets('no ad available: export anyway', (tester) async {
      final (fake, _) = await openKml(tester, RewardOutcome.unavailable);
      await tester.tap(find.text('Watch an ad'));
      await tester.pump(const Duration(milliseconds: 400));
      expect(fake.unlockedCalls, [false, true]);
    });

    testWidgets('ad closed early: no export, explained', (tester) async {
      final (fake, _) = await openKml(tester, RewardOutcome.dismissed);
      await tester.tap(find.text('Watch an ad'));
      await tester.pump(const Duration(milliseconds: 400));
      expect(fake.unlockedCalls, [false]);
      expect(
        find.text('Watch the ad to the end to unlock this export.'),
        findsOneWidget,
      );
    });

    testWidgets('cancel: nothing exported', (tester) async {
      final (fake, rewarded) = await openKml(tester, RewardOutcome.earned);
      await tester.tap(find.text('Cancel'));
      await tester.pump(const Duration(milliseconds: 400));
      expect(fake.unlockedCalls, [false]);
      expect(rewarded.shown, 0);
    });
  });
}

class _FakeSharer implements FileSharer {
  final List<(File, String, Rect?)> calls = [];
  bool accept = true;
  bool fail = false;

  @override
  Future<bool> share(
    File file, {
    required String mimeType,
    Rect? origin,
  }) async {
    if (fail) throw StateError('no share target');
    calls.add((file, mimeType, origin));
    return accept;
  }
}

class _FakeExport implements ExportService {
  final List<(String, ExportFormat, String)> calls = [];
  final List<bool> unlockedCalls = [];
  final List<PdfReportOptions?> pdfOptions = [];
  ExportResult next = ExportResult.shared;

  /// Answers in order (then [next]).
  final List<ExportResult> queue = [];

  @override
  Future<ExportResult> export(
    String measurementId,
    ExportFormat format, {
    required String fallbackName,
    Rect? shareOrigin,
    bool unlocked = false,
    PdfReportOptions? pdf,
  }) async {
    pdfOptions.add(pdf);
    calls.add((measurementId, format, fallbackName));
    unlockedCalls.add(unlocked);
    return queue.isEmpty ? next : queue.removeAt(0);
  }
}
