import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/core/utils/id_generator.dart';
import 'package:gps_measurement/data/db/app_database.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:gps_measurement/data/repositories/photo_repository.dart';
import 'package:gps_measurement/data/repositories/settings_repository.dart';
import 'package:gps_measurement/data/storage/app_directories.dart';
import 'package:gps_measurement/data/storage/image_compressor.dart';
import 'package:gps_measurement/data/storage/orphan_file_cleaner.dart';
import 'package:gps_measurement/data/storage/photo_storage.dart';
import 'package:gps_measurement/data/storage/thumbnail_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'providers.g.dart';

// App-lifetime data providers (keepAlive). The two async-initialised ones
// are resolved in bootstrap() and injected with overrides.

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) =>
    throw UnimplementedError('Overridden in bootstrap()');

@Riverpod(keepAlive: true)
AppDirectories appDirectories(Ref ref) =>
    throw UnimplementedError('Overridden in bootstrap()');

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase.open();
  ref.onDispose(db.close);
  return db;
}

@Riverpod(keepAlive: true)
ImageCompressor imageCompressor(Ref ref) => const NativeImageCompressor();

@Riverpod(keepAlive: true)
PhotoStorage photoStorage(Ref ref) => PhotoStorage(
  directories: ref.watch(appDirectoriesProvider),
  compressor: ref.watch(imageCompressorProvider),
  ids: ref.watch(idGeneratorProvider),
  clock: ref.watch(clockProvider),
);

@Riverpod(keepAlive: true)
ThumbnailStorage thumbnailStorage(Ref ref) =>
    ThumbnailStorage(directories: ref.watch(appDirectoriesProvider));

@Riverpod(keepAlive: true)
MeasurementRepository measurementRepository(Ref ref) =>
    DriftMeasurementRepository(
      db: ref.watch(appDatabaseProvider),
      photoStorage: ref.watch(photoStorageProvider),
      thumbnailStorage: ref.watch(thumbnailStorageProvider),
      ids: ref.watch(idGeneratorProvider),
      clock: ref.watch(clockProvider),
    );

@Riverpod(keepAlive: true)
PhotoRepository photoRepository(Ref ref) => DriftPhotoRepository(
  db: ref.watch(appDatabaseProvider),
  storage: ref.watch(photoStorageProvider),
  clock: ref.watch(clockProvider),
);

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) =>
    SettingsRepository(ref.watch(sharedPreferencesProvider));

@Riverpod(keepAlive: true)
OrphanFileCleaner orphanFileCleaner(Ref ref) => OrphanFileCleaner(
  db: ref.watch(appDatabaseProvider),
  directories: ref.watch(appDirectoriesProvider),
  settings: ref.watch(settingsRepositoryProvider),
  clock: ref.watch(clockProvider),
);
