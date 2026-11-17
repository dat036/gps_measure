import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/l10n/app_locale.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/data/db/app_database.dart';
import 'package:gps_measurement/data/db/search_text.dart';
import 'package:gps_measurement/data/db/stream_utils.dart';
import 'package:gps_measurement/data/prefs/prefs_keys.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:gps_measurement/data/repositories/photo_repository.dart';
import 'package:gps_measurement/data/repositories/settings_repository.dart';
import 'package:gps_measurement/data/storage/orphan_file_cleaner.dart';
import 'package:gps_measurement/data/storage/photo_storage.dart';
import 'package:gps_measurement/data/storage/thumbnail_storage.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/features/settings/app_settings.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/data.dart';

void main() {
  group('AppSettings defaults by region', () {
    test('metric by default', () {
      final s = AppSettings.defaultsFor('VN');
      expect(s.distanceUnit, DistanceUnit.meter);
      expect(s.areaUnit, AreaUnit.squareMeter);
      expect(s.mapStyle, MapStyle.standard);
      expect(s.defaultMode, MeasurementType.area);
      expect(s.inputMode, InputMode.crosshair);
      expect(s.localeCode, isNull);
      expect(AppSettings.defaultsFor(null).distanceUnit, DistanceUnit.meter);
    });

    test('US/UK use feet + acres, MM/LR feet only', () {
      for (final c in ['US', 'gb']) {
        final s = AppSettings.defaultsFor(c);
        expect(
          (s.distanceUnit, s.areaUnit),
          (
            DistanceUnit.foot,
            AreaUnit.acre,
          ),
        );
      }
      final mm = AppSettings.defaultsFor('MM');
      expect(
        (mm.distanceUnit, mm.areaUnit),
        (
          DistanceUnit.foot,
          AreaUnit.squareMeter,
        ),
      );
    });
  });

  group('SettingsRepository', () {
    test('round-trips every field', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = SettingsRepository(await SharedPreferences.getInstance());
      const changed = AppSettings(
        distanceUnit: DistanceUnit.mile,
        areaUnit: AreaUnit.squareFoot,
        showSecondaryUnit: false,
        mapStyle: MapStyle.hybrid,
        localeCode: 'vi',
        defaultMode: MeasurementType.walk,
        showGpsAccuracy: false,
        autoCenter: false,
        savePhotosToMeasurement: false,
        keepScreenAwake: false,
        inputMode: InputMode.tap,
        showEdgeLabels: false,
      );
      await repo.save(changed);
      expect(repo.load(countryCode: 'US'), changed);
      await repo.save(changed.copyWith(localeCode: null));
      expect(repo.load().localeCode, isNull);
    });

    test(
      'first-run session: until the launch that finished the intro',
      () async {
        Future<SettingsRepository> repo(Map<String, Object> values) async {
          SharedPreferences.setMockInitialValues(values);
          return SettingsRepository(await SharedPreferences.getInstance());
        }

        // Language / intro not finished yet.
        expect((await repo({'app_open_count': 1})).inFirstRunSession, isTrue);
        // The launch that finished them.
        expect(
          (await repo({
            'onboarding_seen': true,
            'onboarding_done_at_open': 1,
            'app_open_count': 1,
          })).inFirstRunSession,
          isTrue,
        );
        // Every launch after that.
        expect(
          (await repo({
            'onboarding_seen': true,
            'onboarding_done_at_open': 1,
            'app_open_count': 2,
          })).inFirstRunSession,
          isFalse,
        );
        // Installs from before the launch was recorded.
        expect(
          (await repo({
            'onboarding_seen': true,
            'app_open_count': 5,
          })).inFirstRunSession,
          isFalse,
        );
      },
    );

    test('help is marked seen per mode', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = SettingsRepository(await SharedPreferences.getInstance());
      expect(repo.helpSeen(MeasurementType.area), isFalse);
      await repo.setHelpSeen(MeasurementType.area);
      expect(repo.helpSeen(MeasurementType.area), isTrue);
      expect(repo.helpSeen(MeasurementType.distance), isFalse);
      expect(repo.recentSearches, isEmpty);
    });

    test('invalid stored enum index falls back to the default', () async {
      SharedPreferences.setMockInitialValues({
        PrefsKeys.areaUnit: 99,
        PrefsKeys.mapStyle: -1,
      });
      final repo = SettingsRepository(await SharedPreferences.getInstance());
      final s = repo.load(countryCode: 'VN');
      expect(s.areaUnit, AreaUnit.squareMeter);
      expect(s.mapStyle, MapStyle.standard);
    });

    test('settingsProvider persists changes; appLocale follows', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          deviceLocaleProvider.overrideWithValue(const Locale('en', 'US')),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(settingsProvider).areaUnit, AreaUnit.acre);
      expect(container.read(appLocaleProvider), isNull);

      await container
          .read(settingsProvider.notifier)
          .change((s) => s.copyWith(areaUnit: AreaUnit.hectare));
      await container.read(settingsProvider.notifier).setLocaleCode('vi');

      expect(container.read(appLocaleProvider), const Locale('vi'));
      expect(prefs.getInt(PrefsKeys.areaUnit), AreaUnit.hectare.index);
      expect(prefs.getString(PrefsKeys.locale), 'vi');
    });
  });

  group('OrphanFileCleaner', () {
    late AppDatabase db;
    late TempDirectories temp;
    late FixedClock clock;
    late SettingsRepository settings;
    late OrphanFileCleaner cleaner;

    setUp(() async {
      db = newTestDatabase();
      temp = TempDirectories();
      clock = testClock();
      SharedPreferences.setMockInitialValues({});
      settings = SettingsRepository(await SharedPreferences.getInstance());
      cleaner = OrphanFileCleaner(
        db: db,
        directories: temp.dirs,
        settings: settings,
        clock: clock,
      );
    });

    tearDown(() async {
      await db.close();
      temp.dispose();
    });

    File write(String rel, {bool old = true}) {
      final f = temp.dirs.resolve(rel)
        ..createSync(recursive: true)
        ..writeAsBytesSync([1]);
      if (old) {
        f.setLastModifiedSync(DateTime.now().subtract(const Duration(days: 2)));
      }
      return f;
    }

    test(
      'removes unreferenced files, keeps referenced and young ones',
      () async {
        // Clock must be "now" for file ages to make sense.
        clock.current = DateTime.now().toUtc();
        final storage = PhotoStorage(
          directories: temp.dirs,
          compressor: FakeCompressor(),
          clock: clock,
        );
        final repo = DriftMeasurementRepository(
          db: db,
          photoStorage: storage,
          thumbnailStorage: ThumbnailStorage(directories: temp.dirs),
          clock: clock,
        );
        final photos = DriftPhotoRepository(db: db, storage: storage);
        final m = await repo.createDraft(
          MeasurementType.area,
          MapStyle.satellite,
        );
        final src = File('${temp.dirs.temporary.path}/s.jpg')
          ..writeAsBytesSync([1]);
        final kept = await photos.add(
          await storage.importFromGallery(XFile(src.path), m.id),
        );
        for (final rel in [kept.filePath, kept.thumbPath]) {
          temp.dirs
              .resolve(rel)
              .setLastModifiedSync(
                DateTime.now().subtract(const Duration(days: 2)),
              );
        }
        write('thumbs/${m.id}.png');
        write('photos/${m.id}/stray.jpg'); // not in DB → removed
        write('photos/deleted-measurement/a.jpg'); // folder removed
        write('thumbs/deleted-measurement.png'); // removed
        write('photos/${m.id}/importing.jpg', old: false); // too young → kept

        final removed = await cleaner.run();

        expect(removed, 3);
        expect(
          temp.files(),
          [
            kept.filePath,
            kept.thumbPath,
            'photos/${m.id}/importing.jpg',
            'thumbs/${m.id}.png',
          ]..sort(),
        );
      },
    );

    test('runIfDue runs at most weekly', () async {
      expect(await cleaner.runIfDue(), 0);
      expect(settings.lastOrphanCleanupAt, clock.nowUtc());
      clock.advance(const Duration(days: 6));
      expect(await cleaner.runIfDue(), isNull);
      clock.advance(const Duration(days: 1));
      expect(await cleaner.runIfDue(), 0);
    });

    test('clearExports wipes temp/exports', () async {
      File('${temp.dirs.exports.path}/a.kml')
        ..createSync(recursive: true)
        ..writeAsStringSync('x');
      await cleaner.clearExports();
      expect(temp.dirs.exports.existsSync(), isFalse);
      await cleaner.clearExports(); // no-op when missing
    });
  });

  test('foldForSearch', () {
    expect(foldForSearch('  Ruộng  Nhà   Ông Tư '), 'ruong nha ong tu');
    expect(foldForSearch('ĐƯỜNG ĐẤT'), 'duong dat');
    expect(foldForSearch('Cà phê ỷ lại'), 'ca phe y lai');
    expect(foldForSearch('Field #2'), 'field #2');
  });

  group('combineLatest3', () {
    test(
      'waits for all, then emits on each change; closes when done',
      () async {
        final a = StreamController<int>();
        final b = StreamController<String>();
        final c = StreamController<bool>();
        final out = <String>[];
        final done = Completer<void>();
        combineLatest3(
          a.stream,
          b.stream,
          c.stream,
          (x, y, z) => '$x$y$z',
        ).listen(out.add, onDone: done.complete);
        a.add(1);
        b.add('x');
        await pumpEventQueue();
        expect(out, isEmpty);
        c.add(true);
        a.add(2);
        await pumpEventQueue();
        expect(out, ['1xtrue', '2xtrue']);
        await Future.wait([a.close(), b.close(), c.close()]);
        await done.future;
      },
    );

    test('forwards errors and supports pause/cancel', () async {
      final a = StreamController<int>();
      final b = StreamController<int>();
      final c = StreamController<int>();
      final errors = <Object>[];
      final sub = combineLatest3(
        a.stream,
        b.stream,
        c.stream,
        (x, y, z) => x + y + z,
      ).listen(null, onError: errors.add);
      a.addError('bad');
      await pumpEventQueue();
      sub
        ..pause()
        ..resume();
      await sub.cancel();
      expect(errors, ['bad']);
    });
  });
}
