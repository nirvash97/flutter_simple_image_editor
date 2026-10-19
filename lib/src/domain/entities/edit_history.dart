import 'dart:typed_data';

/// Immutable undo / redo history of edited images.
class EditHistory {
  EditHistory(Uint8List image)
    : _images = List.unmodifiable([image]),
      index = 0;

  const EditHistory._(this._images, this.index);

  final List<Uint8List> _images;

  /// Position of [current] in the history
  final int index;

  Uint8List get current => _images[index];

  int get length => _images.length;

  bool get canUndo => index > 0;

  bool get canRedo => index < _images.length - 1;

  /// Adds [image] after [current], dropping any entries that could be redone.
  EditHistory push(Uint8List image) {
    final images = List<Uint8List>.unmodifiable([
      ..._images.sublist(0, index + 1),
      image,
    ]);
    return EditHistory._(images, images.length - 1);
  }

  EditHistory undo() => canUndo ? EditHistory._(_images, index - 1) : this;

  EditHistory redo() => canRedo ? EditHistory._(_images, index + 1) : this;
}
