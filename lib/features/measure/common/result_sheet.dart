import 'package:flutter/material.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_shadows.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';

/// Draggable result sheet (`design.md` §2.9) snapping to 0.22 (numbers
/// only), 0.45 (default) and 0.9 (everything). Fractions are of the space
/// above the pinned CTA.
class ResultSheet extends StatelessWidget {
  const ResultSheet({
    required this.children,
    this.controller,
    super.key,
  });

  final List<Widget> children;
  final DraggableScrollableController? controller;

  static const double minSize = 0.22;
  static const double defaultSize = 0.45;
  static const double maxSize = 0.9;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    return DraggableScrollableSheet(
      controller: controller,
      initialChildSize: defaultSize,
      minChildSize: minSize,
      maxChildSize: maxSize,
      snap: true,
      snapSizes: const [defaultSize],
      builder: (context, scrollController) => DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceSheet,
          borderRadius: LmRadius.sheetTop,
          boxShadow: LmShadows.sheet,
        ),
        child: ListView(
          controller: scrollController,
          padding: EdgeInsets.zero,
          children: [
            const _DragHandle(),
            ...children,
            const SizedBox(height: LmSpacing.s16),
          ],
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: LmSpacing.s8, bottom: LmSpacing.s12),
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: LmColors.of(context).divider,
          borderRadius: LmRadius.fullAll,
        ),
      ),
    );
  }
}
