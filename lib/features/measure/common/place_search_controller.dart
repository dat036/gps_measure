import 'dart:ui' show Locale;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gps_measurement/core/connectivity/connectivity_service.dart';
import 'package:gps_measurement/data/providers.dart';
import 'package:gps_measurement/features/measure/common/place_search_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'place_search_controller.freezed.dart';
part 'place_search_controller.g.dart';

enum PlaceSearchStatus {
  idle,
  loading,
  results,
  empty,
  offline,

  /// Online, but the OS geocoder failed (e.g. emulator Play services).
  failed,
  unavailable,
}

@freezed
abstract class PlaceSearchState with _$PlaceSearchState {
  const factory PlaceSearchState({
    @Default(PlaceSearchStatus.idle) PlaceSearchStatus status,
    @Default(<PlaceResult>[]) List<PlaceResult> results,
    @Default(<String>[]) List<String> recent,
  }) = _PlaceSearchState;
}

/// Search sheet logic: runs only on submit (never per keystroke — the OS
/// geocoder is rate limited), remembers the last 5 successful queries.
@riverpod
class PlaceSearchController extends _$PlaceSearchController {
  int _request = 0;

  @override
  PlaceSearchState build() => PlaceSearchState(
    recent: ref.read(settingsRepositoryProvider).recentSearches,
  );

  /// Returns the single exact result (coordinates/link) so the caller can
  /// jump straight to it; otherwise updates the list and returns null.
  Future<PlaceResult?> submit(String input, {Locale? locale}) async {
    final text = input.trim();
    if (text.isEmpty) {
      state = state.copyWith(status: PlaceSearchStatus.idle, results: []);
      return null;
    }
    final request = ++_request;
    state = state.copyWith(status: PlaceSearchStatus.loading, results: []);
    try {
      final results = await ref
          .read(placeSearchServiceProvider)
          .search(text, locale: locale);
      if (request != _request || !ref.mounted) return null;
      if (results.isEmpty) {
        state = state.copyWith(status: PlaceSearchStatus.empty);
        return null;
      }
      await _remember(text);
      if (!ref.mounted) return null;
      state = state.copyWith(
        status: PlaceSearchStatus.results,
        results: results,
      );
      return results.length == 1 && results.single.isExact
          ? results.single
          : null;
    } on PlaceSearchException catch (e) {
      if (request != _request || !ref.mounted) return null;
      var status = switch (e.failure) {
        PlaceSearchFailure.offline => PlaceSearchStatus.offline,
        PlaceSearchFailure.unavailable => PlaceSearchStatus.unavailable,
      };
      // A geocoder error while online is not a network problem.
      if (status == PlaceSearchStatus.offline &&
          await ref.read(connectivityServiceProvider).isOnline()) {
        status = PlaceSearchStatus.failed;
      }
      if (ref.mounted) state = state.copyWith(status: status);
      return null;
    }
  }

  Future<void> clearRecent() async {
    await ref.read(settingsRepositoryProvider).clearRecentSearches();
    if (ref.mounted) state = state.copyWith(recent: const []);
  }

  Future<void> _remember(String query) async {
    final settings = ref.read(settingsRepositoryProvider);
    await settings.addRecentSearch(query);
    if (ref.mounted) state = state.copyWith(recent: settings.recentSearches);
  }
}
