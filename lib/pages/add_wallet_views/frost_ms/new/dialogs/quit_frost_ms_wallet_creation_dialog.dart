import 'package:flutter/material.dart';
import 'package:stackfrost/utilities/util.dart';
import 'package:stackfrost/widgets/desktop/primary_button.dart';
import 'package:stackfrost/widgets/desktop/secondary_button.dart';
import 'package:stackfrost/widgets/stack_dialog.dart';

class QuitFrostMSWalletCreationDialog extends StatelessWidget {
  const QuitFrostMSWalletCreationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return StackDialog(
      title: "Cancel wallet creation process",
      message: "Are you sure you want to cancel the wallet creation process?",
      leftButton: SecondaryButton(
        label: "No",
        onPressed: () {
          Navigator.of(context, rootNavigator: Util.isDesktop).pop(false);
        },
      ),
      rightButton: PrimaryButton(
        label: "Yes",
        onPressed: () {
          Navigator.of(context, rootNavigator: Util.isDesktop).pop(true);
        },
      ),
    );
  }
}
