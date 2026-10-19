## 2.0.0

* Require Flutter 3.35+ / Dart 3.9+ (developed against Flutter 3.47.4).
* Upgrade `extended_image` to ^10.1.0, `image_editor` to ^1.6.0, `flutter_svg` to ^2.3.0.
* Editor state (history, crop mode, crop ratio) now lives in `State`, so it is no
  longer lost when the parent rebuilds. `FlutterSimpleImageEditor` is now `const`.
* Crop uses the editor's crop rect, so the result matches what is shown on screen.
* Confirm without crop mode returns the current image instead of cropping it.
* Fix the fallback crop rect producing an empty image for square images.
* Fix `customRotateRightIcon` being ignored.
* Call `onError` instead of throwing when flip/rotate/crop fails.
* `cropActive` is now also called when flip/rotate leaves crop mode.
* Ignore taps while an edit is running.
* Deprecate `editorDetail` (it is no longer used).
* Restructure into domain / data / presentation layers. The widget is split into
  `HistoryBar`, `CropRatioBar` and `EditorToolbar`, with state in
  `SimpleImageEditorController`.
* Add an optional `repository` parameter (`ImageEditRepository`) to plug in
  custom image processing or a fake for tests.

## 1.0.1

* Initial release.
