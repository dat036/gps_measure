// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Mode selected on the Home hero card; starts at the "Default
/// Measurement Type" setting.

@ProviderFor(HomeController)
final homeControllerProvider = HomeControllerProvider._();

/// Mode selected on the Home hero card; starts at the "Default
/// Measurement Type" setting.
final class HomeControllerProvider
    extends $NotifierProvider<HomeController, MeasurementType> {
  /// Mode selected on the Home hero card; starts at the "Default
  /// Measurement Type" setting.
  HomeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeControllerHash();

  @$internal
  @override
  HomeController create() => HomeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeasurementType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeasurementType>(value),
    );
  }
}

String _$homeControllerHash() => r'0877faae72b4a96fe867fddf7627bec9dc9b02fc';

/// Mode selected on the Home hero card; starts at the "Default
/// Measurement Type" setting.

abstract class _$HomeController extends $Notifier<MeasurementType> {
  MeasurementType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MeasurementType, MeasurementType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MeasurementType, MeasurementType>,
              MeasurementType,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Latest saved measurements for Home.

@ProviderFor(recentList)
final recentListProvider = RecentListProvider._();

/// Latest saved measurements for Home.

final class RecentListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MeasurementSummary>>,
          List<MeasurementSummary>,
          Stream<List<MeasurementSummary>>
        >
    with
        $FutureModifier<List<MeasurementSummary>>,
        $StreamProvider<List<MeasurementSummary>> {
  /// Latest saved measurements for Home.
  RecentListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentListHash();

  @$internal
  @override
  $StreamProviderElement<List<MeasurementSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MeasurementSummary>> create(Ref ref) {
    return recentList(ref);
  }
}

String _$recentListHash() => r'f7ab3235861b0b2e4b67a871327b129b36eb739a';
