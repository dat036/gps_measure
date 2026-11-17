import 'package:flutter/widgets.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/features/measure/common/measure_screen.dart';

/// Measure Distance (`design.md` §5.3).
class DistanceMeasureScreen extends StatelessWidget {
  const DistanceMeasureScreen({this.draftId, super.key});

  final String? draftId;

  @override
  Widget build(BuildContext context) =>
      MeasureScreen(type: MeasurementType.distance, draftId: draftId);
}
