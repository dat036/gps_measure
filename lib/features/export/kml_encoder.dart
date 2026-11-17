import 'package:gps_measurement/domain/models/enums.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:xml/xml.dart';

/// Line / fill colors as ARGB ints (the caller passes the mode's design
/// tokens, so the encoder stays free of Flutter).
typedef KmlColors = ({int line, int fill});

/// KML 2.2 of one measurement (`plan.md` P8-01):
/// Area → Polygon (ring closed by repeating the first point), Distance →
/// LineString, Walk → MultiGeometry of one LineString per segment (+ the
/// Polygon when the loop is closed). Points with photos → "P3" Placemarks.
/// Stats go to `ExtendedData`. Coordinates are `lng,lat,0`.
abstract final class KmlEncoder {
  static const String namespace = 'http://www.opengis.net/kml/2.2';

  static String encode(
    Measurement m, {
    required String name,
    required KmlColors colors,
  }) {
    final b = XmlBuilder()..processing('xml', 'version="1.0" encoding="UTF-8"');
    b.element(
      'kml',
      namespaces: {namespace: null},
      nest: () {
        b.element(
          'Document',
          nest: () {
            b.element('name', nest: name);
            _style(b, colors);
            b.element(
              'Placemark',
              nest: () {
                b.element('name', nest: name);
                final notes = m.notes?.trim();
                if (notes != null && notes.isNotEmpty) {
                  b.element('description', nest: notes);
                }
                b.element('styleUrl', nest: '#measurement');
                _extendedData(b, m);
                _geometry(b, m);
              },
            );
            _photoPoints(b, m);
          },
        );
      },
    );
    return b.buildDocument().toXmlString(pretty: true, indent: '  ');
  }

  /// `aabbggrr`, as KML wants.
  static String kmlColor(int argb) {
    String hex(int v) => v.toRadixString(16).padLeft(2, '0');
    final a = (argb >> 24) & 0xff;
    final r = (argb >> 16) & 0xff;
    final g = (argb >> 8) & 0xff;
    final bl = argb & 0xff;
    return '${hex(a)}${hex(bl)}${hex(g)}${hex(r)}';
  }

  static void _style(XmlBuilder b, KmlColors colors) => b.element(
    'Style',
    attributes: {'id': 'measurement'},
    nest: () {
      b
        ..element(
          'LineStyle',
          nest: () {
            b
              ..element('color', nest: kmlColor(colors.line))
              ..element('width', nest: '3');
          },
        )
        ..element(
          'PolyStyle',
          nest: () => b.element('color', nest: kmlColor(colors.fill)),
        );
    },
  );

  static void _extendedData(XmlBuilder b, Measurement m) {
    final s = m.stats;
    final data = <String, String?>{
      'type': m.type.name,
      'area_m2': _num(s.areaM2),
      'perimeter_m': _num(s.perimeterM),
      'distance_m': _num(s.distanceM),
      'duration_s': s.durationSec?.toString(),
      'created_at': m.createdAt.toUtc().toIso8601String(),
      'notes': m.notes?.trim().isEmpty ?? true ? null : m.notes!.trim(),
    };
    b.element(
      'ExtendedData',
      nest: () {
        for (final e in data.entries) {
          if (e.value == null) continue;
          b.element(
            'Data',
            attributes: {'name': e.key},
            nest: () => b.element('value', nest: e.value),
          );
        }
      },
    );
  }

  static void _geometry(XmlBuilder b, Measurement m) {
    final pts = m.points;
    switch (m.type) {
      case MeasurementType.area when pts.length >= 3:
        _polygon(b, pts);
      case MeasurementType.area || MeasurementType.distance
          when pts.length >= 2:
        _lineString(b, pts);
      case MeasurementType.walk when pts.isNotEmpty:
        final segments = <int, List<MeasurePoint>>{};
        for (final p in pts) {
          (segments[p.segmentIndex] ??= []).add(p);
        }
        b.element(
          'MultiGeometry',
          nest: () {
            for (final segment in segments.values) {
              if (segment.length >= 2) {
                _lineString(b, segment);
              } else {
                _point(b, segment.single);
              }
            }
            if (m.stats.isClosed && pts.length >= 3) _polygon(b, pts);
          },
        );
      case _ when pts.length == 1:
        _point(b, pts.single);
      case _:
        break;
    }
  }

  static void _polygon(XmlBuilder b, List<MeasurePoint> ring) => b.element(
    'Polygon',
    nest: () {
      b
        ..element('tessellate', nest: '1')
        ..element(
          'outerBoundaryIs',
          nest: () => b.element(
            'LinearRing',
            nest: () =>
                b.element('coordinates', nest: _coords([...ring, ring.first])),
          ),
        );
    },
  );

  static void _lineString(XmlBuilder b, List<MeasurePoint> path) => b.element(
    'LineString',
    nest: () {
      b
        ..element('tessellate', nest: '1')
        ..element('coordinates', nest: _coords(path));
    },
  );

  static void _point(XmlBuilder b, MeasurePoint p) => b.element(
    'Point',
    nest: () => b.element('coordinates', nest: _coords([p])),
  );

  /// One Placemark per point that has photos, named by its number.
  static void _photoPoints(XmlBuilder b, Measurement m) {
    final withPhotos = {
      for (final photo in m.photos)
        if (photo.pointId != null) photo.pointId!,
    };
    for (final (i, p) in m.points.indexed) {
      if (!withPhotos.contains(p.id)) continue;
      b.element(
        'Placemark',
        nest: () {
          b.element('name', nest: 'P${i + 1}');
          _point(b, p);
        },
      );
    }
  }

  static String _coords(Iterable<MeasurePoint> pts) =>
      pts.map((p) => '${_deg(p.lng)},${_deg(p.lat)},0').join(' ');

  /// 7 decimals ≈ 1 cm.
  static String _deg(double v) => _trimZeros(v.toStringAsFixed(7));

  static String? _num(double? v) =>
      v == null ? null : _trimZeros(v.toStringAsFixed(2));

  static String _trimZeros(String s) {
    if (!s.contains('.')) return s;
    var t = s.replaceFirst(RegExp(r'0+$'), '');
    if (t.endsWith('.')) t = t.substring(0, t.length - 1);
    return t;
  }
}
