import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';
import 'package:gps_measurement/domain/models/photo.dart';
import 'package:gps_measurement/features/photos/photo_actions.dart';
import 'package:gps_measurement/features/save/save_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_controller.freezed.dart';
part 'edit_controller.g.dart';

@freezed
abstract class EditState with _$EditState {
  const factory EditState({
    /// As loaded; never changed by editing.
    required Measurement original,
    required String name,
    required String notes,

    /// Photos added during this edit (already stored; deleted on discard).
    @Default(<String>{}) Set<String> addedPhotoIds,

    /// Photos the user removed (still stored; deleted on Save Changes).
    @Default(<String, Photo>{}) Map<String, Photo> removedPhotos,
    @Default(false) bool saving,
  }) = _EditState;

  const EditState._();

  bool get nameValid => name.trim().isNotEmpty;

  bool get detailsChanged =>
      name.trim() != (original.name ?? '').trim() ||
      notes.trim() != (original.notes ?? '').trim() ||
      addedPhotoIds.isNotEmpty ||
      removedPhotos.isNotEmpty;
}

/// A missing measurement stays missing: show the error, don't retry.
Duration? _noRetry(int retryCount, Object error) => null;

/// Edit Measurement (`plan.md` P7-08). Details (name, notes, photos) are
/// held here; geometry (Area/Distance) is edited by
/// `MeasureSessionController(editing: true)` on a copy. Nothing touches the
/// saved record until [saveChanges]; [discard] undoes the photo imports.
@Riverpod(retry: _noRetry)
class EditController extends _$EditController {
  late MeasurementRepository _repo;

  @override
  Future<EditState> build(String measurementId) async {
    _repo = ref.watch(measurementRepositoryProvider);
    final m = await _repo.get(measurementId);
    if (m == null) {
      throw StorageException('Measurement $measurementId not found');
    }
    return EditState(original: m, name: m.name ?? '', notes: m.notes ?? '');
  }

  EditState get _s => state.requireValue;

  void setName(String name) => state = AsyncData(_s.copyWith(name: name));

  void setNotes(String notes) => state = AsyncData(_s.copyWith(notes: notes));

  void photosAdded(Iterable<Photo> photos) => state = AsyncData(
    _s.copyWith(
      addedPhotoIds: {..._s.addedPhotoIds, ...photos.map((p) => p.id)},
    ),
  );

  /// Hidden now, deleted on Save Changes.
  void removePhoto(Photo photo) => state = AsyncData(
    _s.copyWith(removedPhotos: {..._s.removedPhotos, photo.id: photo}),
  );

  void undoRemovePhoto(Photo photo) => state = AsyncData(
    _s.copyWith(
      removedPhotos: {..._s.removedPhotos}..remove(photo.id),
    ),
  );

  /// Visible photos: stored ones minus those removed in this edit.
  List<Photo> visible(List<Photo> stored) => [
    for (final p in stored)
      if (!_s.removedPhotos.containsKey(p.id)) p,
  ];

  /// One transaction for name, notes and (when [points] is given)
  /// geometry; then removed photos are deleted and the thumbnail redrawn
  /// ([snapshot] from the live map, else painted). False on failure.
  Future<bool> saveChanges({
    List<MeasurePoint>? points,
    MeasurementStats? stats,
    Uint8List? snapshot,
  }) async {
    final s = _s;
    if (s.saving || !s.nameValid) return false;
    state = AsyncData(s.copyWith(saving: true));
    final id = s.original.id;
    var name = s.name.trim();
    if (name.length > SaveController.maxNameLength) {
      name = name.substring(0, SaveController.maxNameLength);
    }
    var notes = s.notes.trim();
    if (notes.length > SaveController.maxNotesLength) {
      notes = notes.substring(0, SaveController.maxNotesLength);
    }
    try {
      await _repo.saveEdit(
        id,
        name: name,
        notes: notes.isEmpty ? null : notes,
        points: points,
        stats: stats,
      );
    } on AppException catch (e, st) {
      Log.e('Save changes failed', e, st);
      if (ref.mounted) state = AsyncData(s.copyWith(saving: false));
      return false;
    }

    final photos = ref.read(photoActionsProvider);
    for (final photo in s.removedPhotos.values) {
      try {
        await photos.removeNow(photo);
      } on AppException catch (e) {
        Log.w('Photo ${photo.id} left for the orphan cleaner', e);
      }
    }
    if (points != null) await _redrawThumbnail(id, snapshot);
    // TODO(phase-10): analytics measurement_edited{mode, geometry_changed}.
    if (ref.mounted) {
      state = AsyncData(
        s.copyWith(saving: false, addedPhotoIds: {}, removedPhotos: {}),
      );
    }
    return true;
  }

  Future<void> _redrawThumbnail(String id, Uint8List? snapshot) async {
    final thumbs = ref.read(thumbnailStorageProvider);
    try {
      final String path;
      if (snapshot != null) {
        path = await thumbs.saveSnapshot(id, snapshot);
      } else {
        final m = await _repo.get(id);
        if (m == null) return;
        path = await thumbs.renderFallback(m);
      }
      await _repo.updateMeta(id, thumbnailPath: Value(path), touch: false);
    } on Object catch (e, st) {
      Log.w('Thumbnail not redrawn for $id', e, st);
    }
  }

  /// Leaving without saving: photos imported during this edit are deleted;
  /// everything else was never written.
  Future<void> discard() async {
    final s = state.value;
    if (s == null) return;
    final stored = await ref
        .read(photoRepositoryProvider)
        .watchForMeasurement(s.original.id)
        .first;
    final photos = ref.read(photoActionsProvider);
    for (final p in stored) {
      if (s.addedPhotoIds.contains(p.id)) {
        try {
          await photos.removeNow(p);
        } on AppException catch (e) {
          Log.w('Discarded photo ${p.id} left for the orphan cleaner', e);
        }
      }
    }
  }
}
