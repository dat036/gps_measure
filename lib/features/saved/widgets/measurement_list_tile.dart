import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_shadows.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/widgets/dashed_border.dart';
import 'package:gps_measurement/core/widgets/type_chip.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/features/saved/widgets/measurement_thumbnail.dart';

/// Measurement row (`design.md` §2.12): thumbnail · name · main value ·
/// "Sep 22, 2026 · Area" · ⋯. Drafts get a dashed outline on the page
/// color and a DRAFT chip (§5.7).
class MeasurementListTile extends StatelessWidget {
  const MeasurementListTile({
    required this.type,
    required this.title,
    required this.subtitle,
    this.value,
    this.thumbnail,
    this.showTypeChip = false,
    this.draftLabel,
    this.trailing,
    this.onTap,
    super.key,
  });

  final MeasurementType type;
  final String title;

  /// Date line, e.g. "Sep 22, 2026 · Area".
  final String subtitle;

  /// Main result ("2.48 ha"); null → nothing shown.
  final String? value;
  final File? thumbnail;
  final bool showTypeChip;

  /// Non-null for drafts: "Draft" or "Finished · not saved".
  final String? draftLabel;

  /// Usually a [TileMenuButton] (40×40).
  final Widget? trailing;
  final VoidCallback? onTap;

  static const double minHeight = 84;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    final draft = draftLabel != null;
    // No right padding: the 48 dp ⋯ touch target reaches the card edge,
    // its icon stays where the 40 dp design puts it.
    final content = Padding(
      padding: const EdgeInsets.fromLTRB(
        LmSpacing.s12,
        LmSpacing.s12,
        0,
        LmSpacing.s12,
      ),
      child: Row(
        children: [
          MeasurementThumbnail(type: type, file: thumbnail),
          const SizedBox(width: LmSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: LmTypography.bodyLg.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    if (showTypeChip) ...[
                      const SizedBox(width: LmSpacing.s8),
                      TypeChip(type: type),
                    ],
                  ],
                ),
                if (value != null)
                  Text(
                    value!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: LmTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.w500,
                      fontFeatures: LmTypography.tabular,
                      color: colors.textSecondary,
                    ),
                  ),
                const SizedBox(height: 2),
                LayoutBuilder(
                  builder: (context, constraints) => Row(
                    children: [
                      // Natural width, but at most 3/4 of the line: long
                      // "FINISHED · NOT SAVED" in large text ellipsizes
                      // instead of overflowing.
                      if (draft) ...[
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth * 0.75,
                          ),
                          child: _DraftChip(label: draftLabel!),
                        ),
                        const SizedBox(width: LmSpacing.s8),
                      ],
                      Flexible(
                        child: Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: LmTypography.caption.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );

    final card = Material(
      color: draft ? colors.surfacePage : colors.surfaceCard,
      borderRadius: LmRadius.mdAll,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: minHeight),
          child: content,
        ),
      ),
    );

    if (draft) {
      return DashedBorder(color: colors.outlineDashed, child: card);
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: LmRadius.mdAll,
        boxShadow: LmShadows.card,
      ),
      child: card,
    );
  }
}

class _DraftChip extends StatelessWidget {
  const _DraftChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: colors.divider,
        borderRadius: LmRadius.xsAll,
      ),
      child: Text(
        label.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: LmTypography.labelCaps.copyWith(
          fontSize: 10,
          height: 1.4,
          color: colors.textSecondary,
        ),
      ),
    );
  }
}

/// ⋯ button opening a menu of [actions]: 40 dp in `design.md` §2.12,
/// 48 dp here for the minimum touch target.
class TileMenuButton extends StatelessWidget {
  const TileMenuButton({
    required this.tooltip,
    required this.actions,
    super.key,
  });

  final String tooltip;
  final List<TileMenuAction> actions;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    return SizedBox.square(
      dimension: LmSpacing.touchMin,
      child: PopupMenuButton<int>(
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        icon: Icon(Icons.more_horiz_rounded, color: colors.textSecondary),
        onSelected: (i) => actions[i].onSelected(),
        itemBuilder: (_) => [
          for (final (i, a) in actions.indexed)
            PopupMenuItem<int>(
              value: i,
              child: Text(
                a.label,
                style: a.destructive
                    ? TextStyle(color: colors.dangerMain)
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}

class TileMenuAction {
  const TileMenuAction(this.label, this.onSelected, {this.destructive = false});

  final String label;
  final VoidCallback onSelected;
  final bool destructive;
}
