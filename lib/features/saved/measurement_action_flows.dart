import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/l10n/measurement_labels.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/core/widgets/lm_dialog.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/features/saved/measurement_actions.dart';
import 'package:gps_measurement/features/saved/widgets/rename_dialog.dart';

/// UI flows (dialog → action → snackbar) shared by Home, Saved and Detail
/// (`plan.md` P6-06/P6-07).
abstract final class MeasurementActionFlows {
  /// Opens the measure screen on the draft (Area/Distance/Walk).
  // TODO(phase-10): analytics draft_resumed{mode, age_min}.
  static void resume(BuildContext context, MeasurementType type, String id) =>
      unawaited(context.push(Routes.measure(type, draftId: id)));

  static void openDetail(BuildContext context, String id) =>
      unawaited(context.push(Routes.detailOf(id)));

  static Future<void> rename(
    BuildContext context,
    WidgetRef ref, {
    required String id,
    required String? name,
    required MeasurementType type,
  }) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final next = await showRenameDialog(
      context,
      initialName: name ?? l10n.titleOf(null, type),
    );
    if (next == null) return;
    final ok = await ref.read(measurementActionsProvider).rename(id, next);
    if (!ok) _snack(messenger, l10n.saveFailed);
  }

  /// Saved measurement: "Delete measurement?" → delete → snackbar. True
  /// when deleted.
  static Future<bool> delete(
    BuildContext context,
    WidgetRef ref, {
    required String id,
  }) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showLmConfirm(
      context,
      title: l10n.dialogDeleteTitle,
      message: l10n.dialogDeleteMessage,
      confirmLabel: l10n.actionDelete,
      cancelLabel: l10n.actionCancel,
      destructive: true,
    );
    if (!ok) return false;
    final deleted = await ref.read(measurementActionsProvider).delete(id);
    _snack(messenger, deleted ? l10n.measurementDeleted : l10n.saveFailed);
    return deleted;
  }

  /// Draft: "Discard this draft?" → delete → snackbar.
  static Future<bool> discard(
    BuildContext context,
    WidgetRef ref, {
    required String id,
  }) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showLmConfirm(
      context,
      title: l10n.dialogDiscardDraftTitle,
      message: l10n.dialogDiscardDraftMessage,
      confirmLabel: l10n.actionDiscard,
      cancelLabel: l10n.actionCancel,
      destructive: true,
    );
    if (!ok) return false;
    final deleted = await ref.read(measurementActionsProvider).delete(id);
    _snack(messenger, deleted ? l10n.draftDiscarded : l10n.saveFailed);
    return deleted;
  }

  static void _snack(ScaffoldMessengerState messenger, String text) => messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}
