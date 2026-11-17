import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_measurement/core/format/date_formatter.dart';
import 'package:gps_measurement/core/format/measurement_value.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/l10n/measurement_labels.dart';
import 'package:gps_measurement/core/widgets/type_chip.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measurement_summary.dart';
import 'package:gps_measurement/features/export/export_sheet.dart';
import 'package:gps_measurement/features/saved/measurement_action_flows.dart';
import 'package:gps_measurement/features/saved/widgets/measurement_list_tile.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';

/// [MeasurementListTile] for a [MeasurementSummary], with its ⋯ menu:
/// saved → Rename · Export · Delete; draft → Resume · Rename · Discard.
/// Tapping opens Detail (saved) or resumes measuring (draft).
class SummaryTile extends ConsumerWidget {
  const SummaryTile({
    required this.summary,
    this.showTypeChip = false,
    super.key,
  });

  final MeasurementSummary summary;
  final bool showTypeChip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final settings = ref.watch(settingsProvider);
    final s = summary;
    final isDraft = s.status != MeasurementStatus.saved;
    final typeLabel = TypeChip.labelOf(context, s.type);
    final date = DateFormatter.date(s.savedAt ?? s.updatedAt, locale);
    final thumb = s.thumbnailPath;

    void resume() => MeasurementActionFlows.resume(context, s.type, s.id);
    void rename() => unawaited(
      MeasurementActionFlows.rename(
        context,
        ref,
        id: s.id,
        name: s.name,
        type: s.type,
      ),
    );

    return MeasurementListTile(
      type: s.type,
      title: l10n.titleOf(s.name, s.type),
      value: MeasurementValue.primary(
        type: s.type,
        areaM2: s.areaM2,
        distanceM: s.distanceM,
        areaUnit: settings.areaUnit,
        distanceUnit: settings.distanceUnit,
        locale: locale,
      ),
      // Drafts: the chip already takes room; the point count matters most.
      subtitle: isDraft
          ? l10n.resultPointCount(s.pointCount)
          : '$date · $typeLabel',
      thumbnail: thumb == null
          ? null
          : ref.read(thumbnailStorageProvider).resolve(thumb),
      showTypeChip: showTypeChip,
      draftLabel: !isDraft
          ? null
          : s.status == MeasurementStatus.completed
          ? l10n.walkFinishedNotSaved
          : l10n.draftLabel,
      onTap: isDraft
          ? resume
          : () => MeasurementActionFlows.openDetail(context, s.id),
      trailing: TileMenuButton(
        tooltip: l10n.menuMore,
        actions: isDraft
            ? [
                TileMenuAction(l10n.ctaResume, resume),
                TileMenuAction(l10n.menuRename, rename),
                TileMenuAction(
                  l10n.actionDiscard,
                  () => unawaited(
                    MeasurementActionFlows.discard(context, ref, id: s.id),
                  ),
                  destructive: true,
                ),
              ]
            : [
                TileMenuAction(l10n.menuRename, rename),
                TileMenuAction(
                  l10n.menuExport,
                  () => unawaited(
                    showExportSheet(context, s.id, name: s.name, type: s.type),
                  ),
                ),
                TileMenuAction(
                  l10n.actionDelete,
                  () => unawaited(
                    MeasurementActionFlows.delete(context, ref, id: s.id),
                  ),
                  destructive: true,
                ),
              ],
      ),
    );
  }
}
