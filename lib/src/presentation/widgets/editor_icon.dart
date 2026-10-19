import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../material/app_color.dart';

/// 24 px SVG icon bundled with this package.
class EditorIcon extends StatelessWidget {
  const EditorIcon(this.asset, {super.key, this.color = AppColor.light0});

  static const flipHorizontal = 'assets/icons/flip_horizontal.svg';
  static const flipVertical = 'assets/icons/flip_vertical.svg';
  static const crop = 'assets/icons/crop_image.svg';
  static const rotateRight = 'assets/icons/flip_right.svg';

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 24,
      child: SvgPicture.asset(
        asset,
        fit: BoxFit.contain,
        package: 'flutter_simple_image_editor',
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}
