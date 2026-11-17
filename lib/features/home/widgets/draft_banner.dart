import 'package:flutter/material.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_shadows.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/core/widgets/mode_icon.dart';
import 'package:gps_measurement/domain/models/enums.dart';

/// "Continue Measurement" card (`design.md` §2.13): 4dp mode-colored left
/// edge, mode icon, "Untitled Area · 6 points · Draft", "Last edited 14 min
/// ago", then **Resume** (mode color) · Discard.
class DraftBanner extends StatelessWidget {
  const DraftBanner({
    required this.type,
    required this.title,
    required this.status,
    required this.lastEdited,
    required this.onResume,
    required this.onDiscard,
    super.key,
  });

  final MeasurementType type;

  /// "Untitled Area · 6 points"
  final String title;

  /// "Draft" / "Finished · not saved"
  final String status;

  /// "Last edited 14 min ago"
  final String lastEdited;
  final VoidCallback onResume;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final mode = ModeColors.of(context, type);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: LmRadius.mdAll,
        boxShadow: LmShadows.card,
      ),
      child: ClipRRect(
        borderRadius: LmRadius.mdAll,
        child: Material(
          color: colors.surfaceCard,
          child: InkWell(
            onTap: onResume,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(width: 4, color: mode.main),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        LmSpacing.s12,
                        LmSpacing.s12,
                        LmSpacing.s8,
                        LmSpacing.s4,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: mode.container,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  modeIcon(type),
                                  size: 22,
                                  color: mode.main,
                                ),
                              ),
                              const SizedBox(width: LmSpacing.s12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$title · $status',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: LmTypography.bodyLg.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: colors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      lastEdited,
                                      style: LmTypography.caption.copyWith(
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Wrap(
                              spacing: LmSpacing.s4,
                              children: [
                                TextButton(
                                  onPressed: onDiscard,
                                  style: TextButton.styleFrom(
                                    foregroundColor: colors.textSecondary,
                                  ),
                                  child: Text(l10n.actionDiscard),
                                ),
                                TextButton(
                                  onPressed: onResume,
                                  style: TextButton.styleFrom(
                                    foregroundColor: mode.main,
                                    textStyle: LmTypography.bodyMd.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  child: Text(l10n.ctaResume),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
