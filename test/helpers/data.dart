import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/core/utils/clock.dart';
import 'package:gps_measurement/core/utils/id_generator.dart';
import 'package:gps_measurement/data/db/app_database.dart';
import 'package:gps_measurement/data/storage/app_directories.dart';
import 'package:gps_measurement/data/storage/image_compressor.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:sqlite3/open.dart';

/// On Windows hosts use the OS-provided SQLite (no sqlite3.dll needed).
/// Linux CI needs `libsqlite3-dev`.
void useHostSqlite() {
  if (Platform.isWindows) {
    open.overrideFor(
      OperatingSystem.windows,
      () => DynamicLibrary.open('winsqlite3.dll'),
    );
  }
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
}

AppDatabase newTestDatabase() {
  useHostSqlite();
  return AppDatabase(NativeDatabase.memory());
}

/// Temp documents/temporary directories, deleted by [dispose].
class TempDirectories {
  TempDirectories()
    : _root = Directory.systemTemp.createTempSync('landmeasure_test_');

  final Directory _root;

  late final AppDirectories dirs = AppDirectories(
    documents: Directory('${_root.path}/docs')..createSync(),
    temporary: Directory('${_root.path}/tmp')..createSync(),
  );

  /// All files under documents, as `/`-separated relative paths.
  List<String> files() {
    final base = dirs.documents.path;
    return [
      for (final f in dirs.documents.listSync(recursive: true))
        if (f is File) f.path.substring(base.length + 1).replaceAll(r'\', '/'),
    ]..sort();
  }

  void dispose() {
    if (_root.existsSync()) _root.deleteSync(recursive: true);
  }
}

class SequentialIds extends IdGenerator {
  SequentialIds([this.prefix = 'id']);

  final String prefix;
  int _next = 0;

  @override
  String newId() => '$prefix${_next++}';
}

/// Writes deterministic bytes instead of calling the native plugin.
class FakeCompressor implements ImageCompressor {
  bool fail = false;
  final List<(String, int)> calls = [];

  @override
  Future<CompressedImage> compress(
    String sourcePath, {
    required int maxEdge,
    required int quality,
  }) async {
    calls.add((sourcePath, maxEdge));
    if (fail) throw const StorageException('boom');
    return CompressedImage(
      bytes: Uint8List.fromList(List.filled(maxEdge ~/ 8, quality)),
      width: maxEdge,
      height: maxEdge * 3 ~/ 4,
    );
  }
}

FixedClock testClock() => FixedClock(DateTime.utc(2026, 9, 28, 8));

/// Bare draft (no points) for mocked repositories.
Measurement draftNamed(
  String id, {
  MeasurementType type = MeasurementType.area,
}) => Measurement(
  id: id,
  type: type,
  status: MeasurementStatus.draft,
  mapStyle: MapStyle.satellite,
  createdAt: DateTime.utc(2026, 9, 28),
  updatedAt: DateTime.utc(2026, 9, 28),
);
