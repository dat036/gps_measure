import 'package:gps_measurement/core/format/unit_formatter.dart';
import 'package:gps_measurement/domain/models/enums.dart';

/// The one number shown for a measurement in lists and cards: area for
/// Area (and for a closed Walk), distance otherwise. Null when there is no
/// result yet.
abstract final class MeasurementValue {
  static String? primary({
    required MeasurementType type,
    required double? areaM2,
    required double? distanceM,
    required AreaUnit areaUnit,
    required DistanceUnit distanceUnit,
    required String locale,
  }) {
    final area = areaM2;
    final distance = distanceM;
    return switch (type) {
      MeasurementType.area when area != null => UnitFormatter.area(
        area,
        areaUnit,
        locale,
      ),
      MeasurementType.walk when area != null => UnitFormatter.area(
        area,
        areaUnit,
        locale,
      ),
      MeasurementType.distance ||
      MeasurementType.walk when distance != null => UnitFormatter.distance(
        distance,
        distanceUnit,
        locale,
      ),
      _ => null,
    };
  }
}
