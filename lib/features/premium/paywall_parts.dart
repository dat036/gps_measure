import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gps_measurement/core/l10n/l10n.dart';
import 'package:gps_measurement/core/router/routes.dart';
import 'package:gps_measurement/core/theme/lm_premium_colors.dart';
import 'package:gps_measurement/core/theme/lm_spacing.dart';
import 'package:gps_measurement/core/theme/lm_typography.dart';
import 'package:gps_measurement/features/premium/premium_controller.dart';
import 'package:gps_measurement/features/premium/premium_links.dart';
import 'package:gps_measurement/services/purchases/purchase_service.dart';

// Pieces shared by the two paywall pages (`PaywallScreen`, the 2nd-launch
// `PremiumFirstScreen`): same dark page with gold accents, same header,
// benefits and buttons.

/// The page behind the paywall: the aerial photo at the top, fading into
/// the dark page colour so the benefits, plans and buttons below stay
/// readable. The scrim also keeps the white title legible over the sky.
class PaywallBackdrop extends StatelessWidget {
  const PaywallBackdrop({super.key});

  static const String imageAsset = 'assets/images/img_premium.webp';

  @override
  Widget build(BuildContext context) {
    const page = LmPremiumColors.background;
    return ExcludeSemantics(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Before / without the photo: the old soft glow.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -1.1),
                radius: 1.1,
                colors: [
                  LmPremiumColors.backgroundGlow,
                  LmPremiumColors.background,
                ],
              ),
            ),
          ),
          Image.asset(
            imageAsset,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  page.withValues(alpha: 0.18),
                  page.withValues(alpha: 0.38),
                  page.withValues(alpha: 0.82),
                  page,
                ],
                stops: const [0, 0.3, 0.6, 0.85],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaywallHeader extends StatelessWidget {
  const PaywallHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final top = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        LmSpacing.pageH,
        top + LmSpacing.s32,
        LmSpacing.pageH,
        LmSpacing.s16,
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: LmPremiumColors.goldSoft,
              border: Border.all(color: LmPremiumColors.goldBorder),
            ),
            child: const ExcludeSemantics(
              child: Icon(
                Icons.workspace_premium_rounded,
                size: 40,
                color: LmPremiumColors.gold,
              ),
            ),
          ),
          const SizedBox(height: LmSpacing.s16),
          Semantics(
            header: true,
            child: Text(
              l10n.paywallTitle,
              textAlign: TextAlign.center,
              style: LmTypography.displayHero.copyWith(
                color: LmPremiumColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: LmSpacing.s8),
          Text(
            l10n.paywallSubtitle,
            textAlign: TextAlign.center,
            style: LmTypography.bodyMd.copyWith(
              color: LmPremiumColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class PaywallBenefit extends StatelessWidget {
  const PaywallBenefit(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: LmSpacing.s4),
    child: Row(
      children: [
        const ExcludeSemantics(
          child: Icon(
            Icons.check_circle_rounded,
            size: 22,
            color: LmPremiumColors.gold,
          ),
        ),
        const SizedBox(width: LmSpacing.s12),
        Expanded(
          child: Text(
            text,
            style: LmTypography.bodyLg.copyWith(
              color: LmPremiumColors.textPrimary,
            ),
          ),
        ),
      ],
    ),
  );
}

/// The primary action, in gold with dark text (enough contrast on both).
class PaywallGoldButton extends StatelessWidget {
  const PaywallGoldButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Semantics(
      button: true,
      enabled: enabled,
      child: SizedBox(
        height: 56,
        child: Material(
          color: enabled
              ? LmPremiumColors.gold
              : LmPremiumColors.gold.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: loading ? null : onPressed,
            child: Center(
              child: loading
                  ? const SizedBox.square(
                      dimension: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: LmPremiumColors.onGold,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: LmSpacing.s16,
                      ),
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: LmTypography.bodyLg.copyWith(
                          color: LmPremiumColors.onGold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class PaywallUnavailable extends StatelessWidget {
  const PaywallUnavailable({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(LmSpacing.s16),
      decoration: BoxDecoration(
        color: LmPremiumColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            color: LmPremiumColors.textTertiary,
          ),
          const SizedBox(height: LmSpacing.s8),
          Text(
            l10n.paywallUnavailable,
            textAlign: TextAlign.center,
            style: LmTypography.bodyMd.copyWith(
              color: LmPremiumColors.textSecondary,
            ),
          ),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(foregroundColor: LmPremiumColors.gold),
            child: Text(l10n.actionRetry),
          ),
        ],
      ),
    );
  }
}

class PaywallPremiumActive extends ConsumerWidget {
  const PaywallPremiumActive({required this.status, super.key});

  final PremiumStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(LmSpacing.s16),
      decoration: BoxDecoration(
        color: LmPremiumColors.goldSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: LmPremiumColors.goldBorder),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.workspace_premium_rounded,
            color: LmPremiumColors.gold,
          ),
          const SizedBox(width: LmSpacing.s12),
          Expanded(
            child: Text(
              status.isLifetime
                  ? l10n.premiumActiveLifetime
                  : l10n.premiumActive,
              style: LmTypography.bodyLg.copyWith(
                color: LmPremiumColors.textPrimary,
              ),
            ),
          ),
          if (!status.isLifetime)
            TextButton(
              onPressed: () => unawaited(openManageSubscription(ref, status)),
              style: TextButton.styleFrom(
                foregroundColor: LmPremiumColors.gold,
              ),
              child: Text(l10n.premiumManage),
            ),
        ],
      ),
    );
  }
}

class PaywallLinkButton extends StatelessWidget {
  const PaywallLinkButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      foregroundColor: LmPremiumColors.textSecondary,
      textStyle: LmTypography.bodyMd.copyWith(fontWeight: FontWeight.w600),
    ),
    child: loading
        ? const SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label),
  );
}

/// The ✕ in the top corner, to place in the page's `Stack`. Fades in with
/// [PaywallFlow.closeVisible], so the offer is read first.
Widget paywallCloseButton(
  BuildContext context, {
  required bool visible,
  required VoidCallback onPressed,
}) => PositionedDirectional(
  top: MediaQuery.paddingOf(context).top + LmSpacing.s4,
  end: LmSpacing.s8,
  child: AnimatedOpacity(
    opacity: visible ? 1 : 0,
    duration: const Duration(milliseconds: 250),
    child: IgnorePointer(
      ignoring: !visible,
      child: IconButton(
        tooltip: context.l10n.actionClose,
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.12),
          foregroundColor: LmPremiumColors.textPrimary,
          minimumSize: const Size.square(LmSpacing.touchMin),
        ),
        icon: const Icon(Icons.close_rounded),
      ),
    ),
  ),
);

/// What both paywall pages do besides drawing: the ✕ that appears after
/// [PaywallFlow.closeDelay], leaving (back to the caller, or Home when this
/// is the only page), buying and restoring with their messages.
mixin PaywallFlow<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  /// How long the ✕ stays hidden.
  Duration get closeDelay => const Duration(seconds: 2);

  /// The page's own controller (keyed by what opened it).
  PremiumControllerProvider get paywallProvider;

  bool closeVisible = false;
  Timer? _closeTimer;

  /// Shows the ✕ now (the page decides when, besides [closeDelay]).
  void revealClose() {
    _closeTimer?.cancel();
    if (mounted && !closeVisible) setState(() => closeVisible = true);
  }

  @override
  void initState() {
    super.initState();
    _closeTimer = Timer(closeDelay, revealClose);
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    super.dispose();
  }

  /// Back to the caller, or to Home when this is the only page.
  void leave({required bool premium}) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop(premium);
    } else {
      context.go(Routes.home);
    }
  }

  void close() => leave(premium: ref.read(premiumProvider).isPremium);

  void snack(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  Future<void> purchase() async {
    final l10n = context.l10n;
    final outcome = await ref.read(paywallProvider.notifier).purchase();
    if (!mounted) return;
    switch (outcome) {
      case PurchaseOutcome.purchased:
        snack(l10n.paywallWelcome);
        leave(premium: true);
      case PurchaseOutcome.cancelled:
        break; // Silent: the user changed their mind.
      case PurchaseOutcome.pending:
        snack(l10n.paywallPending);
      case PurchaseOutcome.failed:
        snack(l10n.paywallPurchaseFailed);
    }
  }

  Future<void> restore() async {
    final l10n = context.l10n;
    final outcome = await ref.read(paywallProvider.notifier).restore();
    if (!mounted) return;
    switch (outcome) {
      case RestoreOutcome.restored:
        snack(l10n.paywallRestored);
        leave(premium: true);
      case RestoreOutcome.nothingToRestore:
        snack(l10n.paywallNothingToRestore);
      case RestoreOutcome.failed:
        snack(l10n.paywallRestoreFailed);
    }
  }
}
