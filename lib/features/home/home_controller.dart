import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measurement_summary.dart';
import 'package:gps_measurement/features/settings/settings_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.g.dart';

/// Mode selected on the Home hero card; starts at the "Default
/// Measurement Type" setting.
@riverpod
class HomeController extends _$HomeController {
  @override
  MeasurementType build() =>
      ref.watch(settingsProvider.select((s) => s.defaultMode));

  // TODO(phase-10): analytics mode_selected{mode}.
  // An action (not a setter): it gains the analytics call in Phase 10.
  // ignore: use_setters_to_change_properties
  void select(MeasurementType mode) => state = mode;
}

/// Home recent list size (`design.md` §5.1).
const int homeRecentCount = 3;

/// Latest saved measurements for Home.
@riverpod
Stream<List<MeasurementSummary>> recentList(Ref ref) =>
    ref.watch(measurementRepositoryProvider).watchRecent(homeRecentCount);
