import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gps_measurement/core/utils/debouncer.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measurement_summary.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saved_controller.freezed.dart';
part 'saved_controller.g.dart';

@freezed
abstract class SavedFilter with _$SavedFilter {
  const factory SavedFilter({
    /// Search field shown in place of the header.
    @Default(false) bool searching,

    /// Applied (debounced) query.
    @Default('') String query,

    /// Type chip; null = All.
    MeasurementType? type,
    @Default(true) bool draftsExpanded,
  }) = _SavedFilter;
}

/// Saved tab filters (`design.md` §5.7). The lists themselves are Drift
/// streams ([savedList], [draftList], [savedCounts]) so they update as soon
/// as anything is saved, renamed or deleted.
@riverpod
class SavedController extends _$SavedController {
  static const Duration searchDebounce = Duration(milliseconds: 200);

  final Debouncer _debouncer = Debouncer(searchDebounce);

  @override
  SavedFilter build() {
    ref.onDispose(_debouncer.dispose);
    return const SavedFilter();
  }

  void openSearch() => state = state.copyWith(searching: true);

  void closeSearch() {
    _debouncer.cancel();
    state = state.copyWith(searching: false, query: '');
  }

  /// Typed text; applied 200 ms after the last keystroke.
  void setQuery(String text) =>
      _debouncer.run(() => state = state.copyWith(query: text.trim()));

  void setType(MeasurementType? type) => state = state.copyWith(type: type);

  void toggleDrafts() =>
      state = state.copyWith(draftsExpanded: !state.draftsExpanded);
}

/// Saved measurements matching the filter, newest first.
@riverpod
Stream<List<MeasurementSummary>> savedList(Ref ref) {
  final filter = ref.watch(savedControllerProvider);
  return ref
      .watch(measurementRepositoryProvider)
      .watchSaved(
        type: filter.type,
        query: filter.query.isEmpty ? null : filter.query,
      );
}

/// Saved counts per type for the chips.
@riverpod
Stream<Map<MeasurementType, int>> savedCounts(Ref ref) =>
    ref.watch(measurementRepositoryProvider).watchCountByType();

/// Drafts and finished-not-saved walks, newest first (Saved drafts
/// section, Home "Continue Measurement").
@riverpod
Stream<List<MeasurementSummary>> draftList(Ref ref) =>
    ref.watch(measurementRepositoryProvider).watchDrafts();
