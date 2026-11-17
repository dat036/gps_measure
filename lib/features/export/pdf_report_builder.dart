import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' show Color, Locale;

import 'package:gps_measurement/core/format/date_formatter.dart';
import 'package:gps_measurement/core/format/duration_formatter.dart';
import 'package:gps_measurement/core/format/unit_formatter.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/domain/geo/geo_calculator.dart';
import 'package:gps_measurement/domain/geo/local_projection.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:gps_measurement/domain/models/photo.dart';
import 'package:gps_measurement/domain/units/unit_converter.dart';
import 'package:gps_measurement/l10n/gen/app_localizations.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// A photo for the report: its row and the JPEG bytes (already compressed
/// by `PhotoStorage`, embedded as is).
typedef PdfReportPhoto = ({Photo photo, Uint8List bytes});

/// How the report is written: language, units, and the display options the
/// user picked in Settings.
class PdfReportOptions {
  const PdfReportOptions({
    required this.l10n,
    required this.locale,
    required this.areaUnit,
    required this.distanceUnit,
    this.showSecondaryUnit = true,
  });

  /// Report in [locale] when the bundled font can draw it, else English.
  factory PdfReportOptions.forLocale(
    Locale locale, {
    required AreaUnit areaUnit,
    required DistanceUnit distanceUnit,
    bool showSecondaryUnit = true,
  }) {
    final code = supportsLocale(locale) ? locale.languageCode : 'en';
    return PdfReportOptions(
      l10n: lookupAppLocalizations(Locale(code)),
      locale: code,
      areaUnit: areaUnit,
      distanceUnit: distanceUnit,
      showSecondaryUnit: showSecondaryUnit,
    );
  }

  /// Languages the bundled Inter font has glyphs for.
  /// Hindi, Chinese and Thai fall back to an English report because the
  /// bundled font does not include Devanagari, CJK or Thai glyphs.
  static const Set<String> latinLanguages = {
    'en',
    'vi',
    'es',
    'pt',
    'id',
    'fr',
    'de',
    'pl',
    'nl',
  };

  static bool supportsLocale(Locale locale) =>
      latinLanguages.contains(locale.languageCode);

  final AppLocalizations l10n;

  /// `en`, `vi`… for number and date formats.
  final String locale;
  final AreaUnit areaUnit;
  final DistanceUnit distanceUnit;
  final bool showSecondaryUnit;
}

/// Everything the report needs; the builder does no I/O.
class PdfReportInput {
  const PdfReportInput({
    required this.measurement,
    required this.name,
    required this.options,
    required this.exportedAt,
    required this.regularFont,
    required this.boldFont,
    this.photos = const [],
    this.hiddenPhotoCount = 0,
    this.isIos = false,
  });

  final Measurement measurement;

  /// The measurement's name, "Untitled Area" when it has none.
  final String name;
  final PdfReportOptions options;
  final DateTime exportedAt;
  final pw.Font regularFont;
  final pw.Font boldFont;
  final List<PdfReportPhoto> photos;

  /// Photos left out to keep the file small.
  final int hiddenPhotoCount;
  final bool isIos;
}

/// A4 report of one measurement, modelled on the sample in `plan.md` P11
/// (header, meta, summary, map, coordinates, notes, photos, export info,
/// accuracy notice). Pure Dart + `package:pdf`, so it is unit-testable.
abstract final class PdfReportBuilder {
  /// Longest coordinate table (a long Walk has thousands of points; the
  /// CSV export has them all).
  static const int maxCoordinateRows = 120;
  static const int maxPhotos = 8;

  static const double _margin = 40;
  static const double _contentWidth = 595.28 - 2 * _margin;
  static const double _mapHeight = 250;
  static const double _mapPad = 34;
  static const int _maxLabeledPoints = 40;
  static const int _maxDotPoints = 150;

  static const LmColors _c = LmColors.light;

  static PdfColor _pdf(Color color) => PdfColor.fromInt(color.toARGB32());

  static Future<Uint8List> build(PdfReportInput input) async {
    final m = input.measurement;
    final l10n = input.options.l10n;
    final theme = pw.ThemeData.withFont(
      base: input.regularFont,
      bold: input.boldFont,
    );
    final doc = pw.Document(
      title: input.name,
      author: 'LandMeasure',
      creator: 'LandMeasure',
      subject: l10n.pdfHeaderLabel,
      theme: theme,
    );
    final report = _Report(input);
    doc.addPage(
      pw.MultiPage(
        maxPages: 60,
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          theme: theme,
          margin: const pw.EdgeInsets.fromLTRB(_margin, 30, _margin, 28),
        ),
        header: report.header,
        footer: report.footer,
        build: (_) => [
          report.title(),
          pw.SizedBox(height: 14),
          report.metaTable(),
          pw.SizedBox(height: 18),
          report.sectionTitle(l10n.pdfSummary),
          report.summaryTable(),
          pw.SizedBox(height: 18),
          report.sectionTitle(l10n.pdfMapBoundary),
          report.map(),
          pw.SizedBox(height: 18),
          if (m.points.isNotEmpty) ...[
            report.sectionTitle(l10n.pdfCoordinates),
            ...report.coordinates(),
            pw.SizedBox(height: 18),
          ],
          if (m.notes?.trim().isNotEmpty ?? false) ...[
            report.sectionTitle(l10n.pdfNotes),
            ...report.notes(),
            pw.SizedBox(height: 18),
          ],
          if (input.photos.isNotEmpty) ...[
            report.sectionTitle(l10n.pdfPhotos),
            ...report.photos(),
            pw.SizedBox(height: 18),
          ],
          report.sectionTitle(l10n.pdfExportInfo),
          report.exportInfo(),
          pw.SizedBox(height: 16),
          report.accuracyNotice(),
        ],
      ),
    );
    return doc.save();
  }

  /// `41.8781° N, 87.6298° W`.
  static String formatCoordinate(GeoPoint p) {
    final ns = p.lat >= 0 ? 'N' : 'S';
    final ew = p.lng >= 0 ? 'E' : 'W';
    return '${p.lat.abs().toStringAsFixed(4)}° $ns, '
        '${p.lng.abs().toStringAsFixed(4)}° $ew';
  }

  /// `LM-AREA-20261019-3F2A`: type, save date, and 4 characters of the id.
  static String reportId(Measurement m) {
    final d = (m.savedAt ?? m.createdAt).toLocal();
    final stamp =
        '${d.year}${d.month.toString().padLeft(2, '0')}'
        '${d.day.toString().padLeft(2, '0')}';
    final compact = m.id.replaceAll('-', '').toUpperCase();
    final tail = compact.length >= 4 ? compact.substring(0, 4) : compact;
    return 'LM-${m.type.name.toUpperCase()}-$stamp-$tail';
  }

  /// 1, 2 or 5 × 10^k not above [value] (scale bar length).
  static double niceFloor(double value) {
    if (value <= 0) return 1;
    final exp = (math.log(value) / math.ln10).floor();
    final base = math.pow(10, exp).toDouble();
    final f = value / base;
    final n = f >= 5 ? 5 : (f >= 2 ? 2 : 1);
    return n * base;
  }
}

/// A point in report-map coordinates (PDF space, origin bottom-left).
typedef _Xy = ({double x, double y});

class _MapLayout {
  _MapLayout(this.measurement, this.width, this.height, double pad) {
    final pts = measurement.points;
    final geo = [for (final p in pts) p.position];
    final bounds = GeoCalculator.bounds(geo);
    center = bounds?.center ?? const GeoPoint(lat: 0, lng: 0);
    final proj = LocalProjection(center);
    final xy = [for (final g in geo) proj.toXY(g)];
    var minX = double.infinity;
    var maxX = -double.infinity;
    var minY = double.infinity;
    var maxY = -double.infinity;
    for (final (x, y) in xy) {
      minX = math.min(minX, x);
      maxX = math.max(maxX, x);
      minY = math.min(minY, y);
      maxY = math.max(maxY, y);
    }
    if (xy.isEmpty) {
      minX = maxX = minY = maxY = 0;
    }
    // At least 1 m so a single point or a straight line still has a scale.
    final spanX = math.max(maxX - minX, 1);
    final spanY = math.max(maxY - minY, 1);
    scale = math.min((width - 2 * pad) / spanX, (height - 2 * pad) / spanY);
    final offX = (width - spanX * scale) / 2 - minX * scale;
    final offY = (height - spanY * scale) / 2 - minY * scale;
    points = [
      for (final (x, y) in xy) (x: x * scale + offX, y: y * scale + offY),
    ];
  }

  final Measurement measurement;
  final double width;
  final double height;
  late final GeoPoint center;

  /// PDF points per meter.
  late final double scale;
  late final List<_Xy> points;
}

class _Report {
  _Report(this.input)
    : m = input.measurement,
      l10n = input.options.l10n,
      locale = input.options.locale,
      mode = ModeColors.from(LmColors.light, input.measurement.type);

  final PdfReportInput input;
  final Measurement m;
  final AppLocalizations l10n;
  final String locale;
  final ModeColors mode;

  LmColors get c => PdfReportBuilder._c;
  PdfColor _p(Color color) => PdfReportBuilder._pdf(color);

  pw.TextStyle _text({
    double size = 9.5,
    Color? color,
    bool bold = false,
  }) => pw.TextStyle(
    fontSize: size,
    color: _p(color ?? c.textPrimary),
    fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
    lineSpacing: 2,
  );

  pw.TextStyle _caps({Color? color}) => pw.TextStyle(
    fontSize: 7,
    color: _p(color ?? c.textSecondary),
    fontWeight: pw.FontWeight.bold,
    letterSpacing: 0.3,
  );

  String _typeLabel() => switch (m.type) {
    MeasurementType.area => l10n.measurementTypeArea,
    MeasurementType.distance => l10n.measurementTypeDistance,
    MeasurementType.walk => l10n.measurementTypeWalk,
  };

  AreaUnit get _areaUnit => m.displayAreaUnit ?? input.options.areaUnit;
  DistanceUnit get _distanceUnit =>
      m.displayDistanceUnit ?? input.options.distanceUnit;

  // ---------------------------------------------------------------- frame

  pw.Widget header(pw.Context context) => pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 14),
    padding: const pw.EdgeInsets.only(bottom: 8),
    decoration: pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: _p(c.divider))),
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Row(
          children: [
            pw.Container(
              width: 24,
              height: 24,
              alignment: pw.Alignment.center,
              decoration: pw.BoxDecoration(
                color: _p(c.brandPrimary),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Text(
                'LM',
                style: _text(size: 8, color: c.onMode, bold: true),
              ),
            ),
            pw.SizedBox(width: 8),
            pw.Text('LandMeasure', style: _text(size: 11, bold: true)),
          ],
        ),
        pw.Text(
          l10n.pdfHeaderLabel,
          style: _text(size: 8, color: c.textSecondary),
        ),
      ],
    ),
  );

  pw.Widget footer(pw.Context context) {
    final small = _text(size: 7, color: c.textTertiary);
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 10),
      padding: const pw.EdgeInsets.only(top: 6),
      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: _p(c.divider))),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(l10n.pdfFooterGenerated, style: small),
          ),
          pw.Expanded(
            child: pw.Text(
              l10n.pdfFooterEstimate,
              style: small,
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              l10n.pdfPage(context.pageNumber, context.pagesCount),
              style: small,
              textAlign: pw.TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------- blocks

  pw.Widget title() {
    final title = switch (m.type) {
      MeasurementType.area => l10n.pdfReportTitleArea,
      MeasurementType.distance => l10n.pdfReportTitleDistance,
      MeasurementType.walk => l10n.pdfReportTitleWalk,
    };
    return pw.SizedBox(
      width: PdfReportBuilder._contentWidth,
      child: pw.Column(
        children: [
          pw.Text(
            title,
            style: _text(size: 22, bold: true),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            l10n.pdfReportSubtitle,
            style: _text(size: 9, color: c.textSecondary),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  pw.Widget sectionTitle(String text) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 7),
    child: pw.Text(text, style: _text(size: 13, bold: true)),
  );

  pw.TableBorder get _border =>
      pw.TableBorder.all(color: _p(c.divider), width: 0.6);

  pw.Widget _cell(
    pw.Widget child, {
    Color? background,
    double vertical = 6,
  }) => pw.Container(
    color: background == null ? null : _p(background),
    padding: pw.EdgeInsets.symmetric(horizontal: 9, vertical: vertical),
    child: child,
  );

  pw.Widget metaTable() {
    final saved = m.savedAt ?? m.createdAt;
    pw.Widget head(String label) => _cell(
      pw.Text(label.toUpperCase(), style: _caps()),
      background: c.surfacePage,
    );
    return pw.Table(
      border: _border,
      columnWidths: const {
        0: pw.FlexColumnWidth(3.2),
        1: pw.FlexColumnWidth(1.6),
        2: pw.FlexColumnWidth(2.4),
        3: pw.FlexColumnWidth(3),
      },
      children: [
        pw.TableRow(
          children: [
            head(l10n.pdfName),
            head(l10n.pdfType),
            head(l10n.pdfDateSaved),
            head(l10n.pdfReportId),
          ],
        ),
        pw.TableRow(
          verticalAlignment: pw.TableCellVerticalAlignment.middle,
          children: [
            _cell(
              pw.Text(input.name, style: _text(size: 11, bold: true)),
              vertical: 9,
            ),
            _cell(
              pw.Text(
                _typeLabel().toUpperCase(),
                style: _text(size: 9, color: mode.main, bold: true),
              ),
              vertical: 9,
            ),
            _cell(
              pw.Text(
                DateFormatter.dateTime(saved, locale),
                style: _text(size: 9),
              ),
              vertical: 9,
            ),
            _cell(
              pw.Text(
                PdfReportBuilder.reportId(m),
                style: _text(size: 9),
              ),
              vertical: 9,
            ),
          ],
        ),
      ],
    );
  }

  /// (label, value, sub line) of the four summary cells.
  List<(String, String, String)> _summaryCells() {
    final s = m.stats;
    final units = input.options;
    String area(double v) => UnitFormatter.areaWithSecondary(
      v,
      _areaUnit,
      locale,
      secondary: units.showSecondaryUnit,
    ).primary;
    String? areaSecondary(double v) => UnitFormatter.areaWithSecondary(
      v,
      _areaUnit,
      locale,
      secondary: units.showSecondaryUnit,
    ).secondary;
    String dist(double v) => UnitFormatter.distanceWithSecondary(
      v,
      _distanceUnit,
      locale,
      secondary: units.showSecondaryUnit,
    ).primary;
    String? distSecondary(double v) => UnitFormatter.distanceWithSecondary(
      v,
      _distanceUnit,
      locale,
      secondary: units.showSecondaryUnit,
    ).secondary;
    const dash = '—';
    final count = '${s.pointCount}';
    switch (m.type) {
      case MeasurementType.area:
        return [
          (
            l10n.pdfArea,
            s.areaM2 == null ? dash : area(s.areaM2!),
            s.areaM2 == null ? '' : areaSecondary(s.areaM2!) ?? '',
          ),
          (
            l10n.pdfPerimeter,
            s.perimeterM == null ? dash : dist(s.perimeterM!),
            s.perimeterM == null ? '' : distSecondary(s.perimeterM!) ?? '',
          ),
          (l10n.pdfPoints, count, l10n.pdfSubBoundaryVertices),
          (l10n.pdfMethod, l10n.pdfMethodMapPoints, l10n.pdfMethodPolygon),
        ];
      case MeasurementType.distance:
        return [
          (
            l10n.pdfDistance,
            s.distanceM == null ? dash : dist(s.distanceM!),
            s.distanceM == null ? '' : distSecondary(s.distanceM!) ?? '',
          ),
          (
            l10n.pdfSegments,
            '${math.max(s.pointCount - 1, 0)}',
            l10n.pdfSubSegments,
          ),
          (l10n.pdfPoints, count, l10n.pdfSubRoutePoints),
          (l10n.pdfMethod, l10n.pdfMethodMapPoints, l10n.pdfMethodRoute),
        ];
      case MeasurementType.walk:
        return [
          (
            l10n.pdfDistance,
            s.distanceM == null ? dash : dist(s.distanceM!),
            s.distanceM == null ? '' : distSecondary(s.distanceM!) ?? '',
          ),
          (
            l10n.pdfDuration,
            s.durationSec == null
                ? dash
                : DurationFormatter.hms(s.durationSec!),
            '',
          ),
          if (s.areaM2 == null)
            (l10n.pdfArea, l10n.pdfAreaNotClosed, l10n.pdfAreaNotClosedSub)
          else
            (l10n.pdfArea, area(s.areaM2!), areaSecondary(s.areaM2!) ?? ''),
          (l10n.pdfPoints, count, l10n.pdfSubTrackPoints),
        ];
    }
  }

  pw.Widget summaryTable() {
    final cells = _summaryCells();
    final bg = mode.container;
    return pw.Table(
      border: pw.TableBorder.all(color: _p(c.divider), width: 0.6),
      // Fill each cell so the tinted background has no gaps.
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.full,
      children: [
        pw.TableRow(
          children: [
            for (final (label, _, _) in cells)
              _cell(
                pw.Text(label.toUpperCase(), style: _caps()),
                background: bg,
              ),
          ],
        ),
        pw.TableRow(
          children: [
            for (final (_, value, _) in cells)
              _cell(
                pw.Text(value, style: _text(size: 18, bold: true)),
                background: bg,
                vertical: 7,
              ),
          ],
        ),
        pw.TableRow(
          children: [
            for (final (_, _, sub) in cells)
              _cell(
                pw.Text(
                  sub,
                  style: _text(size: 8, color: c.textSecondary),
                ),
                background: bg,
                vertical: 5,
              ),
          ],
        ),
      ],
    );
  }

  // ------------------------------------------------------------------ map

  pw.Widget map() {
    const w = PdfReportBuilder._contentWidth;
    const h = PdfReportBuilder._mapHeight;
    final layout = _MapLayout(m, w, h, PdfReportBuilder._mapPad);
    final pts = layout.points;
    final labeled =
        m.type != MeasurementType.walk &&
        pts.length <= PdfReportBuilder._maxLabeledPoints;

    final labels = <pw.Widget>[];
    if (labeled) {
      for (final (i, p) in pts.indexed) {
        labels.add(
          pw.Positioned(
            left: p.x + 7,
            top: h - p.y - 15,
            child: pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 2,
                vertical: 1,
              ),
              decoration: pw.BoxDecoration(
                color: const PdfColor(1, 1, 1, 0.82),
                borderRadius: pw.BorderRadius.circular(2),
              ),
              child: pw.Text(
                'P${i + 1}',
                style: _text(size: 6.5, bold: true),
              ),
            ),
          ),
        );
      }
    }

    // Scale bar (bottom-left) and north arrow (top-right).
    final f = UnitConverter.distanceTo(1, _distanceUnit);
    const targetPt = 110.0;
    final niceInUnit = PdfReportBuilder.niceFloor(
      UnitConverter.distanceTo(targetPt / layout.scale, _distanceUnit),
    );
    final barPt = niceInUnit / f * layout.scale;
    final decimals = niceInUnit < 1
        ? (-(math.log(niceInUnit) / math.ln10)).ceil()
        : 0;
    final barLabel =
        '${UnitFormatter.number(niceInUnit, decimals, locale)} '
        '${UnitFormatter.distanceSymbol(_distanceUnit)}';

    labels
      ..add(
        pw.Positioned(
          left: 14,
          top: h - 34,
          child: pw.Text(barLabel, style: _text(size: 7, bold: true)),
        ),
      )
      ..add(
        pw.Positioned(
          right: 14,
          top: 8,
          child: pw.Text('N', style: _text(size: 8, bold: true)),
        ),
      );

    final painter = _MapPainter(
      measurement: m,
      layout: layout,
      colors: c,
      mode: mode,
      barPt: barPt,
      drawDots: pts.length <= PdfReportBuilder._maxDotPoints,
    );

    final center = PdfReportBuilder.formatCoordinate(layout.center);
    final styleLabel = switch (m.mapStyle) {
      MapStyle.standard => l10n.mapStyleStandard,
      MapStyle.satellite => l10n.mapStyleSatellite,
      MapStyle.terrain => l10n.mapStyleTerrain,
      MapStyle.hybrid => l10n.mapStyleHybrid,
    };
    final units = m.type == MeasurementType.distance
        ? UnitFormatter.distanceSymbol(_distanceUnit)
        : '${UnitFormatter.areaSymbol(_areaUnit)} · '
              '${UnitFormatter.distanceSymbol(_distanceUnit)}';

    pw.Widget info(String label, String value) => _cell(
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: _text(size: 8.5, bold: true)),
          pw.SizedBox(height: 2),
          pw.Text(value, style: _text(size: 9)),
        ],
      ),
      background: c.surfacePage,
      vertical: 8,
    );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: w,
          height: h,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: _p(c.divider), width: 0.6),
          ),
          child: pw.Stack(
            children: [
              pw.CustomPaint(
                size: const PdfPoint(w, h),
                painter: painter.paint,
              ),
              ...labels,
            ],
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          l10n.pdfMapCaption,
          style: _text(size: 7.5, color: c.textTertiary),
        ),
        pw.SizedBox(height: 6),
        pw.Table(
          border: _border,
          children: [
            pw.TableRow(
              children: [
                info(l10n.pdfCenter, center),
                info(l10n.pdfMapStyle, styleLabel),
                info(l10n.pdfDisplayUnits, units),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // --------------------------------------------------------- coordinates

  /// Distance from point [i] to the next one, in the display unit; null for
  /// the last point of an open line or of a Walk segment.
  double? _segmentMeters(int i) {
    final pts = m.points;
    final isRing = m.type == MeasurementType.area && pts.length >= 3;
    MeasurePoint? next;
    if (i + 1 < pts.length) {
      next = pts[i + 1];
      if (m.type == MeasurementType.walk &&
          next.segmentIndex != pts[i].segmentIndex) {
        next = null;
      }
    } else if (isRing) {
      next = pts.first;
    }
    if (next == null) return null;
    return GeoCalculator.distance(pts[i].position, next.position);
  }

  /// Direct children of the page flow (a Column would have to fit on one
  /// page; a Table and a Wrap can span pages).
  List<pw.Widget> coordinates() {
    final pts = m.points;
    final shown = math.min(pts.length, PdfReportBuilder.maxCoordinateRows);
    final photoPointIds = {
      for (final p in m.photos)
        if (p.pointId != null) p.pointId!,
    };
    String noteFor(int i) {
      final notes = <String>[
        if (m.type != MeasurementType.area && i == 0) l10n.pdfNoteStart,
        if (m.type != MeasurementType.area && i == pts.length - 1)
          l10n.pdfNoteEnd,
        if (photoPointIds.contains(pts[i].id)) l10n.pdfNotePhoto,
      ];
      return notes.join(' · ');
    }

    pw.Widget head(String label) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      child: pw.Text(
        label,
        style: _text(size: 8.5, color: c.surfaceCard, bold: true),
      ),
    );
    pw.Widget body(String text, {bool bold = false}) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      child: pw.Text(text, style: _text(size: 8.5, bold: bold)),
    );

    final rows = <pw.TableRow>[
      pw.TableRow(
        repeat: true,
        decoration: pw.BoxDecoration(color: _p(c.textPrimary)),
        children: [
          head(l10n.pdfColPoint),
          head(l10n.pdfColLatitude),
          head(l10n.pdfColLongitude),
          head(l10n.pdfColSegment),
          head(l10n.pdfColNote),
        ],
      ),
      for (var i = 0; i < shown; i++)
        pw.TableRow(
          decoration: pw.BoxDecoration(
            color: i.isOdd ? _p(c.surfacePage) : _p(c.surfaceCard),
          ),
          children: [
            body('P${i + 1}'),
            body(pts[i].lat.toStringAsFixed(6)),
            body(pts[i].lng.toStringAsFixed(6)),
            body(() {
              final meters = _segmentMeters(i);
              return meters == null
                  ? '—'
                  : UnitFormatter.distance(meters, _distanceUnit, locale);
            }()),
            body(noteFor(i)),
          ],
        ),
    ];

    return [
      pw.Text(
        l10n.pdfCoordinatesHint,
        style: _text(size: 8, color: c.textSecondary),
      ),
      pw.SizedBox(height: 6),
      pw.Table(
        border: pw.TableBorder(
          bottom: pw.BorderSide(color: _p(c.divider), width: 0.6),
          horizontalInside: pw.BorderSide(color: _p(c.divider), width: 0.4),
          left: pw.BorderSide(color: _p(c.divider), width: 0.6),
          right: pw.BorderSide(color: _p(c.divider), width: 0.6),
        ),
        columnWidths: const {
          0: pw.FlexColumnWidth(),
          1: pw.FlexColumnWidth(2),
          2: pw.FlexColumnWidth(2),
          3: pw.FlexColumnWidth(1.7),
          4: pw.FlexColumnWidth(3),
        },
        children: rows,
      ),
      if (pts.length > shown) ...[
        pw.SizedBox(height: 5),
        pw.Text(
          l10n.pdfMorePoints(pts.length - shown),
          style: _text(size: 8, color: c.textSecondary),
        ),
      ],
    ];
  }

  // ---------------------------------------------------------------- notes

  /// One table row per paragraph, so a long note continues on the next page.
  List<pw.Widget> notes() {
    final lines = m.notes!.trim().split(RegExp(r'\r?\n'));
    return [
      pw.Table(
        border: pw.TableBorder(
          left: pw.BorderSide(color: _p(c.divider), width: 0.6),
          right: pw.BorderSide(color: _p(c.divider), width: 0.6),
          top: pw.BorderSide(color: _p(c.divider), width: 0.6),
          bottom: pw.BorderSide(color: _p(c.divider), width: 0.6),
        ),
        children: [
          for (final line in lines)
            pw.TableRow(
              decoration: pw.BoxDecoration(color: _p(c.surfacePage)),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 3,
                  ),
                  child: pw.Text(line.isEmpty ? ' ' : line, style: _text()),
                ),
              ],
            ),
        ],
      ),
    ];
  }

  // --------------------------------------------------------------- photos

  List<pw.Widget> photos() {
    const gap = 12.0;
    // A hair under half so floating point never pushes one to the next row.
    const colW = (PdfReportBuilder._contentWidth - gap) / 2 - 0.5;
    final indexOfPoint = {
      for (final (i, p) in m.points.indexed) p.id: i,
    };
    final cards = <pw.Widget>[];
    for (final (i, item) in input.photos.indexed) {
      pw.ImageProvider? image;
      try {
        image = pw.MemoryImage(item.bytes);
      } on Object {
        image = null; // Unreadable file: keep the caption.
      }
      final photo = item.photo;
      final pointIndex = photo.pointId == null
          ? null
          : indexOfPoint[photo.pointId];
      final caption = photo.caption?.trim();
      cards.add(
        pw.Container(
          width: colW,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                height: 150,
                width: colW,
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(
                  color: _p(c.surfacePage),
                  border: pw.Border.all(color: _p(c.divider), width: 0.6),
                ),
                child: image == null ? null : pw.Image(image),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                l10n.pdfPhotoN(i + 1),
                style: _text(size: 9, bold: true),
              ),
              if (caption != null && caption.isNotEmpty)
                pw.Text(caption, style: _text(size: 8.5)),
              if (pointIndex != null)
                pw.Text(
                  l10n.pdfPhotoPoint('P${pointIndex + 1}'),
                  style: _text(size: 8, color: c.textSecondary),
                ),
              pw.Text(
                l10n.pdfCaptured(DateFormatter.dateTime(photo.takenAt, locale)),
                style: _text(size: 8, color: c.textTertiary),
              ),
              pw.SizedBox(height: 4),
            ],
          ),
        ),
      );
    }
    return [
      pw.Wrap(spacing: gap, runSpacing: 10, children: cards),
      if (input.hiddenPhotoCount > 0) ...[
        pw.SizedBox(height: 4),
        pw.Text(
          l10n.pdfMorePhotos(input.hiddenPhotoCount),
          style: _text(size: 8, color: c.textSecondary),
        ),
      ],
    ];
  }

  // ----------------------------------------------------------- export info

  pw.Widget exportInfo() {
    final rows = <(String, String)>[
      (
        l10n.pdfSource,
        input.isIos ? l10n.pdfSourceIos : l10n.pdfSourceAndroid,
      ),
      (l10n.pdfType, _typeLabel()),
      (l10n.pdfCoordFormat, l10n.pdfCoordFormatValue),
      (l10n.pdfExported, DateFormatter.dateTime(input.exportedAt, locale)),
      (l10n.pdfCompanion, 'KML, CSV'),
    ];
    return pw.Table(
      border: _border,
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.full,
      columnWidths: const {
        0: pw.FlexColumnWidth(2.2),
        1: pw.FlexColumnWidth(5),
      },
      children: [
        for (final (label, value) in rows)
          pw.TableRow(
            children: [
              _cell(
                pw.Text(label, style: _text(size: 9, bold: true)),
                background: c.areaContainer,
                vertical: 8,
              ),
              _cell(pw.Text(value, style: _text(size: 9)), vertical: 8),
            ],
          ),
      ],
    );
  }

  pw.Widget accuracyNotice() {
    final amber = Color.alphaBlend(
      c.warning.withValues(alpha: 0.12),
      c.surfaceCard,
    );
    return pw.Container(
      width: PdfReportBuilder._contentWidth,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: _p(amber),
        border: pw.Border.all(color: _p(c.warning), width: 0.6),
      ),
      child: pw.RichText(
        text: pw.TextSpan(
          style: _text(size: 8, color: c.textSecondary),
          children: [
            pw.TextSpan(
              text: '${l10n.pdfAccuracyTitle} ',
              style: _text(size: 8, color: c.textPrimary, bold: true),
            ),
            pw.TextSpan(text: l10n.pdfAccuracyBody),
          ],
        ),
      ),
    );
  }
}

/// Draws the grid, the shape and its points on the report map. Y points up
/// in PDF space, so north is up without any flipping.
class _MapPainter {
  _MapPainter({
    required this.measurement,
    required this.layout,
    required this.colors,
    required this.mode,
    required this.barPt,
    required this.drawDots,
  });

  final Measurement measurement;
  final _MapLayout layout;
  final LmColors colors;
  final ModeColors mode;
  final double barPt;
  final bool drawDots;

  PdfColor _p(Color color) => PdfReportBuilder._pdf(color);

  void paint(PdfGraphics g, PdfPoint size) {
    final w = size.x;
    final h = size.y;

    // Background and a light grid for a sense of ground.
    g
      ..setFillColor(_p(colors.mapLand))
      ..drawRect(0, 0, w, h)
      ..fillPath()
      ..setStrokeColor(_p(colors.mapRoad))
      ..setLineWidth(0.4);
    for (var x = 40.0; x < w; x += 40) {
      g
        ..moveTo(x, 0)
        ..lineTo(x, h)
        ..strokePath();
    }
    for (var y = 40.0; y < h; y += 40) {
      g
        ..moveTo(0, y)
        ..lineTo(w, y)
        ..strokePath();
    }

    final pts = layout.points;
    if (pts.isEmpty) return;
    final type = measurement.type;
    final closed =
        type == MeasurementType.area && pts.length >= 3 ||
        type == MeasurementType.walk && measurement.stats.isClosed;

    g
      ..setLineJoin(PdfLineJoin.round)
      ..setLineCap(PdfLineCap.round);

    if (closed) {
      g
        ..saveContext()
        ..setGraphicState(
          const PdfGraphicState(fillOpacity: ModeColors.fillOpacity),
        )
        ..setFillColor(_p(mode.main));
      _trace(g, pts, close: true);
      g
        ..fillPath()
        ..restoreContext();
    }

    g
      ..setStrokeColor(_p(mode.main))
      ..setLineWidth(2.4);
    if (type == MeasurementType.walk) {
      // One line per recorded segment: no jump across a pause.
      var start = 0;
      final all = measurement.points;
      for (var i = 1; i <= all.length; i++) {
        if (i == all.length || all[i].segmentIndex != all[start].segmentIndex) {
          _trace(g, pts.sublist(start, i), close: false);
          g.strokePath();
          start = i;
        }
      }
    } else {
      _trace(g, pts, close: closed);
      g.strokePath();
    }

    if (drawDots) {
      final startColor = colors.areaMain;
      final endColor = colors.dangerMain;
      for (final (i, p) in pts.indexed) {
        final isRoute = type != MeasurementType.area;
        final isStart = isRoute && i == 0;
        final isEnd = isRoute && i == pts.length - 1;
        if (type == MeasurementType.walk && !isStart && !isEnd) continue;
        final ring = isStart
            ? startColor
            : isEnd
            ? endColor
            : mode.main;
        g
          ..setFillColor(_p(colors.surfaceCard))
          ..setStrokeColor(_p(ring))
          ..setLineWidth(2)
          ..drawEllipse(p.x, p.y, 4.6, 4.6)
          ..fillAndStrokePath();
      }
    }

    // Scale bar: line with end ticks, label is a widget above it.
    const x0 = 14.0;
    const y0 = 14.0;
    g
      ..setStrokeColor(_p(colors.textPrimary))
      ..setLineWidth(1.2)
      ..moveTo(x0, y0 + 4)
      ..lineTo(x0, y0)
      ..lineTo(x0 + barPt, y0)
      ..lineTo(x0 + barPt, y0 + 4)
      ..strokePath();

    // North arrow.
    final nx = w - 18;
    final ny = h - 34;
    g
      ..setFillColor(_p(colors.textPrimary))
      ..moveTo(nx, ny + 16)
      ..lineTo(nx - 5, ny)
      ..lineTo(nx + 5, ny)
      ..closePath()
      ..fillPath();
  }

  void _trace(PdfGraphics g, List<_Xy> pts, {required bool close}) {
    if (pts.isEmpty) return;
    g.moveTo(pts.first.x, pts.first.y);
    for (final p in pts.skip(1)) {
      g.lineTo(p.x, p.y);
    }
    if (close) g.closePath();
  }
}
