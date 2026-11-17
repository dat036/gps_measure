import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clock.g.dart';

/// Injectable time source so time-dependent logic is testable.
class Clock {
  const Clock();

  DateTime now() => DateTime.now();

  /// Timestamps are stored in UTC (architecture.md §2 rule 6).
  DateTime nowUtc() => now().toUtc();
}

/// Test clock that returns a settable instant.
class FixedClock extends Clock {
  FixedClock(this.current);

  DateTime current;

  @override
  DateTime now() => current;

  void advance(Duration by) => current = current.add(by);
}

@Riverpod(keepAlive: true)
Clock clock(Ref ref) => const Clock();
