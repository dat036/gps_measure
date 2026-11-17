import 'package:flutter/material.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/widgets/lm_bottom_sheet.dart';
import 'package:gps_measurement/core/widgets/primary_cta.dart';
import 'package:gps_measurement/features/save/land_value_field.dart';

/// Outcome of the land value sheet.
sealed class LandValueEdit {
  const LandValueEdit();
}

final class LandValueSet extends LandValueEdit {
  const LandValueSet(this.price);

  final LandPrice price;
}

final class LandValueRemoved extends LandValueEdit {
  const LandValueRemoved();
}

/// Detail → Land value editor. Null when dismissed.
Future<LandValueEdit?> showLandValueSheet(
  BuildContext context, {
  required double? areaM2,
  required LandPrice initial,
}) {
  return showLmBottomSheet<LandValueEdit>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _LandValueSheet(areaM2: areaM2, initial: initial),
  );
}

class _LandValueSheet extends StatefulWidget {
  const _LandValueSheet({required this.areaM2, required this.initial});

  final double? areaM2;
  final LandPrice initial;

  @override
  State<_LandValueSheet> createState() => _LandValueSheetState();
}

class _LandValueSheetState extends State<_LandValueSheet> {
  late LandPrice _price = widget.initial;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final valid = (_price.price ?? 0) > 0;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        LmSpacing.pageH,
        0,
        LmSpacing.pageH,
        LmSpacing.s16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.landValueTitle,
            style: LmTypography.titleScreen.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: LmSpacing.s16),
          LandValueField(
            areaM2: widget.areaM2,
            initial: widget.initial,
            onChanged: (p) => setState(() => _price = p),
          ),
          const SizedBox(height: LmSpacing.s16),
          PrimaryCta(
            label: l10n.actionSave,
            onPressed: valid
                ? () => Navigator.of(context).pop(LandValueSet(_price))
                : null,
          ),
          if (widget.initial.price != null)
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(const LandValueRemoved()),
              style: TextButton.styleFrom(
                foregroundColor: colors.dangerMain,
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(l10n.landValueRemove),
            ),
        ],
      ),
    );
  }
}
