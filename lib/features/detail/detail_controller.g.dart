// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Measurement Detail / Full map (`design.md` §5.8): the live record
/// (points, photos) — null once deleted — plus display-only changes.

@ProviderFor(DetailController)
final detailControllerProvider = DetailControllerFamily._();

/// Measurement Detail / Full map (`design.md` §5.8): the live record
/// (points, photos) — null once deleted — plus display-only changes.
final class DetailControllerProvider
    extends $StreamNotifierProvider<DetailController, Measurement?> {
  /// Measurement Detail / Full map (`design.md` §5.8): the live record
  /// (points, photos) — null once deleted — plus display-only changes.
  DetailControllerProvider._({
    required DetailControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'detailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$detailControllerHash();

  @override
  String toString() {
    return r'detailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DetailController create() => DetailController();

  @override
  bool operator ==(Object other) {
    return other is DetailControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$detailControllerHash() => r'1b61ee11f638fa4d6b169c91f4a2ffe20dae2f04';

/// Measurement Detail / Full map (`design.md` §5.8): the live record
/// (points, photos) — null once deleted — plus display-only changes.

final class DetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          DetailController,
          AsyncValue<Measurement?>,
          Measurement?,
          Stream<Measurement?>,
          String
        > {
  DetailControllerFamily._()
    : super(
        retry: null,
        name: r'detailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Measurement Detail / Full map (`design.md` §5.8): the live record
  /// (points, photos) — null once deleted — plus display-only changes.

  DetailControllerProvider call(String measurementId) =>
      DetailControllerProvider._(argument: measurementId, from: this);

  @override
  String toString() => r'detailControllerProvider';
}

/// Measurement Detail / Full map (`design.md` §5.8): the live record
/// (points, photos) — null once deleted — plus display-only changes.

abstract class _$DetailController extends $StreamNotifier<Measurement?> {
  late final _$args = ref.$arg as String;
  String get measurementId => _$args;

  Stream<Measurement?> build(String measurementId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Measurement?>, Measurement?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Measurement?>, Measurement?>,
              AsyncValue<Measurement?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
