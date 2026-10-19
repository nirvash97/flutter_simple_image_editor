import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../material/app_color.dart';

/// Undo / redo buttons shown above the image.
class HistoryBar extends StatelessWidget {
  const HistoryBar({
    super.key,
    required this.canUndo,
    required this.canRedo,
    required this.onUndo,
    required this.onRedo,
    this.undoIcon,
    this.redoIcon,
  });

  final bool canUndo;
  final bool canRedo;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final Widget? undoIcon;
  final Widget? redoIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _button(
            onPressed: onUndo,
            child: undoIcon ?? _defaultIcon(Icons.rotate_left, canUndo),
          ),
          const SizedBox(width: 16),
          _button(
            onPressed: onRedo,
            child: redoIcon ?? _defaultIcon(Icons.rotate_right, canRedo),
          ),
        ],
      ),
    );
  }

  Widget _button({required VoidCallback onPressed, required Widget child}) {
    return CupertinoButton(
      minimumSize: Size.zero,
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: child,
    );
  }

  Widget _defaultIcon(IconData icon, bool enabled) {
    return Icon(icon, color: enabled ? AppColor.light4 : AppColor.dark3);
  }
}
