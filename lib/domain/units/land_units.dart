import 'package:gps_measurement/domain/models/enums.dart';

/// Size of each area unit in m² (`architecture.md` §7.6).
extension AreaUnitSize on AreaUnit {
  double get squareMeters => switch (this) {
    AreaUnit.squareMeter => 1,
    AreaUnit.hectare => 10000,
    AreaUnit.acre => 4046.8564224,
    AreaUnit.squareFoot => 0.09290304,
  };

  bool get isImperial => this == AreaUnit.acre || this == AreaUnit.squareFoot;
}

/// Size of each distance unit in meters.
extension DistanceUnitSize on DistanceUnit {
  double get meters => switch (this) {
    DistanceUnit.meter => 1,
    DistanceUnit.kilometer => 1000,
    DistanceUnit.foot => 0.3048,
    DistanceUnit.mile => 1609.344,
  };

  bool get isImperial => this == DistanceUnit.foot || this == DistanceUnit.mile;
}
