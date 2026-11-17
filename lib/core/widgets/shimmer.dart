import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';

/// Loading placeholder: [child] (usually plain [ShimmerBox]es) with a soft
/// highlight sweeping across it. Stands still with "reduce motion".
class Shimmer extends StatefulWidget {
  const Shimmer({required this.child, super.key});

  final Widget child;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      unawaited(_controller.repeat());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    final base = colors.divider;
    final highlight = Color.lerp(colors.divider, colors.surfaceCard, 0.7)!;
    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) => ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final t = _controller.value;
            return LinearGradient(
              begin: Alignment(-1.5 + 3 * t, -0.3),
              end: Alignment(-0.5 + 3 * t, 0.3),
              colors: [base, highlight, base],
              stops: const [0.2, 0.5, 0.8],
            ).createShader(bounds);
          },
          child: child,
        ),
      ),
    );
  }
}

/// A neutral rounded box for building skeletons inside a [Shimmer].
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({this.width, this.height, this.radius = 8, super.key});

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: LmColors.of(context).divider,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}
