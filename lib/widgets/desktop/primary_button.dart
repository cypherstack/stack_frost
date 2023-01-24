import 'package:flutter/material.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';
import 'package:stackwallet/utilities/util.dart';
import 'package:stackwallet/widgets/desktop/custom_text_button.dart';

export 'package:stackwallet/widgets/desktop/custom_text_button.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    this.width,
    this.height,
    this.label,
    this.icon,
    this.onPressed,
    this.enabled = true,
    this.buttonHeight,
    this.iconSpacing = 10,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? label;
  final VoidCallback? onPressed;
  final bool enabled;
  final Widget? icon;
  final ButtonHeight? buttonHeight;
  final double? iconSpacing;

  TextStyle getStyle(bool isDesktop, BuildContext context) {
    if (isDesktop) {
      if (buttonHeight == null) {
        return enabled
            ? STextStyles.desktopButtonEnabled(context)
            : STextStyles.desktopButtonDisabled(context);
      }

      switch (buttonHeight!) {
        case ButtonHeight.xxs:
        case ButtonHeight.xs:
        case ButtonHeight.s:
          return STextStyles.desktopTextExtraExtraSmall(context).copyWith(
            color: enabled
                ? Theme.of(context).extension<StackColors>()!.buttonTextPrimary
                : Theme.of(context)
                    .extension<StackColors>()!
                    .buttonTextPrimaryDisabled,
          );

        case ButtonHeight.m:
        case ButtonHeight.l:
          return STextStyles.desktopTextExtraSmall(context).copyWith(
            color: enabled
                ? Theme.of(context).extension<StackColors>()!.buttonTextPrimary
                : Theme.of(context)
                    .extension<StackColors>()!
                    .buttonTextPrimaryDisabled,
          );

        case ButtonHeight.xl:
        case ButtonHeight.xxl:
          return enabled
              ? STextStyles.desktopButtonEnabled(context)
              : STextStyles.desktopButtonDisabled(context);
      }
    } else {
      if (buttonHeight == ButtonHeight.l) {
        return STextStyles.button(context).copyWith(
          fontSize: 10,
          color: enabled
              ? Theme.of(context).extension<StackColors>()!.buttonTextPrimary
              : Theme.of(context)
                  .extension<StackColors>()!
                  .buttonTextPrimaryDisabled,
        );
      }
      return STextStyles.button(context).copyWith(
        color: enabled
            ? Theme.of(context).extension<StackColors>()!.buttonTextPrimary
            : Theme.of(context)
                .extension<StackColors>()!
                .buttonTextPrimaryDisabled,
      );
    }
  }

  double? _getHeight() {
    if (buttonHeight == null) {
      return height;
    }

    if (Util.isDesktop) {
      switch (buttonHeight!) {
        case ButtonHeight.xxs:
          return 32;
        case ButtonHeight.xs:
          return 37;
        case ButtonHeight.s:
          return 40;
        case ButtonHeight.m:
          return 48;
        case ButtonHeight.l:
          return 56;
        case ButtonHeight.xl:
          return 70;
        case ButtonHeight.xxl:
          return 96;
      }
    } else {
      switch (buttonHeight!) {
        case ButtonHeight.xxs:
        case ButtonHeight.xs:
        case ButtonHeight.s:
        case ButtonHeight.m:
          return 28;
        case ButtonHeight.l:
          return 30;
        case ButtonHeight.xl:
          return 46;
        case ButtonHeight.xxl:
          return 56;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Util.isDesktop;

    return CustomTextButtonBase(
      height: _getHeight(),
      width: width,
      textButton: TextButton(
        onPressed: enabled ? onPressed : null,
        style: enabled
            ? Theme.of(context)
                .extension<StackColors>()!
                .getPrimaryEnabledButtonStyle(context)
            : Theme.of(context)
                .extension<StackColors>()!
                .getPrimaryDisabledButtonStyle(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            if (icon != null && label != null)
              SizedBox(
                width: iconSpacing,
              ),
            if (label != null)
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    label!,
                    style: getStyle(isDesktop, context),
                  ),
                  if (buttonHeight != null && buttonHeight == ButtonHeight.s)
                    const SizedBox(
                      height: 2,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
