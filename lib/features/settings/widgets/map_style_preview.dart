import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/domain/models/enums.dart';

/// Drawn stand-in for a Map Style preview image (`design.md` §6 lists 4
/// screenshots still to come): roads/parks/water for Standard, fields for
/// Satellite, contours for Terrain, fields + roads for Hybrid. Standard
/// follows the dark map in dark mode, like the real map.
class MapStylePreviewPainter extends CustomPainter {
  const MapStylePreviewPainter({required this.style, required this.colors});

  final MapStyle style;
  final LmColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    switch (style) {
      case MapStyle.standard:
        _standard(canvas, size);
      case MapStyle.satellite:
        _fields(canvas, size);
      case MapStyle.terrain:
        _terrain(canvas, size);
      case MapStyle.hybrid:
        _fields(canvas, size);
        _roads(canvas, size, colors.mapRoad, colors.mapRoadMajor, 0.8);
    }
  }

  void _standard(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas
      ..drawRect(Offset.zero & size, Paint()..color = colors.mapLand)
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.08, h * 0.1, w * 0.36, h * 0.28),
          const Radius.circular(6),
        ),
        Paint()..color = colors.mapPark,
      )
      ..drawPath(
        Path()
          ..moveTo(w * 0.55, h)
          ..quadraticBezierTo(w * 0.7, h * 0.7, w, h * 0.62)
          ..lineTo(w, h)
          ..close(),
        Paint()..color = colors.mapWater,
      );
    _roads(canvas, size, colors.mapRoad, colors.mapRoadMajor, 1);
  }

  void _roads(Canvas canvas, Size size, Color minor, Color major, double a) {
    final w = size.width;
    final h = size.height;
    final minorPaint = Paint()
      ..color = minor.withValues(alpha: a)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2, w * 0.025);
    for (final x in [0.3, 0.72]) {
      canvas.drawLine(Offset(w * x, 0), Offset(w * (x - 0.08), h), minorPaint);
    }
    canvas
      ..drawLine(Offset(0, h * 0.5), Offset(w, h * 0.44), minorPaint)
      ..drawPath(
        Path()
          ..moveTo(0, h * 0.78)
          ..quadraticBezierTo(w * 0.5, h * 0.55, w, h * 0.2),
        Paint()
          ..color = major.withValues(alpha: a)
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(3, w * 0.05),
      );
  }

  void _fields(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas.drawRect(Offset.zero & size, Paint()..color = colors.heroBase);
    final rnd = math.Random(3);
    const n = 4;
    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        final rect = Rect.fromLTWH(
          c * w / n + 2,
          r * h / n + 2 + c * 3,
          w / n - 4,
          h / n - 4,
        );
        final tone = (r + c).isEven ? colors.heroFieldA : colors.heroFieldB;
        canvas.drawRect(
          rect,
          Paint()..color = tone.withValues(alpha: 0.6 + rnd.nextDouble() * 0.4),
        );
      }
    }
    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.86)
        ..quadraticBezierTo(w * 0.5, h * 0.66, w, h * 0.76),
      Paint()
        ..color = colors.heroRoad
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(2, w * 0.03),
    );
  }

  void _terrain(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas.drawRect(Offset.zero & size, Paint()..color = colors.mapTerrain);
    final contour = Paint()
      ..color = colors.mapContour
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final center = Offset(w * 0.62, h * 0.4);
    for (var i = 1; i <= 6; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: w * 0.2 * i,
          height: h * 0.13 * i,
        ),
        contour,
      );
    }
    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.9)
        ..quadraticBezierTo(w * 0.3, h * 0.7, w * 0.45, h),
      Paint()
        ..color = colors.mapWater
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(2, w * 0.03),
    );
  }

  @override
  bool shouldRepaint(MapStylePreviewPainter old) =>
      old.style != style || old.colors != colors;
}
