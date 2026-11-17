import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart' show Locale;
import 'package:geocoding/geocoding.dart';
import 'package:gps_measurement/core/utils/logger.dart';
import 'package:gps_measurement/domain/geo/geo_parse.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'place_search_service.g.dart';

/// A place to move the map to.
class PlaceResult {
  const PlaceResult({required this.point, required this.title, this.subtitle});

  final GeoPoint point;
  final String title;
  final String? subtitle;

  /// Coordinates/links are exact spots; addresses are areas.
  bool get isExact => subtitle == null;
}

enum PlaceSearchFailure {
  /// No network for an address / short link.
  offline,

  /// The OS has no geocoder (e.g. Android without Google Play services).
  unavailable,
}

class PlaceSearchException implements Exception {
  const PlaceSearchException(this.failure);

  final PlaceSearchFailure failure;

  @override
  String toString() => 'PlaceSearchException($failure)';
}

/// Resolves search input to places (P4-04). Free only:
/// - coordinates / Google Maps links → parsed locally ([GeoParse]),
/// - `maps.app.goo.gl` short links → one HTTP redirect lookup (no API key),
/// - addresses → the OS geocoder (`geocoding`), no Places/Geocoding API.
// An interface so tests can swap in a fake.
// ignore: one_member_abstracts
abstract interface class PlaceSearchService {
  /// Throws [PlaceSearchException] for offline / no geocoder.
  Future<List<PlaceResult>> search(String input, {Locale? locale});
}

/// The OS geocoder, behind an interface (the plugin cannot run in tests).
abstract interface class AddressGeocoder {
  Future<bool> isPresent();

  /// Empty when nothing matches; throws on platform/network errors.
  Future<List<GeoPoint>> locate(String address, Locale? locale);

  /// Human-readable area name for [point], or null.
  Future<String?> nameOf(GeoPoint point, Locale? locale);
}

class PlatformAddressGeocoder implements AddressGeocoder {
  PlatformAddressGeocoder();

  late final Geocoding _geocoding = Geocoding();

  @override
  Future<bool> isPresent() => _geocoding.isPresent();

  @override
  Future<List<GeoPoint>> locate(String address, Locale? locale) async => [
    for (final l in await _geocoding.locationFromAddress(
      address,
      locale: locale,
    ))
      GeoPoint(lat: l.latitude, lng: l.longitude),
  ];

  @override
  Future<String?> nameOf(GeoPoint p, Locale? locale) async {
    final marks = await _geocoding.placemarkFromCoordinates(
      p.lat,
      p.lng,
      locale: locale,
    );
    if (marks.isEmpty) return null;
    final m = marks.first;
    final parts = [
      m.subLocality,
      m.locality,
      m.subAdministrativeArea,
      m.administrativeArea,
    ].whereType<String>().where((s) => s.trim().isNotEmpty).toSet();
    return parts.isEmpty ? m.name : parts.join(', ');
  }
}

class DefaultPlaceSearchService implements PlaceSearchService {
  DefaultPlaceSearchService({
    AddressGeocoder? geocoder,
    Future<Uri?> Function(Uri shortLink)? resolveShortLink,
  }) : _geocoder = geocoder ?? PlatformAddressGeocoder(),
       _resolveShortLink = resolveShortLink ?? _followRedirects;

  final AddressGeocoder _geocoder;
  final Future<Uri?> Function(Uri) _resolveShortLink;

  /// Named results are looked up for at most this many address matches
  /// (each is one more geocoder call; the OS rate-limits them).
  static const int maxNamedResults = 3;

  /// Only these hosts are ever contacted to expand a link.
  static const Set<String> shortLinkHosts = {'maps.app.goo.gl', 'goo.gl'};

  @override
  Future<List<PlaceResult>> search(String input, {Locale? locale}) async {
    final text = input.trim();
    final query = GeoParse.parse(text);
    switch (query) {
      case null:
        return const [];
      case CoordinateQuery(:final point):
        return [_coordinateResult(point)];
      case AddressQuery():
        final uri = Uri.tryParse(text);
        if (uri != null && shortLinkHosts.contains(uri.host.toLowerCase())) {
          return _fromShortLink(uri);
        }
        return _geocode(text, locale);
    }
  }

  Future<List<PlaceResult>> _fromShortLink(Uri link) async {
    final Uri? target;
    try {
      target = await _resolveShortLink(link);
    } on SocketException {
      throw const PlaceSearchException(PlaceSearchFailure.offline);
    } on TimeoutException {
      throw const PlaceSearchException(PlaceSearchFailure.offline);
    }
    if (target == null) return const [];
    if (GeoParse.parse(target.toString()) case CoordinateQuery(:final point)) {
      return [_coordinateResult(point)];
    }
    return const [];
  }

  Future<List<PlaceResult>> _geocode(String address, Locale? locale) async {
    if (!await _geocoder.isPresent()) {
      throw const PlaceSearchException(PlaceSearchFailure.unavailable);
    }
    final List<GeoPoint> locations;
    try {
      locations = await _geocoder.locate(address, locale);
    } on Exception catch (e) {
      // "No result" is an empty list; errors (Android reports network
      // problems as an IOException → PlatformException) mean offline.
      Log.w('Geocoder failed for "$address"', e);
      throw const PlaceSearchException(PlaceSearchFailure.offline);
    }

    final results = <PlaceResult>[];
    for (final (i, point) in locations.indexed) {
      final name = i < maxNamedResults ? await _nameOf(point, locale) : null;
      results.add(
        PlaceResult(
          point: point,
          title: name ?? address,
          subtitle: _formatCoordinates(point),
        ),
      );
    }
    return results;
  }

  Future<String?> _nameOf(GeoPoint p, Locale? locale) async {
    try {
      return await _geocoder.nameOf(p, locale);
    } on Exception {
      return null; // the name is a nicety; coordinates still work
    }
  }

  static PlaceResult _coordinateResult(GeoPoint p) =>
      PlaceResult(point: p, title: _formatCoordinates(p));

  static String _formatCoordinates(GeoPoint p) =>
      '${p.lat.toStringAsFixed(6)}, ${p.lng.toStringAsFixed(6)}';

  /// Follows HTTP redirects of a short link (max 5 hops) without
  /// downloading the page. Only [shortLinkHosts] are requested first.
  static Future<Uri?> _followRedirects(Uri link) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 8)
      ..userAgent = 'LandMeasure';
    try {
      var current = link;
      for (var hop = 0; hop < 5; hop++) {
        final request = await client.getUrl(current)
          ..followRedirects = false;
        final response = await request.close().timeout(
          const Duration(seconds: 8),
        );
        await response.drain<void>();
        final location = response.headers.value(HttpHeaders.locationHeader);
        if (!response.isRedirect || location == null) return current;
        current = current.resolve(location);
        // Stop as soon as the target carries coordinates.
        if (GeoParse.parse(current.toString()) is CoordinateQuery) {
          return current;
        }
      }
      return current;
    } on HttpException catch (e) {
      Log.w('Short link lookup failed: $link', e);
      return null;
    } finally {
      client.close(force: true);
    }
  }
}

@Riverpod(keepAlive: true)
PlaceSearchService placeSearchService(Ref ref) => DefaultPlaceSearchService();
