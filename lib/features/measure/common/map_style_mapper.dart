import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_measurement/domain/models/enums.dart';

/// Our [MapStyle] ↔ Google Maps [MapType]. No cloud Map ID (billed): the
/// dark look for Standard uses a bundled JSON style.
abstract final class MapStyleMapper {
  static MapType mapType(MapStyle style) => switch (style) {
    MapStyle.standard => MapType.normal,
    MapStyle.satellite => MapType.satellite,
    MapStyle.terrain => MapType.terrain,
    MapStyle.hybrid => MapType.hybrid,
  };

  static const String darkStyleAsset = 'assets/map_styles/dark.json';

  static String? _darkJson;

  /// Dark JSON style, only for Standard in dark mode (imagery styles ignore
  /// JSON styling).
  static Future<String?> styleFor(MapStyle style, Brightness brightness) async {
    if (style != MapStyle.standard || brightness != Brightness.dark) {
      return null;
    }
    return _darkJson ??= await rootBundle.loadString(darkStyleAsset);
  }
}
