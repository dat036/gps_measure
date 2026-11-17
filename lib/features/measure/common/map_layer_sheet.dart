import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/widgets/lm_bottom_sheet.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:gps_measurement/features/premium/premium_badge.dart';
import 'package:gps_measurement/features/premium/premium_flows.dart';

/// Picks the map type. Returns the chosen style, or null when dismissed.
///
/// Satellite and Hybrid are Premium: choosing one as a free user shows a
/// popup to watch a rewarded ad (open until the app is closed) or upgrade;
/// the style is only returned when one of the two worked.
Future<MapStyle?> showMapLayerSheet(
  BuildContext context,
  WidgetRef ref, {
  required MapStyle current,
}) async {
  final gate = ref.read(featureGateProvider);
  final style = await showLmBottomSheet<MapStyle>(
    context: context,
    builder: (context) =>
        _MapLayerSheet(current: current, canUse: gate.canUseMapStyle),
  );
  if (style == null || gate.canUseMapStyle(style)) return style;
  if (!context.mounted) return null;
  final allowed = await PremiumFlows.unlockMapStyle(
    context,
    ref,
    style: style,
    styleLabel: mapStyleLabel(context, style),
  );
  return allowed ? style : null;
}

String mapStyleLabel(BuildContext context, MapStyle style) {
  final l10n = context.l10n;
  return switch (style) {
    MapStyle.standard => l10n.mapStyleStandard,
    MapStyle.satellite => l10n.mapStyleSatellite,
    MapStyle.terrain => l10n.mapStyleTerrain,
    MapStyle.hybrid => l10n.mapStyleHybrid,
  };
}

class _MapLayerSheet extends StatelessWidget {
  const _MapLayerSheet({required this.current, required this.canUse});

  final MapStyle current;
  final bool Function(MapStyle) canUse;

  static IconData _icon(MapStyle s) => switch (s) {
    MapStyle.standard => Icons.map_outlined,
    MapStyle.satellite => Icons.satellite_alt_outlined,
    MapStyle.terrain => Icons.terrain_outlined,
    MapStyle.hybrid => Icons.layers_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            LmSpacing.pageH,
            0,
            LmSpacing.pageH,
            LmSpacing.s8,
          ),
          child: Text(
            context.l10n.mapLayersTitle,
            style: LmTypography.titleSection.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
        for (final style in MapStyle.values)
          ListTile(
            minTileHeight: 56,
            leading: Icon(_icon(style)),
            title: Text(mapStyleLabel(context, style)),
            trailing: !canUse(style)
                ? PremiumBadge(label: context.l10n.premiumBadge)
                : style == current
                ? Icon(Icons.check_rounded, color: colors.brandPrimary)
                : null,
            selected: style == current,
            onTap: () => Navigator.of(context).pop(style),
          ),
        const SizedBox(height: LmSpacing.s8),
      ],
    );
  }
}
