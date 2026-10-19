/// Thrown when an image can't be decoded or edited.
class ImageEditException implements Exception {
  const ImageEditException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => cause == null
      ? 'ImageEditException: $message'
      : 'ImageEditException: $message ($cause)';
}
