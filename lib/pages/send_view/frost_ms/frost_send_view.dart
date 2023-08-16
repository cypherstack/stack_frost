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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stackfrost/models/isar/models/isar_models.dart';
import 'package:stackfrost/pages/coin_control/coin_control_view.dart';
import 'package:stackfrost/pages/send_view/frost_ms/frost_create_sign_config_view.dart';
import 'package:stackfrost/pages/send_view/frost_ms/recipient.dart';
import 'package:stackfrost/providers/frost_wallet/frost_wallet_providers.dart';
import 'package:stackfrost/providers/providers.dart';
import 'package:stackfrost/providers/ui/preview_tx_button_state_provider.dart';
import 'package:stackfrost/services/coins/bitcoin/frost_wallet.dart';
import 'package:stackfrost/themes/coin_icon_provider.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/amount/amount.dart';
import 'package:stackfrost/utilities/amount/amount_formatter.dart';
import 'package:stackfrost/utilities/constants.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';
import 'package:stackfrost/utilities/show_loading.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/utilities/util.dart';
import 'package:stackfrost/widgets/background.dart';
import 'package:stackfrost/widgets/conditional_parent.dart';
import 'package:stackfrost/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackfrost/widgets/custom_buttons/blue_text_button.dart';
import 'package:stackfrost/widgets/fee_slider.dart';
import 'package:stackfrost/widgets/icon_widgets/x_icon.dart';
import 'package:stackfrost/widgets/rounded_white_container.dart';
import 'package:stackfrost/widgets/stack_dialog.dart';
import 'package:stackfrost/widgets/stack_text_field.dart';
import 'package:stackfrost/widgets/textfield_icon_button.dart';
import 'package:tuple/tuple.dart';

class FrostSendView extends ConsumerStatefulWidget {
  const FrostSendView({
    Key? key,
    required this.walletId,
    required this.coin,
  }) : super(key: key);

  static const String routeName = "/frostSendView";

  final String walletId;
  final Coin coin;

  @override
  ConsumerState<FrostSendView> createState() => _FrostSendViewState();
}

class _FrostSendViewState extends ConsumerState<FrostSendView> {
  final List<int> recipientWidgetIndexes = [0];
  int _greatestWidgetIndex = 0;

  late final String walletId;
  late final Coin coin;

  late TextEditingController noteController;
  late TextEditingController onChainNoteController;

  final _noteFocusNode = FocusNode();

  Set<UTXO> selectedUTXOs = {};

  bool _createSignLock = false;

  Future<String> _loadingFuture() async {
    final wallet = ref
        .read(walletsChangeNotifierProvider)
        .getManager(walletId)
        .wallet as FrostWallet;

    final recipients = recipientWidgetIndexes
        .map((i) => ref.read(pRecipient(i).state).state)
        .map((e) => (address: e!.address, amount: e!.amount!))
        .toList(growable: false);

    final signConfig = await wallet.frostCreateSignConfig(
      outputs: recipients,
      changeAddress: (await wallet.currentReceivingAddress),
      feePerWeight: customFeeRate,
    );

    return signConfig;
  }

  Future<void> _createSignConfig() async {
    if (_createSignLock) {
      return;
    }
    _createSignLock = true;

    try {
      // wait for keyboard to disappear
      FocusScope.of(context).unfocus();
      await Future<void>.delayed(
        const Duration(milliseconds: 100),
      );

      String? config;
      if (mounted) {
        config = await showLoading<String>(
          whileFuture: _loadingFuture(),
          context: context,
          message: "Generating sign config",
          isDesktop: Util.isDesktop,
          onException: (e) {
            throw e;
          },
        );
      }

      if (mounted && config != null) {
        ref.read(pFrostSignConfig.notifier).state = config;

        await Navigator.of(context).pushNamed(
          FrostCreateSignConfigView.routeName,
          arguments: widget.walletId,
        );
      }
    } catch (e) {
      if (mounted) {
        unawaited(
          showDialog<dynamic>(
            context: context,
            useSafeArea: false,
            barrierDismissible: true,
            builder: (context) {
              return StackDialog(
                title: "Create sign config failed",
                message: e.toString(),
                rightButton: TextButton(
                  style: Theme.of(context)
                      .extension<StackColors>()!
                      .getSecondaryEnabledButtonStyle(context),
                  child: Text(
                    "Ok",
                    style: STextStyles.button(context).copyWith(
                        color: Theme.of(context)
                            .extension<StackColors>()!
                            .accentColorDark),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
          ),
        );
      }
    } finally {
      _createSignLock = false;
    }
  }

  int customFeeRate = 1;

  void _validateRecipientFormStates() {
    for (final i in recipientWidgetIndexes) {
      final state = ref.read(pRecipient(i).state).state;
      if (state?.amount == null || state?.address == null) {
        ref.read(previewTxButtonStateProvider.notifier).state = false;
        return;
      }
    }
    ref.read(previewTxButtonStateProvider.notifier).state = true;
    return;
  }

  @override
  void initState() {
    coin = widget.coin;
    walletId = widget.walletId;

    noteController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    noteController.dispose();

    _noteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");
    final manager = ref.watch(
      walletsChangeNotifierProvider.select(
        (value) => value.getManager(walletId),
      ),
    );
    final String locale = ref.watch(
      localeServiceChangeNotifierProvider.select(
        (value) => value.locale,
      ),
    );

    final showCoinControl = manager.hasCoinControlSupport &&
        ref.watch(
          prefsChangeNotifierProvider.select(
            (value) => value.enableCoinControl,
          ),
        );

    return ConditionalParent(
      condition: !Util.isDesktop,
      builder: (child) => Background(
        child: Scaffold(
          backgroundColor:
              Theme.of(context).extension<StackColors>()!.background,
          appBar: AppBar(
            leading: AppBarBackButton(
              onPressed: () async {
                if (FocusScope.of(context).hasFocus) {
                  FocusScope.of(context).unfocus();
                  await Future<void>.delayed(const Duration(milliseconds: 50));
                }
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
            title: Text(
              "Send ${coin.ticker}",
              style: STextStyles.navBarTitle(context),
            ),
          ),
          body: LayoutBuilder(
            builder: (builderContext, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    // subtract top and bottom padding set in parent
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: child,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).extension<StackColors>()!.popupBG,
              borderRadius: BorderRadius.circular(
                Constants.size.circularBorderRadius,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  SvgPicture.file(
                    File(
                      ref.watch(
                        coinIconProvider(coin),
                      ),
                    ),
                    width: 22,
                    height: 22,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        manager.walletName,
                        style: STextStyles.titleBold12(context)
                            .copyWith(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      // const SizedBox(
                      //   height: 2,
                      // ),
                      Text(
                        "Available balance",
                        style:
                            STextStyles.label(context).copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                  Util.isDesktop
                      ? const SizedBox(
                          height: 24,
                        )
                      : const Spacer(),
                  GestureDetector(
                    onTap: () {
                      // cryptoAmountController.text = ref
                      //     .read(pAmountFormatter(coin))
                      //     .format(
                      //       _cachedBalance!,
                      //       withUnitName: false,
                      //     );
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            ref
                                .watch(pAmountFormatter(coin))
                                .format(manager.balance.spendable),
                            style: STextStyles.titleBold12(context).copyWith(
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          Text(
                            "${(manager.balance.spendable.decimal * ref.watch(
                                      priceAnd24hChangeNotifierProvider.select(
                                        (value) => value.getPrice(coin).item1,
                                      ),
                                    )).toAmount(
                                  fractionDigits: 2,
                                ).fiatString(
                                  locale: locale,
                                )} ${ref.watch(
                              prefsChangeNotifierProvider
                                  .select((value) => value.currency),
                            )}",
                            style: STextStyles.subtitle(context).copyWith(
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.right,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recipients",
                style: STextStyles.smallMed12(context),
                textAlign: TextAlign.left,
              ),
              CustomTextButton(
                text: "Add",
                onTap: () {
                  // used for tracking recipient forms
                  _greatestWidgetIndex++;
                  recipientWidgetIndexes.add(_greatestWidgetIndex);
                  setState(() {});
                },
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Column(
            children: [
              for (int i = 0; i < recipientWidgetIndexes.length; i++)
                ConditionalParent(
                  condition: recipientWidgetIndexes.length > 1,
                  builder: (child) => Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: child,
                  ),
                  child: Recipient(
                    key: Key(
                      "recipientKey_${recipientWidgetIndexes[i]}",
                    ),
                    index: recipientWidgetIndexes[i],
                    coin: coin,
                    onChanged: () {
                      _validateRecipientFormStates();
                    },
                    remove: i == 0 && recipientWidgetIndexes.length == 1
                        ? null
                        : () {
                            recipientWidgetIndexes.removeAt(i);
                            setState(() {});
                          },
                  ),
                ),
            ],
          ),
          if (showCoinControl)
            const SizedBox(
              height: 8,
            ),
          if (showCoinControl)
            RoundedWhiteContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Coin control",
                    style: STextStyles.w500_14(context).copyWith(
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .textSubtitle1,
                    ),
                  ),
                  CustomTextButton(
                    text: selectedUTXOs.isEmpty
                        ? "Select coins"
                        : "Selected coins (${selectedUTXOs.length})",
                    onTap: () async {
                      if (FocusScope.of(context).hasFocus) {
                        FocusScope.of(context).unfocus();
                        await Future<void>.delayed(
                          const Duration(milliseconds: 100),
                        );
                      }

                      if (mounted) {
                        final spendable = ref
                            .read(walletsChangeNotifierProvider)
                            .getManager(widget.walletId)
                            .balance
                            .spendable;

                        Amount? amount;

                        final result = await Navigator.of(context).pushNamed(
                          CoinControlView.routeName,
                          arguments: Tuple4(
                            walletId,
                            CoinControlViewType.use,
                            amount,
                            selectedUTXOs,
                          ),
                        );

                        if (result is Set<UTXO>) {
                          setState(() {
                            selectedUTXOs = result;
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "Note (optional)",
            style: STextStyles.smallMed12(context),
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 8,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(
              Constants.size.circularBorderRadius,
            ),
            child: TextField(
              autocorrect: Util.isDesktop ? false : true,
              enableSuggestions: Util.isDesktop ? false : true,
              controller: noteController,
              focusNode: _noteFocusNode,
              style: STextStyles.field(context),
              onChanged: (_) => setState(() {}),
              decoration: standardInputDecoration(
                "Type something...",
                _noteFocusNode,
                context,
              ).copyWith(
                suffixIcon: noteController.text.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: UnconstrainedBox(
                          child: Row(
                            children: [
                              TextFieldIconButton(
                                child: const XIcon(),
                                onTap: () async {
                                  setState(() {
                                    noteController.text = "";
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 12,
              top: 16,
            ),
            child: FeeSlider(
              coin: coin,
              onSatVByteChanged: (rate) {
                customFeeRate = rate;
              },
            ),
          ),
          Util.isDesktop
              ? const SizedBox(
                  height: 12,
                )
              : const Spacer(),
          const SizedBox(
            height: 12,
          ),
          TextButton(
            onPressed: ref.watch(previewTxButtonStateProvider.state).state
                ? _createSignConfig
                : null,
            style: ref.watch(previewTxButtonStateProvider.state).state
                ? Theme.of(context)
                    .extension<StackColors>()!
                    .getPrimaryEnabledButtonStyle(context)
                : Theme.of(context)
                    .extension<StackColors>()!
                    .getPrimaryDisabledButtonStyle(context),
            child: Text(
              "Preview",
              style: STextStyles.button(context),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }
}
