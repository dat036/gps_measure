import 'package:flutter/material.dart';

/// "+" at the map center (`design.md` §2.7): white with a thin dark outline
/// so it reads on any imagery; grows slightly while the map moves.
class CenterCrosshair extends StatelessWidget {
  const CenterCrosshair({this.moving = false, super.key});

  final bool moving;

  static const double size = 32;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedScale(
        scale: moving ? 1.1 : 1,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: const CustomPaint(
          size: Size.square(size),
          painter: _CrosshairPainter(),
        ),
      ),
    );
  }
}

class _CrosshairPainter extends CustomPainter {
  const _CrosshairPainter();

  // Fixed contrast colors are the point of this widget (legible on any
  // satellite image), not theme colors.
  static const Color _fill = Color(0xFFFFFFFF);
  static const Color _outline = Color(0xFF000000);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final arm = size.width / 2;
    const gap = 5.0;
    void cross(Paint paint) {
      canvas
        ..drawLine(c.translate(-arm, 0), c.translate(-gap, 0), paint)
        ..drawLine(c.translate(gap, 0), c.translate(arm, 0), paint)
        ..drawLine(c.translate(0, -arm), c.translate(0, -gap), paint)
        ..drawLine(c.translate(0, gap), c.translate(0, arm), paint);
    }

    cross(
      Paint()
        ..color = _outline
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    cross(
      Paint()
        ..color = _fill
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
    canvas
      ..drawCircle(c, 3, Paint()..color = _outline)
      ..drawCircle(c, 2, Paint()..color = _fill);
  }

  @override
  bool shouldRepaint(_CrosshairPainter oldDelegate) => false;
}
