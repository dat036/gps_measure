// Enums are persisted by index (Drift `intEnum`, SharedPreferences).
// NEVER reorder or remove released values — only append at the end.

enum MeasurementType {
  area,
  distance,
  walk
  ;

  /// Points needed before a result (and Save) is available.
  int get minPoints => switch (this) {
    area => 3,
    distance => 2,
    walk => 1,
  };
}

/// Persisted status. ACTIVE / PAUSED are runtime-only (see [WalkRunState]).
enum MeasurementStatus { draft, completed, saved }

enum WalkRunState { idle, recording, paused, finished }

enum PhotoSource { camera, gallery }

enum MapStyle { standard, satellite, terrain, hybrid }

enum DistanceUnit { meter, kilometer, foot, mile }

enum AreaUnit { squareMeter, hectare, acre, squareFoot }

enum InputMode { crosshair, tap }

/// v1.1 adds: kmz, gpx, geojson.
enum ExportFormat { csv, kml, pdf }
