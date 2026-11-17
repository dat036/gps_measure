import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

/// Receives warning/error logs in release builds.
typedef LogSink =
    void Function(
      LogLevel level,
      String message,
      Object? error,
      StackTrace? stackTrace,
    );

/// App logger. Debug builds print everything; release builds only keep
/// warnings/errors and forward them to [sink].
abstract final class Log {
  static LogSink? sink;

  static void d(String message) => _log(LogLevel.debug, message);

  static void i(String message) => _log(LogLevel.info, message);

  static void w(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.warning, message, error, stackTrace);

  static void e(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.error, message, error, stackTrace);

  static void _log(
    LogLevel level,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    final important = level.index >= LogLevel.warning.index;
    if (kReleaseMode && !important) return;
    if (kReleaseMode) {
      // Device-console diagnostics also work before Firebase is configured.
      debugPrint(
        'LM/${level.name}: $message${error == null ? '' : ' ($error)'}',
      );
    } else {
      developer.log(
        message,
        name: 'LM/${level.name}',
        level: switch (level) {
          LogLevel.debug => 500,
          LogLevel.info => 800,
          LogLevel.warning => 900,
          LogLevel.error => 1000,
        },
        error: error,
        stackTrace: stackTrace,
      );
    }
    if (important) sink?.call(level, message, error, stackTrace);
  }
}
