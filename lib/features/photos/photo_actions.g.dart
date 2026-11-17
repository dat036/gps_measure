// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Photos of a measurement, in strip order; re-emits on any change.

@ProviderFor(measurementPhotos)
final measurementPhotosProvider = MeasurementPhotosFamily._();

/// Photos of a measurement, in strip order; re-emits on any change.

final class MeasurementPhotosProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Photo>>,
          List<Photo>,
          Stream<List<Photo>>
        >
    with $FutureModifier<List<Photo>>, $StreamProvider<List<Photo>> {
  /// Photos of a measurement, in strip order; re-emits on any change.
  MeasurementPhotosProvider._({
    required MeasurementPhotosFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'measurementPhotosProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$measurementPhotosHash();

  @override
  String toString() {
    return r'measurementPhotosProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Photo>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Photo>> create(Ref ref) {
    final argument = this.argument as String;
    return measurementPhotos(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MeasurementPhotosProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$measurementPhotosHash() => r'9f5e4aa5bfff80051f7b1986c681a8025d02c22e';

/// Photos of a measurement, in strip order; re-emits on any change.

final class MeasurementPhotosFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Photo>>, String> {
  MeasurementPhotosFamily._()
    : super(
        retry: null,
        name: r'measurementPhotosProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Photos of a measurement, in strip order; re-emits on any change.

  MeasurementPhotosProvider call(String measurementId) =>
      MeasurementPhotosProvider._(argument: measurementId, from: this);

  @override
  String toString() => r'measurementPhotosProvider';
}

/// Number of photo imports running (the strip shows a spinner tile).

@ProviderFor(PhotoImports)
final photoImportsProvider = PhotoImportsProvider._();

/// Number of photo imports running (the strip shows a spinner tile).
final class PhotoImportsProvider extends $NotifierProvider<PhotoImports, int> {
  /// Number of photo imports running (the strip shows a spinner tile).
  PhotoImportsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoImportsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoImportsHash();

  @$internal
  @override
  PhotoImports create() => PhotoImports();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$photoImportsHash() => r'ee1cecf8ea8a9ff2a48df0be229f775c3d884661';

/// Number of photo imports running (the strip shows a spinner tile).

abstract class _$PhotoImports extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(photoActions)
final photoActionsProvider = PhotoActionsProvider._();

final class PhotoActionsProvider
    extends $FunctionalProvider<PhotoActions, PhotoActions, PhotoActions>
    with $Provider<PhotoActions> {
  PhotoActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoActionsHash();

  @$internal
  @override
  $ProviderElement<PhotoActions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PhotoActions create(Ref ref) {
    return photoActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoActions>(value),
    );
  }
}

String _$photoActionsHash() => r'c5d5aac629274494844d2a7be662ba4cc6b34f4c';
