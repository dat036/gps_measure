import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/core/widgets/mode_icon.dart';
import 'package:gps_measurement/core/widgets/type_chip.dart';
import 'package:gps_measurement/domain/models/enums.dart';

/// Area / Distance / Walk selector on the hero image (`design.md` §2.1):
/// frosted white 16% track, the selected segment a solid white pill that
/// slides (250 ms) with icon + label in the mode color.
class ModeSegmentedSelector extends StatelessWidget {
  const ModeSegmentedSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final MeasurementType selected;
  final ValueChanged<MeasurementType> onChanged;

  static const double height = 64;
  static const Duration slide = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    const modes = MeasurementType.values;
    final index = modes.indexOf(selected);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return ClipRRect(
      borderRadius: LmRadius.mdAll,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: height,
          padding: const EdgeInsets.all(4),
          color: colors.onMode.withValues(alpha: 0.16),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: reduceMotion ? Duration.zero : slide,
                curve: Curves.easeOutCubic,
                alignment: Alignment(-1 + index * 2 / (modes.length - 1), 0),
                child: FractionallySizedBox(
                  widthFactor: 1 / modes.length,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.onMode,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                // Stretch: each segment is tappable over its full height.
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final mode in modes)
                      Expanded(
                        child: _Segment(
                          mode: mode,
                          selected: mode == selected,
                          onTap: () => onChanged(mode),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final MeasurementType mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    final color = selected
        ? ModeColors.of(context, mode).main
        : colors.onMode.withValues(alpha: 0.85);
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(modeIcon(mode), size: 22, color: color),
              const SizedBox(width: 6),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    TypeChip.labelOf(context, mode),
                    maxLines: 1,
                    style: LmTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
