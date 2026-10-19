import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import '../repositories/image_edit_repository.dart';

class CropImage {
  const CropImage(this._repository);

  final ImageEditRepository _repository;

  /// Crops [image] to [cropRect]. Without a [cropRect] the largest centered
  /// rect matching [aspectRatio] is used.
  Future<Uint8List> call(
    Uint8List image, {
    Rect? cropRect,
    required double aspectRatio,
  }) async {
    final rect =
        cropRect ??
        centeredCropRect(await _repository.imageSize(image), aspectRatio);
    return _repository.crop(image, rect);
  }

  /// Largest rect of [aspectRatio] (width / height) centered in [imageSize].
  /// An [aspectRatio] of `0` or less returns the whole image.
  static Rect centeredCropRect(Size imageSize, double aspectRatio) {
    final imageRect = Offset.zero & imageSize;
    if (aspectRatio <= 0) return imageRect;
    final height = math.min(imageSize.height, imageSize.width / aspectRatio);
    return Rect.fromCenter(
      center: imageRect.center,
      width: height * aspectRatio,
      height: height,
    );
  }
}
