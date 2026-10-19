import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../../domain/entities/crop_ratio.dart';
import '../../domain/entities/edit_history.dart';
import '../../domain/entities/image_transform.dart';
import '../../domain/repositories/image_edit_repository.dart';
import '../../domain/usecases/crop_image.dart';
import '../../domain/usecases/transform_image.dart';

/// Holds the editor state and runs edits through the domain use cases.
class SimpleImageEditorController extends ChangeNotifier {
  SimpleImageEditorController({
    required ImageEditRepository repository,
    required Uint8List image,
    bool isCropping = false,
    double cropRatio = CropRatio.original,
    this.onCropModeChanged,
    this.onError,
  }) : _transformImage = TransformImage(repository),
       _cropImage = CropImage(repository),
       _history = EditHistory(image),
       _isCropping = isCropping,
       _cropRatio = cropRatio;

  final TransformImage _transformImage;
  final CropImage _cropImage;

  /// Called with the new value whenever [isCropping] changes
  final ValueChanged<bool>? onCropModeChanged;

  /// Called when an edit fails
  final void Function(Object error)? onError;

  EditHistory _history;
  bool _isCropping;
  double _cropRatio;
  bool _isProcessing = false;
  bool _isDisposed = false;

  Uint8List get image => _history.current;

  bool get canUndo => _history.canUndo;

  bool get canRedo => _history.canRedo;

  bool get isCropping => _isCropping;

  /// Selected crop aspect ratio (width / height), see [CropRatio]
  double get cropRatio => _cropRatio;

  /// True while an edit is running, other actions are ignored meanwhile
  bool get isProcessing => _isProcessing;

  /// Starts over with a new [image], clearing the history.
  void reset(Uint8List image) {
    _history = EditHistory(image);
    notifyListeners();
  }

  void undo() {
    if (_isProcessing || !canUndo) return;
    _history = _history.undo();
    notifyListeners();
  }

  void redo() {
    if (_isProcessing || !canRedo) return;
    _history = _history.redo();
    notifyListeners();
  }

  void toggleCropMode() {
    _setCropping(!_isCropping);
    notifyListeners();
  }

  void selectCropRatio(double ratio) {
    if (_cropRatio == ratio) return;
    _cropRatio = ratio;
    notifyListeners();
  }

  Future<void> flipHorizontal() => _transform(ImageTransform.flipHorizontal);

  Future<void> flipVertical() => _transform(ImageTransform.flipVertical);

  Future<void> rotateRight() => _transform(ImageTransform.rotateRight);

  /// Returns the final image, cropped to [cropRect] (image pixel coordinates)
  /// when in crop mode. Returns null when busy or when cropping fails.
  Future<Uint8List?> confirm({Rect? cropRect}) async {
    if (_isProcessing) return null;
    if (!_isCropping) return image;
    return _run(
      () => _cropImage(image, cropRect: cropRect, aspectRatio: _cropRatio),
    );
  }

  Future<void> _transform(ImageTransform transform) async {
    final edited = await _run(() => _transformImage(image, transform));
    if (edited == null || _isDisposed) return;
    _history = _history.push(edited);
    _setCropping(false);
    notifyListeners();
  }

  /// Runs [action] while marking the controller as busy, reporting errors to
  /// [onError] and returning null on failure.
  Future<Uint8List?> _run(Future<Uint8List> Function() action) async {
    if (_isProcessing) return null;
    _isProcessing = true;
    try {
      return await action();
    } catch (e) {
      if (!_isDisposed) onError?.call(e);
      return null;
    } finally {
      _isProcessing = false;
    }
  }

  void _setCropping(bool value) {
    if (_isCropping == value) return;
    _isCropping = value;
    onCropModeChanged?.call(value);
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
