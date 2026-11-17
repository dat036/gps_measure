import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_measurement/core/format/date_formatter.dart';
import 'package:gps_measurement/core/format/money_formatter.dart';
import 'package:gps_measurement/core/format/unit_formatter.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/l10n/measurement_labels.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_shadows.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/core/widgets/empty_state.dart';
import 'package:gps_measurement/core/widgets/mode_icon.dart';
import 'package:gps_measurement/core/widgets/section_header.dart';
import 'package:gps_measurement/core/widgets/type_chip.dart';
import 'package:gps_measurement/core/widgets/unit_chips.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:gps_measurement/domain/units/land_value.dart';
import 'package:gps_measurement/features/detail/detail_controller.dart';
import 'package:gps_measurement/features/detail/detail_native_ad.dart';
import 'package:gps_measurement/features/detail/land_value_sheet.dart';
import 'package:gps_measurement/features/detail/notes_sheet.dart';
import 'package:gps_measurement/features/detail/result_grid.dart';
import 'package:gps_measurement/features/export/export_sheet.dart';
import 'package:gps_measurement/features/measure/common/photo_strip.dart';
import 'package:gps_measurement/features/photos/photo_actions.dart';
import 'package:gps_measurement/features/photos/photo_flows.dart';
import 'package:gps_measurement/features/save/land_value_field.dart';
import 'package:gps_measurement/features/saved/measurement_action_flows.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:gps_measurement/services/ads/banner_ad_slot.dart';

/// Measurement Detail (`design.md` §5.8).
class DetailScreen extends ConsumerWidget {
  const DetailScreen({required this.measurementId, super.key});

  final String measurementId;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final router = GoRouter.of(context);
    final deleted = await MeasurementActionFlows.delete(
      context,
      ref,
      id: measurementId,
    );
    if (!deleted) return;
    if (router.canPop()) {
      router.pop();
    } else {
      router.go(Routes.saved);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final async = ref.watch(detailControllerProvider(measurementId));
    final m = async.value;

    return Scaffold(
      backgroundColor: colors.surfacePage,
      appBar: AppBar(
        title: Text(l10n.screenDetail),
        actions: [
          if (m != null)
            PopupMenuButton<int>(
              tooltip: l10n.menuMore,
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (i) => i == 0
                  ? unawaited(
                      MeasurementActionFlows.rename(
                        context,
                        ref,
                        id: m.id,
                        name: m.name,
                        type: m.type,
                      ),
                    )
                  : unawaited(_delete(context, ref)),
              itemBuilder: (_) => [
                PopupMenuItem(value: 0, child: Text(l10n.menuRename)),
                PopupMenuItem(
                  value: 1,
                  child: Text(
                    l10n.actionDelete,
                    style: TextStyle(color: colors.dangerMain),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: switch (async) {
        AsyncData(value: final Measurement m) => _Body(measurement: m),
        AsyncData() || AsyncError() => EmptyState(
          icon: Icons.search_off_rounded,
          title: l10n.saveNotFound,
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
      bottomNavigationBar: m == null
          ? null
          : _ActionBar(
              onEdit: () => unawaited(context.push(Routes.editOf(m.id))),
              onExport: () => unawaited(
                showExportSheet(context, m.id, name: m.name, type: m.type),
              ),
              onDelete: () => unawaited(_delete(context, ref)),
            ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.measurement});

  final Measurement measurement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final locale = Localizations.localeOf(context).toString();
    final settings = ref.watch(settingsProvider);
    final m = measurement;
    final controller = ref.read(detailControllerProvider(m.id).notifier);
    final areaUnit = m.displayAreaUnit ?? settings.areaUnit;
    final distanceUnit = m.displayDistanceUnit ?? settings.distanceUnit;
    final hasArea = m.stats.areaM2 != null;
    final thumb = m.thumbnailPath;
    final date = DateFormatter.dateTime(m.savedAt ?? m.updatedAt, locale);
    final notes = m.notes?.trim();
    final estimate = LandValue.estimate(
      areaM2: m.stats.areaM2,
      unitPrice: m.unitPrice,
      priceUnit: m.unitPriceArea,
    );
    final currency = m.unitPriceCurrency ?? 'VND';
    final landValue = estimate == null
        ? null
        : (
            value: MoneyFormatter.format(
              estimate,
              locale: locale,
              currency: currency,
            ),
            rate: l10n.landValueRate(
              MoneyFormatter.format(
                m.unitPrice!,
                locale: locale,
                currency: currency,
              ),
              UnitFormatter.areaSymbol(m.unitPriceArea!),
            ),
          );

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: LmSpacing.s12),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
          child: _MapPreview(
            type: m.type,
            thumbnail: thumb == null
                ? null
                : ref.read(thumbnailStorageProvider).resolve(thumb),
            onTap: () => unawaited(context.push(Routes.detailMapOf(m.id))),
          ),
        ),
        const SizedBox(height: LmSpacing.s16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.titleOf(m.name, m.type),
                style: LmTypography.titleScreen.copyWith(
                  fontSize: 22,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: LmSpacing.s4),
              Row(
                children: [
                  TypeChip(type: m.type),
                  const SizedBox(width: LmSpacing.s8),
                  Expanded(
                    child: Text(
                      m.savedAt == null ? date : l10n.savedOn(date),
                      style: LmTypography.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Free users: right under the name.
        DetailNativeAd(type: m.type),
        const SizedBox(height: LmSpacing.s16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
          child: ResultGrid(
            type: m.type,
            stats: m.stats,
            areaUnit: areaUnit,
            distanceUnit: distanceUnit,
            showSecondary: settings.showSecondaryUnit,
            landValue: landValue,
          ),
        ),
        const SizedBox(height: LmSpacing.s12),
        if (m.type == MeasurementType.area || hasArea)
          UnitChips<AreaUnit>(
            units: AreaUnit.values,
            selected: areaUnit,
            labelOf: UnitFormatter.areaSymbol,
            onSelected: (u) => unawaited(controller.setAreaUnit(u)),
            mode: m.type,
          ),
        if (m.type != MeasurementType.area)
          UnitChips<DistanceUnit>(
            units: DistanceUnit.values,
            selected: distanceUnit,
            labelOf: UnitFormatter.distanceSymbol,
            onSelected: (u) => unawaited(controller.setDistanceUnit(u)),
            mode: m.type,
          ),
        if (hasArea)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
            child: SectionHeader(
              title: l10n.landValueTitle,
              actionLabel: m.unitPrice == null
                  ? l10n.landValueAdd
                  : l10n.actionEdit,
              onAction: () => unawaited(_editLandValue(context, ref, m)),
            ),
          ),
        const SizedBox(height: LmSpacing.s12),
        PhotoStrip(
          photos: m.photos,
          resolve: ref.read(photoStorageProvider).resolve,
          pointNumbers: {
            for (final (i, p) in m.points.indexed) p.id: i + 1,
          },
          importing: ref.watch(photoImportsProvider),
          onOpen: (i) => unawaited(
            context.push(Routes.photosOf(m.id, index: i)),
          ),
          onAdd: () => unawaited(
            PhotoFlows.add(context, ref, measurementId: m.id),
          ),
          onRemove: (p) =>
              unawaited(PhotoFlows.removeConfirmed(context, ref, p)),
        ),
        const SizedBox(height: LmSpacing.s8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
          child: SectionHeader(
            title: l10n.notesTitle,
            actionLabel: notes == null || notes.isEmpty
                ? l10n.notesAdd
                : l10n.actionEdit,
            onAction: () => unawaited(_editNotes(context, controller, notes)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
          child: InkWell(
            borderRadius: LmRadius.smAll,
            onTap: () => unawaited(_editNotes(context, controller, notes)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: LmSpacing.s4),
              child: Text(
                notes == null || notes.isEmpty ? l10n.notesEmpty : notes,
                style: LmTypography.bodyMd.copyWith(
                  color: notes == null || notes.isEmpty
                      ? colors.textTertiary
                      : colors.textPrimary,
                ),
              ),
            ),
          ),
        ),
        // Free users: below the content, away from the action bar so it
        // is not tapped by mistake (AdMob placement policy).
        const SizedBox(height: LmSpacing.s16),
        const BannerAdSlot(),
      ],
    );
  }
}

Future<void> _editLandValue(
  BuildContext context,
  WidgetRef ref,
  Measurement m,
) async {
  final settings = ref.read(settingsProvider);
  final edit = await showLandValueSheet(
    context,
    areaM2: m.stats.areaM2,
    initial: landPriceOf(
      m,
      fallbackUnit: m.displayAreaUnit ?? settings.areaUnit,
      region: ref.read(deviceLocaleProvider).countryCode,
    ),
  );
  final controller = ref.read(detailControllerProvider(m.id).notifier);
  switch (edit) {
    case LandValueSet(:final price):
      await controller.setLandValue(price);
    case LandValueRemoved():
      await controller.setLandValue(null);
    case null:
      break;
  }
}

Future<void> _editNotes(
  BuildContext context,
  DetailController controller,
  String? current,
) async {
  final next = await showNotesSheet(context, initial: current ?? '');
  if (next != null) await controller.setNotes(next);
}

/// Map snapshot 16:10; tap → full map.
class _MapPreview extends StatelessWidget {
  const _MapPreview({
    required this.type,
    required this.thumbnail,
    required this.onTap,
  });

  final MeasurementType type;
  final File? thumbnail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    final mode = ModeColors.of(context, type);
    final fallback = ColoredBox(
      color: mode.container,
      child: Center(child: Icon(modeIcon(type), size: 48, color: mode.main)),
    );
    return Semantics(
      button: true,
      label: context.l10n.detailOpenMap,
      child: ClipRRect(
        borderRadius: LmRadius.mdAll,
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (thumbnail case final File file)
                Image.file(
                  file,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => fallback,
                )
              else
                fallback,
              Positioned(
                right: LmSpacing.s12,
                bottom: LmSpacing.s12,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.surfaceCard,
                    shape: BoxShape.circle,
                    boxShadow: LmShadows.float,
                  ),
                  child: Icon(
                    Icons.open_in_full_rounded,
                    size: 20,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Material(
                type: MaterialType.transparency,
                child: InkWell(onTap: onTap),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Edit (outlined) · Export (outlined) · 🗑 (red icon).
class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.onEdit,
    required this.onExport,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onExport;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final style = OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(48),
      foregroundColor: colors.textPrimary,
      side: BorderSide(color: colors.divider),
      shape: const RoundedRectangleBorder(borderRadius: LmRadius.mdAll),
    );
    return ColoredBox(
      color: colors.surfaceSheet,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            LmSpacing.pageH,
            LmSpacing.s8,
            LmSpacing.pageH,
            LmSpacing.s12,
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEdit,
                  style: style,
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(l10n.actionEdit),
                ),
              ),
              const SizedBox(width: LmSpacing.s12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onExport,
                  style: style,
                  icon: const Icon(Icons.ios_share_rounded),
                  label: Text(l10n.actionExport),
                ),
              ),
              const SizedBox(width: LmSpacing.s12),
              IconButton(
                tooltip: l10n.actionDelete,
                onPressed: onDelete,
                style: IconButton.styleFrom(
                  minimumSize: const Size.square(48),
                  side: BorderSide(color: colors.divider),
                  shape: const RoundedRectangleBorder(
                    borderRadius: LmRadius.mdAll,
                  ),
                ),
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: colors.dangerMain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
