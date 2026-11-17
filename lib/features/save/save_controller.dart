import 'dart:async';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/core/utils/debouncer.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:gps_measurement/data/storage/thumbnail_storage.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:gps_measurement/features/premium/premium_flows.dart';
import 'package:gps_measurement/features/save/land_value_field.dart';
import 'package:gps_measurement/features/save/name_suggester.dart';
import 'package:gps_measurement/features/save/pending_thumbnails.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'save_controller.freezed.dart';
part 'save_controller.g.dart';

@freezed
abstract class SaveState with _$SaveState {
  const factory SaveState({
    required Measurement measurement,

    /// Map snapshot taken by the measure screen, else a drawn preview.
    Uint8List? preview,
    @Default(false) bool saving,
  }) = _SaveState;
}

enum SaveResult {
  saved,

  /// Empty name (after trimming).
  invalidName,

  /// Free limit reached: stays a draft (nothing is lost).
  limitReached,
  failed,
}

/// A missing measurement stays missing: show the error, don't retry.
Duration? _noRetry(int retryCount, Object error) => null;

/// Save Measurement (`architecture.md` §8): validate → FeatureGate →
/// transaction (name, notes, status = saved, saved_at) → thumbnail (never
/// blocks, errors ignored) → saves counter.
@Riverpod(retry: _noRetry)
class SaveController extends _$SaveController {
  static const int maxNameLength = 80;
  static const int maxNotesLength = 2000;

  static const Duration notesAutosaveDelay = Duration(milliseconds: 500);

  late MeasurementRepository _repo;
  final Debouncer _notesDebouncer = Debouncer(notesAutosaveDelay);

  @override
  Future<SaveState> build(String measurementId) async {
    _repo = ref.watch(measurementRepositoryProvider);
    // Leaving Save still writes the last typed notes.
    ref.onDispose(_notesDebouncer.flush);
    final m = await _repo.get(measurementId);
    if (m == null) {
      throw StorageException('Measurement $measurementId not found');
    }
    final snapshot = ref.read(pendingThumbnailsProvider).peek(measurementId);
    var preview = snapshot;
    if (preview == null && m.points.isNotEmpty) {
      try {
        preview = await ThumbnailStorage.renderPng(m);
      } on Object catch (e, st) {
        Log.w('Preview render failed', e, st);
      }
    }
    return SaveState(measurement: m, preview: preview);
  }

  /// Default name: the current one, else "Area · Sep 28" made unique.
  Future<String> suggestName({
    required String typeLabel,
    required String locale,
  }) async {
    final m = (await future).measurement;
    final current = m.name?.trim();
    if (current != null && current.isNotEmpty) return current;
    final base = NameSuggester.base(
      typeLabel: typeLabel,
      date: ref.read(clockProvider).now(),
      locale: locale,
    );
    var existing = const <String>[];
    try {
      existing = await _repo.namesWithPrefix(base);
    } on AppException catch (e) {
      Log.w('Could not read existing names', e);
    }
    return NameSuggester.suggest(
      typeLabel: typeLabel,
      date: ref.read(clockProvider).now(),
      locale: locale,
      existingNames: existing,
    );
  }

  /// Notes typed on Save go to the draft 500 ms after the last keystroke
  /// (`plan.md` P7-07), so they survive a cancelled Save.
  void autosaveNotes(String text) {
    final id = measurementId;
    _notesDebouncer.run(() {
      final trimmed = text.trim();
      unawaited(
        _repo
            .updateMeta(
              id,
              notes: Value(trimmed.isEmpty ? null : trimmed),
              touch: false,
            )
            .catchError(
              (Object e, StackTrace st) =>
                  Log.w('Notes autosave failed', e, st),
            ),
      );
    });
  }

  /// [price]: land value (ignored when its price is missing or ≤ 0).
  Future<SaveResult> save({
    required String name,
    String? notes,
    LandPrice? price,
  }) async {
    _notesDebouncer.cancel(); // save() writes the notes itself
    final current = state.value;
    if (current == null || current.saving) return SaveResult.failed;
    final trimmed = name.trim();
    if (trimmed.isEmpty) return SaveResult.invalidName;
    final cleanName = trimmed.length > maxNameLength
        ? trimmed.substring(0, maxNameLength)
        : trimmed;
    var cleanNotes = notes?.trim();
    if (cleanNotes != null && cleanNotes.isEmpty) cleanNotes = null;
    if (cleanNotes != null && cleanNotes.length > maxNotesLength) {
      cleanNotes = cleanNotes.substring(0, maxNotesLength);
    }

    final m = current.measurement;
    state = AsyncData(current.copyWith(saving: true));
    try {
      if (m.status != MeasurementStatus.saved) {
        final gate = ref.read(featureGateProvider);
        final rewarded =
            ref
                .read(sharedPreferencesProvider)
                .getBool(PremiumFlows.projectUnlockKey(m.id)) ??
            false;
        if (!rewarded && !gate.canSaveNew(await _repo.countSaved())) {
          _done(current);
          return SaveResult.limitReached;
        }
      }
      final validPrice = (price?.price ?? 0) > 0 && m.stats.areaM2 != null;
      await _repo.markSaved(
        m.id,
        name: cleanName,
        notes: cleanNotes,
        unitPrice: validPrice ? price!.price : null,
        unitPriceCurrency: validPrice ? price!.currency : null,
        unitPriceArea: validPrice ? price!.unit : null,
      );
    } on AppException catch (e, st) {
      Log.e('Save failed', e, st);
      _done(current);
      return SaveResult.failed;
    }

    await _saveThumbnail(m);
    await ref.read(settingsRepositoryProvider).incrementSavesCount();
    // TODO(phase-10): analytics measurement_saved{…}.
    _done(current);
    return SaveResult.saved;
  }

  void _done(SaveState previous) {
    if (ref.mounted) state = AsyncData(previous.copyWith(saving: false));
  }

  /// Snapshot from the measure screen, else a drawn one. Never throws.
  Future<void> _saveThumbnail(Measurement m) async {
    final storage = ref.read(thumbnailStorageProvider);
    try {
      final snapshot = ref.read(pendingThumbnailsProvider).take(m.id);
      final path = snapshot != null
          ? await storage.saveSnapshot(m.id, snapshot)
          : await storage.renderFallback(m);
      await _repo.updateMeta(m.id, thumbnailPath: Value(path));
    } on Object catch (e, st) {
      Log.w('Thumbnail not saved for ${m.id}', e, st);
    }
  }
}
