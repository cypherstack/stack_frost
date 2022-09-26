import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';
import 'package:stackwallet/utilities/util.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/desktop/desktop_dialog.dart';
import 'package:stackwallet/widgets/desktop/primary_button.dart';
import 'package:stackwallet/widgets/desktop/secondary_button.dart';
import 'package:stackwallet/widgets/stack_dialog.dart';

class ConfirmRecoveryDialog extends StatelessWidget {
  const ConfirmRecoveryDialog({Key? key, required this.onConfirm})
      : super(key: key);

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    if (Util.isDesktop) {
      return DesktopDialog(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppBarIconButton(
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .textFieldDefaultBG,
                    size: 40,
                    icon: SvgPicture.asset(
                      Assets.svg.x,
                      color:
                          Theme.of(context).extension<StackColors>()!.textDark,
                      width: 22,
                      height: 22,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            SvgPicture.asset(
              Assets.svg.drd,
              width: 99,
              height: 70,
            ),
            const Spacer(),
            Text(
              "Restore wallet",
              style: STextStyles.desktopH2(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Restoring your wallet may take a while.\nPlease do not exit this screen once the process is started.",
              style: STextStyles.desktopTextMedium(context).copyWith(
                color: Theme.of(context).extension<StackColors>()!.textDark3,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                left: 32,
                right: 32,
                bottom: 32,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: "Cancel",
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: PrimaryButton(
                      label: "Restore",
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm.call();
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: StackDialog(
          title: "Are you ready?",
          message:
              "Restoring your wallet may take a while. Please do not exit this screen once the process is started.",
          leftButton: SecondaryButton(
            label: "Cancel",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          rightButton: PrimaryButton(
            label: "Restore",
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm.call();
            },
          ),
        ),
      );
    }
  }
}
