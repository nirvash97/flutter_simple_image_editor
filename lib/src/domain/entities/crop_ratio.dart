/// Crop aspect ratios (width / height) offered by the editor.
abstract final class CropRatio {
  /// Keeps the aspect ratio of the image
  static const double original = 0;
  static const double square = 1;
  static const double ratio3x2 = 3 / 2;
  static const double ratio4x3 = 4 / 3;
  static const double ratio16x9 = 16 / 9;
}
