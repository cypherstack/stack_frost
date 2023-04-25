import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';
import 'package:stackwallet/utilities/util.dart';

class AddCustomTokenSelector extends StatelessWidget {
  const AddCustomTokenSelector({
    Key? key,
    required this.addFunction,
  }) : super(key: key);

  final VoidCallback addFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: MaterialButton(
        key: const Key("coinSelectItemButtonKey_add_custom"),
        padding: Util.isDesktop
            ? const EdgeInsets.only(left: 24)
            : const EdgeInsets.all(12),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Constants.size.circularBorderRadius,
          ),
        ),
        onPressed: addFunction,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: Util.isDesktop ? 70 : 0,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.svg.circlePlusFilled,
                color: Theme.of(context).extension<StackColors>()!.textDark,
                width: 26,
                height: 26,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                "Add custom token",
                style: Util.isDesktop
                    ? STextStyles.desktopTextMedium(context)
                    : STextStyles.w600_14(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
