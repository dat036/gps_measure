import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permission_service.g.dart';

/// Runtime permissions other than location (which `LocationService` checks,
/// since it also knows whether the location service is on). The UI asks
/// through `PermissionFlows` (pre-prompt first, `design.md` §5.16).
abstract interface class PermissionService {
  /// Camera for site photos.
  Future<PermissionAccess> cameraStatus();

  /// Shows the system dialog when it still can; returns the outcome.
  Future<PermissionAccess> requestCamera();

  /// Android 13+ POST_NOTIFICATIONS (Walk recording notification).
  /// [PermissionAccess.granted] on other platforms: iOS asks for push in
  /// Phase 10 and the walk indicator there needs no permission.
  Future<PermissionAccess> notificationStatus();

  Future<PermissionAccess> requestNotifications();

  /// Opens this app's page in system Settings.
  Future<bool> openAppSettings();
}

enum PermissionAccess {
  granted,

  /// Not granted yet; the system dialog can still be shown.
  askable,

  /// "Don't ask again" / restricted: only system Settings can grant it.
  blocked,
}

class PermissionHandlerService implements PermissionService {
  const PermissionHandlerService();

  @override
  Future<PermissionAccess> cameraStatus() async =>
      _access(await Permission.camera.status);

  @override
  Future<PermissionAccess> requestCamera() async {
    // TODO(phase-10): analytics permission_result{type: camera, result}.
    return _access(await Permission.camera.request());
  }

  static bool get _asksNotifications =>
      defaultTargetPlatform == TargetPlatform.android;

  @override
  Future<PermissionAccess> notificationStatus() async => _asksNotifications
      ? _access(await Permission.notification.status)
      : PermissionAccess.granted;

  @override
  Future<PermissionAccess> requestNotifications() async {
    if (!_asksNotifications) return PermissionAccess.granted;
    // TODO(phase-10): analytics permission_result{type: notification}.
    return _access(await Permission.notification.request());
  }

  static PermissionAccess _access(PermissionStatus s) {
    if (s.isGranted || s.isLimited || s.isProvisional) {
      return PermissionAccess.granted;
    }
    if (s.isPermanentlyDenied || s.isRestricted) {
      return PermissionAccess.blocked;
    }
    return PermissionAccess.askable;
  }

  @override
  Future<bool> openAppSettings() => openAppSettingsPage();
}

/// permission_handler's top-level `openAppSettings`, renamed to avoid the
/// clash with [PermissionService.openAppSettings].
Future<bool> openAppSettingsPage() => openAppSettings();

@Riverpod(keepAlive: true)
PermissionService permissionService(Ref ref) =>
    const PermissionHandlerService();
