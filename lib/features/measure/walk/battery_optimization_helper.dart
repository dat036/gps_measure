import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/permissions/permission_service.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/theme/mode_colors.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/core/widgets/lm_bottom_sheet.dart';
import 'package:gps_measurement/core/widgets/primary_cta.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/settings_repository.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'battery_optimization_helper.g.dart';

/// Android makers known to kill background apps aggressively
/// (dontkillmyapp.com). Their users get a one-time hint before the first
/// Start Walking (`design.md` §5.16).
class BatteryOptimizationHelper {
  BatteryOptimizationHelper({
    required SettingsRepository settings,
    required PermissionService permissions,
    Future<String?> Function()? manufacturer,
    bool? isAndroid,
  }) : _settings = settings,
       _permissions = permissions,
       _manufacturer = manufacturer ?? _deviceManufacturer,
       _isAndroid =
           isAndroid ?? defaultTargetPlatform == TargetPlatform.android;

  final SettingsRepository _settings;
  final PermissionService _permissions;
  final Future<String?> Function() _manufacturer;
  final bool _isAndroid;

  static const Set<String> aggressiveMakers = {
    'xiaomi',
    'redmi',
    'poco',
    'oppo',
    'vivo',
    'realme',
    'huawei',
    'honor',
    'oneplus',
    'samsung',
  };

  /// True on an aggressive-OEM Android phone that has not seen the hint.
  Future<bool> shouldShowHint() async {
    if (!_isAndroid || _settings.oemBatteryHintShown) return false;
    try {
      final maker = (await _manufacturer())?.toLowerCase().trim();
      return maker != null && aggressiveMakers.contains(maker);
    } on Object catch (e, st) {
      Log.w('Could not read device manufacturer', e, st);
      return false;
    }
  }

  Future<void> markShown() => _settings.setOemBatteryHintShown();

  /// App info page: its Battery entry holds "Unrestricted" / "No
  /// restrictions" on these phones (no extra permission needed, unlike
  /// REQUEST_IGNORE_BATTERY_OPTIMIZATIONS which Play restricts).
  Future<bool> openSettings() => _permissions.openAppSettings();

  static Future<String?> _deviceManufacturer() async =>
      (await DeviceInfoPlugin().androidInfo).manufacturer;
}

@Riverpod(keepAlive: true)
BatteryOptimizationHelper batteryOptimizationHelper(Ref ref) =>
    BatteryOptimizationHelper(
      settings: ref.watch(settingsRepositoryProvider),
      permissions: ref.watch(permissionServiceProvider),
    );

/// Result of the battery hint sheet.
enum BatteryHintChoice { openSettings, notNow }

/// "Allow LandMeasure to run in background" sheet. Returns null when
/// dismissed.
Future<BatteryHintChoice?> showBatteryHintSheet(BuildContext context) {
  return showLmBottomSheet<BatteryHintChoice>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const BatteryHintSheet(),
  );
}

class BatteryHintSheet extends StatelessWidget {
  const BatteryHintSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final mode = ModeColors.of(context, MeasurementType.walk);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        LmSpacing.pageH,
        0,
        LmSpacing.pageH,
        LmSpacing.s16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: mode.container,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.battery_saver_rounded,
                color: mode.main,
                size: 28,
              ),
            ),
          ),
          const SizedBox(height: LmSpacing.s16),
          Text(
            l10n.batteryHintTitle,
            style: LmTypography.titleScreen.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: LmSpacing.s8),
          Text(
            l10n.batteryHintMessage,
            style: LmTypography.bodyMd.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: LmSpacing.s24),
          PrimaryCta(
            label: l10n.actionOpenSettings,
            variant: PrimaryCtaVariant.walk,
            icon: Icons.settings_rounded,
            onPressed: () =>
                Navigator.of(context).pop(BatteryHintChoice.openSettings),
          ),
          const SizedBox(height: LmSpacing.s8),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(BatteryHintChoice.notNow),
            style: TextButton.styleFrom(
              foregroundColor: colors.textSecondary,
              minimumSize: const Size.fromHeight(48),
            ),
            child: Text(l10n.actionNotNow),
          ),
        ],
      ),
    );
  }
}
