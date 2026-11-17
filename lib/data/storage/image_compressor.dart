import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gps_measurement/core/utils/app_exception.dart';
import 'package:gps_measurement/data/storage/jpeg_size.dart';

class CompressedImage {
  const CompressedImage({
    required this.bytes,
    required this.width,
    required this.height,
  });

  final Uint8List bytes;
  final int width;
  final int height;
}

/// Resizes + re-encodes photos to JPEG. Behind an interface so storage
/// logic can be tested without the native plugin.
// ignore: one_member_abstracts — an interface for test fakes.
abstract interface class ImageCompressor {
  /// JPEG with the long edge ≤ [maxEdge] px (never upscaled), EXIF rotation
  /// applied, metadata stripped.
  Future<CompressedImage> compress(
    String sourcePath, {
    required int maxEdge,
    required int quality,
  });
}

/// flutter_image_compress: encoding runs on a native background thread, so
/// the UI isolate only reads the header.
class NativeImageCompressor implements ImageCompressor {
  const NativeImageCompressor();

  @override
  Future<CompressedImage> compress(
    String sourcePath, {
    required int maxEdge,
    required int quality,
  }) async {
    final (w, h) = await _sourceSize(sourcePath);
    // The plugin scales by max(minWidth/w, minHeight/h). Passing the scaled
    // SHORT edge for both gives exactly `scale`, whatever the EXIF rotation.
    final scale = math.min(1, maxEdge / math.max(w, h));
    final shortEdge = (math.min(w, h) * scale).round();

    final bytes = await FlutterImageCompress.compressWithFile(
      sourcePath,
      minWidth: shortEdge,
      minHeight: shortEdge,
      quality: quality,
    );
    if (bytes == null) {
      throw StorageException('Image compression failed: $sourcePath');
    }
    final size = readJpegSize(bytes);
    if (size == null) {
      throw StorageException('Compressed image is not a JPEG: $sourcePath');
    }
    return CompressedImage(
      bytes: bytes,
      width: size.width,
      height: size.height,
    );
  }

  /// Reads dimensions from the encoded header (no full decode).
  static Future<(int, int)> _sourceSize(String path) async {
    final data = await File(path).readAsBytes();
    final buffer = await ui.ImmutableBuffer.fromUint8List(data);
    final descriptor = await ui.ImageDescriptor.encoded(buffer);
    final size = (descriptor.width, descriptor.height);
    descriptor.dispose();
    buffer.dispose();
    return size;
  }
}
