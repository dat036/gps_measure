import 'package:intl/intl.dart';

/// Land value amounts. Vietnamese + VND uses the words buyers use:
/// `1,87 tỷ`, `350 triệu`; other locales use intl compact currency.
abstract final class MoneyFormatter {
  static const double _billion = 1000000000;
  static const double _million = 1000000;

  static String format(
    double amount, {
    required String locale,
    String currency = 'VND',
  }) {
    final isVi = locale.toLowerCase().startsWith('vi');
    if (isVi && currency.toUpperCase() == 'VND') return _vnd(amount, locale);
    return NumberFormat.compactSimpleCurrency(
      locale: locale,
      name: currency,
    ).format(amount);
  }

  /// A typed price: "50.000.000" (vi), "50,000,000" or "1250.5" (en),
  /// spaces ignored. Null when not a number.
  static double? parse(String text, {required String locale}) {
    final t = text.replaceAll(RegExp(r'\s'), '');
    if (t.isEmpty) return null;
    try {
      return NumberFormat.decimalPattern(locale).parse(t).toDouble();
    } on FormatException {
      final digits = t.replaceAll(RegExp('[^0-9]'), '');
      return digits.isEmpty ? null : double.parse(digits);
    }
  }

  /// A price as typed back into a field ("50.000.000" in vi).
  static String input(double amount, {required String locale}) {
    final f = NumberFormat.decimalPattern(locale)
      ..minimumFractionDigits = 0
      ..maximumFractionDigits = 2;
    return f.format(amount);
  }

  static String _vnd(double amount, String locale) {
    final abs = amount.abs();
    if (abs >= _billion) return '${_trim(amount / _billion, 2, locale)} tỷ';
    if (abs >= _million) return '${_trim(amount / _million, 1, locale)} triệu';
    return '${NumberFormat.decimalPattern(locale).format(amount.round())} đ';
  }

  /// Up to [maxDecimals], trailing zeros dropped ("2 tỷ", "1,87 tỷ").
  static String _trim(double value, int maxDecimals, String locale) {
    final f = NumberFormat.decimalPattern(locale)
      ..minimumFractionDigits = 0
      ..maximumFractionDigits = maxDecimals;
    return f.format(value);
  }
}
