import 'dart:async';

import 'package:drift/drift.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/core/utils/id_generator.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/data/db/app_database.dart';
import 'package:gps_measurement/data/db/converters.dart';
import 'package:gps_measurement/data/db/search_text.dart';
import 'package:gps_measurement/data/db/stream_utils.dart';
import 'package:gps_measurement/data/storage/photo_storage.dart';
import 'package:gps_measurement/data/storage/thumbnail_storage.dart';
import 'package:gps_measurement/domain/geo/geo_calculator.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';
import 'package:gps_measurement/domain/models/measurement_summary.dart';

export 'package:drift/drift.dart' show Value;

/// Measurements (drafts and saved share one table). The ONLY place that
/// deletes a measurement (DB rows + photo files + thumbnail).
///
/// Optional update parameters use drift's [Value]: `Value.absent()` (the
/// default) leaves a column untouched, `Value(null)` clears it.
abstract interface class MeasurementRepository {
  /// Creates a draft (called on the first point / Start Walking).
  Future<Measurement> createDraft(MeasurementType type, MapStyle mapStyle);

  Future<Measurement?> get(String id);

  /// Measurement with points and photos; re-emits on any change to them.
  /// Emits null once the measurement is deleted.
  Stream<Measurement?> watch(String id);

  /// Replaces all points (Area/Distance autosave, Edit save) and the cached
  /// stats/bounds, in one transaction.
  Future<void> replacePoints(
    String id,
    List<MeasurePoint> points,
    MeasurementStats stats,
  );

  /// Appends Walk points (buffered flush) + stats + elapsed time.
  Future<void> appendWalkPoints(
    String id,
    List<MeasurePoint> points,
    MeasurementStats stats,
    int elapsedSec,
  );

  Future<void> updateWalkState(
    String id,
    WalkRunState state, {
    Value<DateTime?> startedAt,
    Value<int?> elapsedSec,
    Value<DateTime?> lastResumeAt,
  });

  /// Walks left `recording` by a killed app become `paused` (elapsed time
  /// kept). Returns their ids. Called once at start-up.
  Future<List<String>> pauseInterruptedWalks();

  /// [touch] false keeps `updated_at` (display-only changes such as units
  /// or map style must not reorder the lists).
  Future<void> updateMeta(
    String id, {
    Value<String?> name,
    Value<String?> notes,
    Value<MapStyle> mapStyle,
    Value<AreaUnit?> displayAreaUnit,
    Value<DistanceUnit?> displayDistanceUnit,
    Value<double?> unitPrice,
    Value<String?> unitPriceCurrency,
    Value<AreaUnit?> unitPriceArea,
    Value<String?> thumbnailPath,
    bool touch,
  });

  /// Save (`architecture.md` §8): name, notes, `status = saved` and
  /// `saved_at` in one transaction. The draft row simply becomes saved.
  /// [unitPrice] (per [unitPriceArea], in [unitPriceCurrency]) is the
  /// land value; null clears it.
  Future<void> markSaved(
    String id, {
    required String name,
    String? notes,
    double? unitPrice,
    String? unitPriceCurrency,
    AreaUnit? unitPriceArea,
  });

  /// Edit screen "Save Changes" (`plan.md` P7-08), one transaction: name,
  /// notes and — when [points] is given — the geometry with its stats and
  /// bounds. Photos attached to points that no longer exist are detached.
  Future<void> saveEdit(
    String id, {
    required String name,
    String? notes,
    List<MeasurePoint>? points,
    MeasurementStats? stats,
  });

  /// Names starting with [prefix] (exact case), for "Area · Sep 28 (2)".
  Future<List<String>> namesWithPrefix(String prefix);

  /// Draft → completed/saved. [savedAt] defaults to now for `saved`.
  Future<void> setStatus(
    String id,
    MeasurementStatus status, {
    DateTime? savedAt,
  });

  /// Saved list, newest first. [query] is matched ignoring case and
  /// Vietnamese diacritics.
  Stream<List<MeasurementSummary>> watchSaved({
    MeasurementType? type,
    String? query,
  });

  /// Drafts + completed-but-unsaved walks, newest first.
  Stream<List<MeasurementSummary>> watchDrafts();

  Stream<List<MeasurementSummary>> watchRecent(int limit);

  Future<int> countSaved();

  /// Saved counts per type (for the Saved filter chips).
  Stream<Map<MeasurementType, int>> watchCountByType();

  /// Deletes DB rows (points/photos cascade), photo files and thumbnail.
  Future<void> delete(String id);
}

class DriftMeasurementRepository implements MeasurementRepository {
  DriftMeasurementRepository({
    required AppDatabase db,
    required PhotoStorage photoStorage,
    required ThumbnailStorage thumbnailStorage,
    IdGenerator ids = const IdGenerator(),
    Clock clock = const Clock(),
  }) : _db = db,
       _photoStorage = photoStorage,
       _thumbs = thumbnailStorage,
       _ids = ids,
       _clock = clock;

  final AppDatabase _db;
  final PhotoStorage _photoStorage;
  final ThumbnailStorage _thumbs;
  final IdGenerator _ids;
  final Clock _clock;

  @override
  Future<Measurement> createDraft(MeasurementType type, MapStyle mapStyle) =>
      _guard('createDraft', () async {
        final now = _clock.nowUtc();
        final id = _ids.newId();
        await _db.measurementDao.insertRow(
          MeasurementsCompanion.insert(
            id: id,
            type: type,
            status: MeasurementStatus.draft,
            mapStyle: mapStyle,
            walkState: Value(
              type == MeasurementType.walk ? WalkRunState.idle : null,
            ),
            createdAt: now,
            updatedAt: now,
          ),
        );
        return (await get(id))!;
      });

  @override
  Future<Measurement?> get(String id) => _guard('get', () async {
    final row = await _db.measurementDao.getById(id);
    if (row == null) return null;
    final points = await _db.pointDao.getForMeasurement(id);
    final photos = await _db.photoDao.getForMeasurement(id);
    return row.toDomain(
      points: [for (final p in points) p.toDomain()],
      photos: [for (final p in photos) p.toDomain()],
    );
  });

  @override
  Stream<Measurement?> watch(String id) => _guardStream(
    'watch',
    combineLatest3(
      _db.measurementDao.watchById(id),
      _db.pointDao.watchForMeasurement(id),
      _db.photoDao.watchForMeasurement(id),
      (row, points, photos) => row?.toDomain(
        points: [for (final p in points) p.toDomain()],
        photos: [for (final p in photos) p.toDomain()],
      ),
    ),
  );

  @override
  Future<void> replacePoints(
    String id,
    List<MeasurePoint> points,
    MeasurementStats stats,
  ) => _guard('replacePoints', () {
    return _db.transaction(() async {
      await _db.pointDao.deleteForMeasurement(id);
      await _db.pointDao.insertAll([for (final p in points) p.toCompanion(id)]);
      final b = _bounds(points);
      await _write(
        id,
        statsCompanion(stats).copyWith(
          minLat: b.minLat,
          minLng: b.minLng,
          maxLat: b.maxLat,
          maxLng: b.maxLng,
          updatedAt: Value(_clock.nowUtc()),
        ),
      );
    });
  });

  @override
  Future<void> appendWalkPoints(
    String id,
    List<MeasurePoint> points,
    MeasurementStats stats,
    int elapsedSec,
  ) => _guard('appendWalkPoints', () {
    return _db.transaction(() async {
      final row = await _db.measurementDao.getById(id);
      if (row == null) throw StorageException('Measurement $id not found');
      await _db.pointDao.insertAll([for (final p in points) p.toCompanion(id)]);
      final merged = GeoCalculator.bounds([
        ...points.map((p) => p.position),
        if (row.bounds case final b?) ...[
          GeoPoint(lat: b.minLat, lng: b.minLng),
          GeoPoint(lat: b.maxLat, lng: b.maxLng),
        ],
      ]);
      await _write(
        id,
        statsCompanion(stats)
            .copyWith(
              walkElapsedSec: Value(elapsedSec),
              updatedAt: Value(_clock.nowUtc()),
            )
            .copyWith(
              minLat: Value(merged?.minLat),
              minLng: Value(merged?.minLng),
              maxLat: Value(merged?.maxLat),
              maxLng: Value(merged?.maxLng),
            ),
      );
    });
  });

  @override
  Future<void> updateWalkState(
    String id,
    WalkRunState state, {
    Value<DateTime?> startedAt = const Value.absent(),
    Value<int?> elapsedSec = const Value.absent(),
    Value<DateTime?> lastResumeAt = const Value.absent(),
  }) => _guard(
    'updateWalkState',
    () => _write(
      id,
      MeasurementsCompanion(
        walkState: Value(state),
        walkStartedAt: _utc(startedAt),
        walkElapsedSec: elapsedSec,
        walkLastResumeAt: _utc(lastResumeAt),
        updatedAt: Value(_clock.nowUtc()),
      ),
    ),
  );

  @override
  Future<List<String>> pauseInterruptedWalks() =>
      _guard('pauseInterruptedWalks', () {
        return _db.transaction(() async {
          final rows = await _db.measurementDao.walksInState(
            WalkRunState.recording,
          );
          for (final row in rows) {
            await _write(
              row.id,
              const MeasurementsCompanion(
                walkState: Value(WalkRunState.paused),
                walkLastResumeAt: Value(null),
              ),
            );
          }
          return [for (final r in rows) r.id];
        });
      });

  @override
  Future<void> updateMeta(
    String id, {
    Value<String?> name = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<MapStyle> mapStyle = const Value.absent(),
    Value<AreaUnit?> displayAreaUnit = const Value.absent(),
    Value<DistanceUnit?> displayDistanceUnit = const Value.absent(),
    Value<double?> unitPrice = const Value.absent(),
    Value<String?> unitPriceCurrency = const Value.absent(),
    Value<AreaUnit?> unitPriceArea = const Value.absent(),
    Value<String?> thumbnailPath = const Value.absent(),
    bool touch = true,
  }) => _guard(
    'updateMeta',
    () => _write(
      id,
      MeasurementsCompanion(
        name: name,
        nameLower: name.present
            ? Value(name.value == null ? null : foldForSearch(name.value!))
            : const Value.absent(),
        notes: notes,
        mapStyle: mapStyle,
        displayAreaUnit: displayAreaUnit,
        displayDistanceUnit: displayDistanceUnit,
        unitPrice: unitPrice,
        unitPriceCurrency: unitPriceCurrency,
        unitPriceArea: unitPriceArea,
        thumbnailPath: thumbnailPath,
        updatedAt: touch ? Value(_clock.nowUtc()) : const Value.absent(),
      ),
    ),
  );

  @override
  Future<void> markSaved(
    String id, {
    required String name,
    String? notes,
    double? unitPrice,
    String? unitPriceCurrency,
    AreaUnit? unitPriceArea,
  }) => _guard('markSaved', () {
    final now = _clock.nowUtc();
    return _write(
      id,
      MeasurementsCompanion(
        name: Value(name),
        nameLower: Value(foldForSearch(name)),
        notes: Value(notes),
        unitPrice: Value(unitPrice),
        unitPriceCurrency: Value(unitPrice == null ? null : unitPriceCurrency),
        unitPriceArea: Value(unitPrice == null ? null : unitPriceArea),
        status: const Value(MeasurementStatus.saved),
        savedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  });

  @override
  Future<void> saveEdit(
    String id, {
    required String name,
    String? notes,
    List<MeasurePoint>? points,
    MeasurementStats? stats,
  }) => _guard('saveEdit', () {
    return _db.transaction(() async {
      var fields = MeasurementsCompanion(
        name: Value(name),
        nameLower: Value(foldForSearch(name)),
        notes: Value(notes),
        updatedAt: Value(_clock.nowUtc()),
      );
      if (points != null) {
        await _db.pointDao.deleteForMeasurement(id);
        await _db.pointDao.insertAll([
          for (final p in points) p.toCompanion(id),
        ]);
        final b = _bounds(points);
        fields = fields.copyWith(
          minLat: b.minLat,
          minLng: b.minLng,
          maxLat: b.maxLat,
          maxLng: b.maxLng,
        );
        if (stats != null) {
          final s = statsCompanion(stats);
          fields = fields.copyWith(
            areaM2: s.areaM2,
            perimeterM: s.perimeterM,
            distanceM: s.distanceM,
            durationSec: s.durationSec,
            pointCount: s.pointCount,
            segmentCount: s.segmentCount,
            isClosed: s.isClosed,
            selfIntersects: s.selfIntersects,
          );
        }
        final ids = {for (final p in points) p.id};
        for (final photo in await _db.photoDao.getForMeasurement(id)) {
          final pointId = photo.pointId;
          if (pointId != null && !ids.contains(pointId)) {
            await _db.photoDao.detachPoint(pointId);
          }
        }
      }
      await _write(id, fields);
    });
  });

  @override
  Future<List<String>> namesWithPrefix(String prefix) => _guard(
    'namesWithPrefix',
    () => _db.measurementDao.namesWithPrefix(prefix),
  );

  @override
  Future<void> setStatus(
    String id,
    MeasurementStatus status, {
    DateTime? savedAt,
  }) => _guard('setStatus', () {
    final now = _clock.nowUtc();
    return _write(
      id,
      MeasurementsCompanion(
        status: Value(status),
        savedAt: status == MeasurementStatus.saved
            ? Value((savedAt ?? now).toUtc())
            : const Value.absent(),
        updatedAt: Value(now),
      ),
    );
  });

  @override
  Stream<List<MeasurementSummary>> watchSaved({
    MeasurementType? type,
    String? query,
  }) => _summaries(
    {MeasurementStatus.saved},
    type: type,
    query: query == null ? null : foldForSearch(query),
  );

  @override
  Stream<List<MeasurementSummary>> watchDrafts() =>
      _summaries({MeasurementStatus.draft, MeasurementStatus.completed});

  @override
  Stream<List<MeasurementSummary>> watchRecent(int limit) =>
      _summaries({MeasurementStatus.saved}, limit: limit);

  Stream<List<MeasurementSummary>> _summaries(
    Set<MeasurementStatus> statuses, {
    MeasurementType? type,
    String? query,
    int? limit,
  }) => _guardStream(
    'list',
    _db.measurementDao
        .watchList(
          statuses: statuses,
          type: type,
          nameQuery: query,
          limit: limit,
        )
        .map(
          (rows) => [
            for (final r in rows) r.row.toSummary(photoCount: r.photoCount),
          ],
        ),
  );

  @override
  Future<int> countSaved() => _guard(
    'countSaved',
    () => _db.measurementDao.countWithStatus(MeasurementStatus.saved),
  );

  @override
  Stream<Map<MeasurementType, int>> watchCountByType() => _guardStream(
    'countByType',
    _db.measurementDao.watchCountByType(MeasurementStatus.saved),
  );

  @override
  Future<void> delete(String id) => _guard('delete', () async {
    // DB first: if file cleanup fails, the orphan cleaner catches it later.
    await _db.measurementDao.deleteById(id);
    try {
      await _photoStorage.deleteForMeasurement(id);
    } on StorageException catch (e) {
      Log.w('Photo files of $id left for the orphan cleaner', e);
    }
    await _thumbs.delete(id);
  });

  // ---------------------------------------------------------------------

  Future<void> _write(String id, MeasurementsCompanion fields) async {
    final changed = await _db.measurementDao.updateFields(id, fields);
    if (changed == 0) throw StorageException('Measurement $id not found');
  }

  static MeasurementsCompanion _bounds(List<MeasurePoint> points) =>
      boundsCompanion(GeoCalculator.bounds(points.map((p) => p.position)));

  static Value<DateTime?> _utc(Value<DateTime?> v) =>
      v.present ? Value(v.value?.toUtc()) : v;

  Future<T> _guard<T>(String op, Future<T> Function() body) async {
    try {
      return await body();
    } on AppException {
      rethrow;
    } on Object catch (e, st) {
      throw StorageException(
        'MeasurementRepository.$op',
        cause: e,
        stackTrace: st,
      );
    }
  }

  Stream<T> _guardStream<T>(String op, Stream<T> source) => source.handleError(
    (Object e, StackTrace st) => throw e is AppException
        ? e
        : StorageException(
            'MeasurementRepository.$op',
            cause: e,
            stackTrace: st,
          ),
  );
}
