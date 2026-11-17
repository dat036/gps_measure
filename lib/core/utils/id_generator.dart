import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'id_generator.g.dart';

/// Generates entity IDs (UUID v4).
class IdGenerator {
  const IdGenerator();

  static const Uuid _uuid = Uuid();

  String newId() => _uuid.v4();
}

@Riverpod(keepAlive: true)
IdGenerator idGenerator(Ref ref) => const IdGenerator();
