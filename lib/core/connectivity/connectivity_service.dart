import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

/// Whether the device has any network. Used for the "map connection
/// unavailable — your points are safe" banner; measuring never depends on
/// it (points are stored locally).
abstract interface class ConnectivityService {
  Future<bool> isOnline();

  /// Emits on every change (not deduplicated).
  Stream<bool> get onlineChanges;
}

class PlusConnectivityService implements ConnectivityService {
  PlusConnectivityService([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  static bool _online(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  @override
  Future<bool> isOnline() async =>
      _online(await _connectivity.checkConnectivity());

  @override
  Stream<bool> get onlineChanges =>
      _connectivity.onConnectivityChanged.map(_online);
}

@Riverpod(keepAlive: true)
ConnectivityService connectivityService(Ref ref) => PlusConnectivityService();

/// Current online state; starts optimistic (true) so no banner flashes.
@riverpod
Stream<bool> isOnline(Ref ref) async* {
  final service = ref.watch(connectivityServiceProvider);
  yield await service.isOnline();
  yield* service.onlineChanges.distinct();
}
