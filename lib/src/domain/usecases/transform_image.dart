import 'dart:typed_data';

import '../entities/image_transform.dart';
import '../repositories/image_edit_repository.dart';

class TransformImage {
  const TransformImage(this._repository);

  final ImageEditRepository _repository;

  Future<Uint8List> call(Uint8List image, ImageTransform transform) =>
      _repository.transform(image, transform);
}
