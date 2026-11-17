import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/location/location_service.dart';
import 'package:gps_measurement/core/permissions/permission_prompt_sheet.dart';
import 'package:gps_measurement/core/permissions/permission_service.dart';
import 'package:gps_measurement/data/providers.dart';

/// Asking for a permission (`design.md` §5.16): our pre-prompt sheet first,
/// then the system dialog; refused for good → the sheet offers "Open
/// Settings" instead. Refusing never blocks the rest of the app.
abstract final class PermissionFlows {
  /// Camera before taking a photo. True when it may be used now.
  static Future<bool> camera(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final permissions = ref.read(permissionServiceProvider);
    final access = await permissions.cameraStatus();
    if (access == PermissionAccess.granted) return true;
    if (!context.mounted) return false;
    final blocked = access == PermissionAccess.blocked;
    final go = await showPermissionPromptSheet(
      context,
      icon: Icons.photo_camera_outlined,
      title: l10n.cameraPermissionTitle,
      message: blocked
          ? l10n.cameraPermissionDenied
          : l10n.cameraPermissionMessage,
      blocked: blocked,
    );
    if (!go) return false;
    if (blocked) {
      await permissions.openAppSettings();
      return false;
    }
    return await permissions.requestCamera() == PermissionAccess.granted;
  }

  /// "While in use" location. [message] says why this screen needs it.
  /// Returns the access after the flow; a location service that is off is
  /// returned as is (the caller shows its own banner/snackbar).
  static Future<LocationAccess> location(
    BuildContext context,
    WidgetRef ref, {
    String? message,
  }) async {
    final l10n = context.l10n;
    final location = ref.read(locationServiceProvider);
    final access = await location.ensureAccess(request: false);
    if (access == LocationAccess.granted ||
        access == LocationAccess.serviceDisabled ||
        !context.mounted) {
      return access;
    }
    final blocked = access == LocationAccess.deniedForever;
    final go = await showPermissionPromptSheet(
      context,
      icon: Icons.location_on_outlined,
      title: l10n.locationPermissionTitle,
      message: blocked
          ? l10n.locationPermissionBlocked
          : message ?? l10n.locationPermissionMessage,
      blocked: blocked,
    );
    if (!go) return access;
    if (blocked) {
      await ref.read(permissionServiceProvider).openAppSettings();
      return access;
    }
    return location.ensureAccess();
  }

  /// Android 13+: before the first Start Walking, explain and ask for
  /// notifications so the recording notification shows. Asked once per
  /// install; refusing is fine (recording still works).
  static Future<void> walkNotificationsOnce(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final settings = ref.read(settingsRepositoryProvider);
    if (settings.walkNotificationAsked) return;
    final permissions = ref.read(permissionServiceProvider);
    final access = await permissions.notificationStatus();
    await settings.setWalkNotificationAsked();
    // Blocked: a sheet sending people to Settings right when they want to
    // start walking would get in the way.
    if (access != PermissionAccess.askable || !context.mounted) return;
    final l10n = context.l10n;
    final go = await showPermissionPromptSheet(
      context,
      icon: Icons.notifications_active_outlined,
      title: l10n.notificationPermissionTitle,
      message: l10n.notificationPermissionMessage,
    );
    if (go) await permissions.requestNotifications();
  }
}
