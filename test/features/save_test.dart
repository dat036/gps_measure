import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/core/utils/id_generator.dart';
import 'package:gps_measurement/data/db/app_database.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:gps_measurement/data/storage/thumbnail_storage.dart';
import 'package:gps_measurement/domain/geo/stats_calculator.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/premium/feature_gate.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:gps_measurement/features/premium/premium_flows.dart';
import 'package:gps_measurement/features/save/name_suggester.dart';
import 'package:gps_measurement/features/save/pending_thumbnails.dart';
import 'package:gps_measurement/features/save/save_controller.dart';
import 'package:gps_measurement/features/saved/saved_controller.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/data.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('vi');
  });

  group('NameSuggester', () {
    final day = DateTime(2026, 9, 28, 10);

    test('en / vi base names', () {
      expect(
        NameSuggester.base(typeLabel: 'Area', date: day, locale: 'en'),
        'Area · Sep 28',
      );
      expect(
        NameSuggester.base(typeLabel: 'Diện tích', date: day, locale: 'vi'),
        'Diện tích · 28/09',
      );
    });

    test('same-day duplicates get (2), (3)…', () {
      String suggest(List<String> existing) => NameSuggester.suggest(
        typeLabel: 'Area',
        date: day,
        locale: 'en',
        existingNames: existing,
      );
      expect(suggest([]), 'Area · Sep 28');
      expect(suggest(['Area · Sep 28']), 'Area · Sep 28 (2)');
      expect(
        suggest(['Area · Sep 28', 'Area · Sep 28 (2)', 'Area · Sep 28 (4)']),
        'Area · Sep 28 (3)',
      );
      // Only exact collisions count.
      expect(suggest(['Area · Sep 28 old']), 'Area · Sep 28');
    });
  });

  group('with a database', () {
    late AppDatabase db;
    late TempDirectories temp;
    late SharedPreferences prefs;
    late FixedClock clock;
    late ProviderContainer container;

    ProviderContainer newContainer({List<Override> extra = const []}) {
      final c = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          appDirectoriesProvider.overrideWithValue(temp.dirs),
          appDatabaseProvider.overrideWithValue(db),
          imageCompressorProvider.overrideWithValue(FakeCompressor()),
          clockProvider.overrideWithValue(clock),
          idGeneratorProvider.overrideWithValue(SequentialIds()),
          ...extra,
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    MeasurementRepository repo() =>
        container.read(measurementRepositoryProvider);

    /// An Area draft with a 4-point square (≈ 100 × 100 m).
    Future<String> areaDraft() async {
      final m = await repo().createDraft(
        MeasurementType.area,
        MapStyle.satellite,
      );
      final points = [
        for (final (i, (lat, lng)) in [
          (21.0, 105.0),
          (21.0, 105.001),
          (21.001, 105.001),
          (21.001, 105.0),
        ].indexed)
          MeasurePoint(
            id: '${m.id}-p$i',
            orderIndex: i,
            lat: lat,
            lng: lng,
            timestamp: clock.nowUtc(),
          ),
      ];
      await repo().replacePoints(
        m.id,
        points,
        StatsCalculator.compute(MeasurementType.area, points, closed: true),
      );
      return m.id;
    }

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      db = newTestDatabase();
      temp = TempDirectories();
      clock = testClock();
      container = newContainer();
    });

    tearDown(() async {
      await db.close();
      temp.dispose();
    });

    group('repository', () {
      test('markSaved: name, search key, notes, status, saved_at', () async {
        final id = await areaDraft();
        clock.advance(const Duration(minutes: 5));
        await repo().markSaved(id, name: 'Ruộng Đông', notes: 'Bờ tây');
        final m = (await repo().get(id))!;
        expect(m.name, 'Ruộng Đông');
        expect(m.notes, 'Bờ tây');
        expect(m.status, MeasurementStatus.saved);
        expect(m.savedAt, clock.nowUtc());
        final found = await repo().watchSaved(query: 'ruong dong').first;
        expect(found.map((s) => s.id), [id]);
      });

      test('namesWithPrefix is literal and case-exact', () async {
        final a = await areaDraft();
        final b = await areaDraft();
        final c = await areaDraft();
        await repo().markSaved(a, name: 'Area · Sep 28');
        await repo().markSaved(b, name: 'area · Sep 28 (2)');
        await repo().markSaved(c, name: 'Area_x');
        expect(await repo().namesWithPrefix('Area · Sep 28'), [
          'Area · Sep 28',
        ]);
        expect(await repo().namesWithPrefix('Area_'), ['Area_x']);
        expect(await repo().namesWithPrefix('Area%'), isEmpty);
      });

      test('updateMeta(touch: false) keeps updated_at', () async {
        final id = await areaDraft();
        final before = (await repo().get(id))!.updatedAt;
        clock.advance(const Duration(hours: 1));
        await repo().updateMeta(
          id,
          displayAreaUnit: const Value(AreaUnit.hectare),
          touch: false,
        );
        final m = (await repo().get(id))!;
        expect(m.displayAreaUnit, AreaUnit.hectare);
        expect(m.updatedAt, before);
      });
    });

    group('SaveController', () {
      SaveController save(String id) =>
          container.read(saveControllerProvider(id).notifier);

      test('suggests a unique name and saves the draft', () async {
        final id = await areaDraft();
        final other = await areaDraft();
        await repo().markSaved(other, name: 'Area · Sep 28');

        final sub = container.listen(saveControllerProvider(id), (_, _) {});
        addTearDown(sub.close);
        final state = await container.read(saveControllerProvider(id).future);
        expect(state.preview, isNotNull); // drawn preview (no snapshot)
        expect(
          await save(id).suggestName(typeLabel: 'Area', locale: 'en'),
          'Area · Sep 28 (2)',
        );

        expect(
          await save(id).save(name: '  '),
          SaveResult.invalidName,
        );
        expect(
          await save(id).save(name: '  My farm ', notes: '  '),
          SaveResult.saved,
        );
        final m = (await repo().get(id))!;
        expect(m.name, 'My farm');
        expect(m.notes, isNull);
        expect(m.status, MeasurementStatus.saved);
        expect(m.thumbnailPath, ThumbnailStorage.relativePathFor(id));
        expect(temp.files(), contains(ThumbnailStorage.relativePathFor(id)));
        expect(container.read(settingsRepositoryProvider).savesCountTotal, 1);
      });

      test('keeps the name of a named draft', () async {
        final id = await areaDraft();
        await repo().updateMeta(id, name: const Value('Vườn'));
        final sub = container.listen(saveControllerProvider(id), (_, _) {});
        addTearDown(sub.close);
        await container.read(saveControllerProvider(id).future);
        expect(
          await save(id).suggestName(typeLabel: 'Area', locale: 'en'),
          'Vườn',
        );
      });

      test('uses the map snapshot from the measure screen', () async {
        final id = await areaDraft();
        final png = await ThumbnailStorage.renderPng((await repo().get(id))!);
        container.read(pendingThumbnailsProvider).put(id, png);
        final sub = container.listen(saveControllerProvider(id), (_, _) {});
        addTearDown(sub.close);
        final state = await container.read(saveControllerProvider(id).future);
        expect(state.preview, same(png));

        expect(await save(id).save(name: 'A'), SaveResult.saved);
        final file = temp.dirs.resolve(ThumbnailStorage.relativePathFor(id));
        expect(file.readAsBytesSync(), Uint8List.fromList(png));
        expect(container.read(pendingThumbnailsProvider).peek(id), isNull);
      });

      test('free limit: stays a draft', () async {
        container = newContainer(
          extra: [
            featureGateProvider.overrideWithValue(
              const FeatureGate(
                isPremium: false,
                config: GateConfig(freeMaxSaved: 1),
              ),
            ),
          ],
        );
        final first = await areaDraft();
        await repo().markSaved(first, name: 'First');
        final id = await areaDraft();
        final sub = container.listen(saveControllerProvider(id), (_, _) {});
        addTearDown(sub.close);
        await container.read(saveControllerProvider(id).future);
        expect(await save(id).save(name: 'Second'), SaveResult.limitReached);
        expect((await repo().get(id))!.status, MeasurementStatus.draft);
      });

      test(
        'reward opens only its project beyond four saved projects',
        () async {
          for (var i = 0; i < 4; i++) {
            await repo().markSaved(await areaDraft(), name: 'Project $i');
          }
          final id = await areaDraft();
          await prefs.setBool(PremiumFlows.projectUnlockKey(id), true);
          final other = await areaDraft();
          // Recreate the container: the grant survives an app restart.
          container = newContainer();
          final sub = container.listen(saveControllerProvider(id), (_, _) {});
          addTearDown(sub.close);
          await container.read(saveControllerProvider(id).future);
          expect(await save(id).save(name: 'Rewarded'), SaveResult.saved);
          final otherSub = container.listen(
            saveControllerProvider(other),
            (_, _) {},
          );
          addTearDown(otherSub.close);
          await container.read(saveControllerProvider(other).future);
          expect(
            await save(other).save(name: 'Other'),
            SaveResult.limitReached,
          );
        },
      );

      test('missing measurement → error state', () async {
        final sub = container.listen(
          saveControllerProvider('nope'),
          (_, _) {},
        );
        addTearDown(sub.close);
        await pumpEventQueue();
        expect(container.read(saveControllerProvider('nope')).hasError, isTrue);
      });
    });

    group('SavedController', () {
      test('filters by type and debounced query; drafts separate', () async {
        final a = await areaDraft();
        final b = await areaDraft();
        await areaDraft(); // stays a draft
        await repo().markSaved(a, name: 'Ruộng lúa');
        await repo().markSaved(b, name: 'Vườn cam');

        final saved = container.listen(savedListProvider, (_, _) {});
        final drafts = container.listen(draftListProvider, (_, _) {});
        addTearDown(saved.close);
        addTearDown(drafts.close);
        Future<List<String?>> names() async => (await container.read(
          savedListProvider.future,
        )).map((s) => s.name).toList();

        expect(await names(), hasLength(2));
        expect(await container.read(draftListProvider.future), hasLength(1));

        final controller = container.read(savedControllerProvider.notifier)
          ..openSearch()
          ..setQuery('ruong');
        expect(container.read(savedControllerProvider).query, isEmpty);
        await Future<void>.delayed(
          SavedController.searchDebounce + const Duration(milliseconds: 50),
        );
        expect(container.read(savedControllerProvider).query, 'ruong');
        expect(await names(), ['Ruộng lúa']);

        controller
          ..closeSearch()
          ..setType(MeasurementType.distance);
        expect(await names(), isEmpty);
        controller.setType(null);
        expect(await names(), hasLength(2));
      });
    });
  });
}
