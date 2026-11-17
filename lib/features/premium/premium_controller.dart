import 'package:flutter/foundation.dart';
import 'package:gps_measurement/services/purchases/purchase_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'premium_controller.g.dart';

enum PaywallBusy { purchasing, restoring }

@immutable
class PaywallState {
  const PaywallState({
    required this.offers,
    this.selected = PremiumPlan.monthly,
    this.busy,
  });

  /// Empty: the store could not be reached (or purchases are not set up).
  final List<PlanOffer> offers;
  final PremiumPlan selected;
  final PaywallBusy? busy;

  PlanOffer? get selectedOffer =>
      offers.where((o) => o.plan == selected).firstOrNull;

  PaywallState copyWith({
    PremiumPlan? selected,
    PaywallBusy? busy,
    bool clearBusy = false,
  }) => PaywallState(
    offers: offers,
    selected: selected ?? this.selected,
    busy: clearBusy ? null : busy ?? this.busy,
  );
}

/// Paywall (`design.md` §5.15). [source] says what opened it (save_limit,
/// photo_limit, export_kml, settings…) for analytics. [preferAnnual]: the
/// yearly plan is the only one on offer (2nd-launch page), whatever plan
/// has a trial.
@riverpod
class PremiumController extends _$PremiumController {
  PurchaseService get _service => ref.read(purchaseServiceProvider);

  @override
  Future<PaywallState> build(String source, {bool preferAnnual = false}) async {
    // TODO(phase-10): analytics paywall_view{source, variant}.
    final offers = await _service.plans();
    // The plan with the free trial is preselected, else yearly (best value).
    final withTrial = preferAnnual
        ? null
        : offers.where((o) => o.trialDays != null).firstOrNull;
    final selected =
        withTrial?.plan ??
        (offers.any((o) => o.plan == PremiumPlan.annual)
            ? PremiumPlan.annual
            : offers.firstOrNull?.plan ?? PremiumPlan.monthly);
    return PaywallState(offers: offers, selected: selected);
  }

  void select(PremiumPlan plan) {
    final s = state.value;
    if (s == null || s.busy != null) return;
    state = AsyncData(s.copyWith(selected: plan));
  }

  Future<PurchaseOutcome> purchase() async {
    final s = state.value;
    final offer = s?.selectedOffer;
    if (s == null || offer == null || s.busy != null) {
      return PurchaseOutcome.failed;
    }
    state = AsyncData(s.copyWith(busy: PaywallBusy.purchasing));
    final outcome = await _service.purchase(offer);
    // TODO(phase-10): analytics purchase_success{product, source}.
    if (ref.mounted) state = AsyncData(s.copyWith(clearBusy: true));
    return outcome;
  }

  Future<RestoreOutcome> restore() async {
    final s = state.value;
    if (s == null || s.busy != null) return RestoreOutcome.failed;
    state = AsyncData(s.copyWith(busy: PaywallBusy.restoring));
    final outcome = await _service.restore();
    if (ref.mounted) state = AsyncData(s.copyWith(clearBusy: true));
    return outcome;
  }
}
