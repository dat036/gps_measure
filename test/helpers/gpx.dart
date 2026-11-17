import 'dart:io';

import 'package:gps_measurement/domain/models/location_fix.dart';
import 'package:xml/xml.dart';

/// Reads `<trkpt>`s from a fixture GPX (accuracy/mocked from extensions).
List<LocationFix> loadGpx(String name) {
  final doc = XmlDocument.parse(
    File('test/fixtures/gpx/$name').readAsStringSync(),
  );
  return [
    for (final pt in doc.findAllElements('trkpt'))
      LocationFix(
        lat: double.parse(pt.getAttribute('lat')!),
        lng: double.parse(pt.getAttribute('lon')!),
        timestamp: DateTime.parse(pt.getElement('time')!.innerText),
        accuracy: double.parse(
          pt.findAllElements('accuracy').firstOrNull?.innerText ?? '5',
        ),
        isMocked: pt.findAllElements('mocked').firstOrNull?.innerText == 'true',
      ),
  ];
}
