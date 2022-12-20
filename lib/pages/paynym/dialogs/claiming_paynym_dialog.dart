import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';
import 'package:stackwallet/utilities/util.dart';
import 'package:stackwallet/widgets/desktop/desktop_dialog.dart';
import 'package:stackwallet/widgets/desktop/secondary_button.dart';
import 'package:stackwallet/widgets/stack_dialog.dart';

class ClaimingPaynymDialog extends StatefulWidget {
  const ClaimingPaynymDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<ClaimingPaynymDialog> createState() => _RestoringDialogState();
}

class _RestoringDialogState extends State<ClaimingPaynymDialog>
    with TickerProviderStateMixin {
  late AnimationController? _spinController;
  late Animation<double> _spinAnimation;

  @override
  void initState() {
    _spinController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _spinAnimation = CurvedAnimation(
      parent: _spinController!,
      curve: Curves.linear,
    );

    super.initState();
  }

  @override
  void dispose() {
    _spinController?.dispose();
    _spinController = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Util.isDesktop) {
      return DesktopDialog(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Claiming PayNym",
                style: STextStyles.desktopH3(context),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "We are generating your PayNym",
                style: STextStyles.desktopSubtitleH1(context),
              ),
              const SizedBox(
                height: 40,
              ),
              RotationTransition(
                turns: _spinAnimation,
                child: SvgPicture.asset(
                  Assets.svg.arrowRotate,
                  color: Theme.of(context)
                      .extension<StackColors>()!
                      .accentColorDark,
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: StackDialog(
          title: "Claiming PayNym",
          message: "We are generating your PayNym",
          icon: RotationTransition(
            turns: _spinAnimation,
            child: SvgPicture.asset(
              Assets.svg.arrowRotate,
              color:
                  Theme.of(context).extension<StackColors>()!.accentColorDark,
              width: 24,
              height: 24,
            ),
          ),
          rightButton: SecondaryButton(
            label: "Cancel",
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ),
      );
    }
  }
}
