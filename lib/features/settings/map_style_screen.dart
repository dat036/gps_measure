import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_shadows.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/core/widgets/primary_cta.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/features/measure/common/map_layer_sheet.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:gps_measurement/features/premium/premium_badge.dart';
import 'package:gps_measurement/features/premium/premium_flows.dart';
import 'package:gps_measurement/features/settings/settings_controller.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:gps_measurement/features/settings/widgets/map_style_preview.dart';

/// Settings → Map Style (`design.md` §5.12): 2×2 previews, **Apply** sets
/// the map type new measurements open with.
class MapStyleScreen extends ConsumerStatefulWidget {
  const MapStyleScreen({super.key});

  @override
  ConsumerState<MapStyleScreen> createState() => _MapStyleScreenState();
}

class _MapStyleScreenState extends ConsumerState<MapStyleScreen> {
  late MapStyle _selected = ref.read(settingsProvider).mapStyle;

  Future<void> _choose(MapStyle style) async {
    final gate = ref.read(featureGateProvider);
    if (gate.canUseMapStyle(style)) {
      setState(() => _selected = style);
      return;
    }
    final allowed = await PremiumFlows.unlockMapStyle(
      context,
      ref,
      style: style,
      styleLabel: mapStyleLabel(context, style),
    );
    if (allowed && mounted) setState(() => _selected = style);
  }

  Future<void> _apply() async {
    await ref.read(settingsControllerProvider.notifier).setMapStyle(_selected);
    if (mounted) await Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = LmColors.of(context);
    final current = ref.watch(settingsProvider.select((s) => s.mapStyle));
    final gate = ref.watch(featureGateProvider);
    return Scaffold(
      backgroundColor: colors.surfacePage,
      appBar: AppBar(title: Text(l10n.screenMapStyle)),
      body: ListView(
        padding: const EdgeInsets.all(LmSpacing.pageH),
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: LmSpacing.s12,
            crossAxisSpacing: LmSpacing.s12,
            childAspectRatio: 0.8,
            children: [
              for (final style in MapStyle.values)
                _StyleCard(
                  style: style,
                  selected: style == _selected,
                  locked: !gate.canUseMapStyle(style),
                  onTap: () => unawaited(_choose(style)),
                ),
            ],
          ),
          const SizedBox(height: LmSpacing.s12),
          Text(
            l10n.mapStyleNote,
            style: LmTypography.caption.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            LmSpacing.pageH,
            LmSpacing.s8,
            LmSpacing.pageH,
            LmSpacing.s12,
          ),
          child: PrimaryCta(
            label: l10n.actionApply,
            icon: Icons.check_rounded,
            onPressed: _selected == current ? null : () => unawaited(_apply()),
          ),
        ),
      ),
    );
  }
}

class _StyleCard extends StatelessWidget {
  const _StyleCard({
    required this.style,
    required this.selected,
    required this.locked,
    required this.onTap,
  });

  final MapStyle style;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    return Semantics(
      selected: selected,
      button: true,
      label: mapStyleLabel(context, style),
      excludeSemantics: true,
      child: Material(
        color: colors.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: LmRadius.mdAll,
          side: BorderSide(
            color: selected ? colors.brandPrimary : colors.divider,
            width: selected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(LmSpacing.s8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: LmRadius.smAll,
                        child: CustomPaint(
                          painter: MapStylePreviewPainter(
                            style: style,
                            colors: colors,
                          ),
                        ),
                      ),
                      if (locked)
                        PositionedDirectional(
                          top: LmSpacing.s8,
                          start: LmSpacing.s8,
                          child: PremiumBadge(label: context.l10n.premiumBadge),
                        ),
                      if (selected)
                        Positioned(
                          top: LmSpacing.s8,
                          right: LmSpacing.s8,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: colors.brandPrimary,
                              shape: BoxShape.circle,
                              boxShadow: LmShadows.float,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(
                                Icons.check_rounded,
                                size: 18,
                                color: colors.onMode,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: LmSpacing.s8),
                Text(
                  mapStyleLabel(context, style),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: LmTypography.bodyLg.copyWith(
                    color: selected ? colors.brandPrimary : colors.textPrimary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
