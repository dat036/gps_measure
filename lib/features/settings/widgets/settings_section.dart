import 'package:flutter/material.dart';
import 'package:gps_measurement/core/theme/lm_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_shadows.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';

/// Titled card of settings rows (`design.md` §5.10): caps title, white
/// card radius 16, thin dividers between rows.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.children,
    this.title,
    this.dividerIndent = 64,
    super.key,
  });

  final String? title;
  final List<Widget> children;

  /// 64 lines dividers up with titles after the round icon; rows without
  /// an icon use the page padding.
  final double dividerIndent;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LmSpacing.s4,
              LmSpacing.s16,
              LmSpacing.s4,
              LmSpacing.s8,
            ),
            child: Semantics(
              header: true,
              child: Text(
                title!.toUpperCase(),
                style: LmTypography.labelCaps.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
          ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            borderRadius: LmRadius.mdAll,
            boxShadow: LmShadows.card,
          ),
          child: ClipRRect(
            borderRadius: LmRadius.mdAll,
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                children: [
                  for (final (i, child) in children.indexed) ...[
                    if (i > 0)
                      Divider(
                        height: 1,
                        thickness: 1,
                        indent: dividerIndent,
                        color: colors.divider,
                      ),
                    child,
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Settings row: round icon, title (+ subtitle), then a current value with
/// a chevron ([onTap]) or a switch ([SettingsTile.toggle]). Min height 64.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.onTap,
    this.external = false,
    super.key,
  }) : switchValue = null,
       onChanged = null;

  const SettingsTile.toggle({
    required this.icon,
    required this.title,
    required bool this.switchValue,
    required ValueChanged<bool> this.onChanged,
    this.subtitle,
    super.key,
  }) : value = null,
       onTap = null,
       external = false;

  final IconData icon;
  final String title;
  final String? subtitle;

  /// Current choice shown before the chevron ("Satellite").
  final String? value;
  final VoidCallback? onTap;

  /// Opens outside the app (browser, mail, store): ↗ instead of ›.
  final bool external;

  final bool? switchValue;
  final ValueChanged<bool>? onChanged;

  bool get _isToggle => switchValue != null;

  @override
  Widget build(BuildContext context) {
    final colors = LmColors.of(context);
    final trailing = _isToggle
        ? ExcludeSemantics(
            child: Switch(value: switchValue!, onChanged: onChanged),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (value != null)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 140),
                  child: Text(
                    value!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: LmTypography.bodyMd.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              const SizedBox(width: LmSpacing.s4),
              Icon(
                external
                    ? Icons.open_in_new_rounded
                    : Icons.chevron_right_rounded,
                size: external ? 18 : 22,
                color: colors.textTertiary,
              ),
            ],
          );

    final row = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 64),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: LmSpacing.s12,
          vertical: LmSpacing.s8,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.areaContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: colors.brandPrimary),
            ),
            const SizedBox(width: LmSpacing.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: LmTypography.bodyLg.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: LmTypography.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: LmSpacing.s8),
            trailing,
          ],
        ),
      ),
    );

    if (_isToggle) {
      // The whole row flips the switch; read as one "switch" by
      // TalkBack/VoiceOver.
      return MergeSemantics(
        child: Semantics(
          toggled: switchValue,
          child: InkWell(onTap: () => onChanged!(!switchValue!), child: row),
        ),
      );
    }
    return Semantics(
      button: true,
      child: InkWell(onTap: onTap, child: row),
    );
  }
}
