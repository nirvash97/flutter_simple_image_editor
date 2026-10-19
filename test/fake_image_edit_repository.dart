import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_simple_image_editor/flutter_simple_image_editor.dart';

/// Records calls and returns a new 1-byte image per edit.
class FakeImageEditRepository implements ImageEditRepository {
  FakeImageEditRepository({this.size = const Size(400, 200)});

  final Size size;
  bool shouldFail = false;
  final transforms = <ImageTransform>[];
  final cropRects = <Rect>[];

  @override
  Future<Uint8List> transform(Uint8List image, ImageTransform transform) async {
    _maybeFail();
    transforms.add(transform);
    return Uint8List.fromList([transforms.length]);
  }

  @override
  Future<Uint8List> crop(Uint8List image, Rect rect) async {
    _maybeFail();
    cropRects.add(rect);
    return Uint8List.fromList([255]);
  }

  @override
  Future<Size> imageSize(Uint8List image) async => size;

  void _maybeFail() {
    if (shouldFail) throw const ImageEditException('fake failure');
  }
}
