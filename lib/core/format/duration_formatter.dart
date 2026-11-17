/// Walk durations as `HH:MM:SS` (hours may exceed 99).
abstract final class DurationFormatter {
  static String hms(int totalSeconds) {
    final s = totalSeconds < 0 ? 0 : totalSeconds;
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(s ~/ 3600)}:${two(s % 3600 ~/ 60)}:${two(s % 60)}';
  }

  static String fromDuration(Duration d) => hms(d.inSeconds);
}
