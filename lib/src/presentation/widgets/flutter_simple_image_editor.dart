import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../../material/app_color.dart';
import '../../data/repositories/native_image_edit_repository.dart';
import '../../domain/entities/crop_ratio.dart';
import '../../domain/repositories/image_edit_repository.dart';
import '../controllers/simple_image_editor_controller.dart';
import 'crop_ratio_bar.dart';
import 'editor_toolbar.dart';
import 'history_bar.dart';

class FlutterSimpleImageEditor extends StatefulWidget {
  /// Default value is false
  /// CropActive is callback status of cropMode if cropMode was ExtendedImageMode.editor this value will return true
  final ValueChanged<bool>? cropActive;

  /// ImageByte was get by convert image (XFile) to Uint8List by using .readAsBytes and render into widget by using Image.memory(Uint8List)
  final Uint8List imageBytes;

  /// seting action when editing is complete will return edited image in Uint8List
  final void Function(Uint8List imgBytes) onConfirm;

  /// setting action when editing is error (ex. show error toast)
  final VoidCallback onError;

  /// Initial history index. Only `0` is meaningful because the history starts
  /// with [imageBytes] as its single entry.
  final int currentIndex;

  /// No longer used. The crop area is read from the editor directly.
  @Deprecated('Ignored. The crop area is read from the editor directly.')
  final EditActionDetails? editorDetail;

  /// Initial mode, pass [ExtendedImageMode.editor] to start in crop mode
  final ExtendedImageMode cropMode;

  /// Initial crop ratio (width / height), `0` keeps the original ratio
  final double cropRatio;
  final String? originalRatioText;
  final String? oneOnOneRatioText;
  final String? threeOnOtwRatioText;
  final String? fourOnThreeRatioText;
  final String? wideRatioWideText;
  final Text? cancelText;
  final Text? confirmText;

  /// setting backgroundColor
  final Color? backgroundColor;

  /// Sugestion use widget with size 24 px for custom icon widget
  final Widget? customFlipHorizonIcon;

  /// Sugestion use widget with size 24 px for custom icon widget
  final Widget? customFlipVerticalIcon;

  /// Sugestion use widget with size 24 px for custom icon widget
  final Widget? customCropImageIcon;

  /// Sugestion use widget with size 24 px for custom icon widget
  final Widget? customRotateRightIcon;

  /// Sugestion use widget with size 24 px for custom icon widget
  final Widget? customUnDoIcon;

  /// Sugestion use widget with size 24 px for custom icon widget
  final Widget? customReDoIcon;

  /// Image processing backend, defaults to the native `image_editor` plugin.
  /// Pass your own to customize processing or to test without the plugin.
  final ImageEditRepository repository;

  const FlutterSimpleImageEditor({
    super.key,
    required this.imageBytes,
    required this.onConfirm,
    required this.onError,
    this.currentIndex = 0,
    @Deprecated('Ignored. The crop area is read from the editor directly.')
    this.editorDetail,
    this.cropActive,
    this.cropMode = ExtendedImageMode.none,
    this.cropRatio = CropRatio.original,
    this.originalRatioText,
    this.oneOnOneRatioText,
    this.threeOnOtwRatioText,
    this.fourOnThreeRatioText,
    this.wideRatioWideText,
    this.cancelText,
    this.confirmText,
    this.customFlipHorizonIcon,
    this.customFlipVerticalIcon,
    this.customCropImageIcon,
    this.customRotateRightIcon,
    this.customUnDoIcon,
    this.customReDoIcon,
    this.backgroundColor,
    this.repository = const NativeImageEditRepository(),
  });

  @override
  State<FlutterSimpleImageEditor> createState() =>
      _FlutterSimpleImageEditorState();
}

class _FlutterSimpleImageEditorState extends State<FlutterSimpleImageEditor> {
  /// extended_image's controller, used to read the crop rect on screen
  final ImageEditorController _cropController = ImageEditorController();

  late final SimpleImageEditorController _controller =
      SimpleImageEditorController(
        repository: widget.repository,
        image: widget.imageBytes,
        isCropping: widget.cropMode == ExtendedImageMode.editor,
        cropRatio: widget.cropRatio,
        onCropModeChanged: (value) => widget.cropActive?.call(value),
        onError: (_) => widget.onError(),
      );

  @override
  void didUpdateWidget(covariant FlutterSimpleImageEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.imageBytes, widget.imageBytes)) {
      _controller.reset(widget.imageBytes);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _cropController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final result = await _controller.confirm(
      cropRect: _cropController.getCropRect(),
    );
    if (result != null && mounted) widget.onConfirm(result);
  }

  List<CropRatioOption> get _ratioOptions => [
    (ratio: CropRatio.original, label: widget.originalRatioText ?? 'Original'),
    (ratio: CropRatio.square, label: widget.oneOnOneRatioText ?? '1:1'),
    (ratio: CropRatio.ratio3x2, label: widget.threeOnOtwRatioText ?? '3:2'),
    (ratio: CropRatio.ratio4x3, label: widget.fourOnThreeRatioText ?? '4:3'),
    (ratio: CropRatio.ratio16x9, label: widget.wideRatioWideText ?? '16:9'),
  ];

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.backgroundColor ?? AppColor.dark0;

    return ColoredBox(
      color: backgroundColor,
      child: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) => Column(
            children: [
              HistoryBar(
                canUndo: _controller.canUndo,
                canRedo: _controller.canRedo,
                onUndo: _controller.undo,
                onRedo: _controller.redo,
                undoIcon: widget.customUnDoIcon,
                redoIcon: widget.customReDoIcon,
              ),
              Expanded(child: _buildImage(context)),
              FittedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: _controller.isCropping,
                      child: CropRatioBar(
                        options: _ratioOptions,
                        selected: _controller.cropRatio,
                        onSelected: _controller.selectCropRatio,
                        backgroundColor: backgroundColor,
                      ),
                    ),
                    EditorToolbar(
                      isCropping: _controller.isCropping,
                      backgroundColor: backgroundColor,
                      onCancel: () => Navigator.maybePop(context),
                      onFlipHorizontal: _controller.flipHorizontal,
                      onFlipVertical: _controller.flipVertical,
                      onToggleCrop: _controller.toggleCropMode,
                      onRotateRight: _controller.rotateRight,
                      onConfirm: _confirm,
                      cancelText: widget.cancelText,
                      confirmText: widget.confirmText,
                      flipHorizontalIcon: widget.customFlipHorizonIcon,
                      flipVerticalIcon: widget.customFlipVerticalIcon,
                      cropIcon: widget.customCropImageIcon,
                      rotateRightIcon: widget.customRotateRightIcon,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return ExtendedImage(
      image: ExtendedMemoryImageProvider(
        _controller.image,
        cacheRawData: false,
      ),
      width: MediaQuery.sizeOf(context).width,
      mode: _controller.isCropping
          ? ExtendedImageMode.editor
          : ExtendedImageMode.none,
      fit: BoxFit.contain,
      clipBehavior: Clip.hardEdge,
      initEditorConfigHandler: (_) => EditorConfig(
        controller: _cropController,
        editorMaskColorHandler: (context, pointerDown) =>
            const Color.fromRGBO(28, 28, 40, 0.3),
        cornerColor: AppColor.light4,
        lineColor: AppColor.light2,
        initCropRectType: InitCropRectType.imageRect,
        maxScale: 5.0,
        cropRectPadding: EdgeInsets.zero,
        hitTestSize: 20.0,
        cropAspectRatio: _controller.cropRatio,
      ),
    );
  }
}
