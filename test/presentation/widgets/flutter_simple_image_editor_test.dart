import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_image_editor/flutter_simple_image_editor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_simple_image_editor/src/presentation/widgets/history_bar.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fake_image_edit_repository.dart';

// 1x1 transparent PNG
final _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
);

// Icons in order: flip horizontal, flip vertical, crop, rotate
Finder _cropButton() => _iconButton(2);

Finder _iconButton(int index) => find
    .ancestor(
      of: find.byType(SvgPicture).at(index),
      matching: find.byType(CupertinoButton),
    )
    .first;

Widget _app(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('confirm without cropping returns the image unchanged', (
    tester,
  ) async {
    Uint8List? result;
    await tester.pumpWidget(
      _app(
        FlutterSimpleImageEditor(
          imageBytes: _png,
          onConfirm: (bytes) => result = bytes,
          onError: () => fail('onError should not be called'),
        ),
      ),
    );

    await tester.tap(find.text('Confirm'));
    await tester.pump();

    expect(result, same(_png));
  });

  testWidgets('crop button toggles crop mode and reports it', (tester) async {
    final states = <bool>[];
    await tester.pumpWidget(
      _app(
        FlutterSimpleImageEditor(
          imageBytes: _png,
          onConfirm: (_) {},
          onError: () {},
          cropActive: states.add,
        ),
      ),
    );

    expect(find.text('1:1'), findsNothing);
    expect(tester.widget<Visibility>(find.byType(Visibility)).visible, isFalse);

    await tester.tap(_cropButton());
    await tester.pump();
    expect(tester.widget<Visibility>(find.byType(Visibility)).visible, isTrue);
    expect(find.text('1:1'), findsOneWidget);

    await tester.tap(_cropButton());
    await tester.pump();
    expect(states, [true, false]);
  });

  testWidgets('state survives a parent rebuild', (tester) async {
    final setter = ValueNotifier(0);
    await tester.pumpWidget(
      _app(
        ValueListenableBuilder<int>(
          valueListenable: setter,
          builder: (_, _, _) => FlutterSimpleImageEditor(
            imageBytes: _png,
            onConfirm: (_) {},
            onError: () {},
          ),
        ),
      ),
    );

    await tester.tap(_cropButton());
    await tester.pump();
    setter.value++;
    await tester.pump();

    expect(tester.widget<Visibility>(find.byType(Visibility)).visible, isTrue);
  });

  testWidgets('flip goes through the repository and enables undo', (
    tester,
  ) async {
    final repository = _PngRepository();
    await tester.pumpWidget(
      _app(
        FlutterSimpleImageEditor(
          imageBytes: _png,
          onConfirm: (_) {},
          onError: () => fail('onError should not be called'),
          repository: repository,
        ),
      ),
    );
    expect(tester.widget<HistoryBar>(find.byType(HistoryBar)).canUndo, isFalse);

    await tester.tap(_iconButton(0));
    await tester.pump();

    expect(repository.transforms, [ImageTransform.flipHorizontal]);
    expect(tester.widget<HistoryBar>(find.byType(HistoryBar)).canUndo, isTrue);
  });

  testWidgets('a failing repository calls onError', (tester) async {
    var errorCount = 0;
    await tester.pumpWidget(
      _app(
        FlutterSimpleImageEditor(
          imageBytes: _png,
          onConfirm: (_) {},
          onError: () => errorCount++,
          repository: FakeImageEditRepository()..shouldFail = true,
        ),
      ),
    );

    await tester.tap(_iconButton(3));
    await tester.pump();

    expect(errorCount, 1);
  });
}

/// Returns a decodable image so the editor can display the result
class _PngRepository extends FakeImageEditRepository {
  @override
  Future<Uint8List> transform(Uint8List image, ImageTransform transform) async {
    await super.transform(image, transform);
    return _png;
  }
}
