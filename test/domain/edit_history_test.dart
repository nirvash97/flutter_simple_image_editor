import 'dart:typed_data';

import 'package:flutter_simple_image_editor/src/domain/entities/edit_history.dart';
import 'package:flutter_test/flutter_test.dart';

Uint8List _img(int id) => Uint8List.fromList([id]);

void main() {
  test('starts with the original image and nothing to undo or redo', () {
    final history = EditHistory(_img(0));
    expect(history.current, [0]);
    expect(history.canUndo, isFalse);
    expect(history.canRedo, isFalse);
  });

  test('undo and redo move through pushed images', () {
    var history = EditHistory(_img(0)).push(_img(1)).push(_img(2));
    expect(history.current, [2]);

    history = history.undo().undo();
    expect(history.current, [0]);
    expect(history.undo().current, [0]);

    history = history.redo();
    expect(history.current, [1]);
  });

  test('push after undo drops the redo entries', () {
    final history = EditHistory(_img(0)).push(_img(1)).push(_img(2)).undo();
    final branched = history.push(_img(3));
    expect(branched.length, 3);
    expect(branched.current, [3]);
    expect(branched.canRedo, isFalse);
  });
}
