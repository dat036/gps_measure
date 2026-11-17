import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/location/location_service.dart';
import 'package:gps_measurement/core/permissions/permission_flows.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/core/widgets/lm_dialog.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/photo.dart';
import 'package:gps_measurement/features/measure/common/add_photo_sheet.dart';
import 'package:gps_measurement/features/photos/photo_actions.dart';
import 'package:gps_measurement/features/photos/photo_picker.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:gps_measurement/features/premium/premium_flows.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';

/// Photo UI flows (sheet → permission → picker → import → snackbar) shared
/// by the measure screens, Save, Detail and Edit.
abstract final class PhotoFlows {
  /// Add Photo (`plan.md` P7-01). [pointId]/[pointNumber]: attach to the
  /// selected point. [location]: where it was taken (point position); else
  /// the last known GPS fix, if any. Returns the photos added.
  static Future<List<Photo>> add(
    BuildContext context,
    WidgetRef ref, {
    required String measurementId,
    String? pointId,
    int? pointNumber,
    GeoPoint? location,
  }) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    void snack(String text) => messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));

    var actions = ref.read(photoActionsProvider);
    var remaining = await actions.remaining(measurementId);
    if (remaining == 0) {
      if (!context.mounted) return const [];
      final premium = await PremiumFlows.promptUpgrade(
        context,
        message: l10n.premiumPromptPhotos(
          ref.read(featureGateProvider).config.freeMaxPhotos,
        ),
        source: PaywallSource.photoLimit,
      );
      if (!premium) {
        snack(l10n.photoLimitReached);
        return const [];
      }
      // A new gate came with premium.
      actions = ref.read(photoActionsProvider);
      remaining = await actions.remaining(measurementId);
      if (remaining == 0) return const [];
    }
    if (!context.mounted) return const [];
    final choice = await showAddPhotoSheet(context, pointNumber: pointNumber);
    if (choice == null || !context.mounted) return const [];

    final picker = ref.read(photoPickerProvider);
    final at = location ?? await ref.read(locationServiceProvider).lastKnown();
    if (!context.mounted) return const [];
    try {
      switch (choice) {
        case PhotoSourceChoice.camera:
          if (!await PermissionFlows.camera(context, ref)) return const [];
          final file = await picker.takePhoto();
          if (file == null || !context.mounted) return const [];
          if (!ref.read(settingsProvider).savePhotosToMeasurement) {
            final attach = await showLmConfirm(
              context,
              title: l10n.photoAttachTitle,
              message: l10n.photoAttachMessage,
              confirmLabel: l10n.actionAttach,
              cancelLabel: l10n.actionDiscard,
            );
            if (!attach) {
              await ref.read(photoStorageProvider).discardCapture(file);
              return const [];
            }
          }
          return [
            await actions.addFromCamera(
              file,
              measurementId,
              pointId: pointId,
              location: at,
            ),
          ];
        case PhotoSourceChoice.gallery:
          final files = await picker.pickFromGallery(limit: remaining);
          return actions.addFromGallery(
            files,
            measurementId,
            pointId: pointId,
            location: at,
          );
      }
    } on AppException catch (e, st) {
      Log.e('Adding a photo failed', e, st);
      snack(l10n.photoAddFailed);
      return const [];
    } on Exception catch (e, st) {
      // Picker/platform errors (camera unavailable…).
      Log.w('Photo picker failed', e, st);
      snack(l10n.photoAddFailed);
      return const [];
    }
  }

  /// In a measuring session / Save: remove now, "Photo removed · Undo".
  static Future<void> removeWithUndo(
    BuildContext context,
    WidgetRef ref,
    Photo photo,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final actions = ref.read(photoActionsProvider);
    try {
      await actions.removeWithUndo(photo);
    } on AppException catch (e, st) {
      Log.e('Removing a photo failed', e, st);
      return;
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.photoRemoved),
          duration: actions.undoWindow,
          persist: false,
          action: SnackBarAction(
            label: l10n.actionUndo,
            onPressed: () => unawaited(actions.undoRemove(photo)),
          ),
        ),
      );
  }

  /// Detail / viewer: "Delete photo?" first. True when deleted.
  static Future<bool> removeConfirmed(
    BuildContext context,
    WidgetRef ref,
    Photo photo,
  ) async {
    final l10n = context.l10n;
    final ok = await showLmConfirm(
      context,
      title: l10n.photoDeleteTitle,
      message: l10n.photoDeleteMessage,
      confirmLabel: l10n.actionDelete,
      cancelLabel: l10n.actionCancel,
      destructive: true,
    );
    if (!ok) return false;
    try {
      await ref.read(photoActionsProvider).removeNow(photo);
      return true;
    } on AppException catch (e, st) {
      Log.e('Deleting a photo failed', e, st);
      return false;
    }
  }
}
