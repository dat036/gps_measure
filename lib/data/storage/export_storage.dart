import 'dart:convert';
import 'dart:io';

import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/data/db/search_text.dart';
import 'package:gps_measurement/data/storage/app_directories.dart';
import 'package:intl/intl.dart';

/// Export files: `<temporary>/exports/<slug>_<yyyyMMdd_HHmm>.<ext>`
/// (`architecture.md` §5.4), cleared on every start.
class ExportStorage {
  ExportStorage({
    required AppDirectories directories,
    Clock clock = const Clock(),
  }) : _dirs = directories,
       _clock = clock;

  final AppDirectories _dirs;
  final Clock _clock;

  static const int maxSlugLength = 40;

  /// "Ruộng Đông (2)" → `ruong_dong_2`; empty → `measurement`.
  static String slug(String name) {
    final s = foldForSearch(
      name,
    ).replaceAll(RegExp('[^a-z0-9]+'), '_').replaceAll(RegExp(r'^_+|_+$'), '');
    if (s.isEmpty) return 'measurement';
    return s.length > maxSlugLength
        ? s.substring(0, maxSlugLength).replaceAll(RegExp(r'_+$'), '')
        : s;
  }

  /// Writes [content] as UTF-8 bytes exactly (no newline translation).
  Future<File> write(String name, String extension, String content) =>
      writeBytes(name, extension, utf8.encode(content));

  /// Writes binary [bytes] (the PDF report).
  Future<File> writeBytes(
    String name,
    String extension,
    List<int> bytes,
  ) async {
    final stamp = DateFormat('yyyyMMdd_HHmm').format(_clock.now());
    final file = File('${_dirs.exports.path}/${slug(name)}_$stamp.$extension');
    try {
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes, flush: true);
      return file;
    } on FileSystemException catch (e, st) {
      throw ExportException('Export write failed', cause: e, stackTrace: st);
    }
  }
}
