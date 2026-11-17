import 'package:flutter/material.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/domain/models/enums.dart';

/// Horizontally scrolling unit picker (`design.md` §2.10):
/// `m² · ha · acre · ft² · sào · mẫu · công`.
class UnitChips<T> extends StatelessWidget {
  const UnitChips({
    required this.units,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
    this.mode = MeasurementType.area,
    this.padding = const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
    super.key,
  });

  final List<T> units;
  final T selected;
  final String Function(T unit) labelOf;
  final ValueChanged<T> onSelected;

  /// Selected chip uses this mode's container/main colors.
  final MeasurementType mode;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    final modeColors = ModeColors.of(context, mode);

    return SizedBox(
      height: LmSpacing.touchMin,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: units.length,
        separatorBuilder: (_, _) => const SizedBox(width: LmSpacing.s8),
        itemBuilder: (context, index) {
          final unit = units[index];
          final isSelected = unit == selected;
          return Center(
            child: Semantics(
              selected: isSelected,
              button: true,
              child: Material(
                color: isSelected ? modeColors.container : colors.surfaceCard,
                shape: RoundedRectangleBorder(
                  borderRadius: LmRadius.xsAll,
                  side: BorderSide(
                    color: isSelected ? modeColors.main : colors.divider,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => onSelected(unit),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 48),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: LmSpacing.s12,
                        vertical: 6,
                      ),
                      child: Text(
                        labelOf(unit),
                        textAlign: TextAlign.center,
                        style: LmTypography.bodyMd.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? modeColors.main
                              : colors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
