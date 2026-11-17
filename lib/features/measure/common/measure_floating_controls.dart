import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/widgets/map_fab.dart';
import 'package:gps_measurement/features/measure/common/measure_toolbar.dart';

/// FAB column, camera FAB and toolbar riding on top of the result sheet;
/// they fade out when the sheet is expanded.
class MeasureFloatingControls extends StatelessWidget {
  const MeasureFloatingControls({
    required this.sheetExtent,
    required this.height,
    required this.topInset,
    required this.topFabs,
    required this.cameraFab,
    required this.bottom,
    super.key,
  });

  final ValueListenable<double> sheetExtent;

  /// Height of the map area the sheet extent is a fraction of.
  final double height;

  /// Top of the FAB column (below the status banner when one is shown).
  final double topInset;
  final List<Widget> topFabs;
  final Widget cameraFab;

  /// Point actions + toolbar, just above the sheet.
  final Widget bottom;

  /// Above this extent the sheet covers most of the map.
  static const double hideAbove = 0.6;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: sheetExtent,
      builder: (context, extent, child) {
        final visible = extent <= hideAbove;
        final sheetTop = extent * height;
        final cameraBottom = sheetTop + MeasureToolbar.height + 28;
        final columnBottom = topInset + topFabs.length * (48 + MapFab.spacing);
        // On short screens the camera button moves to the left edge rather
        // than overlapping the column.
        final cameraFitsRight = height - cameraBottom - 56 >= columnBottom;
        return Positioned.fill(
          child: IgnorePointer(
            ignoring: !visible,
            child: AnimatedOpacity(
              opacity: visible ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: Stack(
                children: [
                  Positioned(
                    top: topInset,
                    right: LmSpacing.pageH,
                    child: Column(
                      children: [
                        for (final fab in topFabs) ...[
                          fab,
                          const SizedBox(height: MapFab.spacing),
                        ],
                      ],
                    ),
                  ),
                  Positioned(
                    right: cameraFitsRight ? LmSpacing.pageH : null,
                    left: cameraFitsRight ? null : LmSpacing.pageH,
                    bottom: cameraBottom,
                    child: cameraFab,
                  ),
                  Positioned(
                    left: LmSpacing.pageH,
                    right: LmSpacing.pageH,
                    bottom: sheetTop + LmSpacing.s12,
                    child: bottom,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
