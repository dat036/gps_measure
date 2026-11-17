import 'dart:async';

import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/photo_repository.dart';
import 'package:gps_measurement/data/storage/photo_storage.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/photo.dart';
import 'package:gps_measurement/domain/premium/feature_gate.dart';
import 'package:gps_measurement/features/premium/feature_gate_provider.dart';
import 'package:image_picker/image_picker.dart' show XFile;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'photo_actions.g.dart';

/// Photos of a measurement, in strip order; re-emits on any change.
@riverpod
Stream<List<Photo>> measurementPhotos(Ref ref, String measurementId) =>
    ref.watch(photoRepositoryProvider).watchForMeasurement(measurementId);

/// Number of photo imports running (the strip shows a spinner tile).
@Riverpod(keepAlive: true)
class PhotoImports extends _$PhotoImports {
  @override
  int build() => 0;

  void started() => state++;

  void finished() => state = state > 0 ? state - 1 : 0;
}

/// Adding and removing site photos (`plan.md` P7-01, P7-03). Files go
/// through [PhotoStorage] (the only class deleting photo files), rows
/// through [PhotoRepository].
class PhotoActions {
  PhotoActions({
    required PhotoRepository repository,
    required PhotoStorage storage,
    required FeatureGate gate,
    required PhotoImports imports,
    this.undoWindow = defaultUndoWindow,
  }) : _repo = repository,
       _storage = storage,
       _gate = gate,
       _imports = imports;

  final PhotoRepository _repo;
  final PhotoStorage _storage;
  final FeatureGate _gate;
  final PhotoImports _imports;

  /// How long a removed photo can be restored before its files go.
  static const Duration defaultUndoWindow = Duration(seconds: 5);
  final Duration undoWindow;

  final Map<String, Timer> _pendingDeletes = {};

  /// Photos that may still be added (null = unlimited).
  Future<int?> remaining(String measurementId) async {
    if (_gate.isPremium) return null;
    final left = _gate.config.freeMaxPhotos - await _repo.count(measurementId);
    return left < 0 ? 0 : left;
  }

  Future<Photo> addFromCamera(
    XFile file,
    String measurementId, {
    String? pointId,
    GeoPoint? location,
  }) => _import(
    () => _storage.importFromCamera(
      file,
      measurementId,
      pointId: pointId,
      location: location,
    ),
  );

  /// Imports in order; stops at the first failure (earlier ones are kept).
  Future<List<Photo>> addFromGallery(
    List<XFile> files,
    String measurementId, {
    String? pointId,
    GeoPoint? location,
  }) async {
    final added = <Photo>[];
    for (final f in files) {
      added.add(
        await _import(
          () => _storage.importFromGallery(
            f,
            measurementId,
            pointId: pointId,
            location: location,
          ),
        ),
      );
    }
    return added;
  }

  // TODO(phase-10): analytics photo_added{mode, source, attached_to_point}.
  Future<Photo> _import(Future<Photo> Function() importFile) async {
    _imports.started();
    try {
      final photo = await importFile();
      try {
        return await _repo.add(photo);
      } on AppException {
        await _storage.delete(photo);
        rethrow;
      }
    } finally {
      _imports.finished();
    }
  }

  /// Removes at once but keeps the files for [undoWindow] ([undoRemove]).
  Future<void> removeWithUndo(Photo photo) async {
    await _repo.removeRow(photo);
    _pendingDeletes.remove(photo.id)?.cancel();
    _pendingDeletes[photo.id] = Timer(undoWindow, () {
      _pendingDeletes.remove(photo.id);
      unawaited(_storage.delete(photo));
    });
  }

  Future<void> undoRemove(Photo photo) async {
    _pendingDeletes.remove(photo.id)?.cancel();
    await _repo.restore(photo);
  }

  /// Removes row and files now (Detail, after a confirm dialog).
  Future<void> removeNow(Photo photo) => _repo.remove(photo);
}

@Riverpod(keepAlive: true)
PhotoActions photoActions(Ref ref) => PhotoActions(
  repository: ref.watch(photoRepositoryProvider),
  storage: ref.watch(photoStorageProvider),
  gate: ref.watch(featureGateProvider),
  imports: ref.watch(photoImportsProvider.notifier),
);
