import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'photo_picker.g.dart';

/// Camera / gallery picking behind an interface (tests use a fake).
abstract interface class PhotoPicker {
  /// Full-resolution camera capture (compressed later by `PhotoStorage`),
  /// or null when cancelled.
  Future<XFile?> takePhoto();

  /// Gallery multi-select (Android Photo Picker: no storage permission).
  /// [limit] caps the selection; null = no cap.
  Future<List<XFile>> pickFromGallery({int? limit});
}

class ImagePickerPhotoPicker implements PhotoPicker {
  ImagePickerPhotoPicker([ImagePicker? picker])
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<XFile?> takePhoto() => _picker.pickImage(
    source: ImageSource.camera,
    requestFullMetadata: false,
  );

  @override
  Future<List<XFile>> pickFromGallery({int? limit}) async {
    if (limit != null && limit < 1) return const [];
    return _picker.pickMultiImage(limit: limit, requestFullMetadata: false);
  }
}

@Riverpod(keepAlive: true)
PhotoPicker photoPicker(Ref ref) => ImagePickerPhotoPicker();
