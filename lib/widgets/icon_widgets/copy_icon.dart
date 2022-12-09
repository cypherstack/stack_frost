import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';

class CopyIcon extends StatelessWidget {
  const CopyIcon({
    Key? key,
    this.width = 18,
    this.height = 18,
    this.color,
  }) : super(key: key);

  final double width;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Assets.svg.copy,
      width: width,
      height: height,
      color: color ?? Theme.of(context).extension<StackColors>()!.textDark3,
    );
  }
}
