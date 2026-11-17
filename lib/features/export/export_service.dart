import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' show Locale, Rect;

import 'package:flutter/services.dart' show rootBundle;

import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:gps_measurement/data/repositories/settings_repository.dart';
import 'package:gps_measurement/data/storage/export_storage.dart';
import 'package:gps_measurement/data/storage/photo_storage.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:gps_measurement/domain/premium/feature_gate.dart';
import 'package:gps_measurement/features/export/csv_encoder.dart';
import 'package:gps_measurement/features/export/kml_encoder.dart';
import 'package:gps_measurement/features/export/pdf_report_builder.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'export_service.g.dart';

/// Opens the system share sheet (behind an interface for tests).
// A one-method interface on purpose: tests substitute it.
// ignore: one_member_abstracts
abstract interface class FileSharer {
  /// True when the user picked a target (false: dismissed).
  Future<bool> share(File file, {required String mimeType, Rect? origin});
}

class SharePlusSharer implements FileSharer {
  const SharePlusSharer();

  @override
  Future<bool> share(
    File file, {
    required String mimeType,
    Rect? origin,
  }) async {
    final result = await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: mimeType)],
        // iPad popover anchor.
        sharePositionOrigin: origin,
      ),
    );
    return result.status != ShareResultStatus.dismissed;
  }
}

@Riverpod(keepAlive: true)
FileSharer fileSharer(Ref ref) => const SharePlusSharer();

enum ExportResult {
  shared,
  dismissed,

  /// Free KML export already used today (Phase 11: rewarded ad / paywall).
  limitReached,

  /// PDF report asked by a free user (the UI goes to the paywall first).
  premiumRequired,
  failed,
}

/// Export (`plan.md` P8-03): FeatureGate → encode → temp file → share.
class ExportService {
  ExportService({
    required MeasurementRepository repository,
    required ExportStorage storage,
    required FileSharer sharer,
    required FeatureGate gate,
    required SettingsRepository settings,
    required PhotoStorage photos,
    Clock clock = const Clock(),
    Future<(pw.Font, pw.Font)> Function()? loadFonts,
  }) : _repo = repository,
       _storage = storage,
       _sharer = sharer,
       _gate = gate,
       _settings = settings,
       _photos = photos,
       _loadFonts = loadFonts ?? _bundledFonts,
       _clock = clock;

  final MeasurementRepository _repo;
  final ExportStorage _storage;
  final FileSharer _sharer;
  final FeatureGate _gate;
  final SettingsRepository _settings;
  final PhotoStorage _photos;
  final Future<(pw.Font, pw.Font)> Function() _loadFonts;
  final Clock _clock;

  static const Map<ExportFormat, String> mimeTypes = {
    ExportFormat.kml: 'application/vnd.google-earth.kml+xml',
    ExportFormat.csv: 'text/csv',
    ExportFormat.pdf: 'application/pdf',
  };

  /// Inter (regular, bold): the app's font, with Vietnamese glyphs.
  static Future<(pw.Font, pw.Font)> _bundledFonts() async {
    final regular = await rootBundle.load('assets/fonts/Inter-Regular.ttf');
    final bold = await rootBundle.load('assets/fonts/Inter-Bold.ttf');
    return (pw.Font.ttf(regular), pw.Font.ttf(bold));
  }

  String get _today => DateFormat('yyyy-MM-dd').format(_clock.now());

  /// [fallbackName]: "Untitled Area" for an unnamed measurement.
  /// [unlocked]: this one export was unlocked by a rewarded ad — skips
  /// the gate and does not use the day's free KML. [pdf]: language and
  /// units of the PDF report (English, metric when omitted).
  // TODO(phase-10): analytics export_done{format, mode, via}.
  Future<ExportResult> export(
    String measurementId,
    ExportFormat format, {
    required String fallbackName,
    Rect? shareOrigin,
    bool unlocked = false,
    PdfReportOptions? pdf,
  }) async {
    final freeUsedToday = _settings.exportFreeUsedOn == _today;
    if (format == ExportFormat.pdf && !_gate.canUsePdf) {
      return ExportResult.premiumRequired; // UI: paywall.
    }
    if (!unlocked && !_gate.canExport(format, freeUsedToday: freeUsedToday)) {
      return ExportResult.limitReached; // UI: rewarded ad or paywall.
    }
    try {
      final m = await _repo.get(measurementId);
      if (m == null) throw ExportException('Measurement $measurementId gone');
      final name = (m.name?.trim().isNotEmpty ?? false)
          ? m.name!.trim()
          : fallbackName;
      final file = switch (format) {
        ExportFormat.kml => await _storage.write(
          name,
          format.name,
          KmlEncoder.encode(m, name: name, colors: _kmlColors(m.type)),
        ),
        ExportFormat.csv => await _storage.write(
          name,
          format.name,
          CsvEncoder.encode(m, name: name),
        ),
        ExportFormat.pdf => await _storage.writeBytes(
          name,
          format.name,
          await _buildPdf(m, name, pdf),
        ),
      };
      final shared = await _sharer.share(
        file,
        mimeType: mimeTypes[format]!,
        origin: shareOrigin,
      );
      if (shared &&
          format == ExportFormat.kml &&
          !_gate.isPremium &&
          !unlocked) {
        await _settings.setExportFreeUsedOn(_today);
      }
      return shared ? ExportResult.shared : ExportResult.dismissed;
    } on AppException catch (e, st) {
      Log.e('Export failed', e, st);
      return ExportResult.failed;
    } on Object catch (e, st) {
      Log.e('Export/share failed', e, st);
      return ExportResult.failed;
    }
  }

  Future<Uint8List> _buildPdf(
    Measurement m,
    String name,
    PdfReportOptions? options,
  ) async {
    final opts =
        options ??
        PdfReportOptions.forLocale(
          const Locale('en'),
          areaUnit: AreaUnit.squareMeter,
          distanceUnit: DistanceUnit.meter,
        );
    // Date symbols of the report's language (the app only loads its own).
    await initializeDateFormatting(opts.locale);
    final (regular, bold) = await _loadFonts();
    // Cap the photos (in the user's order) to keep the file small.
    final sorted = [...m.photos]..sort((a, b) => a.sortIndex - b.sortIndex);
    final shown = sorted.take(PdfReportBuilder.maxPhotos);
    final photos = <PdfReportPhoto>[];
    for (final photo in shown) {
      final file = _photos.resolve(photo.filePath);
      if (!file.existsSync()) continue;
      photos.add((photo: photo, bytes: await file.readAsBytes()));
    }
    return PdfReportBuilder.build(
      PdfReportInput(
        measurement: m,
        name: name,
        options: opts,
        exportedAt: _clock.now(),
        regularFont: regular,
        boldFont: bold,
        photos: photos,
        hiddenPhotoCount: sorted.length - shown.length,
        isIos: Platform.isIOS,
      ),
    );
  }

  /// The mode's design colors (area fill for the polygon).
  static KmlColors _kmlColors(MeasurementType type) {
    const colors = LmColors.light;
    final mode = ModeColors.from(colors, type);
    final fill = ModeColors.from(colors, MeasurementType.area).fill;
    return (line: mode.main.toARGB32(), fill: fill.toARGB32());
  }
}

@Riverpod(keepAlive: true)
ExportService exportService(Ref ref) => ExportService(
  repository: ref.watch(measurementRepositoryProvider),
  storage: ExportStorage(
    directories: ref.watch(appDirectoriesProvider),
    clock: ref.watch(clockProvider),
  ),
  sharer: ref.watch(fileSharerProvider),
  gate: ref.watch(featureGateProvider),
  settings: ref.watch(settingsRepositoryProvider),
  photos: ref.watch(photoStorageProvider),
  clock: ref.watch(clockProvider),
);
