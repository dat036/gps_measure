import 'package:flutter/widgets.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/features/measure/common/measure_screen.dart';

/// Measure Area (`design.md` §5.2).
class AreaMeasureScreen extends StatelessWidget {
  const AreaMeasureScreen({this.draftId, super.key});

  final String? draftId;

  @override
  Widget build(BuildContext context) =>
      MeasureScreen(type: MeasurementType.area, draftId: draftId);
}
