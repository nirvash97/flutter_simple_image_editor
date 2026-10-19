import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_simple_image_editor/flutter_simple_image_editor.dart';
import 'package:flutter_simple_image_editor/src/domain/usecases/crop_image.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fake_image_edit_repository.dart';

void main() {
  group('centeredCropRect', () {
    test('original ratio keeps the whole image', () {
      expect(
        CropImage.centeredCropRect(const Size(400, 200), CropRatio.original),
        const Rect.fromLTWH(0, 0, 400, 200),
      );
    });

    test('square on a landscape image', () {
      expect(
        CropImage.centeredCropRect(const Size(400, 200), CropRatio.square),
        const Rect.fromLTWH(100, 0, 200, 200),
      );
    });

    test('square on a square image is not empty', () {
      expect(
        CropImage.centeredCropRect(const Size(300, 300), CropRatio.square),
        const Rect.fromLTWH(0, 0, 300, 300),
      );
    });

    test('16:9 on a portrait image uses the full width', () {
      final rect = CropImage.centeredCropRect(
        const Size(900, 1600),
        CropRatio.ratio16x9,
      );
      expect(rect.width, 900);
      expect(rect.height, closeTo(506.25, 0.001));
      expect(rect.center, const Offset(450, 800));
    });
  });

  test('uses the given crop rect when there is one', () async {
    final repository = FakeImageEditRepository();
    const rect = Rect.fromLTWH(1, 2, 3, 4);
    await CropImage(repository)(
      Uint8List(0),
      cropRect: rect,
      aspectRatio: CropRatio.square,
    );
    expect(repository.cropRects, [rect]);
  });
}
