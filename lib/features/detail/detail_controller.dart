import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/data/repositories/measurement_repository.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:gps_measurement/features/save/land_value_field.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'detail_controller.g.dart';

/// Measurement Detail / Full map (`design.md` §5.8): the live record
/// (points, photos) — null once deleted — plus display-only changes.
@riverpod
class DetailController extends _$DetailController {
  late MeasurementRepository _repo;

  @override
  Stream<Measurement?> build(String measurementId) {
    _repo = ref.watch(measurementRepositoryProvider);
    return _repo.watch(measurementId);
  }

  // Display preferences: saved, but they must not reorder the lists.
  Future<void> setAreaUnit(AreaUnit unit) => _repo.updateMeta(
    measurementId,
    displayAreaUnit: Value(unit),
    touch: false,
  );

  Future<void> setDistanceUnit(DistanceUnit unit) => _repo.updateMeta(
    measurementId,
    displayDistanceUnit: Value(unit),
    touch: false,
  );

  /// Empty → cleared.
  Future<void> setNotes(String notes) {
    final trimmed = notes.trim();
    return _repo.updateMeta(
      measurementId,
      notes: Value(trimmed.isEmpty ? null : trimmed),
    );
  }

  /// Null removes the land value.
  Future<void> setLandValue(LandPrice? price) {
    final set = price != null && (price.price ?? 0) > 0;
    return _repo.updateMeta(
      measurementId,
      unitPrice: Value(set ? price.price : null),
      unitPriceCurrency: Value(set ? price.currency : null),
      unitPriceArea: Value(set ? price.unit : null),
    );
  }

  Future<void> setMapStyle(MapStyle style) =>
      _repo.updateMeta(measurementId, mapStyle: Value(style), touch: false);
}
