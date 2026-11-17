import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:gps_measurement/core/config/env.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'support_service.g.dart';

/// App version and device, for the Settings footer and feedback emails.
typedef AppInfo = ({String version, String build, String device, String os});

/// Where Settings → Support & Legal points. Empty values hide the item
/// (`env/<flavor>.json`, 👤 provides the real ones).
typedef SupportLinks = ({
  String supportEmail,
  String privacyPolicyUrl,
  String termsUrl,
  String appStoreId,
});

/// Settings → Support & Legal: app/device info, opening links and mail,
/// the store listing. Behind an interface so widget tests can fake it.
abstract interface class SupportService {
  Future<AppInfo> appInfo();

  /// `mailto:` goes to the mail app, `https:` to the browser. False when
  /// nothing can open it.
  Future<bool> launch(Uri uri);

  /// Rate Us: the store page (not the in-app review sheet, which the OS
  /// may silently skip).
  Future<bool> openStoreListing();
}

class PlatformSupportService implements SupportService {
  const PlatformSupportService();

  @override
  Future<AppInfo> appInfo() async {
    final package = await PackageInfo.fromPlatform();
    var device = '';
    var os = '';
    try {
      final plugin = DeviceInfoPlugin();
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          final a = await plugin.androidInfo;
          device = '${a.manufacturer} ${a.model}';
          os = 'Android ${a.version.release} (SDK ${a.version.sdkInt})';
        case TargetPlatform.iOS:
          final i = await plugin.iosInfo;
          device = i.utsname.machine;
          os = '${i.systemName} ${i.systemVersion}';
        case _:
          os = defaultTargetPlatform.name;
      }
    } on Object catch (e, st) {
      Log.w('Could not read device info', e, st);
    }
    return (
      version: package.version,
      build: package.buildNumber,
      device: device,
      os: os,
    );
  }

  @override
  Future<bool> launch(Uri uri) async {
    try {
      return await launchUrl(
        uri,
        mode: uri.scheme == 'mailto'
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
      );
    } on Object catch (e, st) {
      Log.w('Could not open $uri', e, st);
      return false;
    }
  }

  @override
  Future<bool> openStoreListing() async {
    try {
      await InAppReview.instance.openStoreListing(
        appStoreId: Env.appStoreId.isEmpty ? null : Env.appStoreId,
      );
      return true;
    } on Object catch (e, st) {
      Log.w('Could not open the store listing', e, st);
      return false;
    }
  }
}

@Riverpod(keepAlive: true)
SupportService supportService(Ref ref) => const PlatformSupportService();

@Riverpod(keepAlive: true)
SupportLinks supportLinks(Ref ref) => (
  supportEmail: Env.supportEmail,
  privacyPolicyUrl: Env.privacyPolicyUrl,
  termsUrl: Env.termsUrl,
  appStoreId: Env.appStoreId,
);
