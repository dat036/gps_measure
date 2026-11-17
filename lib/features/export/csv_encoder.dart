import 'package:csv/csv.dart';
import 'package:gps_measurement/domain/models/measurement.dart';

/// CSV of one measurement (`plan.md` P8-02): one row per point, the
/// measurement's name/type/stats repeated on every row so each row stands
/// alone in a spreadsheet. UTF-8 with BOM (Excel then reads Vietnamese
/// correctly), CRLF, ISO-8601 UTC times, `.` decimals. A measurement
/// without points still gets one row.
abstract final class CsvEncoder {
  static const List<String> header = [
    'measurement_name',
    'measurement_type',
    'created_at',
    'segment_index',
    'point_index',
    'latitude',
    'longitude',
    'altitude',
    'accuracy',
    'timestamp',
    'area_m2',
    'perimeter_m',
    'distance_m',
    'duration_s',
  ];

  static String encode(Measurement m, {required String name}) {
    final s = m.stats;
    final created = m.createdAt.toUtc().toIso8601String();
    final summary = [
      _num(s.areaM2, 2),
      _num(s.perimeterM, 2),
      _num(s.distanceM, 2),
      s.durationSec?.toString() ?? '',
    ];
    final rows = <List<String>>[
      header,
      if (m.points.isEmpty)
        [name, m.type.name, created, '', '', '', '', '', '', '', ...summary],
      for (final (i, p) in m.points.indexed)
        [
          name,
          m.type.name,
          created,
          '${p.segmentIndex}',
          '$i',
          _num(p.lat, 7),
          _num(p.lng, 7),
          _num(p.altitude, 1),
          _num(p.accuracy, 1),
          p.timestamp.toUtc().toIso8601String(),
          ...summary,
        ],
    ];
    return Csv(addBom: true).encode(rows);
  }

  static String _num(double? v, int decimals) {
    if (v == null) return '';
    final s = v.toStringAsFixed(decimals);
    if (!s.contains('.')) return s;
    var t = s.replaceFirst(RegExp(r'0+$'), '');
    if (t.endsWith('.')) t = t.substring(0, t.length - 1);
    return t;
  }
}
