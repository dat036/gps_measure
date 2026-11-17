import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gps_measurement/domain/models/enums.dart';

/// Premium map styles a free user opened by watching a rewarded ad. Kept in
/// memory only: they stay open until the app is closed.
class UnlockedMapStyles extends Notifier<Set<MapStyle>> {
  @override
  Set<MapStyle> build() => const {};

  void unlock(MapStyle style) => state = {...state, style};
}

final unlockedMapStylesProvider =
    NotifierProvider<UnlockedMapStyles, Set<MapStyle>>(UnlockedMapStyles.new);
