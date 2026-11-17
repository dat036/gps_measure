import 'package:gps_measurement/core/format/date_formatter.dart';
import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/l10n/gen/app_localizations.dart';

/// Localized labels shared by Home, Saved and Detail.
extension MeasurementLabels on AppLocalizations {
  /// The measurement's name, or "Untitled Area" for an unnamed draft.
  String titleOf(String? name, MeasurementType type) {
    final trimmed = name?.trim();
    if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    return switch (type) {
      MeasurementType.area => untitledArea,
      MeasurementType.distance => untitledDistance,
      MeasurementType.walk => untitledWalk,
    };
  }

  /// "just now", "14 min ago", "3 hours ago", "yesterday", "5 days ago",
  /// then the date.
  String relativeTime(DateTime then, DateTime now, String locale) {
    final d = now.difference(then);
    if (d.inMinutes < 1) return timeJustNow;
    if (d.inHours < 1) return timeMinutesAgo(d.inMinutes);
    if (d.inDays < 1) return timeHoursAgo(d.inHours);
    if (d.inDays < 7) return timeDaysAgo(d.inDays);
    return DateFormatter.date(then, locale);
  }
}
