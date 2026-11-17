// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'30d59109f9ecc12015c3f234b6cbd4f7ad740868';

@ProviderFor(appDirectories)
final appDirectoriesProvider = AppDirectoriesProvider._();

final class AppDirectoriesProvider
    extends $FunctionalProvider<AppDirectories, AppDirectories, AppDirectories>
    with $Provider<AppDirectories> {
  AppDirectoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDirectoriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDirectoriesHash();

  @$internal
  @override
  $ProviderElement<AppDirectories> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDirectories create(Ref ref) {
    return appDirectories(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDirectories value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDirectories>(value),
    );
  }
}

String _$appDirectoriesHash() => r'dfcc3a7127b163ec704163bb202bfc5e1ec84074';

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'365ef3f215d780c29a21b6328f0b547a8363c6a6';

@ProviderFor(imageCompressor)
final imageCompressorProvider = ImageCompressorProvider._();

final class ImageCompressorProvider
    extends
        $FunctionalProvider<ImageCompressor, ImageCompressor, ImageCompressor>
    with $Provider<ImageCompressor> {
  ImageCompressorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageCompressorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageCompressorHash();

  @$internal
  @override
  $ProviderElement<ImageCompressor> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ImageCompressor create(Ref ref) {
    return imageCompressor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageCompressor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageCompressor>(value),
    );
  }
}

String _$imageCompressorHash() => r'83c5cdf68c1fc2d8b2a340f8e06f3448c4eeed0f';

@ProviderFor(photoStorage)
final photoStorageProvider = PhotoStorageProvider._();

final class PhotoStorageProvider
    extends $FunctionalProvider<PhotoStorage, PhotoStorage, PhotoStorage>
    with $Provider<PhotoStorage> {
  PhotoStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoStorageHash();

  @$internal
  @override
  $ProviderElement<PhotoStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PhotoStorage create(Ref ref) {
    return photoStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoStorage>(value),
    );
  }
}

String _$photoStorageHash() => r'470a7f7913164271ac9bac1a5939681f35365f63';

@ProviderFor(thumbnailStorage)
final thumbnailStorageProvider = ThumbnailStorageProvider._();

final class ThumbnailStorageProvider
    extends
        $FunctionalProvider<
          ThumbnailStorage,
          ThumbnailStorage,
          ThumbnailStorage
        >
    with $Provider<ThumbnailStorage> {
  ThumbnailStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'thumbnailStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$thumbnailStorageHash();

  @$internal
  @override
  $ProviderElement<ThumbnailStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ThumbnailStorage create(Ref ref) {
    return thumbnailStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThumbnailStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThumbnailStorage>(value),
    );
  }
}

String _$thumbnailStorageHash() => r'3f028e5daf6938e6cede28a145c465a05270d4de';

@ProviderFor(measurementRepository)
final measurementRepositoryProvider = MeasurementRepositoryProvider._();

final class MeasurementRepositoryProvider
    extends
        $FunctionalProvider<
          MeasurementRepository,
          MeasurementRepository,
          MeasurementRepository
        >
    with $Provider<MeasurementRepository> {
  MeasurementRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'measurementRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$measurementRepositoryHash();

  @$internal
  @override
  $ProviderElement<MeasurementRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MeasurementRepository create(Ref ref) {
    return measurementRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeasurementRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeasurementRepository>(value),
    );
  }
}

String _$measurementRepositoryHash() =>
    r'e8a8bd8220568beb5c2c10b6692b6f33f12b17f2';

@ProviderFor(photoRepository)
final photoRepositoryProvider = PhotoRepositoryProvider._();

final class PhotoRepositoryProvider
    extends
        $FunctionalProvider<PhotoRepository, PhotoRepository, PhotoRepository>
    with $Provider<PhotoRepository> {
  PhotoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photoRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photoRepositoryHash();

  @$internal
  @override
  $ProviderElement<PhotoRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PhotoRepository create(Ref ref) {
    return photoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhotoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhotoRepository>(value),
    );
  }
}

String _$photoRepositoryHash() => r'3c0e68d6309ef41c79753b61887fdc441e77bd63';

@ProviderFor(settingsRepository)
final settingsRepositoryProvider = SettingsRepositoryProvider._();

final class SettingsRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsRepository,
          SettingsRepository,
          SettingsRepository
        >
    with $Provider<SettingsRepository> {
  SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'cb57457244062d3bd9be73a1a3ee43a55e76dd3d';

@ProviderFor(orphanFileCleaner)
final orphanFileCleanerProvider = OrphanFileCleanerProvider._();

final class OrphanFileCleanerProvider
    extends
        $FunctionalProvider<
          OrphanFileCleaner,
          OrphanFileCleaner,
          OrphanFileCleaner
        >
    with $Provider<OrphanFileCleaner> {
  OrphanFileCleanerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orphanFileCleanerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orphanFileCleanerHash();

  @$internal
  @override
  $ProviderElement<OrphanFileCleaner> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OrphanFileCleaner create(Ref ref) {
    return orphanFileCleaner(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrphanFileCleaner value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrphanFileCleaner>(value),
    );
  }
}

String _$orphanFileCleanerHash() => r'600e87b477aa6c7b3c9d16e4d45da517f082cb6a';
