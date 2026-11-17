import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:gps_measurement/data/repositories/photo_repository.dart';
import 'package:gps_measurement/data/storage/orphan_file_cleaner.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/data.dart';

void main() {
  test('data providers are wired and share one database', () async {
    SharedPreferences.setMockInitialValues({});
    final temp = TempDirectories();
    addTearDown(temp.dispose);
    final db = newTestDatabase();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(
          await SharedPreferences.getInstance(),
        ),
        appDirectoriesProvider.overrideWithValue(temp.dirs),
        appDatabaseProvider.overrideWithValue(db),
        imageCompressorProvider.overrideWithValue(FakeCompressor()),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await db.close();
    });

    final repo = container.read(measurementRepositoryProvider);
    expect(repo, isA<DriftMeasurementRepository>());
    expect(
      container.read(photoRepositoryProvider),
      isA<DriftPhotoRepository>(),
    );
    expect(container.read(orphanFileCleanerProvider), isA<OrphanFileCleaner>());
    expect(container.read(thumbnailStorageProvider), isNotNull);
    expect(container.read(photoStorageProvider), isNotNull);

    final m = await repo.createDraft(MeasurementType.area, MapStyle.satellite);
    expect((await db.measurementDao.getById(m.id))?.id, m.id);
  });

  test('prefs and directories must be provided by bootstrap', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(
      () => container.read(sharedPreferencesProvider),
      throwsA(anything),
    );
    expect(() => container.read(appDirectoriesProvider), throwsA(anything));
  });
}
