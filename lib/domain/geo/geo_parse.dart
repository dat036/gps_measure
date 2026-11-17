import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';

part 'geo_parse.freezed.dart';

/// Result of parsing the place-search input.
@freezed
sealed class GeoQuery with _$GeoQuery {
  /// Input was a coordinate (decimal, DMS or a Google Maps link).
  const factory GeoQuery.coordinate(GeoPoint point) = CoordinateQuery;

  /// Anything else: pass to the native geocoder.
  const factory GeoQuery.address(String text) = AddressQuery;
}

/// Parses search input (`architecture.md` §7.7):
/// - `21.0285, 105.8542` · `21.0285 105.8542` · `21.0285N 105.8542E`
/// - DMS `21°01'42.6"N 105°51'15.1"E` (also `º ′ ″`, `''`)
/// - Google Maps links: `/@lat,lng`, `?q=lat,lng`, `ll=lat,lng`,
///   `/search/lat,+lng`
///
/// Shortened links (maps.app.goo.gl) need a network redirect and are
/// returned as [AddressQuery]; out-of-range numbers are not coordinates.
abstract final class GeoParse {
  static GeoQuery? parse(String input) {
    final text = input.trim();
    if (text.isEmpty) return null;
    final point = _fromLink(text) ?? _fromDms(text) ?? _fromDecimal(text);
    if (point != null && point.isValid) return GeoQuery.coordinate(point);
    return GeoQuery.address(text);
  }

  static const String _num = r'[-+]?\d{1,3}(?:\.\d+)?';

  static final RegExp _linkAt = RegExp('@($_num),($_num)');
  static final RegExp _linkParam = RegExp(
    '[?&](?:q|ll|query|center|destination)=($_num)(?:,|%2C)\\s*\\+?($_num)',
    caseSensitive: false,
  );
  static final RegExp _linkPath = RegExp(
    '/(?:search|place|dir)/($_num)(?:,|%2C)\\+?\\s*($_num)',
    caseSensitive: false,
  );

  static GeoPoint? _fromLink(String text) {
    final lower = text.toLowerCase();
    final isMapsLink =
        lower.contains('google.') && lower.contains('map') ||
        lower.contains('maps.app.goo.gl') ||
        lower.startsWith('geo:');
    if (!isMapsLink) return null;
    if (lower.startsWith('geo:')) {
      return _fromDecimal(text.substring(4).split('?').first);
    }
    final decoded = Uri.decodeFull(text);
    for (final re in [_linkParam, _linkPath, _linkAt]) {
      final m = re.firstMatch(decoded);
      if (m != null) {
        return GeoPoint(
          lat: double.parse(m.group(1)!),
          lng: double.parse(m.group(2)!),
        );
      }
    }
    return null;
  }

  // 21.0285, 105.8542 | 21.0285 105.8542 | 21.0285N 105.8542E | N21.02 E105.85
  static final RegExp _decimal = RegExp(
    r'^([NS])?\s*([-+]?\d{1,3}(?:\.\d+)?)\s*°?\s*([NS])?\s*[,;\s]\s*'
    r'([EW])?\s*([-+]?\d{1,3}(?:\.\d+)?)\s*°?\s*([EW])?$',
    caseSensitive: false,
  );

  static GeoPoint? _fromDecimal(String text) {
    final m = _decimal.firstMatch(text.trim());
    if (m == null) return null;
    var lat = double.parse(m.group(2)!);
    var lng = double.parse(m.group(5)!);
    final ns = (m.group(1) ?? m.group(3))?.toUpperCase();
    final ew = (m.group(4) ?? m.group(6))?.toUpperCase();
    if (ns == 'S') lat = -lat.abs();
    if (ew == 'W') lng = -lng.abs();
    return GeoPoint(lat: lat, lng: lng);
  }

  // 21°01'42.6"N  |  21° 1′ 42.6″ N  |  21 01 42.6 N
  static const String _dmsPart =
      r'(\d{1,3})\s*[°º:\s]\s*(\d{1,2})\s*['
      "'′:\\s]\\s*(\\d{1,2}(?:\\.\\d+)?)\\s*(?:\"|″|''|)?\\s*";
  static final RegExp _dms = RegExp(
    '^$_dmsPart([NS])[,;\\s]*$_dmsPart([EW])\$',
    caseSensitive: false,
  );

  static GeoPoint? _fromDms(String text) {
    final m = _dms.firstMatch(text.trim());
    if (m == null) return null;
    double part(int i) {
      final deg = double.parse(m.group(i)!);
      final min = double.parse(m.group(i + 1)!);
      final sec = double.parse(m.group(i + 2)!);
      if (min >= 60 || sec >= 60) return double.nan;
      return deg + min / 60 + sec / 3600;
    }

    var lat = part(1);
    var lng = part(5);
    if (m.group(4)!.toUpperCase() == 'S') lat = -lat;
    if (m.group(8)!.toUpperCase() == 'W') lng = -lng;
    return GeoPoint(lat: lat, lng: lng);
  }
}
