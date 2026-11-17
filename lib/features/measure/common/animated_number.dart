import 'package:flutter/material.dart';

/// Counts to [value] in 200 ms so results feel alive (`design.md` §1.5).
/// Jumps straight there when the system asks to reduce motion.
class AnimatedNumber extends StatelessWidget {
  const AnimatedNumber({
    required this.value,
    required this.format,
    this.style,
    super.key,
  });

  final double value;
  final String Function(double value) format;
  final TextStyle? style;

  static const Duration duration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return Text(format(value), style: style, maxLines: 1);
    }
    return TweenAnimationBuilder<double>(
      tween: Tween(end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => Text(format(v), style: style, maxLines: 1),
    );
  }
}
