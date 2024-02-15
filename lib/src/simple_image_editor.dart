import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_simple_image_editor/material/app_color.dart';
import 'package:flutter_simple_image_editor/material/app_text_style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_editor/image_editor.dart';

// ignore: must_be_immutable
class FlutterSimpleImageEditor extends StatefulWidget {
  Uint8List currentImg = Uint8List(0);
  List<Uint8List> imgList = [];

  /// Default value is false
  /// CropActive is callback status of cropMode if cropMode was ExtendedImageMode.editor this value will return true
  ValueChanged<bool>? cropActive;

  /// ImageByte was get by convert image (XFile) to Uint8List by using .readAsBytes and render into widget by using Image.memory(Uint8List)
  final Uint8List imageBytes;

  /// seting action when editing is complete will return edited image in Uint8List
  final void Function(Uint8List imgBytes) onConfirm;

  /// setting action when editing is error (ex. show error toast)
  final VoidCallback onError;
  int currentIndex;
  EditActionDetails? editorDetail;
  ExtendedImageMode cropMode;
  double cropRatio;
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

  FlutterSimpleImageEditor({
    super.key,
    required this.imageBytes,
    required this.onConfirm,
    required this.onError,
    this.currentIndex = 0,
    this.editorDetail,
    this.cropActive,
    this.cropMode = ExtendedImageMode.none,
    this.cropRatio = 0,
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
  });

  @override
  State<FlutterSimpleImageEditor> createState() =>
      _FlutterSimpleImageEditorState();
}

class _FlutterSimpleImageEditorState extends State<FlutterSimpleImageEditor> {
  @override
  void initState() {
    widget.currentImg = widget.imageBytes;
    widget.imgList = [widget.imageBytes];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            color: widget.backgroundColor ?? AppColor.dark0,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0)),
                Expanded(
                  child: ExtendedImage(
                    image: ExtendedMemoryImageProvider(widget.currentImg,
                        cacheRawData: false),
                    width: MediaQuery.of(context).size.width,
                    mode: widget.cropMode,
                    fit: BoxFit.contain,
                    clipBehavior: Clip.hardEdge,
                    initEditorConfigHandler: (_) => EditorConfig(
                      editorMaskColorHandler: (context, pointerDown) =>
                          const Color.fromRGBO(28, 28, 40, 0.3),
                      cornerColor: AppColor.light4,
                      lineColor: AppColor.light2,
                      editActionDetailsIsChanged: (details) async {
                        widget.editorDetail = details;
                      },
                      initCropRectType: InitCropRectType.imageRect,
                      maxScale: 5.0,
                      cropRectPadding: const EdgeInsets.all(0.0),
                      hitTestSize: 20.0,
                      cropAspectRatio: widget.cropRatio,
                    ),
                  ),
                ),
                FittedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: widget.cropMode == ExtendedImageMode.editor,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                          width: MediaQuery.of(context).size.width,
                          color: widget.backgroundColor ?? AppColor.dark0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ratioButton(
                                onPress: () {
                                  setState(() {
                                    widget.cropRatio = 0;
                                  });
                                },
                                isSelected: widget.cropRatio == 0,
                                text: widget.originalRatioText ?? 'Original',
                              ),
                              ratioButton(
                                onPress: () {
                                  setState(() {
                                    widget.cropRatio = 1;
                                  });
                                },
                                isSelected: widget.cropRatio == 1,
                                text: widget.oneOnOneRatioText ?? '1:1',
                              ),
                              ratioButton(
                                onPress: () {
                                  setState(() {
                                    widget.cropRatio = 3 / 2;
                                  });
                                },
                                isSelected: widget.cropRatio == 3 / 2,
                                text: widget.threeOnOtwRatioText ?? '3:2',
                              ),
                              ratioButton(
                                onPress: () {
                                  setState(() {
                                    widget.cropRatio = 4 / 3;
                                  });
                                },
                                isSelected: widget.cropRatio == 4 / 3,
                                text: widget.fourOnThreeRatioText ?? '4:3',
                              ),
                              ratioButton(
                                onPress: () {
                                  setState(() {
                                    widget.cropRatio = 16 / 9;
                                  });
                                },
                                isSelected: widget.cropRatio == 16 / 9,
                                text: widget.wideRatioWideText ?? '16:9',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: widget.backgroundColor ?? AppColor.dark0,
                        child: FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CupertinoButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                                child: widget.cancelText ??
                                    Text(
                                      'Cancel',
                                      style: AppTextStyle.body1
                                          .copyWith(color: AppColor.yellow1),
                                    ),
                              ),
                              CupertinoButton(
                                  onPressed: () async {
                                    // Flip Horizontal
                                    final ImageEditorOption option =
                                        ImageEditorOption();
                                    option.addOption(
                                        const FlipOption(horizontal: true));
                                    var z = await ImageEditor.editImage(
                                        image: widget.currentImg,
                                        imageEditorOption: option);
                                    setState(() {
                                      widget.cropMode = ExtendedImageMode.none;

                                      // Remove Previous Action ::  Legacy Version
                                      // if (widget.currentIndex !=
                                      //     widget.imgList.length - 1) {

                                      //   for (var i = widget.currentIndex;
                                      //       i < widget.imgList.length;
                                      //       i++) {
                                      //     log('current i $i');
                                      //     log('current length ${widget.imgList.length}');

                                      //     widget.imgList.removeAt(i + 1);
                                      //     log('removed ${i + 1}');
                                      //     log('after length ${widget.imgList.length}');
                                      //   }
                                      // }

                                      if (widget.currentIndex !=
                                          widget.imgList.length - 1) {
                                        var tempList = <Uint8List>[];
                                        for (var i = 0;
                                            i <= widget.currentIndex;
                                            i++) {
                                          tempList.add(widget.imgList[i]);
                                          if (i == widget.currentIndex) {
                                            widget.imgList = tempList;
                                          }
                                        }
                                      }

                                      widget.imgList.add(z!);
                                      widget.currentImg = z;
                                      widget.currentIndex =
                                          widget.imgList.length - 1;
                                    });
                                  },
                                  child: widget.customFlipHorizonIcon ??
                                      SvgPicture.asset(
                                        'assets/icons/flip_horizontal.svg',
                                        fit: BoxFit.contain,
                                        package: 'flutter_simple_image_editor',
                                        colorFilter: const ColorFilter.mode(
                                            AppColor.light0, BlendMode.srcIn),
                                      )),
                              CupertinoButton(
                                  onPressed: () async {
                                    // Flip Vertical
                                    final ImageEditorOption option =
                                        ImageEditorOption();
                                    option.addOption(
                                        const FlipOption(vertical: true));
                                    var editImage = await ImageEditor.editImage(
                                        image: widget.currentImg,
                                        imageEditorOption: option);
                                    setState(() {
                                      widget.cropMode = ExtendedImageMode.none;

                                      if (widget.currentIndex !=
                                          widget.imgList.length - 1) {
                                        var tempList = <Uint8List>[];
                                        for (var i = 0;
                                            i <= widget.currentIndex;
                                            i++) {
                                          tempList.add(widget.imgList[i]);
                                          if (i == widget.currentIndex) {
                                            widget.imgList = tempList;
                                          }
                                        }
                                      }

                                      widget.imgList.add(editImage!);
                                      widget.currentImg = editImage;
                                      widget.currentIndex =
                                          widget.imgList.length - 1;
                                    });
                                  },
                                  child: widget.customFlipVerticalIcon ??
                                      SvgPicture.asset(
                                        'assets/icons/flip_vertical.svg',
                                        fit: BoxFit.contain,
                                        package: 'flutter_simple_image_editor',
                                        colorFilter: const ColorFilter.mode(
                                            AppColor.light0, BlendMode.srcIn),
                                      )
                                  // Assets.icons.flipVertical
                                  //     .svg(fit: BoxFit.contain),
                                  ),
                              CupertinoButton(
                                onPressed: () async {
                                  setState(() {
                                    if (widget.cropMode !=
                                        ExtendedImageMode.editor) {
                                      widget.cropMode =
                                          ExtendedImageMode.editor;
                                    } else {
                                      widget.cropMode = ExtendedImageMode.none;
                                    }
                                  });
                                  widget.cropActive?.call(widget.cropMode ==
                                      ExtendedImageMode.editor);
                                },
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: widget.customCropImageIcon ??
                                      SvgPicture.asset(
                                        'assets/icons/crop_image.svg',
                                        fit: BoxFit.contain,
                                        package: 'flutter_simple_image_editor',
                                        colorFilter: ColorFilter.mode(
                                            widget.cropMode ==
                                                    ExtendedImageMode.editor
                                                ? AppColor.yellow1
                                                : AppColor.light0,
                                            BlendMode.srcIn),
                                      ),

                                  // Assets.icons.cropImage.svg(
                                  //     fit: BoxFit.contain,
                                  //     color: widget.cropMode ==
                                  //             ExtendedImageMode.editor
                                  //         ? AppColor.yellow1
                                  //         : AppColor.light0),
                                ),
                              ),
                              CupertinoButton(
                                onPressed: () async {
                                  final ImageEditorOption option =
                                      ImageEditorOption();
                                  option.addOption(const RotateOption(90));
                                  var z = await ImageEditor.editImage(
                                      image: widget.currentImg,
                                      imageEditorOption: option);
                                  setState(() {
                                    widget.editorDetail = null;
                                    widget.cropMode = ExtendedImageMode.none;

                                    if (widget.currentIndex !=
                                        widget.imgList.length - 1) {
                                      var tempList = <Uint8List>[];
                                      for (var i = 0;
                                          i <= widget.currentIndex;
                                          i++) {
                                        tempList.add(widget.imgList[i]);
                                        if (i == widget.currentIndex) {
                                          widget.imgList = tempList;
                                        }
                                      }
                                    }
                                    // Rotate

                                    widget.imgList.add(z!);

                                    widget.currentImg = z;
                                    widget.currentIndex =
                                        widget.imgList.length - 1;
                                  });
                                },
                                child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: SvgPicture.asset(
                                      'assets/icons/flip_right.svg',
                                      fit: BoxFit.contain,
                                      package: 'flutter_simple_image_editor',
                                      colorFilter: const ColorFilter.mode(
                                          AppColor.light0, BlendMode.srcIn),
                                    )
                                    // Assets.icons.flipRight
                                    //     .svg(fit: BoxFit.contain),
                                    ),
                              ),
                              CupertinoButton(
                                onPressed: () async {
                                  if (widget.editorDetail != null) {
                                    final editActionDetails =
                                        widget.editorDetail;
                                    // Crop frame
                                    Rect? cropScreen =
                                        editActionDetails!.screenCropRect;
                                    // locate crop place
                                    Rect? imageScreenRect =
                                        editActionDetails.screenDestinationRect;
                                    imageScreenRect = editActionDetails
                                        .paintRect(imageScreenRect!);
                                    cropScreen = editActionDetails
                                        .paintRect(cropScreen!);
                                    cropScreen = cropScreen
                                        .shift(-imageScreenRect.topLeft);
                                    imageScreenRect = imageScreenRect
                                        .shift(-imageScreenRect.topLeft);
                                    // Convert image Uint8List to ui.Image to get image React
                                    ui.Codec codec =
                                        await ui.instantiateImageCodec(
                                            widget.currentImg);
                                    ui.FrameInfo frame;
                                    try {
                                      frame = await codec.getNextFrame();
                                    } finally {
                                      codec.dispose();
                                    }
                                    // -------- ^^^^^^^^^---------

                                    final ui.Image image = frame.image;
                                    final Rect imageRect = Offset.zero &
                                        Size(image.width.toDouble(),
                                            image.height.toDouble());
                                    final double ratioX =
                                        imageRect.width / imageScreenRect.width;
                                    final double ratioY = imageRect.height /
                                        imageScreenRect.height;
                                    final Rect cropRect = Rect.fromLTWH(
                                        cropScreen.left * ratioX,
                                        cropScreen.top * ratioY,
                                        cropScreen.width * ratioX,
                                        cropScreen.height * ratioY);
                                    final cropImageRect = cropRect;
                                    final ImageEditorOption option =
                                        ImageEditorOption();

                                    option.addOption(
                                        ClipOption.fromRect(cropImageRect));
                                    var cropImg = await ImageEditor.editImage(
                                        image: widget.currentImg,
                                        imageEditorOption: option);

                                    if (cropImg != null) {
                                      widget.onConfirm(cropImg);
                                    } else {
                                      widget.onError.call();
                                    }
                                  } else {
                                    // In case user didn't drag crop frame to set value of 'EditActionDetails' have to init
                                    // Convert image Uint8List to ui.Image to get image React
                                    ui.Codec codec =
                                        await ui.instantiateImageCodec(
                                            widget.currentImg);
                                    ui.FrameInfo frame;
                                    try {
                                      frame = await codec.getNextFrame();
                                    } finally {
                                      codec.dispose();
                                    }
                                    // -------- ^^^^^^^^^---------
                                    final ui.Image image = frame.image;

                                    final imageWidth = image.width;
                                    final imageHeight = image.height;

                                    double rectWidth = 0;
                                    double rectHeight = 0;
                                    //==================================
                                    // initial crop rect by ratio
                                    //===================================
                                    // original ratio
                                    if (widget.cropRatio == 0) {
                                      rectWidth = imageWidth.toDouble();
                                      rectHeight = imageHeight.toDouble();
                                    }
                                    //  ratio 1:1
                                    if (widget.cropRatio == 1 &&
                                        imageWidth > imageHeight) {
                                      rectWidth = imageHeight.toDouble();
                                      rectHeight = imageHeight.toDouble();
                                    } else if (widget.cropRatio == 1 &&
                                        imageWidth < imageHeight) {
                                      rectWidth = imageWidth.toDouble();
                                      rectHeight = imageWidth.toDouble();
                                    }

                                    //  Ratio 3 : 2
                                    if (widget.cropRatio == 3 / 2 &&
                                        imageWidth > imageHeight) {
                                      var defaultValue = imageHeight;
                                      rectWidth = defaultValue * 3 / 2;
                                      rectHeight = defaultValue.toDouble();
                                    }
                                    if (widget.cropRatio == 3 / 2 &&
                                        imageHeight > imageWidth) {
                                      var defaultValue = imageWidth;
                                      rectWidth = defaultValue.toDouble();
                                      rectHeight = defaultValue * 2 / 3;
                                    }
                                    //  Ratio 4 : 3
                                    if (widget.cropRatio == 4 / 3 &&
                                        imageWidth > imageHeight) {
                                      var defaultValue = imageHeight;
                                      rectWidth = defaultValue * 4 / 3;
                                      rectHeight = defaultValue.toDouble();
                                    }
                                    if (widget.cropRatio == 4 / 3 &&
                                        imageHeight > imageWidth) {
                                      var defaultValue = imageWidth;
                                      rectWidth = defaultValue.toDouble();
                                      rectHeight = defaultValue * 3 / 4;
                                    }
                                    //  Ratio 16 : 9
                                    if (widget.cropRatio == 16 / 9 &&
                                        imageWidth > imageHeight) {
                                      var defaultValue = imageHeight;
                                      rectWidth = defaultValue * 16 / 9;
                                      rectHeight = defaultValue.toDouble();
                                    }
                                    if (widget.cropRatio == 16 / 9 &&
                                        imageHeight > imageWidth) {
                                      var defaultValue = imageWidth;
                                      rectWidth = defaultValue.toDouble();
                                      rectHeight = defaultValue * 9 / 16;
                                    }
                                    if (imageWidth - rectWidth < 0) {
                                      var widthDiff =
                                          (imageWidth - rectWidth).abs() / 2;
                                      rectHeight = imageHeight - widthDiff;
                                      rectWidth = imageWidth.toDouble();
                                    }
                                    if (imageHeight - rectHeight < 0) {
                                      var heightDiff =
                                          (imageHeight - rectHeight).abs() / 2;
                                      rectHeight = imageHeight.toDouble();
                                      rectWidth = imageWidth - heightDiff;
                                    }
                                    // Center Initail Crop Area
                                    var rectLeft = (imageWidth - rectWidth) / 2;
                                    var rectTop =
                                        (imageHeight - rectHeight) / 2;

                                    // Create the Rect
                                    final defaultRect = Rect.fromLTWH(rectLeft,
                                        rectTop, rectWidth, rectHeight);

                                    final ImageEditorOption option =
                                        ImageEditorOption();

                                    option.addOption(
                                        ClipOption.fromRect(defaultRect));
                                    var cropImg = await ImageEditor.editImage(
                                        image: widget.currentImg,
                                        imageEditorOption: option);
                                    if (cropImg != null) {
                                      widget.onConfirm.call(cropImg);
                                    } else {
                                      widget.onError.call();
                                    }
                                  }
                                },
                                child: widget.confirmText ??
                                    Text('Confirm',
                                        style: AppTextStyle.body1
                                            .copyWith(color: AppColor.yellow1)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
            width: MediaQuery.of(context).size.width,
            height: 50,
            color: widget.backgroundColor ?? AppColor.dark0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                    minSize: 0,
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      setState(() {
                        if (widget.currentIndex > 0) {
                          widget.currentImg =
                              widget.imgList[widget.currentIndex - 1];
                          widget.currentIndex = widget.currentIndex - 1;
                        }
                      });
                    },
                    child: widget.customUnDoIcon ??
                        Icon(
                          Icons.rotate_left,
                          color: widget.currentIndex > 0
                              ? AppColor.light4
                              : AppColor.dark3,
                        )),
                const SizedBox(width: 16),
                CupertinoButton(
                    minSize: 0,
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      setState(() {
                        if (widget.currentIndex < widget.imgList.length - 1) {
                          widget.currentImg =
                              widget.imgList[widget.currentIndex + 1];
                          widget.currentIndex = widget.currentIndex + 1;
                        }
                      });
                    },
                    child: widget.customReDoIcon ??
                        Icon(
                          Icons.rotate_right,
                          color: widget.currentIndex < widget.imgList.length - 1
                              ? AppColor.light4
                              : AppColor.dark3,
                        )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget ratioButton({
  required VoidCallback onPress,
  required bool isSelected,
  required String text,
}) {
  return CupertinoButton(
    padding: const EdgeInsets.all(0),
    minSize: 0,
    onPressed: onPress,
    child: Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      decoration: BoxDecoration(
        color: AppColor.light4.withOpacity(isSelected ? 0.4 : 0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        text,
        style: AppTextStyle.body2
            .copyWith(color: isSelected ? AppColor.light4 : AppColor.dark4),
      ),
    ),
  );
}
