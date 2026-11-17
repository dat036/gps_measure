// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Settings → "Privacy choices" is shown only when UMP requires it.
/// Invalidate after the form closes.

@ProviderFor(privacyOptionsRequired)
final privacyOptionsRequiredProvider = PrivacyOptionsRequiredProvider._();

/// Settings → "Privacy choices" is shown only when UMP requires it.
/// Invalidate after the form closes.

final class PrivacyOptionsRequiredProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Settings → "Privacy choices" is shown only when UMP requires it.
  /// Invalidate after the form closes.
  PrivacyOptionsRequiredProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'privacyOptionsRequiredProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$privacyOptionsRequiredHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return privacyOptionsRequired(ref);
  }
}

String _$privacyOptionsRequiredHash() =>
    r'8366024edbafa263e3dbed4ca50276a338fa604d';

@ProviderFor(consentService)
final consentServiceProvider = ConsentServiceProvider._();

final class ConsentServiceProvider
    extends $FunctionalProvider<ConsentService, ConsentService, ConsentService>
    with $Provider<ConsentService> {
  ConsentServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'consentServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$consentServiceHash();

  @$internal
  @override
  $ProviderElement<ConsentService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ConsentService create(Ref ref) {
    return consentService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConsentService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConsentService>(value),
    );
  }
}

String _$consentServiceHash() => r'6b4a11d7e6d0f1eefd0785c8ae91043ad58ba22b';
