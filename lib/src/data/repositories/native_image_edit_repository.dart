import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:image_editor/image_editor.dart';

import '../../domain/entities/image_transform.dart';
import '../../domain/errors/image_edit_exception.dart';
import '../../domain/repositories/image_edit_repository.dart';

/// [ImageEditRepository] backed by the native `image_editor` plugin.
class NativeImageEditRepository implements ImageEditRepository {
  const NativeImageEditRepository();

  @override
  Future<Uint8List> transform(Uint8List image, ImageTransform transform) {
    final option = switch (transform) {
      ImageTransform.flipHorizontal => const FlipOption(horizontal: true),
      ImageTransform.flipVertical => const FlipOption(vertical: true),
      ImageTransform.rotateRight => const RotateOption(90),
    };
    return _edit(image, option);
  }

  @override
  Future<Uint8List> crop(Uint8List image, ui.Rect rect) =>
      _edit(image, ClipOption.fromRect(rect));

  @override
  Future<ui.Size> imageSize(Uint8List image) async {
    try {
      final codec = await ui.instantiateImageCodec(image);
      final ui.Image decoded;
      try {
        decoded = (await codec.getNextFrame()).image;
      } finally {
        codec.dispose();
      }
      final size = ui.Size(decoded.width.toDouble(), decoded.height.toDouble());
      decoded.dispose();
      return size;
    } catch (e) {
      throw ImageEditException('Could not decode image', e);
    }
  }

  Future<Uint8List> _edit(Uint8List image, Option option) async {
    final Uint8List? result;
    try {
      result = await ImageEditor.editImage(
        image: image,
        imageEditorOption: ImageEditorOption()..addOption(option),
      );
    } catch (e) {
      throw ImageEditException('Could not edit image', e);
    }
    if (result == null) {
      throw const ImageEditException('Could not edit image');
    }
    return result;
  }
}
