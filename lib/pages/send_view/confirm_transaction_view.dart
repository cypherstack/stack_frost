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
import 'package:flutter_svg/svg.dart';
import 'package:stackfrost/models/tx_data.dart';
import 'package:stackfrost/notifications/show_flush_bar.dart';
import 'package:stackfrost/pages/pinpad_views/lock_screen_view.dart';
import 'package:stackfrost/pages/send_view/sub_widgets/sending_transaction_dialog.dart';
import 'package:stackfrost/pages/wallet_view/wallet_view.dart';
import 'package:stackfrost/pages_desktop_specific/coin_control/desktop_coin_control_use_dialog.dart';
import 'package:stackfrost/pages_desktop_specific/my_stack_view/wallet_view/sub_widgets/desktop_auth_send.dart';
import 'package:stackfrost/providers/providers.dart';
import 'package:stackfrost/route_generator.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/themes/theme_providers.dart';
import 'package:stackfrost/utilities/amount/amount_formatter.dart';
import 'package:stackfrost/utilities/constants.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/utilities/util.dart';
import 'package:stackfrost/widgets/background.dart';
import 'package:stackfrost/widgets/conditional_parent.dart';
import 'package:stackfrost/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackfrost/widgets/desktop/desktop_dialog.dart';
import 'package:stackfrost/widgets/desktop/desktop_dialog_close_button.dart';
import 'package:stackfrost/widgets/desktop/primary_button.dart';
import 'package:stackfrost/widgets/icon_widgets/x_icon.dart';
import 'package:stackfrost/widgets/rounded_container.dart';
import 'package:stackfrost/widgets/rounded_white_container.dart';
import 'package:stackfrost/widgets/stack_dialog.dart';
import 'package:stackfrost/widgets/stack_text_field.dart';
import 'package:stackfrost/widgets/textfield_icon_button.dart';

class ConfirmTransactionView extends ConsumerStatefulWidget {
  const ConfirmTransactionView({
    Key? key,
    required this.transactionInfo,
    required this.walletId,
    this.routeOnSuccessName = WalletView.routeName,
    this.isTradeTransaction = false,
    this.onSuccessInsteadOfRouteOnSuccess,
  }) : super(key: key);

  static const String routeName = "/confirmTransactionView";

  final TxData transactionInfo;
  final String walletId;
  final String routeOnSuccessName;
  final bool isTradeTransaction;
  final VoidCallback? onSuccessInsteadOfRouteOnSuccess;

  @override
  ConsumerState<ConfirmTransactionView> createState() =>
      _ConfirmTransactionViewState();
}

class _ConfirmTransactionViewState
    extends ConsumerState<ConfirmTransactionView> {
  late final TxData transactionInfo;
  late final String walletId;
  late final String routeOnSuccessName;
  late final bool isDesktop;

  late final FocusNode _noteFocusNode;
  late final TextEditingController noteController;

  late final FocusNode _onChainNoteFocusNode;
  late final TextEditingController onChainNoteController;

  Future<void> _attemptSend(BuildContext context) async {
    final manager =
        ref.read(walletsChangeNotifierProvider).getManager(walletId);

    final sendProgressController = ProgressAndSuccessController();

    unawaited(
      showDialog<dynamic>(
        context: context,
        useSafeArea: false,
        barrierDismissible: false,
        builder: (context) {
          return SendingTransactionDialog(
            coin: manager.coin,
            controller: sendProgressController,
          );
        },
      ),
    );

    final time = Future<dynamic>.delayed(
      const Duration(
        milliseconds: 2500,
      ),
    );

    late String txid;
    Future<TxData> txidFuture;

    final note = noteController.text;

    try {
      txidFuture = manager.confirmSend(txData: transactionInfo);

      final results = await Future.wait([
        txidFuture,
        time,
      ]);

      sendProgressController.triggerSuccess?.call();
      await Future<void>.delayed(const Duration(seconds: 5));

      final txData = results.first as TxData;
      txid = txData.txid!;
      ref.refresh(desktopUseUTXOs);

      // save note
      await ref
          .read(notesServiceChangeNotifierProvider(walletId))
          .editOrAddNote(txid: txid, note: note);

      unawaited(manager.refresh());

      // pop back to wallet
      if (mounted) {
        if (widget.onSuccessInsteadOfRouteOnSuccess == null) {
          Navigator.of(context)
              .popUntil(ModalRoute.withName(routeOnSuccessName));
        } else {
          widget.onSuccessInsteadOfRouteOnSuccess!.call();
        }
      }
    } catch (e, s) {
      //todo: comeback to this
      debugPrint("$e\n$s");
      // pop sending dialog
      Navigator.of(context).pop();

      await showDialog<void>(
        context: context,
        useSafeArea: false,
        barrierDismissible: true,
        builder: (context) {
          if (isDesktop) {
            return DesktopDialog(
              maxWidth: 450,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Broadcast transaction failed",
                      style: STextStyles.desktopH3(context),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      e.toString(),
                      style: STextStyles.smallMed14(context),
                    ),
                    const SizedBox(
                      height: 56,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Expanded(
                          child: PrimaryButton(
                            buttonHeight: ButtonHeight.l,
                            label: "Ok",
                            onPressed: Navigator.of(context).pop,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return StackDialog(
              title: "Broadcast transaction failed",
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
          }
        },
      );
    }
  }

  @override
  void initState() {
    isDesktop = Util.isDesktop;
    transactionInfo = widget.transactionInfo;
    walletId = widget.walletId;
    routeOnSuccessName = widget.routeOnSuccessName;
    _noteFocusNode = FocusNode();
    noteController = TextEditingController();
    noteController.text = transactionInfo.note ?? "";

    _onChainNoteFocusNode = FocusNode();
    onChainNoteController = TextEditingController();
    onChainNoteController.text = transactionInfo.noteOnChain ?? "";

    super.initState();
  }

  @override
  void dispose() {
    noteController.dispose();
    onChainNoteController.dispose();

    _noteFocusNode.dispose();
    _onChainNoteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final managerProvider = ref.watch(walletsChangeNotifierProvider
        .select((value) => value.getManagerProvider(walletId)));

    final coin = ref.watch(walletsChangeNotifierProvider
        .select((value) => value.getManager(walletId).coin));

    final String unit;
    unit = coin.ticker;

    return ConditionalParent(
      condition: !isDesktop,
      builder: (child) => Background(
        child: Scaffold(
          backgroundColor:
              Theme.of(context).extension<StackColors>()!.background,
          appBar: AppBar(
            backgroundColor:
                Theme.of(context).extension<StackColors>()!.background,
            leading: AppBarBackButton(
              onPressed: () async {
                // if (FocusScope.of(context).hasFocus) {
                //   FocusScope.of(context).unfocus();
                //   await Future<void>.delayed(Duration(milliseconds: 50));
                // }
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              "Confirm transaction",
              style: STextStyles.navBarTitle(context),
            ),
          ),
          body: LayoutBuilder(
            builder: (builderContext, constraints) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  top: 12,
                  right: 12,
                ),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 24,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: child,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      child: ConditionalParent(
        condition: isDesktop,
        builder: (child) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                AppBarBackButton(
                  size: 40,
                  iconSize: 24,
                  onPressed: () => Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pop(),
                ),
                Text(
                  "Confirm $unit transaction",
                  style: STextStyles.desktopH3(context),
                ),
              ],
            ),
            child,
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: isDesktop ? MainAxisSize.min : MainAxisSize.max,
          children: [
            if (!isDesktop)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Send $unit",
                    style: STextStyles.pageTitleH1(context),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  RoundedWhiteContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Recipient",
                          style: STextStyles.smallMed12(context),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          transactionInfo.recipients?.first.address ?? "ERROR",
                          style: STextStyles.itemSubtitle12(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  RoundedWhiteContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Amount",
                          style: STextStyles.smallMed12(context),
                        ),
                        Text(
                          ref.watch(pAmountFormatter(coin)).format(
                                transactionInfo.amount!,
                              ),
                          style: STextStyles.itemSubtitle12(context),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  RoundedWhiteContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Transaction fee",
                          style: STextStyles.smallMed12(context),
                        ),
                        Text(
                          ref
                              .watch(pAmountFormatter(coin))
                              .format(transactionInfo.fee!),
                          style: STextStyles.itemSubtitle12(context),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  if (transactionInfo.estimatedSatsPerVByte != null)
                    const SizedBox(
                      height: 12,
                    ),
                  if (transactionInfo.estimatedSatsPerVByte != null)
                    RoundedWhiteContainer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "sats/vByte",
                            style: STextStyles.smallMed12(context),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "~${transactionInfo.estimatedSatsPerVByte!}",
                            style: STextStyles.itemSubtitle12(context),
                          ),
                        ],
                      ),
                    ),
                  if (transactionInfo.noteOnChain != null &&
                      transactionInfo.noteOnChain!.isNotEmpty)
                    const SizedBox(
                      height: 12,
                    ),
                  if (transactionInfo.noteOnChain != null &&
                      transactionInfo.noteOnChain!.isNotEmpty)
                    RoundedWhiteContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "On chain note",
                            style: STextStyles.smallMed12(context),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            transactionInfo.noteOnChain!,
                            style: STextStyles.itemSubtitle12(context),
                          ),
                        ],
                      ),
                    ),
                  if (transactionInfo.note != null &&
                      transactionInfo.note!.isNotEmpty)
                    const SizedBox(
                      height: 12,
                    ),
                  if (transactionInfo.note != null &&
                      transactionInfo.note!.isNotEmpty)
                    RoundedWhiteContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Note",
                            style: STextStyles.smallMed12(context),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            transactionInfo.note!,
                            style: STextStyles.itemSubtitle12(context),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            if (isDesktop)
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 32,
                  right: 32,
                  bottom: 50,
                ),
                child: RoundedWhiteContainer(
                  padding: const EdgeInsets.all(0),
                  borderColor:
                      Theme.of(context).extension<StackColors>()!.background,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .extension<StackColors>()!
                              .background,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              Constants.size.circularBorderRadius,
                            ),
                            topRight: Radius.circular(
                              Constants.size.circularBorderRadius,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 22,
                          ),
                          child: Row(
                            children: [
                              SvgPicture.file(
                                File(
                                  ref.watch(
                                    themeProvider.select(
                                      (value) => value.assets.send,
                                    ),
                                  ),
                                ),
                                width: 32,
                                height: 32,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(
                                "Send $unit",
                                style: STextStyles.desktopTextMedium(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Amount",
                              style: STextStyles.desktopTextExtraExtraSmall(
                                  context),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Builder(
                              builder: (context) {
                                final coin = ref.watch(
                                  managerProvider.select(
                                    (value) => value.coin,
                                  ),
                                );
                                final amount = transactionInfo.amount!;
                                final externalCalls = coin.isTestNet
                                    ? false
                                    : ref.watch(
                                        prefsChangeNotifierProvider.select(
                                            (value) => value.externalCalls));
                                String fiatAmount = "N/A";

                                // if (externalCalls) {
                                //   final price = ref
                                //       .read(priceAnd24hChangeNotifierProvider)
                                //       .getPrice(coin)
                                //       .item1;
                                //   if (price > Decimal.zero) {
                                //     fiatAmount = (amount.decimal * price)
                                //         .toAmount(fractionDigits: 2)
                                //         .fiatString(
                                //           locale: ref
                                //               .read(
                                //                   localeServiceChangeNotifierProvider)
                                //               .locale,
                                //         );
                                //   }
                                // }

                                return Row(
                                  children: [
                                    Text(
                                      ref.watch(pAmountFormatter(coin)).format(
                                            amount,
                                          ),
                                      style: STextStyles
                                              .desktopTextExtraExtraSmall(
                                                  context)
                                          .copyWith(
                                        color: Theme.of(context)
                                            .extension<StackColors>()!
                                            .textDark,
                                      ),
                                    ),
                                    if (externalCalls)
                                      Text(
                                        " | ",
                                        style: STextStyles
                                            .desktopTextExtraExtraSmall(
                                                context),
                                      ),
                                    if (externalCalls)
                                      Text(
                                        "~$fiatAmount ${ref.watch(prefsChangeNotifierProvider.select(
                                          (value) => value.currency,
                                        ))}",
                                        style: STextStyles
                                            .desktopTextExtraExtraSmall(
                                                context),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Theme.of(context)
                            .extension<StackColors>()!
                            .background,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Send to",
                              style: STextStyles.desktopTextExtraExtraSmall(
                                  context),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              transactionInfo.recipients?.first.address ??
                                  "ERROR",
                              style: STextStyles.desktopTextExtraExtraSmall(
                                      context)
                                  .copyWith(
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .textDark,
                              ),
                            )
                          ],
                        ),
                      ),
                      // Container(
                      //   height: 1,
                      //   color: Theme.of(context)
                      //       .extension<StackColors>()!
                      //       .background,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(12),
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         "Note",
                      //         style: STextStyles.desktopTextExtraExtraSmall(
                      //             context),
                      //       ),
                      //       const SizedBox(
                      //         height: 2,
                      //       ),
                      //       Text(
                      //         transactionInfo["note"] as String,
                      //         style: STextStyles.desktopTextExtraExtraSmall(
                      //                 context)
                      //             .copyWith(
                      //           color: Theme.of(context)
                      //               .extension<StackColors>()!
                      //               .textDark,
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            if (isDesktop)
              Padding(
                padding: const EdgeInsets.only(
                  left: 32,
                  right: 32,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Note (optional)",
                      style:
                          STextStyles.desktopTextExtraSmall(context).copyWith(
                        color: Theme.of(context)
                            .extension<StackColors>()!
                            .textFieldActiveSearchIconRight,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        Constants.size.circularBorderRadius,
                      ),
                      child: TextField(
                        minLines: 1,
                        maxLines: 5,
                        autocorrect: isDesktop ? false : true,
                        enableSuggestions: isDesktop ? false : true,
                        controller: noteController,
                        focusNode: _noteFocusNode,
                        style:
                            STextStyles.desktopTextExtraSmall(context).copyWith(
                          color: Theme.of(context)
                              .extension<StackColors>()!
                              .textFieldActiveText,
                          height: 1.8,
                        ),
                        onChanged: (_) => setState(() {}),
                        decoration: standardInputDecoration(
                          "Type something...",
                          _noteFocusNode,
                          context,
                          desktopMed: true,
                        ).copyWith(
                          contentPadding: const EdgeInsets.only(
                            left: 16,
                            top: 11,
                            bottom: 12,
                            right: 5,
                          ),
                          suffixIcon: noteController.text.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 0),
                                  child: UnconstrainedBox(
                                    child: Row(
                                      children: [
                                        TextFieldIconButton(
                                          child: const XIcon(),
                                          onTap: () async {
                                            setState(
                                              () => noteController.text = "",
                                            );
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
                      height: 20,
                    )
                  ],
                ),
              ),
            if (isDesktop)
              Padding(
                padding: const EdgeInsets.only(
                  left: 32,
                ),
                child: Text(
                  "Transaction fee",
                  style: STextStyles.desktopTextExtraExtraSmall(context),
                ),
              ),
            if (isDesktop)
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 32,
                  right: 32,
                ),
                child: RoundedContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  color: Theme.of(context)
                      .extension<StackColors>()!
                      .textFieldDefaultBG,
                  child: Builder(
                    builder: (context) {
                      final coin = ref
                          .watch(walletsChangeNotifierProvider
                              .select((value) => value.getManager(walletId)))
                          .coin;

                      final fee = transactionInfo.fee!;

                      return Text(
                        ref.watch(pAmountFormatter(coin)).format(fee),
                        style: STextStyles.itemSubtitle(context),
                      );
                    },
                  ),
                ),
              ),
            if (isDesktop && transactionInfo.estimatedSatsPerVByte != null)
              Padding(
                padding: const EdgeInsets.only(
                  left: 32,
                ),
                child: Text(
                  "sats/vByte",
                  style: STextStyles.desktopTextExtraExtraSmall(context),
                ),
              ),
            if (isDesktop && transactionInfo.estimatedSatsPerVByte != null)
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 32,
                  right: 32,
                ),
                child: RoundedContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  color: Theme.of(context)
                      .extension<StackColors>()!
                      .textFieldDefaultBG,
                  child: Text(
                    "~${transactionInfo.estimatedSatsPerVByte!}",
                    style: STextStyles.itemSubtitle(context),
                  ),
                ),
              ),
            if (!isDesktop) const Spacer(),
            SizedBox(
              height: isDesktop ? 23 : 12,
            ),
            Padding(
              padding: isDesktop
                  ? const EdgeInsets.symmetric(
                      horizontal: 32,
                    )
                  : const EdgeInsets.all(0),
              child: RoundedContainer(
                padding: isDesktop
                    ? const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      )
                    : const EdgeInsets.all(12),
                color: Theme.of(context)
                    .extension<StackColors>()!
                    .snackBarBackSuccess,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isDesktop ? "Total amount to send" : "Total amount",
                      style: isDesktop
                          ? STextStyles.desktopTextExtraExtraSmall(context)
                              .copyWith(
                              color: Theme.of(context)
                                  .extension<StackColors>()!
                                  .textConfirmTotalAmount,
                            )
                          : STextStyles.titleBold12(context).copyWith(
                              color: Theme.of(context)
                                  .extension<StackColors>()!
                                  .textConfirmTotalAmount,
                            ),
                    ),
                    Builder(builder: (context) {
                      final coin = ref.watch(walletsChangeNotifierProvider
                          .select((value) => value.getManager(walletId).coin));
                      final fee = transactionInfo.fee!;

                      final amount = transactionInfo.amount!;
                      return Text(
                        ref.watch(pAmountFormatter(coin)).format(amount + fee),
                        style: isDesktop
                            ? STextStyles.desktopTextExtraExtraSmall(context)
                                .copyWith(
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .textConfirmTotalAmount,
                              )
                            : STextStyles.itemSubtitle12(context).copyWith(
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .textConfirmTotalAmount,
                              ),
                        textAlign: TextAlign.right,
                      );
                    }),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: isDesktop ? 28 : 16,
            ),
            Padding(
              padding: isDesktop
                  ? const EdgeInsets.symmetric(
                      horizontal: 32,
                    )
                  : const EdgeInsets.all(0),
              child: PrimaryButton(
                label: "Send",
                buttonHeight: isDesktop ? ButtonHeight.l : null,
                onPressed: () async {
                  final dynamic unlocked;

                  final coin = ref
                      .read(walletsChangeNotifierProvider)
                      .getManager(walletId)
                      .coin;

                  if (isDesktop) {
                    unlocked = await showDialog<bool?>(
                      context: context,
                      builder: (context) => DesktopDialog(
                        maxWidth: 580,
                        maxHeight: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                DesktopDialogCloseButton(),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 32,
                                right: 32,
                                bottom: 32,
                              ),
                              child: DesktopAuthSend(
                                coin: coin,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    unlocked = await Navigator.push(
                      context,
                      RouteGenerator.getRoute(
                        shouldUseMaterialRoute:
                            RouteGenerator.useMaterialPageRoute,
                        builder: (_) => const LockscreenView(
                          showBackButton: true,
                          popOnSuccess: true,
                          routeOnSuccessArguments: true,
                          routeOnSuccess: "",
                          biometricsCancelButtonString: "CANCEL",
                          biometricsLocalizedReason:
                              "Authenticate to send transaction",
                          biometricsAuthenticationTitle: "Confirm Transaction",
                        ),
                        settings:
                            const RouteSettings(name: "/confirmsendlockscreen"),
                      ),
                    );
                  }

                  if (mounted) {
                    if (unlocked == true) {
                      unawaited(_attemptSend(context));
                    } else {
                      unawaited(
                        showFloatingFlushBar(
                            type: FlushBarType.warning,
                            message: Util.isDesktop
                                ? "Invalid passphrase"
                                : "Invalid PIN",
                            context: context),
                      );
                    }
                  }
                },
              ),
            ),
            if (isDesktop)
              const SizedBox(
                height: 32,
              ),
          ],
        ),
      ),
    );
  }
}
