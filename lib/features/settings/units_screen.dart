import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_measurement/core/format/unit_formatter.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/features/settings/settings_controller.dart';
import 'package:gps_measurement/features/settings/settings_labels.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:gps_measurement/features/settings/widgets/settings_section.dart';

/// Settings → Units (`design.md` §5.11): default distance and area units
/// and the secondary unit.
/// Measurements keep their own unit choice from the result chips.
class UnitsScreen extends ConsumerWidget {
  const UnitsScreen({super.key});

  /// Example for the secondary-unit switch: 12,450 m² · 1.25 ha.
  static const double _exampleM2 = 12450;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final locale = Localizations.localeOf(context).toString();
    final settings = ref.watch(settingsProvider);
    // Read when used: the controller is auto-disposed while nobody
    // listens to it.
    SettingsController controller() =>
        ref.read(settingsControllerProvider.notifier);
    final example = UnitFormatter.areaWithSecondary(
      _exampleM2,
      settings.areaUnit,
      locale,
    );

    Widget areaOption(AreaUnit unit) => _UnitOption<AreaUnit>(
      value: unit,
      title: l10n.areaUnitName(unit),
      symbol: UnitFormatter.areaSymbol(unit),
    );

    return Scaffold(
      backgroundColor: colors.surfacePage,
      appBar: AppBar(title: Text(l10n.screenUnits)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          LmSpacing.pageH,
          0,
          LmSpacing.pageH,
          LmSpacing.s32,
        ),
        children: [
          RadioGroup<DistanceUnit>(
            groupValue: settings.distanceUnit,
            onChanged: (u) {
              if (u != null) unawaited(controller().setDistanceUnit(u));
            },
            child: SettingsSection(
              title: l10n.unitsDistanceTitle,
              dividerIndent: LmSpacing.s16,
              children: [
                for (final unit in DistanceUnit.values)
                  _UnitOption<DistanceUnit>(
                    value: unit,
                    title: l10n.distanceUnitName(unit),
                    symbol: UnitFormatter.distanceSymbol(unit),
                  ),
              ],
            ),
          ),
          RadioGroup<AreaUnit>(
            groupValue: settings.areaUnit,
            onChanged: (u) {
              if (u != null) unawaited(controller().setAreaUnit(u));
            },
            child: SettingsSection(
              title: l10n.unitsAreaTitle,
              dividerIndent: LmSpacing.s16,
              children: [
                for (final unit in AreaUnit.values) areaOption(unit),
              ],
            ),
          ),
          const SizedBox(height: LmSpacing.s24),
          SettingsSection(
            children: [
              SettingsTile.toggle(
                icon: Icons.swap_vert_rounded,
                title: l10n.unitsSecondary,
                subtitle: l10n.unitsSecondaryExample(
                  [example.primary, ?example.secondary].join(' · '),
                ),
                switchValue: settings.showSecondaryUnit,
                onChanged: (on) =>
                    unawaited(controller().setShowSecondaryUnit(on: on)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LmSpacing.s4,
              LmSpacing.s12,
              LmSpacing.s4,
              0,
            ),
            child: Text(
              l10n.unitsNote,
              style: LmTypography.caption.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnitOption<T> extends StatelessWidget {
  const _UnitOption({
    required this.value,
    required this.title,
    required this.symbol,
  });

  final T value;
  final String title;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    return RadioListTile<T>(
      value: value,
      controlAffinity: ListTileControlAffinity.trailing,
      contentPadding: const EdgeInsets.symmetric(horizontal: LmSpacing.s16),
      title: Text(
        title,
        style: LmTypography.bodyLg.copyWith(color: colors.textPrimary),
      ),
      subtitle: Text(
        symbol,
        style: LmTypography.caption.copyWith(color: colors.textSecondary),
      ),
    );
  }
}
