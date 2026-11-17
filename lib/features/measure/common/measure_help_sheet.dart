import 'package:flutter/material.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/core/widgets/lm_bottom_sheet.dart';
import 'package:gps_measurement/core/widgets/primary_cta.dart';
import 'package:gps_measurement/domain/models/enums.dart';

/// "How to measure" sheet (`design.md` §5.18): 3 numbered steps, a tip,
/// the photo tip and the accuracy note.
Future<void> showMeasureHelpSheet(BuildContext context, MeasurementType type) {
  return showLmBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => MeasureHelpSheet(type: type),
  );
}

/// One-line summary per mode, also used as the empty-state hint banner.
String helpSummary(BuildContext context, MeasurementType type) {
  final l10n = context.l10n;
  return switch (type) {
    MeasurementType.area => l10n.helpAreaSummary,
    MeasurementType.distance => l10n.helpDistanceSummary,
    MeasurementType.walk => l10n.helpWalkSummary,
  };
}

class MeasureHelpSheet extends StatelessWidget {
  const MeasureHelpSheet({required this.type, super.key});

  final MeasurementType type;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final mode = ModeColors.of(context, type);
    final (title, steps, tip) = switch (type) {
      MeasurementType.area => (
        l10n.helpTitleArea,
        [l10n.helpAreaStep1, l10n.helpAreaStep2, l10n.helpAreaStep3],
        l10n.helpTipGpsPoint,
      ),
      MeasurementType.distance => (
        l10n.helpTitleDistance,
        [
          l10n.helpDistanceStep1,
          l10n.helpDistanceStep2,
          l10n.helpDistanceStep3,
        ],
        l10n.helpTipGpsPoint,
      ),
      MeasurementType.walk => (
        l10n.helpTitleWalk,
        [l10n.helpWalkStep1, l10n.helpWalkStep2, l10n.helpWalkStep3],
        l10n.helpTipWalk,
      ),
    };
    final body = LmTypography.bodyMd.copyWith(color: colors.textPrimary);
    final secondary = LmTypography.bodyMd.copyWith(color: colors.textSecondary);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        LmSpacing.pageH,
        0,
        LmSpacing.pageH,
        LmSpacing.s16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: LmTypography.titleScreen.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: LmSpacing.s4),
          Text(helpSummary(context, type), style: secondary),
          const SizedBox(height: LmSpacing.s20),
          for (final (i, step) in steps.indexed) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: mode.container,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${i + 1}',
                    style: LmTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.w700,
                      color: mode.main,
                    ),
                  ),
                ),
                const SizedBox(width: LmSpacing.s12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text.rich(boldMarkup(step, body)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: LmSpacing.s16),
          ],
          Text(tip, style: secondary),
          const SizedBox(height: LmSpacing.s12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.photo_camera_outlined,
                size: 20,
                color: colors.textSecondary,
              ),
              const SizedBox(width: LmSpacing.s8),
              Expanded(child: Text(l10n.helpPhotoTip, style: secondary)),
            ],
          ),
          const SizedBox(height: LmSpacing.s16),
          Text(
            l10n.helpAccuracyNote,
            style: LmTypography.caption.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: LmSpacing.s20),
          PrimaryCta(
            label: l10n.actionGotIt,
            variant: PrimaryCtaVariant.forMode(type),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

/// Renders `**bold**` segments of a translated string in bold.
TextSpan boldMarkup(String text, TextStyle style) {
  final parts = text.split('**');
  return TextSpan(
    style: style,
    children: [
      for (final (i, part) in parts.indexed)
        if (part.isNotEmpty)
          TextSpan(
            text: part,
            style: i.isOdd
                ? const TextStyle(fontWeight: FontWeight.w700)
                : null,
          ),
    ],
  );
}
