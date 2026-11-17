import 'package:drift/drift.dart';
import 'package:gps_measurement/data/db/app_database.dart';
import 'package:gps_measurement/domain/models/geo_point.dart';
import 'package:gps_measurement/domain/models/measure_point.dart';
import 'package:gps_measurement/domain/models/measurement.dart';
import 'package:gps_measurement/domain/models/measurement_stats.dart';
import 'package:gps_measurement/domain/models/measurement_summary.dart';
import 'package:gps_measurement/domain/models/photo.dart';

// Row ↔ domain mapping. DateTimes are stored as UTC and returned as UTC.

extension MeasurementRowX on MeasurementRow {
  MeasurementStats get stats => MeasurementStats(
    areaM2: areaM2,
    perimeterM: perimeterM,
    distanceM: distanceM,
    durationSec: durationSec,
    pointCount: pointCount,
    segmentCount: segmentCount,
    isClosed: isClosed,
    selfIntersects: selfIntersects,
  );

  GeoBounds? get bounds =>
      minLat == null || minLng == null || maxLat == null || maxLng == null
      ? null
      : GeoBounds(
          minLat: minLat!,
          minLng: minLng!,
          maxLat: maxLat!,
          maxLng: maxLng!,
        );

  Measurement toDomain({
    List<MeasurePoint> points = const [],
    List<Photo> photos = const [],
  }) => Measurement(
    id: id,
    name: name,
    type: type,
    status: status,
    points: points,
    photos: photos,
    notes: notes,
    stats: stats,
    mapStyle: mapStyle,
    displayAreaUnit: displayAreaUnit,
    displayDistanceUnit: displayDistanceUnit,
    unitPrice: unitPrice,
    unitPriceCurrency: unitPriceCurrency,
    unitPriceArea: unitPriceArea,
    thumbnailPath: thumbnailPath,
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
    savedAt: savedAt?.toUtc(),
    walkState: walkState,
    walkStartedAt: walkStartedAt?.toUtc(),
    walkElapsedSec: walkElapsedSec,
    walkLastResumeAt: walkLastResumeAt?.toUtc(),
  );

  MeasurementSummary toSummary({int photoCount = 0}) => MeasurementSummary(
    id: id,
    name: name,
    type: type,
    status: status,
    areaM2: areaM2,
    perimeterM: perimeterM,
    distanceM: distanceM,
    durationSec: durationSec,
    pointCount: pointCount,
    segmentCount: segmentCount,
    photoCount: photoCount,
    thumbnailPath: thumbnailPath,
    updatedAt: updatedAt.toUtc(),
    savedAt: savedAt?.toUtc(),
    walkState: walkState,
  );
}

/// Stats columns for an update.
MeasurementsCompanion statsCompanion(MeasurementStats s) =>
    MeasurementsCompanion(
      areaM2: Value(s.areaM2),
      perimeterM: Value(s.perimeterM),
      distanceM: Value(s.distanceM),
      durationSec: Value(s.durationSec),
      pointCount: Value(s.pointCount),
      segmentCount: Value(s.segmentCount),
      isClosed: Value(s.isClosed),
      selfIntersects: Value(s.selfIntersects),
    );

MeasurementsCompanion boundsCompanion(GeoBounds? b) => MeasurementsCompanion(
  minLat: Value(b?.minLat),
  minLng: Value(b?.minLng),
  maxLat: Value(b?.maxLat),
  maxLng: Value(b?.maxLng),
);

extension PointRowX on PointRow {
  MeasurePoint toDomain() => MeasurePoint(
    id: id,
    orderIndex: orderIndex,
    segmentIndex: segmentIndex,
    lat: lat,
    lng: lng,
    altitude: altitude,
    accuracy: accuracy,
    speed: speed,
    bearing: bearing,
    timestamp: timestamp.toUtc(),
  );
}

extension MeasurePointX on MeasurePoint {
  MeasurePointsCompanion toCompanion(String measurementId) =>
      MeasurePointsCompanion.insert(
        id: id,
        measurementId: measurementId,
        orderIndex: orderIndex,
        segmentIndex: Value(segmentIndex),
        lat: lat,
        lng: lng,
        altitude: Value(altitude),
        accuracy: Value(accuracy),
        speed: Value(speed),
        bearing: Value(bearing),
        timestamp: timestamp.toUtc(),
      );
}

extension PhotoRowX on PhotoRow {
  Photo toDomain() => Photo(
    id: id,
    measurementId: measurementId,
    pointId: pointId,
    filePath: filePath,
    thumbPath: thumbPath,
    takenAt: takenAt.toUtc(),
    lat: lat,
    lng: lng,
    caption: caption,
    source: source,
    width: width,
    height: height,
    bytes: bytes,
    sortIndex: sortIndex,
  );
}

extension PhotoX on Photo {
  PhotosCompanion toCompanion() => PhotosCompanion.insert(
    id: id,
    measurementId: measurementId,
    pointId: Value(pointId),
    filePath: filePath,
    thumbPath: thumbPath,
    takenAt: takenAt.toUtc(),
    lat: Value(lat),
    lng: Value(lng),
    caption: Value(caption),
    source: source,
    width: width,
    height: height,
    bytes: bytes,
    sortIndex: sortIndex,
  );
}
