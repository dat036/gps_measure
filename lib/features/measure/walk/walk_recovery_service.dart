import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'walk_recovery_service.g.dart';

/// Start-up step 7 (`architecture.md` §9): a walk still marked `recording`
/// means the app was killed mid-walk. Nothing records it anymore, so it
/// becomes `paused` with its points and last saved elapsed time; the user
/// resumes it from the draft.
class WalkRecoveryService {
  const WalkRecoveryService(this._repository);

  final MeasurementRepository _repository;

  /// Returns the recovered walk ids. Never throws: start-up must go on.
  Future<List<String>> check() async {
    try {
      final ids = await _repository.pauseInterruptedWalks();
      // TODO(phase-10): analytics walk_recovered{state: paused}.
      if (ids.isNotEmpty) Log.i('Recovered interrupted walks: $ids');
      return ids;
    } on AppException catch (e, st) {
      Log.e('Walk recovery failed', e, st);
      return const [];
    }
  }
}

@Riverpod(keepAlive: true)
WalkRecoveryService walkRecoveryService(Ref ref) =>
    WalkRecoveryService(ref.watch(measurementRepositoryProvider));
