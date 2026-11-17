import 'package:intl/intl.dart';

/// Default measurement name (`plan.md` P6-01): "Area · Sep 28" (en) /
/// "Diện tích · 28/09" (vi); a name already used gets " (2)", " (3)"…
abstract final class NameSuggester {
  static const String separator = ' · ';

  /// Base name for [typeLabel] on [date] (local day).
  static String base({
    required String typeLabel,
    required DateTime date,
    required String locale,
  }) {
    final lang = locale.split(RegExp('[-_]')).first.toLowerCase();
    final pattern = lang == 'vi' ? 'dd/MM' : 'MMM d';
    final day = DateFormat(pattern, locale).format(date.toLocal());
    return '$typeLabel$separator$day';
  }

  /// [base] or, if taken, the first free "base (n)" with n ≥ 2.
  static String suggest({
    required String typeLabel,
    required DateTime date,
    required String locale,
    required Iterable<String> existingNames,
  }) {
    final name = base(typeLabel: typeLabel, date: date, locale: locale);
    final taken = existingNames.toSet();
    if (!taken.contains(name)) return name;
    var n = 2;
    while (taken.contains('$name ($n)')) {
      n++;
    }
    return '$name ($n)';
  }
}
