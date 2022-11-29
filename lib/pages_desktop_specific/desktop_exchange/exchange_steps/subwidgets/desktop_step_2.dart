import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackwallet/models/contact_address_entry.dart';
import 'package:stackwallet/models/exchange/incomplete_exchange.dart';
import 'package:stackwallet/pages_desktop_specific/desktop_exchange/exchange_steps/step_scaffold.dart';
import 'package:stackwallet/pages_desktop_specific/desktop_exchange/exchange_steps/subwidgets/desktop_step_3.dart';
import 'package:stackwallet/pages_desktop_specific/desktop_exchange/subwidgets/desktop_choose_from_stack.dart';
import 'package:stackwallet/pages_desktop_specific/home/my_stack_view/wallet_view/sub_widgets/address_book_address_chooser/address_book_address_chooser.dart';
import 'package:stackwallet/providers/exchange/exchange_send_from_wallet_id_provider.dart';
import 'package:stackwallet/providers/global/wallets_provider.dart';
import 'package:stackwallet/utilities/clipboard_interface.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/logger.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';
import 'package:stackwallet/widgets/custom_buttons/blue_text_button.dart';
import 'package:stackwallet/widgets/desktop/desktop_dialog.dart';
import 'package:stackwallet/widgets/desktop/desktop_dialog_close_button.dart';
import 'package:stackwallet/widgets/desktop/primary_button.dart';
import 'package:stackwallet/widgets/desktop/secondary_button.dart';
import 'package:stackwallet/widgets/icon_widgets/addressbook_icon.dart';
import 'package:stackwallet/widgets/icon_widgets/clipboard_icon.dart';
import 'package:stackwallet/widgets/icon_widgets/x_icon.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';
import 'package:stackwallet/widgets/stack_text_field.dart';
import 'package:stackwallet/widgets/textfield_icon_button.dart';

class DesktopStep2 extends ConsumerStatefulWidget {
  const DesktopStep2({
    Key? key,
    required this.model,
    this.clipboard = const ClipboardWrapper(),
  }) : super(key: key);

  final IncompleteExchangeModel model;
  final ClipboardInterface clipboard;

  @override
  ConsumerState<DesktopStep2> createState() => _DesktopStep2State();
}

class _DesktopStep2State extends ConsumerState<DesktopStep2> {
  late final IncompleteExchangeModel model;
  late final ClipboardInterface clipboard;

  late final TextEditingController _toController;
  late final TextEditingController _refundController;

  late final FocusNode _toFocusNode;
  late final FocusNode _refundFocusNode;

  bool enableNext = false;

  bool isStackCoin(String ticker) {
    try {
      coinFromTickerCaseInsensitive(ticker);
      return true;
    } on ArgumentError catch (_) {
      return false;
    }
  }

  void selectRecipientAddressFromStack() async {
    try {
      final coin = coinFromTickerCaseInsensitive(
        model.receiveTicker,
      );

      final address = await showDialog<String?>(
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) => DesktopDialog(
          maxWidth: 720,
          maxHeight: 670,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: DesktopChooseFromStack(
              coin: coin,
            ),
          ),
        ),
      );

      if (address is String) {
        final manager =
            ref.read(walletsChangeNotifierProvider).getManager(address);

        _toController.text = manager.walletName;
        model.recipientAddress = await manager.currentReceivingAddress;
      }
    } catch (e, s) {
      Logging.instance.log("$e\n$s", level: LogLevel.Info);
    }
    setState(() {
      enableNext =
          _toController.text.isNotEmpty && _refundController.text.isNotEmpty;
    });
  }

  void selectRefundAddressFromStack() async {
    try {
      final coin = coinFromTickerCaseInsensitive(
        model.sendTicker,
      );

      final address = await showDialog<String?>(
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) => DesktopDialog(
          maxWidth: 720,
          maxHeight: 670,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: DesktopChooseFromStack(
              coin: coin,
            ),
          ),
        ),
      );
      if (address is String) {
        final manager =
            ref.read(walletsChangeNotifierProvider).getManager(address);

        _refundController.text = manager.walletName;
        model.refundAddress = await manager.currentReceivingAddress;
      }
    } catch (e, s) {
      Logging.instance.log("$e\n$s", level: LogLevel.Info);
    }
    setState(() {
      enableNext =
          _toController.text.isNotEmpty && _refundController.text.isNotEmpty;
    });
  }

  void selectRecipientFromAddressBook() async {
    final coin = coinFromTickerCaseInsensitive(
      model.receiveTicker,
    );

    final entry = await showDialog<ContactAddressEntry?>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => DesktopDialog(
        maxWidth: 720,
        maxHeight: 670,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 32,
                  ),
                  child: Text(
                    "Address book",
                    style: STextStyles.desktopH3(context),
                  ),
                ),
                const DesktopDialogCloseButton(),
              ],
            ),
            Expanded(
              child: AddressBookAddressChooser(
                coin: coin,
              ),
            ),
          ],
        ),
      ),
    );

    if (entry != null) {
      _toController.text = entry.address;
      model.recipientAddress = entry.address;
      setState(() {
        enableNext =
            _toController.text.isNotEmpty && _refundController.text.isNotEmpty;
      });
    }
  }

  void selectRefundFromAddressBook() async {
    final coin = coinFromTickerCaseInsensitive(
      model.sendTicker,
    );

    final entry = await showDialog<ContactAddressEntry?>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => DesktopDialog(
        maxWidth: 720,
        maxHeight: 670,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 32,
                  ),
                  child: Text(
                    "Address book",
                    style: STextStyles.desktopH3(context),
                  ),
                ),
                const DesktopDialogCloseButton(),
              ],
            ),
            Expanded(
              child: AddressBookAddressChooser(
                coin: coin,
              ),
            ),
          ],
        ),
      ),
    );

    if (entry != null) {
      _refundController.text = entry.address;
      model.refundAddress = entry.address;
      setState(() {
        enableNext =
            _toController.text.isNotEmpty && _refundController.text.isNotEmpty;
      });
    }
  }

  @override
  void initState() {
    model = widget.model;
    clipboard = widget.clipboard;

    _toController = TextEditingController();
    _refundController = TextEditingController();

    _toFocusNode = FocusNode();
    _refundFocusNode = FocusNode();

    final tuple = ref.read(exchangeSendFromWalletIdStateProvider.state).state;
    if (tuple != null) {
      if (model.receiveTicker.toLowerCase() ==
          tuple.item2.ticker.toLowerCase()) {
        ref
            .read(walletsChangeNotifierProvider)
            .getManager(tuple.item1)
            .currentReceivingAddress
            .then((value) {
          _toController.text = value;
          model.recipientAddress = _toController.text;
        });
      } else {
        if (model.sendTicker.toUpperCase() ==
            tuple.item2.ticker.toUpperCase()) {
          ref
              .read(walletsChangeNotifierProvider)
              .getManager(tuple.item1)
              .currentReceivingAddress
              .then((value) {
            _refundController.text = value;
            model.refundAddress = _refundController.text;
          });
        }
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    _toController.dispose();
    _refundController.dispose();

    _toFocusNode.dispose();
    _refundFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Enter exchange details",
          style: STextStyles.desktopTextMedium(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "Enter your recipient and refund addresses",
          style: STextStyles.desktopTextExtraExtraSmall(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recipient Wallet",
              style: STextStyles.desktopTextExtraExtraSmall(context).copyWith(
                  color: Theme.of(context)
                      .extension<StackColors>()!
                      .textFieldActiveSearchIconRight),
            ),
            if (isStackCoin(model.receiveTicker))
              BlueTextButton(
                text: "Choose from stack",
                onTap: selectRecipientAddressFromStack,
              ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(
            Constants.size.circularBorderRadius,
          ),
          child: TextField(
            onTap: () {},
            key: const Key("recipientExchangeStep2ViewAddressFieldKey"),
            controller: _toController,
            readOnly: false,
            autocorrect: false,
            enableSuggestions: false,
            // inputFormatters: <TextInputFormatter>[
            //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]{34}")),
            // ],
            toolbarOptions: const ToolbarOptions(
              copy: false,
              cut: false,
              paste: true,
              selectAll: false,
            ),
            focusNode: _toFocusNode,
            style: STextStyles.field(context),
            onChanged: (value) {
              setState(() {
                enableNext = _toController.text.isNotEmpty &&
                    _refundController.text.isNotEmpty;
              });
            },
            decoration: standardInputDecoration(
              "Enter the ${model.receiveTicker.toUpperCase()} payout address",
              _toFocusNode,
              context,
              desktopMed: true,
            ).copyWith(
              contentPadding: const EdgeInsets.only(
                left: 16,
                top: 6,
                bottom: 8,
                right: 5,
              ),
              suffixIcon: Padding(
                padding: _toController.text.isEmpty
                    ? const EdgeInsets.only(right: 8)
                    : const EdgeInsets.only(right: 0),
                child: UnconstrainedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _toController.text.isNotEmpty
                          ? TextFieldIconButton(
                              key: const Key(
                                  "sendViewClearAddressFieldButtonKey"),
                              onTap: () {
                                _toController.text = "";
                                model.recipientAddress = _toController.text;
                                setState(() {
                                  enableNext = _toController.text.isNotEmpty &&
                                      _refundController.text.isNotEmpty;
                                });
                              },
                              child: const XIcon(),
                            )
                          : TextFieldIconButton(
                              key: const Key(
                                  "sendViewPasteAddressFieldButtonKey"),
                              onTap: () async {
                                final ClipboardData? data = await clipboard
                                    .getData(Clipboard.kTextPlain);
                                if (data?.text != null &&
                                    data!.text!.isNotEmpty) {
                                  final content = data.text!.trim();
                                  _toController.text = content;
                                  model.recipientAddress = _toController.text;
                                  setState(() {
                                    enableNext =
                                        _toController.text.isNotEmpty &&
                                            _refundController.text.isNotEmpty;
                                  });
                                }
                              },
                              child: _toController.text.isEmpty
                                  ? const ClipboardIcon()
                                  : const XIcon(),
                            ),
                      if (_toController.text.isEmpty &&
                          isStackCoin(model.receiveTicker))
                        TextFieldIconButton(
                          key: const Key("sendViewAddressBookButtonKey"),
                          onTap: selectRecipientFromAddressBook,
                          child: const AddressBookIcon(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        RoundedWhiteContainer(
          borderColor: Theme.of(context).extension<StackColors>()!.background,
          child: Text(
            "This is the wallet where your ${model.receiveTicker.toUpperCase()} will be sent to.",
            style: STextStyles.desktopTextExtraExtraSmall(context),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Refund Wallet (required)",
              style: STextStyles.desktopTextExtraExtraSmall(context).copyWith(
                  color: Theme.of(context)
                      .extension<StackColors>()!
                      .textFieldActiveSearchIconRight),
            ),
            if (isStackCoin(model.sendTicker))
              BlueTextButton(
                text: "Choose from stack",
                onTap: selectRefundAddressFromStack,
              ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(
            Constants.size.circularBorderRadius,
          ),
          child: TextField(
            key: const Key("refundExchangeStep2ViewAddressFieldKey"),
            controller: _refundController,
            readOnly: false,
            autocorrect: false,
            enableSuggestions: false,
            // inputFormatters: <TextInputFormatter>[
            //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]{34}")),
            // ],
            toolbarOptions: const ToolbarOptions(
              copy: false,
              cut: false,
              paste: true,
              selectAll: false,
            ),
            focusNode: _refundFocusNode,
            style: STextStyles.field(context),
            onChanged: (value) {
              setState(() {
                enableNext = _toController.text.isNotEmpty &&
                    _refundController.text.isNotEmpty;
              });
            },
            decoration: standardInputDecoration(
              "Enter ${model.sendTicker.toUpperCase()} refund address",
              _refundFocusNode,
              context,
              desktopMed: true,
            ).copyWith(
              contentPadding: const EdgeInsets.only(
                left: 16,
                top: 6,
                bottom: 8,
                right: 5,
              ),
              suffixIcon: Padding(
                padding: _refundController.text.isEmpty
                    ? const EdgeInsets.only(right: 16)
                    : const EdgeInsets.only(right: 0),
                child: UnconstrainedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _refundController.text.isNotEmpty
                          ? TextFieldIconButton(
                              key: const Key(
                                  "sendViewClearAddressFieldButtonKey"),
                              onTap: () {
                                _refundController.text = "";
                                model.refundAddress = _refundController.text;

                                setState(() {
                                  enableNext = _toController.text.isNotEmpty &&
                                      _refundController.text.isNotEmpty;
                                });
                              },
                              child: const XIcon(),
                            )
                          : TextFieldIconButton(
                              key: const Key(
                                  "sendViewPasteAddressFieldButtonKey"),
                              onTap: () async {
                                final ClipboardData? data = await clipboard
                                    .getData(Clipboard.kTextPlain);
                                if (data?.text != null &&
                                    data!.text!.isNotEmpty) {
                                  final content = data.text!.trim();

                                  _refundController.text = content;
                                  model.refundAddress = _refundController.text;

                                  setState(() {
                                    enableNext =
                                        _toController.text.isNotEmpty &&
                                            _refundController.text.isNotEmpty;
                                  });
                                }
                              },
                              child: _refundController.text.isEmpty
                                  ? const ClipboardIcon()
                                  : const XIcon(),
                            ),
                      if (_refundController.text.isEmpty &&
                          isStackCoin(model.sendTicker))
                        TextFieldIconButton(
                          key: const Key("sendViewAddressBookButtonKey"),
                          onTap: selectRefundFromAddressBook,
                          child: const AddressBookIcon(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        RoundedWhiteContainer(
          borderColor: Theme.of(context).extension<StackColors>()!.background,
          child: Text(
            "In case something goes wrong during the exchange, we might need a refund address so we can return your coins back to you.",
            style: STextStyles.desktopTextExtraExtraSmall(context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 32,
          ),
          child: Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: "Back",
                  buttonHeight: ButtonHeight.l,
                  onPressed: Navigator.of(context).pop,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: PrimaryButton(
                  label: "Next",
                  enabled: enableNext,
                  buttonHeight: ButtonHeight.l,
                  onPressed: () async {
                    await showDialog<void>(
                      context: context,
                      barrierColor: Colors.transparent,
                      barrierDismissible: false,
                      builder: (context) {
                        return DesktopDialog(
                          maxWidth: 720,
                          maxHeight: double.infinity,
                          child: StepScaffold(
                            step: 3,
                            model: model,
                            body: DesktopStep3(
                              model: model,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
