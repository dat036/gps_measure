/// Errors thrown by repositories/services. Controllers catch them, move to
/// an error state and report non-fatally — never swallow silently.
sealed class AppException implements Exception {
  const AppException(this.message, {this.cause, this.stackTrace});

  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  /// Short name used in logs.
  String get kind;

  @override
  String toString() {
    final c = cause == null ? '' : ' (cause: $cause)';
    return '$kind: $message$c';
  }
}

/// Database or file system failure.
final class StorageException extends AppException {
  const StorageException(super.message, {super.cause, super.stackTrace});

  @override
  String get kind => 'StorageException';
}

/// GPS unavailable, timed out or service disabled.
final class LocationException extends AppException {
  const LocationException(super.message, {super.cause, super.stackTrace});

  @override
  String get kind => 'LocationException';
}

final class PermissionDeniedException extends AppException {
  const PermissionDeniedException(
    super.message, {
    this.permanently = false,
    super.cause,
    super.stackTrace,
  });

  /// User chose "don't ask again" — only system Settings can grant it now.
  final bool permanently;

  @override
  String get kind => 'PermissionDeniedException';
}

final class ExportException extends AppException {
  const ExportException(super.message, {super.cause, super.stackTrace});

  @override
  String get kind => 'ExportException';
}

final class PurchaseException extends AppException {
  const PurchaseException(
    super.message, {
    this.userCancelled = false,
    super.cause,
    super.stackTrace,
  });

  /// Cancelled purchases are not errors to show (plan P11-02).
  final bool userCancelled;

  @override
  String get kind => 'PurchaseException';
}
