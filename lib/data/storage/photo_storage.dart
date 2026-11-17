import 'dart:io';

import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/core/utils/id_generator.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/data/storage/app_directories.dart';
import 'package:gps_measurement/data/storage/image_compressor.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/photo.dart';
import 'package:image_picker/image_picker.dart' show XFile;

/// Owns photo files on disk (`architecture.md` §5.4). The ONLY class that
/// deletes photo files.
///
/// ```text
/// photos/<measurementId>/<photoId>.jpg    ≤ 2048 px long edge, q82
/// photos/<measurementId>/<photoId>_t.jpg  320 px, q70
/// ```
/// Gallery photos are always COPIED; the user's original is never touched.
class PhotoStorage {
  PhotoStorage({
    required AppDirectories directories,
    ImageCompressor compressor = const NativeImageCompressor(),
    IdGenerator ids = const IdGenerator(),
    Clock clock = const Clock(),
  }) : _dirs = directories,
       _compressor = compressor,
       _ids = ids,
       _clock = clock;

  final AppDirectories _dirs;
  final ImageCompressor _compressor;
  final IdGenerator _ids;
  final Clock _clock;

  static const int maxEdge = 2048;
  static const int quality = 82;
  static const int thumbEdge = 320;
  static const int thumbQuality = 70;

  /// Imports a camera capture, then deletes the picker's temporary file.
  Future<Photo> importFromCamera(
    XFile file,
    String measurementId, {
    String? pointId,
    GeoPoint? location,
  }) async {
    final photo = await _import(
      file,
      measurementId,
      source: PhotoSource.camera,
      takenAt: _clock.nowUtc(),
      pointId: pointId,
      location: location,
    );
    await _deleteQuietly(File(file.path));
    return photo;
  }

  /// Imports a gallery pick (copy — the original stays).
  Future<Photo> importFromGallery(
    XFile file,
    String measurementId, {
    String? pointId,
    GeoPoint? location,
  }) async {
    DateTime takenAt;
    try {
      takenAt = (await file.lastModified()).toUtc();
    } on Object {
      takenAt = _clock.nowUtc();
    }
    return _import(
      file,
      measurementId,
      source: PhotoSource.gallery,
      takenAt: takenAt,
      pointId: pointId,
      location: location,
    );
  }

  Future<Photo> _import(
    XFile file,
    String measurementId, {
    required PhotoSource source,
    required DateTime takenAt,
    String? pointId,
    GeoPoint? location,
  }) async {
    final id = _ids.newId();
    final folder = '${AppDirectories.photosFolder}/$measurementId';
    final filePath = '$folder/$id.jpg';
    final thumbPath = '$folder/${id}_t.jpg';
    final full = _dirs.resolve(filePath);
    final thumb = _dirs.resolve(thumbPath);
    try {
      await full.parent.create(recursive: true);
      final image = await _compressor.compress(
        file.path,
        maxEdge: maxEdge,
        quality: quality,
      );
      await full.writeAsBytes(image.bytes, flush: true);
      final small = await _compressor.compress(
        file.path,
        maxEdge: thumbEdge,
        quality: thumbQuality,
      );
      await thumb.writeAsBytes(small.bytes, flush: true);

      return Photo(
        id: id,
        measurementId: measurementId,
        pointId: pointId,
        filePath: filePath,
        thumbPath: thumbPath,
        takenAt: takenAt,
        lat: location?.lat,
        lng: location?.lng,
        source: source,
        width: image.width,
        height: image.height,
        bytes: image.bytes.length,
        sortIndex: 0, // assigned by PhotoRepository.add
      );
    } on Object catch (e, st) {
      await _deleteQuietly(full);
      await _deleteQuietly(thumb);
      if (e is AppException) rethrow;
      throw StorageException('Photo import failed', cause: e, stackTrace: st);
    }
  }

  /// Drops a camera capture the user chose not to attach (picker temp
  /// file; never a gallery original).
  Future<void> discardCapture(XFile file) => _deleteQuietly(File(file.path));

  Future<void> delete(Photo photo) async {
    await _deleteQuietly(_dirs.resolve(photo.filePath));
    await _deleteQuietly(_dirs.resolve(photo.thumbPath));
  }

  /// Removes the measurement's whole photo folder.
  Future<void> deleteForMeasurement(String measurementId) async {
    final dir = Directory(
      _dirs.resolve('${AppDirectories.photosFolder}/$measurementId').path,
    );
    try {
      if (dir.existsSync()) await dir.delete(recursive: true);
    } on FileSystemException catch (e, st) {
      throw StorageException(
        'Could not delete photos of $measurementId',
        cause: e,
        stackTrace: st,
      );
    }
  }

  File resolve(String relativePath) => _dirs.resolve(relativePath);

  static Future<void> _deleteQuietly(File file) async {
    try {
      if (file.existsSync()) await file.delete();
    } on FileSystemException catch (e) {
      Log.w('Could not delete ${file.path}', e);
    }
  }
}
