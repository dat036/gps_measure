import 'dart:io';

import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/data/db/app_database.dart';
import 'package:gps_measurement/data/repositories/settings_repository.dart';
import 'package:gps_measurement/data/storage/app_directories.dart';
import 'package:path/path.dart' as p;

/// Removes files no DB row points to (crash mid-import, failed delete…).
/// Runs at most every [interval]; files younger than [minAge] are skipped so
/// an import in progress is never touched.
class OrphanFileCleaner {
  OrphanFileCleaner({
    required AppDatabase db,
    required AppDirectories directories,
    required SettingsRepository settings,
    Clock clock = const Clock(),
  }) : _db = db,
       _dirs = directories,
       _settings = settings,
       _clock = clock;

  final AppDatabase _db;
  final AppDirectories _dirs;
  final SettingsRepository _settings;
  final Clock _clock;

  static const Duration interval = Duration(days: 7);
  static const Duration minAge = Duration(hours: 1);

  /// Returns the number of deleted files/folders, or null if not due.
  Future<int?> runIfDue() async {
    final last = _settings.lastOrphanCleanupAt;
    final now = _clock.nowUtc();
    if (last != null && now.difference(last) < interval) return null;
    final deleted = await run();
    await _settings.setLastOrphanCleanupAt(now);
    return deleted;
  }

  Future<int> run() async {
    final ids = (await _db.measurementDao.allIds()).toSet();
    final photoFiles = await _db.photoDao.allFilePaths();
    var deleted = 0;

    final photosDir = _dirs.photos;
    if (photosDir.existsSync()) {
      for (final entity in photosDir.listSync()) {
        final name = p.basename(entity.path);
        if (entity is Directory && !ids.contains(name)) {
          if (_allOldEnough(entity) && await _delete(entity)) deleted++;
          continue;
        }
        if (entity is! Directory) continue;
        for (final file in entity.listSync().whereType<File>()) {
          final rel =
              '${AppDirectories.photosFolder}/$name/${p.basename(file.path)}';
          if (!photoFiles.contains(rel) &&
              _oldEnough(file) &&
              await _delete(file)) {
            deleted++;
          }
        }
      }
    }

    final thumbsDir = _dirs.thumbs;
    if (thumbsDir.existsSync()) {
      for (final file in thumbsDir.listSync().whereType<File>()) {
        final id = p.basenameWithoutExtension(file.path);
        if (!ids.contains(id) && _oldEnough(file) && await _delete(file)) {
          deleted++;
        }
      }
    }
    if (deleted > 0) Log.i('OrphanFileCleaner removed $deleted item(s)');
    return deleted;
  }

  /// Share-sheet exports are temporary: wiped on every start.
  Future<void> clearExports() async {
    final dir = _dirs.exports;
    if (dir.existsSync()) await _delete(dir);
  }

  /// A folder's own mtime changes whenever its content does, so judge an
  /// orphan folder by its files (empty folder: by itself).
  bool _allOldEnough(Directory dir) {
    final files = dir.listSync(recursive: true).whereType<File>().toList();
    return files.isEmpty ? _oldEnough(dir) : files.every(_oldEnough);
  }

  bool _oldEnough(FileSystemEntity e) {
    final modified = e.statSync().modified.toUtc();
    return _clock.nowUtc().difference(modified) >= minAge;
  }

  static Future<bool> _delete(FileSystemEntity e) async {
    try {
      await e.delete(recursive: true);
      return true;
    } on FileSystemException catch (err) {
      Log.w('Could not delete ${e.path}', err);
      return false;
    }
  }
}
