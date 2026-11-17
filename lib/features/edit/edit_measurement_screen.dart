import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/widgets/empty_state.dart';
import 'package:gps_measurement/core/widgets/lm_dialog.dart';
import 'package:gps_measurement/core/widgets/primary_cta.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/features/edit/edit_controller.dart';
import 'package:gps_measurement/features/edit/edit_details_form.dart';
import 'package:gps_measurement/features/measure/common/measure_screen.dart';
import 'package:gps_measurement/services/ads/interstitial_manager.dart';

/// `/edit/:id` (`design.md` §5.9). Area/Distance: the measure screen in
/// edit mode (map + Details tab). Walk: Details only (a GPS track is not
/// edited by hand).
class EditMeasurementScreen extends ConsumerWidget {
  const EditMeasurementScreen({required this.measurementId, super.key});

  final String measurementId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final async = ref.watch(editControllerProvider(measurementId));
    return switch (async) {
      AsyncData(:final value) =>
        value.original.type == MeasurementType.walk
            ? _WalkDetailsEdit(measurementId: measurementId)
            : MeasureScreen(
                type: value.original.type,
                draftId: measurementId,
                editing: true,
              ),
      AsyncError() => Scaffold(
        appBar: AppBar(title: Text(l10n.screenEdit)),
        body: EmptyState(
          icon: Icons.search_off_rounded,
          title: l10n.saveNotFound,
        ),
      ),
      _ => Scaffold(
        appBar: AppBar(title: Text(l10n.screenEdit)),
        body: const Center(child: CircularProgressIndicator()),
      ),
    };
  }
}

class _WalkDetailsEdit extends ConsumerStatefulWidget {
  const _WalkDetailsEdit({required this.measurementId});

  final String measurementId;

  @override
  ConsumerState<_WalkDetailsEdit> createState() => _WalkDetailsEditState();
}

class _WalkDetailsEditState extends ConsumerState<_WalkDetailsEdit> {
  bool _discarded = false;

  EditControllerProvider get _provider =>
      editControllerProvider(widget.measurementId);

  Future<void> _save() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final ok = await ref.read(_provider.notifier).saveChanges();
    if (!ok) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.saveFailed)));
      return;
    }
    // Interstitial after Save Changes (at most one per 30 s), then leave.
    await ref.read(interstitialManagerProvider).showIfReady();
    if (!mounted) return;
    navigator.pop();
    messenger.showSnackBar(SnackBar(content: Text(l10n.changesSaved)));
  }

  Future<void> _confirmDiscard() async {
    final l10n = context.l10n;
    final navigator = Navigator.of(context);
    final discard = await showLmConfirm(
      context,
      title: l10n.dialogDiscardChangesTitle,
      message: l10n.dialogDiscardChangesMessage,
      confirmLabel: l10n.actionDiscard,
      cancelLabel: l10n.actionKeepEditing,
      destructive: true,
    );
    if (!discard) return;
    await ref.read(_provider.notifier).discard();
    setState(() => _discarded = true);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final s = ref.watch(_provider).value;
    if (s == null) return const SizedBox.shrink();
    final dirty = s.detailsChanged;
    return PopScope<Object?>(
      canPop: !dirty || _discarded,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_confirmDiscard());
      },
      child: Scaffold(
        backgroundColor: LmColors.of(context).surfaceSheet,
        appBar: AppBar(title: Text(l10n.screenEdit)),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: LmSpacing.s12),
          children: [
            EditDetailsForm(
              measurementId: widget.measurementId,
              points: s.original.points,
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              LmSpacing.pageH,
              LmSpacing.s8,
              LmSpacing.pageH,
              LmSpacing.s12,
            ),
            child: PrimaryCta(
              label: l10n.ctaSaveChanges,
              variant: PrimaryCtaVariant.walk,
              icon: Icons.check_circle_outline_rounded,
              loading: s.saving,
              onPressed: dirty && s.nameValid ? () => unawaited(_save()) : null,
            ),
          ),
        ),
      ),
    );
  }
}
