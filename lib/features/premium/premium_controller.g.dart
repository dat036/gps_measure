// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'premium_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Paywall (`design.md` §5.15). [source] says what opened it (save_limit,
/// photo_limit, export_kml, settings…) for analytics. [preferAnnual]: the
/// yearly plan is the only one on offer (2nd-launch page), whatever plan
/// has a trial.

@ProviderFor(PremiumController)
final premiumControllerProvider = PremiumControllerFamily._();

/// Paywall (`design.md` §5.15). [source] says what opened it (save_limit,
/// photo_limit, export_kml, settings…) for analytics. [preferAnnual]: the
/// yearly plan is the only one on offer (2nd-launch page), whatever plan
/// has a trial.
final class PremiumControllerProvider
    extends $AsyncNotifierProvider<PremiumController, PaywallState> {
  /// Paywall (`design.md` §5.15). [source] says what opened it (save_limit,
  /// photo_limit, export_kml, settings…) for analytics. [preferAnnual]: the
  /// yearly plan is the only one on offer (2nd-launch page), whatever plan
  /// has a trial.
  PremiumControllerProvider._({
    required PremiumControllerFamily super.from,
    required (String, {bool preferAnnual}) super.argument,
  }) : super(
         retry: null,
         name: r'premiumControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$premiumControllerHash();

  @override
  String toString() {
    return r'premiumControllerProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  PremiumController create() => PremiumController();

  @override
  bool operator ==(Object other) {
    return other is PremiumControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$premiumControllerHash() => r'4056c6d03ee46a670ef9c3dc3dc07612459cee7a';

/// Paywall (`design.md` §5.15). [source] says what opened it (save_limit,
/// photo_limit, export_kml, settings…) for analytics. [preferAnnual]: the
/// yearly plan is the only one on offer (2nd-launch page), whatever plan
/// has a trial.

final class PremiumControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          PremiumController,
          AsyncValue<PaywallState>,
          PaywallState,
          FutureOr<PaywallState>,
          (String, {bool preferAnnual})
        > {
  PremiumControllerFamily._()
    : super(
        retry: null,
        name: r'premiumControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Paywall (`design.md` §5.15). [source] says what opened it (save_limit,
  /// photo_limit, export_kml, settings…) for analytics. [preferAnnual]: the
  /// yearly plan is the only one on offer (2nd-launch page), whatever plan
  /// has a trial.

  PremiumControllerProvider call(String source, {bool preferAnnual = false}) =>
      PremiumControllerProvider._(
        argument: (source, preferAnnual: preferAnnual),
        from: this,
      );

  @override
  String toString() => r'premiumControllerProvider';
}

/// Paywall (`design.md` §5.15). [source] says what opened it (save_limit,
/// photo_limit, export_kml, settings…) for analytics. [preferAnnual]: the
/// yearly plan is the only one on offer (2nd-launch page), whatever plan
/// has a trial.

abstract class _$PremiumController extends $AsyncNotifier<PaywallState> {
  late final _$args = ref.$arg as (String, {bool preferAnnual});
  String get source => _$args.$1;
  bool get preferAnnual => _$args.preferAnnual;

  FutureOr<PaywallState> build(String source, {bool preferAnnual = false});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PaywallState>, PaywallState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PaywallState>, PaywallState>,
              AsyncValue<PaywallState>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(_$args.$1, preferAnnual: _$args.preferAnnual),
    );
  }
}
