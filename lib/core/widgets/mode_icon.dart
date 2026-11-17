import 'package:flutter/material.dart';
import 'package:gps_measurement/domain/models/enums.dart';

/// Icon of each measuring mode (`design.md` §1.4).
IconData modeIcon(MeasurementType type) => switch (type) {
  MeasurementType.area => Icons.pentagon_outlined,
  MeasurementType.distance => Icons.timeline_rounded,
  MeasurementType.walk => Icons.directions_walk_rounded,
};
