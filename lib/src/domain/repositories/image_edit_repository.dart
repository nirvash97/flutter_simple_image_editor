import 'dart:typed_data';
import 'dart:ui';

import '../entities/image_transform.dart';

/// Image processing used by the editor.
///
/// Implementations throw an `ImageEditException` when an operation fails.
abstract interface class ImageEditRepository {
  Future<Uint8List> transform(Uint8List image, ImageTransform transform);

  /// Crops [image] to [rect], in image pixel coordinates.
  Future<Uint8List> crop(Uint8List image, Rect rect);

  /// Size of [image] in pixels.
  Future<Size> imageSize(Uint8List image);
}
