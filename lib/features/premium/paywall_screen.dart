import 'dart:async';

import 'package:flutter/foundation.dart';
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
import 'package:gps_measurement/features/premium/premium_links.dart';
import 'package:gps_measurement/services/purchases/purchase_service.dart';
import 'package:gps_measurement/services/support/support_service.dart';

/// Paywall (`design.md` §5.15): two plans, monthly (free trial) and yearly.
/// Pops `true` when the user is premium afterwards, so the caller can retry
/// what was blocked (save, photo, map type…). Opened as the first screen of
/// the 2nd launch it has no page below it: closing goes to Home.
///
/// Honest by design (`overview.md` §5.3): only benefits that exist today,
/// the renewal terms next to the button, Restore always visible, and the
/// system back always closes it (the ✕ only fades in after 2 s).
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({required this.source, super.key});

  final String source;

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen>
    with PaywallFlow<PaywallScreen> {
  @override
  PremiumControllerProvider get paywallProvider =>
      premiumControllerProvider(widget.source);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final async = ref.watch(paywallProvider);
    final premium = ref.watch(premiumProvider);
    final links = ref.watch(supportLinksProvider);
    final s = async.value;
    final offer = s?.selectedOffer;
    final busy = s?.busy;

    final plans = switch (async) {
      _ when premium.isPremium =>
        PaywallPremiumActive(status: premium) as Widget,
      AsyncData(value: final v) when v.offers.isEmpty => PaywallUnavailable(
        onRetry: () => ref.invalidate(paywallProvider),
      ),
      AsyncData(value: final v) => Column(
        children: [
          for (final o in v.offers) ...[
            _PlanCard(
              offer: o,
              selected: o.plan == v.selected,
              onTap: () => ref.read(paywallProvider.notifier).select(o.plan),
            ),
            const SizedBox(height: LmSpacing.s12),
          ],
        ],
      ),
      AsyncError() => PaywallUnavailable(
        onRetry: () => ref.invalidate(paywallProvider),
      ),
      _ => const _PlansLoading(),
    };

    final showBuy = !premium.isPremium && offer != null;
    final trial = offer?.trialDays != null;

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
                      const SizedBox(height: LmSpacing.s20),
                      plans,
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
                  if (showBuy) ...[
                    Text(
                      _terms(context, offer, trial: trial),
                      textAlign: TextAlign.center,
                      style: LmTypography.caption.copyWith(
                        color: LmPremiumColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: LmSpacing.s8),
                    PaywallGoldButton(
                      label: trial
                          ? l10n.paywallStartTrial(offer.trialDays!)
                          : l10n.actionContinue,
                      loading: busy == PaywallBusy.purchasing,
                      onPressed: busy == null
                          ? () => unawaited(purchase())
                          : null,
                    ),
                  ] else if (premium.isPremium)
                    PaywallGoldButton(
                      label: l10n.actionClose,
                      onPressed: close,
                    ),
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

  /// Renewal terms right above the button (store requirement).
  static String _terms(
    BuildContext context,
    PlanOffer offer, {
    required bool trial,
  }) {
    final l10n = context.l10n;
    final store = defaultTargetPlatform == TargetPlatform.iOS
        ? 'App Store'
        : 'Google Play';
    return switch (offer.plan) {
      PremiumPlan.monthly when trial => l10n.paywallTermsTrialMonthly(
        offer.trialDays!,
        offer.price,
        store,
      ),
      PremiumPlan.monthly => l10n.paywallTermsMonthly(offer.price, store),
      PremiumPlan.annual when trial => l10n.paywallTermsTrial(
        offer.trialDays!,
        offer.price,
        store,
      ),
      PremiumPlan.annual => l10n.paywallTermsYearly(offer.price, store),
    };
  }
}

/// One plan: radio + text + badge. The selected one has a 2 dp gold border,
/// a glow and a filled radio (not color alone).
class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.offer,
    required this.selected,
    required this.onTap,
  });

  final PlanOffer offer;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final trial = offer.trialDays;
    final isYearly = offer.plan == PremiumPlan.annual;

    // Text before/after the gold price in "Only {price} per year".
    final yearlyParts = isYearly
        ? l10n.paywallYearlyOnly('\u0000').split('\u0000')
        : const <String>[];

    // A plan with a free trial leads with it ("3-day free trial"), the
    // price underneath.
    final title = trial != null
        ? l10n.paywallTrialTitle(trial)
        : isYearly
        ? l10n.paywallYearlyTitle
        : l10n.paywallMonthlyTitle;

    final subtitleStyle = LmTypography.bodyMd.copyWith(
      color: LmPremiumColors.textSecondary,
    );
    final Widget subtitle = isYearly
        ? Text.rich(
            TextSpan(
              style: subtitleStyle,
              children: [
                TextSpan(text: yearlyParts.first),
                TextSpan(
                  text: offer.price,
                  style: const TextStyle(
                    color: LmPremiumColors.gold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: yearlyParts.length > 1 ? yearlyParts[1] : ''),
              ],
            ),
          )
        : Text(
            trial != null
                ? l10n.paywallThenMonthly(offer.price)
                : l10n.paywallMonthlyPrice(offer.price),
            style: subtitleStyle,
          );

    final badge = isYearly ? _Badge(text: l10n.paywallBestPrice) : null;

    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      button: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: selected
                ? [LmPremiumColors.selectedCard, LmPremiumColors.card]
                : [LmPremiumColors.card, LmPremiumColors.background],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? LmPremiumColors.gold : LmPremiumColors.cardBorder,
            width: 2,
          ),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: LmPremiumColors.goldSoft,
                    blurRadius: 18,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(LmSpacing.s16),
              child: Row(
                children: [
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 28,
                    color: selected
                        ? LmPremiumColors.gold
                        : LmPremiumColors.radioOff,
                  ),
                  const SizedBox(width: LmSpacing.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isYearly
                              ? l10n.paywallYearlyTitle
                              : l10n.paywallMonthlyTitle,
                          style: LmTypography.titleSection.copyWith(
                            color: LmPremiumColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(height: LmSpacing.s8),
                          badge,
                        ],
                        if (trial != null) ...[
                          const SizedBox(height: LmSpacing.s8),
                          Text(
                            title,
                            style: LmTypography.bodyMd.copyWith(
                              color: LmPremiumColors.gold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        const SizedBox(height: 2),
                        subtitle,
                      ],
                    ),
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

class _Badge extends StatelessWidget {
  const _Badge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: LmSpacing.s8,
      vertical: LmSpacing.s4,
    ),
    decoration: BoxDecoration(
      color: LmPremiumColors.goldSoft,
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: LmPremiumColors.goldBorder),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ExcludeSemantics(
          child: Icon(
            Icons.local_offer_rounded,
            size: 16,
            color: LmPremiumColors.gold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: LmTypography.caption.copyWith(
            color: LmPremiumColors.gold,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _PlansLoading extends StatelessWidget {
  const _PlansLoading();

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (var i = 0; i < 2; i++) ...[
        Container(
          height: 92,
          decoration: BoxDecoration(
            color: LmPremiumColors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: LmPremiumColors.cardBorder),
          ),
        ),
        const SizedBox(height: LmSpacing.s12),
      ],
    ],
  );
}
