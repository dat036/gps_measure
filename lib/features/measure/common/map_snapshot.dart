import 'dart:async';
import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/data/storage/thumbnail_storage.dart';
import 'package:gps_measurement/domain/geo/geo_calculator.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';

/// Frames [points] on the live map, waits for tiles, and returns a square
/// 400×400 PNG thumbnail — or null (no map, snapshot failed, timed out).
/// Never throws: Save then draws a fallback thumbnail.
///
/// [mapHeight] / [visibleHeight]: the map widget's height and the part not
/// covered by the sheet (the map's bottom padding keeps the framed shape
/// there). The shape is framed with [marginFraction] of that height on each
/// side so it also survives the 16:10 crop on Detail and Save.
Future<Uint8List?> captureMapThumbnail(
  GoogleMapController? map,
  Iterable<GeoPoint> points, {
  required double mapHeight,
  required double visibleHeight,
  double marginFraction = 0.22,
  Duration settle = const Duration(milliseconds: 900),
}) async {
  final b = GeoCalculator.bounds(points);
  if (map == null || b == null) return null;
  try {
    final span = GeoCalculator.distance(
      GeoPoint(lat: b.minLat, lng: b.minLng),
      GeoPoint(lat: b.maxLat, lng: b.maxLng),
    );
    await map
        .animateCamera(
          span < 30
              ? CameraUpdate.newLatLngZoom(
                  LatLng(b.center.lat, b.center.lng),
                  18,
                )
              : CameraUpdate.newLatLngBounds(
                  LatLngBounds(
                    southwest: LatLng(b.minLat, b.minLng),
                    northeast: LatLng(b.maxLat, b.maxLng),
                  ),
                  visibleHeight * marginFraction,
                ),
        )
        .timeout(const Duration(seconds: 2));
    await Future<void>.delayed(settle); // let imagery load
    final raw = await map.takeSnapshot().timeout(const Duration(seconds: 3));
    if (raw == null) return null;
    return await ThumbnailStorage.squareFromSnapshot(
      raw,
      visibleHeightFraction: visibleHeight / mapHeight,
    );
  } on Object catch (e, st) {
    Log.w('Map snapshot failed; a drawn thumbnail will be used', e, st);
    return null;
  }
}
