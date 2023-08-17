import 'package:flutter/material.dart';
import 'package:stackfrost/utilities/util.dart';
import 'package:stackfrost/widgets/desktop/primary_button.dart';
import 'package:stackfrost/widgets/desktop/secondary_button.dart';
import 'package:stackfrost/widgets/stack_dialog.dart';

enum FrostQuitDialogType {
  walletCreation,
  transactionCreation;
}

class QuitFrostMSWalletProcessDialog extends StatelessWidget {
  const QuitFrostMSWalletProcessDialog({super.key, required this.type});

  final FrostQuitDialogType type;

  String get message {
    switch (type) {
      case FrostQuitDialogType.walletCreation:
        return "wallet creation";
      case FrostQuitDialogType.transactionCreation:
        return "transaction signing";
    }
  }

  @override
  Widget build(BuildContext context) {
    return StackDialog(
      title: "Cancel $message process",
      message: "Are you sure you want to cancel the $message process?",
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
