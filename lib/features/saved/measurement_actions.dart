import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'measurement_actions.g.dart';

/// Rename / delete / discard, shared by Home, Saved and Detail so widgets
/// never touch the repository (`architecture.md` §2 rule 2). Each returns
/// false when the write failed (the caller shows a message).
class MeasurementActions {
  const MeasurementActions(this._repository);

  final MeasurementRepository _repository;

  Future<bool> rename(String id, String name) =>
      _run('rename', () => _repository.updateMeta(id, name: Value(name)));

  /// Deletes a saved measurement or discards a draft (DB rows, photos,
  /// thumbnail).
  // TODO(phase-10): analytics measurement_deleted / draft_discarded.
  Future<bool> delete(String id) =>
      _run('delete', () => _repository.delete(id));

  Future<bool> _run(String op, Future<void> Function() body) async {
    try {
      await body();
      return true;
    } on AppException catch (e, st) {
      Log.e('MeasurementActions.$op failed', e, st);
      return false;
    }
  }
}

@Riverpod(keepAlive: true)
MeasurementActions measurementActions(Ref ref) =>
    MeasurementActions(ref.watch(measurementRepositoryProvider));
