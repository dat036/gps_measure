import 'dart:collection';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';

/// Draws map markers (`design.md` §2.4–2.6) straight onto a canvas and
/// caches the bitmaps by content + device pixel ratio, so markers are not
/// re-rendered on every rebuild.
class MarkerFactory {
  MarkerFactory({required this.devicePixelRatio, this.colors = LmColors.light});

  final double devicePixelRatio;
  final LmColors colors;

  static const int _maxCache = 256;
  final LinkedHashMap<String, Future<BitmapDescriptor>> _cache =
      LinkedHashMap();

  static const Offset centerAnchor = Offset(0.5, 0.5);
  static const Offset bottomAnchor = Offset(0.5, 1);

  /// Floats a label just above its position.
  static const Offset aboveAnchor = Offset(0.5, 1.35);

  int get cacheSize => _cache.length;

  Future<BitmapDescriptor> _cached(
    String key,
    Future<BitmapDescriptor> Function() create,
  ) {
    final hit = _cache.remove(key);
    if (hit != null) {
      _cache[key] = hit; // most recently used
      return hit;
    }
    final created = create();
    _cache[key] = created;
    if (_cache.length > _maxCache) _cache.remove(_cache.keys.first)?.ignore();
    return created;
  }

  // ------------------------------------------------------------ markers

  /// White dot with a mode-colored ring. Selected: larger with a halo.
  /// [hasPhoto] adds a small camera badge.
  Future<BitmapDescriptor> pointHandle({
    required Color color,
    bool selected = false,
    bool hasPhoto = false,
  }) => _cached(
    'handle:${color.toARGB32()}:$selected:$hasPhoto',
    () => _render(const Size.square(44), (canvas, size) {
      final c = size.center(Offset.zero);
      final r = selected ? 12.0 : 9.0;
      if (selected) {
        canvas.drawCircle(c, 20, Paint()..color = color.withValues(alpha: 0.3));
      }
      canvas
        ..drawCircle(
          c.translate(0, 1),
          r + 1,
          Paint()
            ..color = const Color(0x40000000)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
        )
        ..drawCircle(c, r, Paint()..color = colors.onMode)
        ..drawCircle(
          c,
          r - (selected ? 2 : 1.5),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = selected ? 4 : 3
            ..color = color,
        );
      if (hasPhoto) {
        final b = c.translate(r * 0.85, -r * 0.85);
        canvas
          ..drawCircle(b, 6, Paint()..color = colors.textPrimary)
          ..drawCircle(b, 2.2, Paint()..color = colors.onMode);
      }
    }),
  );

  /// Distance start: green dot with a white border.
  Future<BitmapDescriptor> startDot() => _cached(
    'start',
    () => _render(const Size.square(30), (canvas, size) {
      final c = size.center(Offset.zero);
      canvas
        ..drawCircle(c, 11, Paint()..color = colors.onMode)
        ..drawCircle(c, 8, Paint()..color = colors.areaMain);
    }),
  );

  /// Distance end: red map pin, anchored at its tip ([bottomAnchor]).
  Future<BitmapDescriptor> endPin() => _cached(
    'end',
    () => _render(const Size(28, 38), (canvas, size) {
      const r = 12.0;
      final c = Offset(size.width / 2, r + 2);
      final tip = Offset(size.width / 2, size.height - 1);
      final a = math.asin(r / (tip.dy - c.dy));
      final path = Path()
        ..moveTo(tip.dx, tip.dy)
        ..lineTo(c.dx - r * math.cos(a), c.dy + r * math.sin(a))
        ..arcToPoint(
          Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a)),
          radius: const Radius.circular(r),
          largeArc: true,
        )
        ..close();
      canvas
        ..drawPath(path, Paint()..color = colors.dangerMain)
        ..drawCircle(c, 4.5, Paint()..color = colors.onMode);
    }),
  );

  /// Walk: current position, blue dot with a white border. [heading] adds a
  /// red arrow at the top; rotate the marker by the bearing (`flat`).
  Future<BitmapDescriptor> currentLocation({required bool heading}) => _cached(
    'current:$heading',
    () => _render(const Size.square(44), (canvas, size) {
      final c = size.center(Offset.zero);
      if (heading) {
        final arrow = Path()
          ..moveTo(c.dx, 1)
          ..lineTo(c.dx + 7, 12)
          ..lineTo(c.dx - 7, 12)
          ..close();
        canvas.drawPath(arrow, Paint()..color = colors.dangerMain);
      }
      canvas
        ..drawCircle(
          c.translate(0, 1),
          12,
          Paint()
            ..color = const Color(0x40000000)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
        )
        ..drawCircle(c, 11, Paint()..color = colors.onMode)
        ..drawCircle(c, 8, Paint()..color = colors.distanceMain);
    }),
  );

  /// Result pill at the polygon centroid / route midpoint.
  Future<BitmapDescriptor> resultPill(String primary, String? secondary) =>
      _cached('pill:$primary|$secondary', () {
        final line1 = _paragraph(
          primary,
          LmTypography.fontFamily,
          20,
          FontWeight.w700,
          colors.onMode,
        );
        final line2 = secondary == null
            ? null
            : _paragraph(
                secondary,
                LmTypography.fontFamily,
                13,
                FontWeight.w500,
                colors.onMode.withValues(alpha: 0.8),
              );
        final w =
            math.max(line1.maxIntrinsicWidth, line2?.maxIntrinsicWidth ?? 0) +
            24;
        final h = line1.height + (line2?.height ?? 0) + 16;
        return _render(Size(w.ceilToDouble(), h.ceilToDouble()), (
          canvas,
          size,
        ) {
          canvas
            ..drawRRect(
              RRect.fromRectAndRadius(
                Offset.zero & size,
                const Radius.circular(14),
              ),
              Paint()..color = colors.mapPill,
            )
            ..drawParagraph(
              line1,
              Offset((size.width - line1.maxIntrinsicWidth) / 2, 8),
            );
          if (line2 != null) {
            canvas.drawParagraph(
              line2,
              Offset(
                (size.width - line2.maxIntrinsicWidth) / 2,
                8 + line1.height,
              ),
            );
          }
        });
      });

  /// Small length chip at the middle of an edge.
  Future<BitmapDescriptor> edgeLabel(String text) => _cached('edge:$text', () {
    final p = _paragraph(
      text,
      LmTypography.fontFamily,
      11,
      FontWeight.w600,
      colors.textPrimary,
    );
    final size = Size(
      (p.maxIntrinsicWidth + 12).ceilToDouble(),
      (p.height + 6).ceilToDouble(),
    );
    return _render(size, (canvas, s) {
      canvas
        ..drawRRect(
          RRect.fromRectAndRadius(Offset.zero & s, Radius.circular(s.height)),
          Paint()..color = colors.surfaceCard.withValues(alpha: 0.9),
        )
        ..drawParagraph(p, const Offset(6, 3));
    });
  });

  // ------------------------------------------------------------ helpers

  static ui.Paragraph _paragraph(
    String text,
    String family,
    double fontSize,
    FontWeight weight,
    Color color,
  ) {
    final builder =
        ui.ParagraphBuilder(
            ui.ParagraphStyle(
              fontFamily: family,
              fontSize: fontSize,
              fontWeight: weight,
              maxLines: 1,
            ),
          )
          ..pushStyle(
            ui.TextStyle(
              color: color,
              fontFeatures: LmTypography.tabular,
              fontFamily: family,
              fontSize: fontSize,
              fontWeight: weight,
            ),
          )
          ..addText(text);
    return builder.build()
      ..layout(const ui.ParagraphConstraints(width: double.infinity));
  }

  /// Renders [paint] at [size] logical pixels × [devicePixelRatio].
  Future<BitmapDescriptor> _render(
    Size size,
    void Function(Canvas canvas, Size size) paint,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)..scale(devicePixelRatio);
    paint(canvas, size);
    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (size.width * devicePixelRatio).ceil(),
      (size.height * devicePixelRatio).ceil(),
    );
    picture.dispose();
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return BitmapDescriptor.bytes(
      bytes!.buffer.asUint8List(),
      imagePixelRatio: devicePixelRatio,
    );
  }
}
