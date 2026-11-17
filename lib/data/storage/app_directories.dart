import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Root directories for app files (`architecture.md` §5.4). The DB stores
/// paths RELATIVE to [documents] because the iOS container path changes
/// between app updates.
class AppDirectories {
  const AppDirectories({required this.documents, required this.temporary});

  static Future<AppDirectories> load() async => AppDirectories(
    documents: await getApplicationDocumentsDirectory(),
    temporary: await getTemporaryDirectory(),
  );

  final Directory documents;
  final Directory temporary;

  static const String photosFolder = 'photos';
  static const String thumbsFolder = 'thumbs';
  static const String exportsFolder = 'exports';

  /// `<documents>/photos`
  Directory get photos => Directory(p.join(documents.path, photosFolder));

  /// `<documents>/thumbs`
  Directory get thumbs => Directory(p.join(documents.path, thumbsFolder));

  /// `<temporary>/exports` — cleared on every start.
  Directory get exports => Directory(p.join(temporary.path, exportsFolder));

  /// Absolute file for a documents-relative path (always `/`-separated).
  File resolve(String relativePath) =>
      File(p.joinAll([documents.path, ...p.posix.split(relativePath)]));
}
