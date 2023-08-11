/*
 * This file is part of Stack Wallet.
 *
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackfrost/pages/settings_views/wallet_settings_view/frost_ms/frost_participants_view.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/constants.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/widgets/background.dart';
import 'package:stackfrost/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackfrost/widgets/rounded_white_container.dart';

class FrostMSWalletOptionsView extends ConsumerWidget {
  const FrostMSWalletOptionsView({
    Key? key,
    required this.walletId,
  }) : super(key: key);

  static const String routeName = "/frostMSWalletOptionsView";

  final String walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Background(
      child: Scaffold(
        backgroundColor: Theme.of(context).extension<StackColors>()!.background,
        appBar: AppBar(
          leading: AppBarBackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Multisig settings",
            style: STextStyles.navBarTitle(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            top: 12,
            left: 16,
            right: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _OptionButton(
                  label: "Show participants",
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      FrostParticipantsView.routeName,
                      arguments: walletId,
                    );
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                _OptionButton(
                  label: "Add participant",
                  onPressed: () {},
                ),
                const SizedBox(
                  height: 8,
                ),
                _OptionButton(
                  label: "Remove participant",
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RoundedWhiteContainer(
      padding: const EdgeInsets.all(0),
      child: RawMaterialButton(
        // splashColor: Theme.of(context).extension<StackColors>()!.highlight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Constants.size.circularBorderRadius,
          ),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 20,
          ),
          child: Row(
            children: [
              Text(
                label,
                style: STextStyles.titleBold12(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
