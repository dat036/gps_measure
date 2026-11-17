import 'package:intl/intl.dart';

/// Measurement dates: `Sep 22, 2026 · 10:24` (en) / `22/09/2026 · 10:24`
/// (vi). Values are stored in UTC and shown in local time.
///
/// Needs intl date symbols for the locale — `GlobalMaterialLocalizations`
/// loads them for supported locales; tests call `initializeDateFormatting`.
abstract final class DateFormatter {
  static const String _separator = ' · ';

  static String dateTime(DateTime value, String locale) {
    final local = value.toLocal();
    return '${date(local, locale)}$_separator'
        '${DateFormat('HH:mm', locale).format(local)}';
  }

  static String date(DateTime value, String locale) {
    final local = value.toLocal();
    final lang = locale.split(RegExp('[-_]')).first.toLowerCase();
    return switch (lang) {
      'en' => DateFormat('MMM d, y', locale).format(local),
      'vi' => DateFormat('dd/MM/yyyy', locale).format(local),
      _ => DateFormat.yMMMd(locale).format(local),
    };
  }
}
