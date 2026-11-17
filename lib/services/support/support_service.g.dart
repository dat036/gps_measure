// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(supportService)
final supportServiceProvider = SupportServiceProvider._();

final class SupportServiceProvider
    extends $FunctionalProvider<SupportService, SupportService, SupportService>
    with $Provider<SupportService> {
  SupportServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supportServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supportServiceHash();

  @$internal
  @override
  $ProviderElement<SupportService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SupportService create(Ref ref) {
    return supportService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupportService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupportService>(value),
    );
  }
}

String _$supportServiceHash() => r'24574ca563013278383c84dd830e37e2e3da75db';

@ProviderFor(supportLinks)
final supportLinksProvider = SupportLinksProvider._();

final class SupportLinksProvider
    extends $FunctionalProvider<SupportLinks, SupportLinks, SupportLinks>
    with $Provider<SupportLinks> {
  SupportLinksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supportLinksProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supportLinksHash();

  @$internal
  @override
  $ProviderElement<SupportLinks> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SupportLinks create(Ref ref) {
    return supportLinks(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupportLinks value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupportLinks>(value),
    );
  }
}

String _$supportLinksHash() => r'57b2ad53e7add888bd415534f2be37823d08781b';
