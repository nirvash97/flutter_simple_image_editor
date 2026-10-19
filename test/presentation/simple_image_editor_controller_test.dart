import 'dart:typed_data';

import 'package:flutter_simple_image_editor/flutter_simple_image_editor.dart';
import 'package:flutter_simple_image_editor/src/presentation/controllers/simple_image_editor_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:ui';

import '../fake_image_edit_repository.dart';

void main() {
  final original = Uint8List.fromList([0]);
  late FakeImageEditRepository repository;
  late List<bool> cropModes;
  late List<Object> errors;

  SimpleImageEditorController create({bool isCropping = false}) =>
      SimpleImageEditorController(
        repository: repository,
        image: original,
        isCropping: isCropping,
        onCropModeChanged: cropModes.add,
        onError: errors.add,
      );

  setUp(() {
    repository = FakeImageEditRepository();
    cropModes = [];
    errors = [];
  });

  test('edits are added to the history and can be undone', () async {
    final controller = create();
    await controller.flipHorizontal();
    await controller.rotateRight();

    expect(repository.transforms, [
      ImageTransform.flipHorizontal,
      ImageTransform.rotateRight,
    ]);
    expect(controller.image, [2]);

    controller.undo();
    expect(controller.image, [1]);
    expect(controller.canRedo, isTrue);

    controller.redo();
    expect(controller.image, [2]);
  });

  test('an edit leaves crop mode and reports it', () async {
    final controller = create(isCropping: true);
    await controller.flipVertical();
    expect(controller.isCropping, isFalse);
    expect(cropModes, [false]);
  });

  test('a failed edit reports the error and keeps the image', () async {
    final controller = create();
    repository.shouldFail = true;
    await controller.flipHorizontal();

    expect(errors, hasLength(1));
    expect(controller.image, same(original));
    expect(controller.canUndo, isFalse);
  });

  test('confirm outside crop mode returns the image unchanged', () async {
    final controller = create();
    expect(await controller.confirm(), same(original));
    expect(repository.cropRects, isEmpty);
  });

  test('confirm in crop mode crops with the selected ratio', () async {
    final controller = create(isCropping: true)
      ..selectCropRatio(CropRatio.square);
    final result = await controller.confirm();

    expect(result, [255]);
    expect(repository.cropRects.single.size, const Size(200, 200));
  });

  test('ignores actions while an edit is running', () async {
    final controller = create();
    final first = controller.flipHorizontal();
    await controller.flipVertical();
    await first;

    expect(repository.transforms, [ImageTransform.flipHorizontal]);
  });
}
