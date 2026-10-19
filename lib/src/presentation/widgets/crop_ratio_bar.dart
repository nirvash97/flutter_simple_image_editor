import 'package:flutter/cupertino.dart';

import '../../../material/app_color.dart';
import '../../../material/app_text_style.dart';

/// A crop ratio choice: [ratio] is width / height, see `CropRatio`.
typedef CropRatioOption = ({double ratio, String label});

/// Row of crop ratio choices shown in crop mode.
class CropRatioBar extends StatelessWidget {
  const CropRatioBar({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.backgroundColor,
  });

  final List<CropRatioOption> options;
  final double selected;
  final ValueChanged<double> onSelected;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      width: MediaQuery.sizeOf(context).width,
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final option in options)
            ratioButton(
              onPress: () => onSelected(option.ratio),
              isSelected: option.ratio == selected,
              text: option.label,
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
    padding: EdgeInsets.zero,
    minimumSize: Size.zero,
    onPressed: onPress,
    child: Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      decoration: BoxDecoration(
        color: AppColor.light4.withValues(alpha: isSelected ? 0.4 : 0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        text,
        style: AppTextStyle.body2.copyWith(
          color: isSelected ? AppColor.light4 : AppColor.dark4,
        ),
      ),
    ),
  );
}
