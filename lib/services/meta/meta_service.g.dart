// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(metaService)
final metaServiceProvider = MetaServiceProvider._();

final class MetaServiceProvider
    extends $FunctionalProvider<MetaService, MetaService, MetaService>
    with $Provider<MetaService> {
  MetaServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'metaServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$metaServiceHash();

  @$internal
  @override
  $ProviderElement<MetaService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MetaService create(Ref ref) {
    return metaService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MetaService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MetaService>(value),
    );
  }
}

String _$metaServiceHash() => r'c881661fc797b6f8ae0f2b8879e798637a870361';
