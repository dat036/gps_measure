import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/data/storage/app_directories.dart';
import 'package:gps_measurement/domain/geo/geo_calculator.dart';
import 'package:gps_measurement/domain/geo/local_projection.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement.dart';

/// Map thumbnails: `thumbs/<measurementId>.png`, 400×400.
///
/// Preferred source is a `GoogleMapController.takeSnapshot()` of the live
/// map ([saveSnapshot]); [renderFallback] draws the geometry on the mode's
/// container color when no map is available (offline, map disposed).
class ThumbnailStorage {
  ThumbnailStorage({required AppDirectories directories}) : _dirs = directories;

  final AppDirectories _dirs;

  static const int size = 400;
  static const double _padding = 36;

  static String relativePathFor(String measurementId) =>
      '${AppDirectories.thumbsFolder}/$measurementId.png';

  /// Writes PNG [bytes]; returns the relative path to store in the DB.
  Future<String> saveSnapshot(String measurementId, Uint8List bytes) async {
    final rel = relativePathFor(measurementId);
    final file = _dirs.resolve(rel);
    try {
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes, flush: true);
      return rel;
    } on FileSystemException catch (e, st) {
      throw StorageException(
        'Thumbnail write failed',
        cause: e,
        stackTrace: st,
      );
    }
  }

  /// Draws [m]'s geometry to a PNG and saves it.
  Future<String> renderFallback(
    Measurement m, {
    LmColors colors = LmColors.light,
  }) async {
    final png = await renderPng(m, colors: colors);
    return saveSnapshot(m.id, png);
  }

  Future<void> delete(String measurementId) async {
    final file = _dirs.resolve(relativePathFor(measurementId));
    try {
      if (file.existsSync()) await file.delete();
    } on FileSystemException catch (e) {
      Log.w('Could not delete thumbnail of $measurementId', e);
    }
  }

  File resolve(String relativePath) => _dirs.resolve(relativePath);

  /// Crops a map snapshot to the largest square centered in its visible
  /// part (the top [visibleHeightFraction]; the rest sits under the sheet)
  /// and scales it to [size]×[size] PNG.
  static Future<Uint8List> squareFromSnapshot(
    Uint8List snapshot, {
    double visibleHeightFraction = 1,
  }) async {
    final codec = await ui.instantiateImageCodec(snapshot);
    final frame = await codec.getNextFrame();
    codec.dispose();
    final src = frame.image;
    final visibleH = src.height * visibleHeightFraction.clamp(0.1, 1.0);
    final side = math.min(src.width.toDouble(), visibleH);
    final from = ui.Rect.fromCenter(
      center: ui.Offset(src.width / 2, visibleH / 2),
      width: side,
      height: side,
    );
    final recorder = ui.PictureRecorder();
    ui.Canvas(recorder).drawImageRect(
      src,
      from,
      ui.Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
      ui.Paint()..filterQuality = ui.FilterQuality.medium,
    );
    src.dispose();
    final picture = recorder.endRecording();
    final image = await picture.toImage(size, size);
    picture.dispose();
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    if (data == null) throw const StorageException('PNG encoding failed');
    return data.buffer.asUint8List();
  }

  static Future<Uint8List> renderPng(
    Measurement m, {
    LmColors colors = LmColors.light,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    const rect = ui.Rect.fromLTWH(0, 0, 400, 400);
    final mode = ModeColors.from(colors, m.type);
    canvas.drawRect(rect, ui.Paint()..color = mode.container);
    _drawGeometry(canvas, m, mode, colors);

    final picture = recorder.endRecording();
    final image = await picture.toImage(size, size);
    picture.dispose();
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    if (data == null) throw const StorageException('PNG encoding failed');
    return data.buffer.asUint8List();
  }

  static void _drawGeometry(
    ui.Canvas canvas,
    Measurement m,
    ModeColors mode,
    LmColors colors,
  ) {
    final points = m.points;
    if (points.isEmpty) return;

    final bounds = GeoCalculator.bounds(points.map((p) => p.position))!;
    final proj = LocalProjection(bounds.center);
    final xy = [for (final p in points) proj.toXY(p.position)];
    var maxX = 1.0;
    var maxY = 1.0;
    for (final (x, y) in xy) {
      maxX = math.max(maxX, x.abs());
      maxY = math.max(maxY, y.abs());
    }
    final scale = (size / 2 - _padding) / math.max(maxX, maxY);
    ui.Offset toCanvas((double, double) p) =>
        ui.Offset(size / 2 + p.$1 * scale, size / 2 - p.$2 * scale);

    final stroke = ui.Paint()
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeJoin = ui.StrokeJoin.round
      ..strokeCap = ui.StrokeCap.round
      ..color = mode.main;

    ui.Path pathOf(Iterable<MeasurePoint> pts, {bool close = false}) {
      final path = ui.Path();
      var first = true;
      for (final p in pts) {
        final o = toCanvas(proj.toXY(p.position));
        first ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
        first = false;
      }
      if (close) path.close();
      return path;
    }

    switch (m.type) {
      case MeasurementType.area:
        final ring = pathOf(points, close: points.length >= 3);
        if (points.length >= 3) {
          canvas.drawPath(ring, ui.Paint()..color = mode.fill);
        }
        canvas.drawPath(ring, stroke);
        _vertices(canvas, xy.map(toCanvas), mode.main, colors);
      case MeasurementType.distance:
        canvas.drawPath(pathOf(points), stroke);
        _dot(canvas, toCanvas(xy.first), colors.areaMain, colors.onMode, 11);
        _dot(canvas, toCanvas(xy.last), colors.dangerMain, colors.onMode, 11);
      case MeasurementType.walk:
        if (m.stats.isClosed) {
          final area = ModeColors.from(colors, MeasurementType.area);
          canvas.drawPath(
            pathOf(points, close: true),
            ui.Paint()..color = area.fill,
          );
        }
        final segments = <int, List<MeasurePoint>>{};
        for (final p in points) {
          (segments[p.segmentIndex] ??= []).add(p);
        }
        for (final segment in segments.values) {
          canvas.drawPath(pathOf(segment), stroke);
        }
    }
  }

  static void _vertices(
    ui.Canvas canvas,
    Iterable<ui.Offset> points,
    ui.Color border,
    LmColors colors,
  ) {
    for (final o in points) {
      _dot(canvas, o, colors.onMode, border, 7);
    }
  }

  static void _dot(
    ui.Canvas canvas,
    ui.Offset o,
    ui.Color fill,
    ui.Color border,
    double radius,
  ) {
    canvas
      ..drawCircle(o, radius, ui.Paint()..color = fill)
      ..drawCircle(
        o,
        radius,
        ui.Paint()
          ..style = ui.PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = border,
      );
  }
}
