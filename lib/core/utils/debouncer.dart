import 'dart:async';
import 'dart:ui' show VoidCallback;

/// Runs the last scheduled action after [duration] of inactivity.
class Debouncer {
  Debouncer(this.duration);

  final Duration duration;
  Timer? _timer;
  VoidCallback? _pending;

  bool get isPending => _pending != null;

  void run(VoidCallback action) {
    _timer?.cancel();
    _pending = action;
    _timer = Timer(duration, flush);
  }

  /// Runs the pending action now (e.g. when the app goes to background).
  void flush() {
    _timer?.cancel();
    _timer = null;
    final action = _pending;
    _pending = null;
    action?.call();
  }

  /// Drops the pending action without running it.
  void cancel() {
    _timer?.cancel();
    _timer = null;
    _pending = null;
  }

  void dispose() => cancel();
}
