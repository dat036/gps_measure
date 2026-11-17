import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/core/widgets/primary_cta.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/features/home/widgets/mode_segmented_selector.dart';

/// Home hero (`design.md` §5.1): aerial-style illustration with the
/// selected mode's geometry (crossfades 250 ms), dark overlay, title,
/// mode selector and the mode-colored Start CTA.
///
/// The backdrop is drawn ([HeroBackdropPainter]) until licensed satellite
/// images are available (`plan.md` "Việc chờ người").
class HeroMeasureCard extends StatelessWidget {
  const HeroMeasureCard({
    required this.mode,
    required this.onModeChanged,
    required this.onStart,
    super.key,
  });

  final MeasurementType mode;
  final ValueChanged<MeasurementType> onModeChanged;
  final VoidCallback onStart;

  static const double minHeight = 260;

  static String ctaLabel(BuildContext context, MeasurementType mode) {
    final l10n = context.l10n;
    return switch (mode) {
      MeasurementType.area => l10n.ctaStartArea,
      MeasurementType.distance => l10n.ctaStartDistance,
      MeasurementType.walk => l10n.ctaStartWalk,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return ClipRRect(
      borderRadius: LmRadius.lgAll,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: minHeight),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 250),
                child: CustomPaint(
                  key: ValueKey(mode),
                  size: Size.infinite,
                  painter: HeroBackdropPainter(mode: mode, colors: colors),
                ),
              ),
            ),
            // Darker on the text side (design.md §1.1: the only gradient).
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      colors.scrim.withValues(alpha: 0),
                      colors.scrim.withValues(alpha: 0.55),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(LmSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: LmSpacing.s24),
                  Text(
                    l10n.ctaStartMeasuring,
                    style: LmTypography.displayHero.copyWith(
                      color: colors.onMode,
                    ),
                  ),
                  const SizedBox(height: LmSpacing.s4),
                  Text(
                    l10n.homeHeroSubtitle,
                    style: LmTypography.bodyMd.copyWith(
                      color: colors.onMode.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: LmSpacing.s20),
                  ModeSegmentedSelector(
                    selected: mode,
                    onChanged: onModeChanged,
                  ),
                  const SizedBox(height: LmSpacing.s12),
                  PrimaryCta(
                    label: ctaLabel(context, mode),
                    icon: Icons.arrow_forward_rounded,
                    showChevron: true,
                    variant: PrimaryCtaVariant.forMode(mode),
                    onPressed: onStart,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stylized aerial view: fields, a dirt road and the mode's geometry.
/// Deterministic (fixed seed) so goldens are stable.
class HeroBackdropPainter extends CustomPainter {
  const HeroBackdropPainter({required this.mode, required this.colors});

  final MeasurementType mode;
  final LmColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas.drawRect(Offset.zero & size, Paint()..color = colors.heroBase);

    // Tilted grid of fields.
    final rnd = math.Random(7);
    const cols = 5;
    const rows = 4;
    final cw = w / (cols - 1);
    final ch = h / (rows - 1);
    Offset jitter(int c, int r) => Offset(
      (c - 0.5) * cw + (rnd.nextDouble() - 0.5) * cw * 0.25,
      (r - 0.5) * ch + (rnd.nextDouble() - 0.5) * ch * 0.25 + c * 6,
    );
    final grid = [
      for (var r = 0; r <= rows; r++)
        [for (var c = 0; c <= cols; c++) jitter(c, r)],
    ];
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final field = Path()
          ..moveTo(grid[r][c].dx + 3, grid[r][c].dy + 3)
          ..lineTo(grid[r][c + 1].dx - 3, grid[r][c + 1].dy + 3)
          ..lineTo(grid[r + 1][c + 1].dx - 3, grid[r + 1][c + 1].dy - 3)
          ..lineTo(grid[r + 1][c].dx + 3, grid[r + 1][c].dy - 3)
          ..close();
        final tone = (r + c).isEven ? colors.heroFieldA : colors.heroFieldB;
        canvas.drawPath(
          field,
          Paint()..color = tone.withValues(alpha: 0.6 + rnd.nextDouble() * 0.4),
        );
      }
    }

    // Dirt road.
    canvas.drawPath(
      Path()
        ..moveTo(-10, h * 0.82)
        ..quadraticBezierTo(w * 0.45, h * 0.62, w + 10, h * 0.72),
      Paint()
        ..color = colors.heroRoad
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );

    final main = ModeColors.from(colors, mode);
    // Top-right corner, clear of the title and the controls below it.
    final r = math.min(w, h) * 0.13;
    final cx = w - r * 1.6;
    final cy = r * 1.3;
    final stroke = Paint()
      ..color = main.main
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    switch (mode) {
      case MeasurementType.area:
        final pts = [
          Offset(cx - r, cy - r * 0.5),
          Offset(cx + r * 0.2, cy - r),
          Offset(cx + r * 1.1, cy - r * 0.2),
          Offset(cx + r * 0.6, cy + r * 0.9),
          Offset(cx - r * 0.8, cy + r * 0.7),
        ];
        final poly = Path()..addPolygon(pts, true);
        canvas
          ..drawPath(poly, Paint()..color = main.fill)
          ..drawPath(poly, stroke);
        for (final p in pts) {
          _vertex(canvas, p, main.main);
        }
      case MeasurementType.distance:
        final pts = [
          Offset(cx - r * 1.2, cy + r * 0.8),
          Offset(cx - r * 0.3, cy + r * 0.1),
          Offset(cx + r * 0.4, cy + r * 0.4),
          Offset(cx + r * 1.1, cy - r * 0.7),
        ];
        canvas.drawPath(
          Path()..addPolygon(pts, false),
          stroke..strokeWidth = 4,
        );
        for (final p in pts.skip(1).take(pts.length - 2)) {
          _vertex(canvas, p, main.main);
        }
        _dot(canvas, pts.first, colors.areaMain);
        _dot(canvas, pts.last, colors.dangerMain);
      case MeasurementType.walk:
        final track = Path();
        for (var i = 0; i <= 48; i++) {
          final a = i / 48 * 2 * math.pi;
          final wobble = 1 + 0.08 * math.sin(a * 5) + 0.05 * math.cos(a * 3);
          final p = Offset(
            cx + r * 1.1 * wobble * math.cos(a),
            cy + r * 0.85 * wobble * math.sin(a),
          );
          i == 0 ? track.moveTo(p.dx, p.dy) : track.lineTo(p.dx, p.dy);
        }
        final area = ModeColors.from(colors, MeasurementType.area);
        canvas
          ..drawPath(track, Paint()..color = area.fill)
          ..drawPath(track, stroke..strokeWidth = 4);
        _dot(canvas, Offset(cx + r * 1.1 * 1.05, cy), colors.distanceMain);
    }
  }

  void _vertex(Canvas canvas, Offset p, Color border) {
    canvas
      ..drawCircle(p, 5, Paint()..color = colors.onMode)
      ..drawCircle(
        p,
        5,
        Paint()
          ..color = border
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
  }

  void _dot(Canvas canvas, Offset p, Color fill) {
    canvas
      ..drawCircle(p, 7, Paint()..color = colors.onMode)
      ..drawCircle(p, 5, Paint()..color = fill);
  }

  @override
  bool shouldRepaint(HeroBackdropPainter old) =>
      old.mode != mode || old.colors != colors;
}
