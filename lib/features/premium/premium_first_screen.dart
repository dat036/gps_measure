import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/core/theme/lm_premium_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/features/premium/paywall_parts.dart';
import 'package:gps_measurement/features/premium/premium_controller.dart';
import 'package:gps_measurement/features/premium/premium_flows.dart';
import 'package:gps_measurement/features/premium/premium_links.dart';
import 'package:gps_measurement/services/purchases/purchase_service.dart';
import 'package:gps_measurement/services/support/support_service.dart';

/// The paywall of the 2nd launch, the first screen after the first-run
/// flow: the same page as `PaywallScreen` without the plan choice. Only the
/// yearly plan is offered (preselected, nothing to pick): "Start free
/// trial", then the trial length and the yearly price, and that it can be
/// cancelled at any time. It has no page below it: closing goes to Home.
/// The ✕ shows after 10 s, or once the user taps "Start free trial".
class PremiumFirstScreen extends ConsumerStatefulWidget {
  const PremiumFirstScreen({super.key});

  @override
  ConsumerState<PremiumFirstScreen> createState() => _PremiumFirstScreenState();
}

class _PremiumFirstScreenState extends ConsumerState<PremiumFirstScreen>
    with PaywallFlow<PremiumFirstScreen> {
  /// The ✕ stays hidden for this long, unless the user taps the button
  /// first (tapping is enough, whether or not they buy).
  static const Duration _closeAfter = Duration(seconds: 10);

  @override
  Duration get closeDelay => _closeAfter;

  @override
  PremiumControllerProvider get paywallProvider => premiumControllerProvider(
    PaywallSource.startup,
    preferAnnual: true,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final async = ref.watch(paywallProvider);
    final premium = ref.watch(premiumProvider);
    final links = ref.watch(supportLinksProvider);
    final s = async.value;
    final busy = s?.busy;
    final offer = s?.offers
        .where((o) => o.plan == PremiumPlan.annual)
        .firstOrNull;
    final unavailable = !premium.isPremium && !async.isLoading && offer == null;
    final trialDays = offer?.trialDays;

    return PopScope<Object?>(
      canPop: Navigator.of(context).canPop(),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go(Routes.home);
      },
      child: Scaffold(
        backgroundColor: LmPremiumColors.background,
        body: Stack(
          children: [
            const Positioned.fill(child: PaywallBackdrop()),
            CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: PaywallHeader()),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    LmSpacing.pageH,
                    LmSpacing.s8,
                    LmSpacing.pageH,
                    LmSpacing.s24,
                  ),
                  sliver: SliverList.list(
                    children: [
                      PaywallBenefit(l10n.paywallBenefitNoAds),
                      PaywallBenefit(l10n.paywallBenefitSaves),
                      PaywallBenefit(l10n.paywallBenefitPhotos),
                      PaywallBenefit(l10n.paywallBenefitKml),
                      if (premium.isPremium) ...[
                        const SizedBox(height: LmSpacing.s20),
                        PaywallPremiumActive(status: premium),
                      ] else if (unavailable) ...[
                        const SizedBox(height: LmSpacing.s20),
                        PaywallUnavailable(
                          onRetry: () => ref.invalidate(paywallProvider),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            paywallCloseButton(
              context,
              visible: closeVisible,
              onPressed: close,
            ),
          ],
        ),
        bottomNavigationBar: ColoredBox(
          color: LmPremiumColors.background,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                LmSpacing.pageH,
                LmSpacing.s8,
                LmSpacing.pageH,
                LmSpacing.s8,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (premium.isPremium)
                    PaywallGoldButton(label: l10n.actionClose, onPressed: close)
                  else if (!unavailable) ...[
                    PaywallGoldButton(
                      label: offer != null && trialDays == null
                          ? l10n.actionContinue
                          : l10n.paywallStartFreeTrial,
                      loading: busy == PaywallBusy.purchasing,
                      onPressed: offer == null || busy != null
                          ? null
                          : () {
                              revealClose();
                              unawaited(purchase());
                            },
                    ),
                    const SizedBox(height: LmSpacing.s12),
                    // Empty while the plans load: the page does not jump.
                    Text(
                      offer == null
                          ? ' '
                          : trialDays == null
                          ? l10n.paywallPricePerYear(offer.price)
                          : l10n.paywallTrialThenYearly(
                              trialDays,
                              offer.price,
                            ),
                      textAlign: TextAlign.center,
                      style: LmTypography.bodyMd.copyWith(
                        color: LmPremiumColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: LmSpacing.s4),
                    Text(
                      l10n.paywallCancelAnytime,
                      textAlign: TextAlign.center,
                      style: LmTypography.caption.copyWith(
                        color: LmPremiumColors.textTertiary,
                      ),
                    ),
                  ],
                  const SizedBox(height: LmSpacing.s4),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      if (!premium.isPremium)
                        PaywallLinkButton(
                          label: l10n.paywallRestore,
                          loading: busy == PaywallBusy.restoring,
                          onPressed: busy == null
                              ? () => unawaited(restore())
                              : null,
                        ),
                      if (links.termsUrl.isNotEmpty)
                        PaywallLinkButton(
                          label: l10n.settingsTerms,
                          onPressed: () => unawaited(
                            openPremiumLink(ref, links.termsUrl),
                          ),
                        ),
                      if (links.privacyPolicyUrl.isNotEmpty)
                        PaywallLinkButton(
                          label: l10n.settingsPrivacyPolicy,
                          onPressed: () => unawaited(
                            openPremiumLink(ref, links.privacyPolicyUrl),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
