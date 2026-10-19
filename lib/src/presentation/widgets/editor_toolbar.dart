import 'package:flutter/cupertino.dart';

import '../../../material/app_color.dart';
import '../../../material/app_text_style.dart';
import 'editor_icon.dart';

/// Bottom bar: cancel, flip, crop, rotate and confirm.
class EditorToolbar extends StatelessWidget {
  const EditorToolbar({
    super.key,
    required this.isCropping,
    required this.backgroundColor,
    required this.onCancel,
    required this.onFlipHorizontal,
    required this.onFlipVertical,
    required this.onToggleCrop,
    required this.onRotateRight,
    required this.onConfirm,
    this.cancelText,
    this.confirmText,
    this.flipHorizontalIcon,
    this.flipVerticalIcon,
    this.cropIcon,
    this.rotateRightIcon,
  });

  final bool isCropping;
  final Color backgroundColor;
  final VoidCallback onCancel;
  final VoidCallback onFlipHorizontal;
  final VoidCallback onFlipVertical;
  final VoidCallback onToggleCrop;
  final VoidCallback onRotateRight;
  final VoidCallback onConfirm;
  final Text? cancelText;
  final Text? confirmText;
  final Widget? flipHorizontalIcon;
  final Widget? flipVerticalIcon;
  final Widget? cropIcon;
  final Widget? rotateRightIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      color: backgroundColor,
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoButton(
              onPressed: onCancel,
              child: cancelText ?? _label('Cancel'),
            ),
            CupertinoButton(
              onPressed: onFlipHorizontal,
              child:
                  flipHorizontalIcon ??
                  const EditorIcon(EditorIcon.flipHorizontal),
            ),
            CupertinoButton(
              onPressed: onFlipVertical,
              child:
                  flipVerticalIcon ?? const EditorIcon(EditorIcon.flipVertical),
            ),
            CupertinoButton(
              onPressed: onToggleCrop,
              child: SizedBox.square(
                dimension: 24,
                child:
                    cropIcon ??
                    EditorIcon(
                      EditorIcon.crop,
                      color: isCropping ? AppColor.yellow1 : AppColor.light0,
                    ),
              ),
            ),
            CupertinoButton(
              onPressed: onRotateRight,
              child: SizedBox.square(
                dimension: 24,
                child:
                    rotateRightIcon ?? const EditorIcon(EditorIcon.rotateRight),
              ),
            ),
            CupertinoButton(
              onPressed: onConfirm,
              child: confirmText ?? _label('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  Text _label(String text) {
    return Text(
      text,
      style: AppTextStyle.body1.copyWith(color: AppColor.yellow1),
    );
  }
}
