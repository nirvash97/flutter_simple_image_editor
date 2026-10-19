<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

```dart
FlutterSimpleImageEditor(
  imageBytes: await xFile.readAsBytes(),
  onConfirm: (editedBytes) => Navigator.pop(context, editedBytes),
  onError: () => debugPrint('Editing failed'),
  cropActive: (isCropping) => debugPrint('crop mode: $isCropping'),
)
```

See `/example` for a complete app.

### Custom image processing

Editing runs through an `ImageEditRepository`, by default the native
`image_editor` plugin. Pass your own implementation to change how images are
processed, or a fake one in tests:

```dart
FlutterSimpleImageEditor(
  imageBytes: bytes,
  onConfirm: onConfirm,
  onError: onError,
  repository: MyImageEditRepository(),
)
```

## Architecture

```
lib/
├── flutter_simple_image_editor.dart   public exports
├── material/                          colors and text styles
└── src/
    ├── domain/                        pure Dart, no plugins
    │   ├── entities/                  EditHistory, ImageTransform, CropRatio
    │   ├── errors/                    ImageEditException
    │   ├── repositories/              ImageEditRepository (interface)
    │   └── usecases/                  TransformImage, CropImage
    ├── data/
    │   └── repositories/              NativeImageEditRepository (image_editor plugin)
    └── presentation/
        ├── controllers/               SimpleImageEditorController (state + actions)
        └── widgets/                   FlutterSimpleImageEditor and its parts
```

Dependencies point inward: `presentation` → `domain` ← `data`. Widgets only
render the controller's state and forward taps to it. The controller holds the
history, crop mode and ratio, and calls the use cases. The use cases talk to the
`ImageEditRepository` interface, which `data` implements.

`test/` mirrors this layout. Domain and controller tests use
`FakeImageEditRepository`, so they run without native code.
