import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gps_measurement/domain/models/enums.dart';

part 'photo.freezed.dart';

@freezed
abstract class Photo with _$Photo {
  const factory Photo({
    required String id,
    required String measurementId,

    /// Paths RELATIVE to the app documents directory (the iOS container path
    /// changes between app updates).
    required String filePath,
    required String thumbPath,
    required DateTime takenAt,
    required PhotoSource source,
    required int width,
    required int height,
    required int bytes,
    required int sortIndex,

    /// Set when the photo is attached to a specific point (badge 📷).
    String? pointId,
    double? lat,
    double? lng,
    String? caption,
  }) = _Photo;
}
