import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/widgets/type_chip.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/domain/models/enums.dart';

/// Leaving a measure screen never asks (decision B, plan P4-05): back —
/// app bar or Android system back — saves the draft and leaves at once;
/// the previous screen then shows "Draft saved · Area · 6 points" with a
/// **Discard** action. Resume lives on Home (Phase 6).
class LeaveMeasureGuard extends ConsumerWidget {
  const LeaveMeasureGuard({
    required this.type,
    required this.onLeave,
    required this.child,
    this.canPop = true,
    this.onPopBlocked,
    super.key,
  });

  final MeasurementType type;

  /// Flushes pending edits; returns the draft left behind, if any.
  final Future<({String id, int pointCount})?> Function() onLeave;
  final Widget child;

  /// False blocks back (Walk while recording); [onPopBlocked] then runs.
  final bool canPop;
  final VoidCallback? onPopBlocked;

  static const Duration snackDuration = Duration(seconds: 6);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope<Object?>(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          onPopBlocked?.call();
          return;
        }
        // Capture everything now: this screen is going away.
        final messenger = ScaffoldMessenger.of(context);
        final l10n = context.l10n;
        final typeLabel = TypeChip.labelOf(context, type);
        final repository = ref.read(measurementRepositoryProvider);
        unawaited(
          onLeave().then((draft) async {
            if (draft == null) return;
            // Saved in the meantime (Save replaced this screen): not a
            // draft any more, so never offer to discard it.
            final m = await repository.get(draft.id);
            if (m == null || m.status == MeasurementStatus.saved) return;
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  duration: snackDuration,
                  // A SnackBar with an action persists by default: it would
                  // follow the user into the next screen.
                  persist: false,
                  content: Text(
                    l10n.draftSavedSnack(draft.pointCount, typeLabel),
                  ),
                  action: SnackBarAction(
                    label: l10n.actionDiscard,
                    onPressed: () => unawaited(repository.delete(draft.id)),
                  ),
                ),
              );
          }),
        );
      },
      child: child,
    );
  }
}
