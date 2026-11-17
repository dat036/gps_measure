import 'dart:async';
import 'dart:ui' show VoidCallback;

/// Runs at most once per [interval]: the first call immediately, and the
/// latest call made during the interval once it ends (so the final value of
/// a drag is never lost).
class Throttler {
  Throttler(this.interval);

  final Duration interval;
  Timer? _timer;
  VoidCallback? _trailing;

  void run(VoidCallback action) {
    if (_timer == null) {
      action();
      _timer = Timer(interval, _onTick);
    } else {
      _trailing = action;
    }
  }

  void _onTick() {
    final action = _trailing;
    _trailing = null;
    if (action == null) {
      _timer = null;
      return;
    }
    action();
    _timer = Timer(interval, _onTick);
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
    _trailing = null;
  }

  void dispose() => cancel();
}
