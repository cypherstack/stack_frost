/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stackfrost/notifications/show_flush_bar.dart';
import 'package:stackfrost/pages/add_wallet_views/new_wallet_recovery_phrase_view/sub_widgets/mnemonic_table.dart';
import 'package:stackfrost/pages_desktop_specific/my_stack_view/wallet_view/sub_widgets/qr_code_desktop_popup_content.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/address_utils.dart';
import 'package:stackfrost/utilities/assets.dart';
import 'package:stackfrost/utilities/clipboard_interface.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/widgets/desktop/desktop_dialog.dart';
import 'package:stackfrost/widgets/desktop/desktop_dialog_close_button.dart';
import 'package:stackfrost/widgets/desktop/primary_button.dart';
import 'package:stackfrost/widgets/desktop/secondary_button.dart';

class WalletKeysDesktopPopup extends StatelessWidget {
  const WalletKeysDesktopPopup({
    Key? key,
    required this.words,
    this.frostData,
    this.clipboardInterface = const ClipboardWrapper(),
  }) : super(key: key);

  final List<String> words;
  final ({String keys, String config})? frostData;
  final ClipboardInterface clipboardInterface;

  static const String routeName = "walletKeysDesktopPopup";

  @override
  Widget build(BuildContext context) {
    return DesktopDialog(
      maxWidth: 614,
      maxHeight: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 32,
                ),
                child: Text(
                  "Wallet keys",
                  style: STextStyles.desktopH3(context),
                ),
              ),
              DesktopDialogCloseButton(
                onPressedOverride: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          ),
          const SizedBox(
            height: 28,
          ),
          frostData != null
              ? Column(
                  children: [
                    Text(
                      "Keys",
                      style: STextStyles.desktopTextMedium(context),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                        ),
                        child: SelectableText(
                          frostData!.keys,
                          style:
                              STextStyles.desktopTextExtraExtraSmall(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Config",
                      style: STextStyles.desktopTextMedium(context),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                        ),
                        child: SelectableText(
                          frostData!.config,
                          style:
                              STextStyles.desktopTextExtraExtraSmall(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                )
              : Column(
                  children: [
                    Text(
                      "Recovery phrase",
                      style: STextStyles.desktopTextMedium(context),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                        ),
                        child: Text(
                          "Please write down your recovery phrase in the correct order and save it to keep your funds secure. You will also be asked to verify the words on the next screen.",
                          style:
                              STextStyles.desktopTextExtraExtraSmall(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                      ),
                      child: MnemonicTable(
                        words: words,
                        isDesktop: true,
                        itemBorderColor: Theme.of(context)
                            .extension<StackColors>()!
                            .buttonBackSecondary,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SecondaryButton(
                              label: "Show QR code",
                              onPressed: () {
                                // TODO: address utils
                                final String value =
                                    AddressUtils.encodeQRSeedData(words);
                                Navigator.of(context).pushNamed(
                                  QRCodeDesktopPopupContent.routeName,
                                  arguments: value,
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: PrimaryButton(
                              label: "Copy",
                              onPressed: () async {
                                await clipboardInterface.setData(
                                  ClipboardData(text: words.join(" ")),
                                );
                                if (context.mounted) {
                                  unawaited(
                                    showFloatingFlushBar(
                                      type: FlushBarType.info,
                                      message: "Copied to clipboard",
                                      iconAsset: Assets.svg.copy,
                                      context: context,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
