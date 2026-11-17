import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/core/widgets/empty_state.dart';
import 'package:gps_measurement/core/widgets/primary_cta.dart';
import 'package:gps_measurement/core/widgets/type_chip.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measurement_summary.dart';
import 'package:gps_measurement/features/saved/saved_controller.dart';
import 'package:gps_measurement/features/saved/widgets/summary_tile.dart';

/// Saved tab (`design.md` §5.7): search, type chips with counts, the
/// collapsible Drafts section (drafts + finished walks), saved list.
class SavedScreen extends ConsumerWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final filter = ref.watch(savedControllerProvider);
    final controller = ref.read(savedControllerProvider.notifier);
    final counts = ref.watch(savedCountsProvider).value ?? const {};
    final saved = ref.watch(savedListProvider);
    final allDrafts = ref.watch(draftListProvider).value ?? const [];
    final drafts = [
      for (final d in allDrafts)
        if (filter.type == null || d.type == filter.type) d,
    ];
    final total = counts.values.fold(0, (a, b) => a + b);
    final showDrafts = !filter.searching && drafts.isNotEmpty;

    final list = <Widget>[];
    if (showDrafts) {
      list
        ..add(
          _DraftsHeader(
            count: drafts.length,
            expanded: filter.draftsExpanded,
            onToggle: controller.toggleDrafts,
          ),
        )
        ..addAll(
          filter.draftsExpanded ? _tiles(drafts, typeChip: true) : const [],
        )
        ..add(const SizedBox(height: LmSpacing.s8));
    }
    switch (saved) {
      case AsyncData(:final value) when value.isNotEmpty:
        list.addAll(_tiles(value, typeChip: true));
      case AsyncData():
        final nothingAtAll =
            total == 0 && allDrafts.isEmpty && filter.query.isEmpty;
        list.add(
          nothingAtAll
              ? EmptyState(
                  title: l10n.emptyNoMeasurementsTitle,
                  message: l10n.emptyNoMeasurementsMessage,
                  action: PrimaryCta(
                    label: l10n.ctaStartMeasuring,
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () => context.go(Routes.home),
                  ),
                )
              : showDrafts && filter.query.isEmpty
              ? const SizedBox.shrink()
              : EmptyState(
                  icon: Icons.search_off_rounded,
                  title: l10n.savedNoResults,
                ),
        );
      case AsyncError():
        list.add(
          EmptyState(
            icon: Icons.error_outline_rounded,
            title: l10n.saveFailed,
          ),
        );
      case AsyncLoading():
        list.add(
          const Padding(
            padding: EdgeInsets.all(LmSpacing.s32),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
    }

    return Scaffold(
      backgroundColor: colors.surfacePage,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
              child: filter.searching
                  ? _SearchField(
                      onChanged: controller.setQuery,
                      onClose: controller.closeSearch,
                    )
                  : _Header(onSearch: controller.openSearch),
            ),
            _TypeChips(
              selected: filter.type,
              counts: counts,
              total: total,
              onSelected: controller.setType,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  LmSpacing.pageH,
                  LmSpacing.s8,
                  LmSpacing.pageH,
                  LmSpacing.s24,
                ),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: list,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static List<Widget> _tiles(
    List<MeasurementSummary> items, {
    required bool typeChip,
  }) => [
    for (final s in items)
      Padding(
        key: ValueKey(s.id),
        padding: const EdgeInsets.only(bottom: LmSpacing.s8),
        child: SummaryTile(summary: s, showTypeChip: typeChip),
      ),
  ];
}

class _Header extends StatelessWidget {
  const _Header({required this.onSearch});

  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          Icon(Icons.location_on_rounded, size: 28, color: colors.brandPrimary),
          const SizedBox(width: LmSpacing.s8),
          Expanded(
            child: Text(
              l10n.screenSaved,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: LmTypography.titleScreen.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.savedSearchOpen,
            icon: const Icon(Icons.search_rounded),
            onPressed: onSearch,
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged, required this.onClose});

  final ValueChanged<String> onChanged;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      height: 56,
      child: Center(
        child: TextField(
          autofocus: true,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            isDense: true,
            hintText: l10n.savedSearchHint,
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: IconButton(
              tooltip: l10n.savedSearchClose,
              icon: const Icon(Icons.close_rounded),
              onPressed: onClose,
            ),
            border: const OutlineInputBorder(borderRadius: LmRadius.fullAll),
          ),
        ),
      ),
    );
  }
}

class _TypeChips extends StatelessWidget {
  const _TypeChips({
    required this.selected,
    required this.counts,
    required this.total,
    required this.onSelected,
  });

  final MeasurementType? selected;
  final Map<MeasurementType, int> counts;
  final int total;
  final ValueChanged<MeasurementType?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final options = <(MeasurementType?, String)>[
      (null, l10n.filterWithCount(l10n.filterAll, total)),
      for (final t in MeasurementType.values)
        (t, l10n.filterWithCount(TypeChip.labelOf(context, t), counts[t] ?? 0)),
    ];
    return SizedBox(
      height: LmSpacing.touchMin,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: LmSpacing.pageH),
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: LmSpacing.s8),
        itemBuilder: (context, i) {
          final (type, label) = options[i];
          final isSelected = type == selected;
          final main = type == null
              ? colors.brandPrimary
              : ModeColors.of(context, type).main;
          final container = type == null
              ? colors.areaContainer
              : ModeColors.of(context, type).container;
          return Center(
            child: ChoiceChip(
              label: Text(label),
              selected: isSelected,
              showCheckmark: false,
              onSelected: (_) => onSelected(type),
              selectedColor: container,
              backgroundColor: colors.surfaceCard,
              side: BorderSide(color: isSelected ? main : colors.divider),
              shape: const RoundedRectangleBorder(
                borderRadius: LmRadius.fullAll,
              ),
              labelStyle: LmTypography.bodyMd.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? main : colors.textSecondary,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DraftsHeader extends StatelessWidget {
  const _DraftsHeader({
    required this.count,
    required this.expanded,
    required this.onToggle,
  });

  final int count;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    return InkWell(
      onTap: onToggle,
      borderRadius: LmRadius.smAll,
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            Expanded(
              child: Text(
                context.l10n.savedDraftsTitle(count),
                style: LmTypography.titleSection.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
            AnimatedRotation(
              turns: expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 150),
              child: Icon(
                Icons.expand_more_rounded,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
