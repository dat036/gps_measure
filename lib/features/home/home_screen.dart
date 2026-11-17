import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/l10n/measurement_labels.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_premium_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/core/widgets/empty_state.dart';
import 'package:gps_measurement/core/widgets/section_header.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measurement_summary.dart';
import 'package:gps_measurement/features/home/home_controller.dart';
import 'package:gps_measurement/features/home/widgets/draft_banner.dart';
import 'package:gps_measurement/features/home/widgets/hero_measure_card.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:gps_measurement/features/premium/premium_flows.dart';
import 'package:gps_measurement/features/saved/measurement_action_flows.dart';
import 'package:gps_measurement/features/saved/saved_controller.dart';
import 'package:gps_measurement/features/saved/widgets/summary_tile.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';

/// Home tab (`design.md` §5.1): hero card with mode selector and Start CTA,
/// the latest draft ("Continue Measurement"), 3 recent saved measurements.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _starting = false;

  Future<void> _start(MeasurementType mode) async {
    if (_starting) return;
    _starting = true;
    try {
      final repo = ref.read(measurementRepositoryProvider);
      final count = await repo.countSaved();
      if (!mounted) return;
      final gate = ref.read(featureGateProvider);
      if (gate.canSaveNew(count)) {
        unawaited(context.push(Routes.measure(mode)));
        return;
      }
      if (!await PremiumFlows.unlockProject(context, ref) || !mounted) return;
      final style = ref
          .read(featureGateProvider)
          .effectiveMapStyle(ref.read(settingsProvider).mapStyle);
      final prefs = ref.read(sharedPreferencesProvider);
      final draft = await repo.createDraft(mode, style);
      await prefs.setBool(PremiumFlows.projectUnlockKey(draft.id), true);
      if (mounted) {
        unawaited(context.push(Routes.measure(mode, draftId: draft.id)));
      }
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.saveFailed)),
        );
      }
    } finally {
      _starting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final mode = ref.watch(homeControllerProvider);
    final drafts = ref.watch(draftListProvider).value ?? const [];
    final recent = ref.watch(recentListProvider);

    return Scaffold(
      backgroundColor: colors.surfacePage,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            LmSpacing.pageH,
            0,
            LmSpacing.pageH,
            LmSpacing.s24,
          ),
          children: [
            const _Header(),
            HeroMeasureCard(
              mode: mode,
              onModeChanged: ref.read(homeControllerProvider.notifier).select,
              // TODO(phase-10): analytics measure_start{mode, source: home}.
              onStart: () => unawaited(_start(mode)),
            ),
            if (drafts.isNotEmpty) ...[
              const SizedBox(height: LmSpacing.s12),
              SectionHeader(
                title: l10n.homeContinueTitle,
                actionLabel: drafts.length > 1 ? l10n.homeSeeAllDrafts : null,
                onAction: () => context.go(Routes.saved),
              ),
              _LatestDraft(draft: drafts.first),
            ],
            const SizedBox(height: LmSpacing.s12),
            SectionHeader(
              title: l10n.homeRecentTitle,
              actionLabel: l10n.actionSeeAll,
              onAction: (recent.value?.isEmpty ?? true)
                  ? null
                  : () => context.go(Routes.saved),
            ),
            ...switch (recent) {
              AsyncData(:final value) when value.isEmpty => [
                EmptyState.compact(
                  title: l10n.homeRecentEmptyTitle,
                  message: l10n.homeRecentEmptyMessage,
                ),
              ],
              AsyncData(:final value) => [
                for (final s in value) ...[
                  SummaryTile(summary: s),
                  const SizedBox(height: LmSpacing.s8),
                ],
              ],
              _ => const <Widget>[],
            },
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          Icon(Icons.location_on_rounded, size: 28, color: colors.brandPrimary),
          const SizedBox(width: LmSpacing.s8),
          Expanded(
            child: Text(
              context.l10n.appTitle,
              style: LmTypography.titleScreen.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: LmSpacing.s8),
          IconButton.filledTonal(
            tooltip: context.l10n.premiumBadge,
            style: IconButton.styleFrom(
              foregroundColor: LmPremiumColors.gold,
              backgroundColor: LmPremiumColors.background,
              minimumSize: const Size(48, 48),
            ),
            onPressed: () => context.push(Routes.paywallFrom('home')),
            icon: const Icon(Icons.workspace_premium_rounded),
          ),
        ],
      ),
    );
  }
}

class _LatestDraft extends ConsumerWidget {
  const _LatestDraft({required this.draft});

  final MeasurementSummary draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final now = ref.watch(clockProvider).nowUtc();
    return DraftBanner(
      type: draft.type,
      title:
          '${l10n.titleOf(draft.name, draft.type)} · '
          '${l10n.resultPointCount(draft.pointCount)}',
      status: draft.status == MeasurementStatus.completed
          ? l10n.walkFinishedNotSaved
          : l10n.draftLabel,
      lastEdited: l10n.lastEdited(
        l10n.relativeTime(draft.updatedAt, now, locale),
      ),
      onResume: () =>
          MeasurementActionFlows.resume(context, draft.type, draft.id),
      onDiscard: () => unawaited(
        MeasurementActionFlows.discard(context, ref, id: draft.id),
      ),
    );
  }
}
