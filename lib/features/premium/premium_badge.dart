import 'package:flutter/material.dart';
import 'package:gps_measurement/core/theme/lm_premium_colors.dart';
import 'package:gps_measurement/core/theme/lm_radius.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';

/// Small gold "Premium" pill with a crown, on locked options. The label is
/// text, so the lock is not shown by color alone.
class PremiumBadge extends StatelessWidget {
  const PremiumBadge({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      color: LmPremiumColors.background,
      borderRadius: LmRadius.fullAll,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ExcludeSemantics(
            child: Icon(
              Icons.workspace_premium_rounded,
              size: 14,
              color: LmPremiumColors.gold,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: LmTypography.caption.copyWith(
              color: LmPremiumColors.gold,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}
