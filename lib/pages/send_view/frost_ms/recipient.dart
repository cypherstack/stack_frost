import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackfrost/pages/address_book_views/address_book_view.dart';
import 'package:stackfrost/providers/global/locale_provider.dart';
import 'package:stackfrost/providers/global/prefs_provider.dart';
import 'package:stackfrost/providers/global/price_provider.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/address_utils.dart';
import 'package:stackfrost/utilities/amount/amount.dart';
import 'package:stackfrost/utilities/amount/amount_formatter.dart';
import 'package:stackfrost/utilities/amount/amount_input_formatter.dart';
import 'package:stackfrost/utilities/amount/amount_unit.dart';
import 'package:stackfrost/utilities/barcode_scanner_interface.dart';
import 'package:stackfrost/utilities/clipboard_interface.dart';
import 'package:stackfrost/utilities/constants.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';
import 'package:stackfrost/utilities/logger.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/utilities/util.dart';
import 'package:stackfrost/widgets/custom_buttons/blue_text_button.dart';
import 'package:stackfrost/widgets/icon_widgets/addressbook_icon.dart';
import 'package:stackfrost/widgets/icon_widgets/clipboard_icon.dart';
import 'package:stackfrost/widgets/icon_widgets/qrcode_icon.dart';
import 'package:stackfrost/widgets/icon_widgets/x_icon.dart';
import 'package:stackfrost/widgets/rounded_white_container.dart';
import 'package:stackfrost/widgets/stack_text_field.dart';
import 'package:stackfrost/widgets/textfield_icon_button.dart';

//TODO: move the following two providers elsewhere
final pClipboard =
    Provider<ClipboardInterface>((ref) => const ClipboardWrapper());
final pBarcodeScanner =
    Provider<BarcodeScannerInterface>((ref) => const BarcodeScannerWrapper());

final _pPrice = Provider.family<Decimal, Coin>((ref, coin) {
  return ref.watch(
    priceAnd24hChangeNotifierProvider
        .select((value) => value.getPrice(coin).item1),
  );
});

final pRecipient =
    StateProvider.family<({String address, Amount? amount})?, int>(
        (ref, index) => null);

class Recipient extends ConsumerStatefulWidget {
  const Recipient({
    super.key,
    required this.index,
    required this.coin,
    this.remove,
  });

  final int index;
  final Coin coin;

  final VoidCallback? remove;

  @override
  ConsumerState<Recipient> createState() => _RecipientState();
}

class _RecipientState extends ConsumerState<Recipient> {
  late final TextEditingController addressController,
      amountController,
      baseController;
  late final FocusNode addressFocusNode, amountFocusNode, baseFocusNode;

  bool _addressIsEmpty = true;
  bool _cryptoAmountChangeLock = false;

  void _updateRecipientData() {
    final address = addressController.text;
    final amount =
        ref.read(pAmountFormatter(widget.coin)).tryParse(amountController.text);

    ref.read(pRecipient(widget.index).notifier).state = (
      address: address,
      amount: amount,
    );
  }

  void _cryptoAmountChanged() async {
    if (!_cryptoAmountChangeLock) {
      Amount? cryptoAmount = ref.read(pAmountFormatter(widget.coin)).tryParse(
            amountController.text,
          );
      if (cryptoAmount != null) {
        if (ref.read(pRecipient(widget.index))?.amount != null &&
            ref.read(pRecipient(widget.index))?.amount == cryptoAmount) {
          return;
        }

        final price = ref.read(_pPrice(widget.coin));

        if (price > Decimal.zero) {
          baseController.text = (cryptoAmount.decimal * price)
              .toAmount(
                fractionDigits: 2,
              )
              .fiatString(
                locale: ref.read(localeServiceChangeNotifierProvider).locale,
              );
        }
      } else {
        cryptoAmount = null;
        baseController.text = "";
      }

      _updateRecipientData();
    }
  }

  @override
  void initState() {
    addressController = TextEditingController();
    amountController = TextEditingController();
    baseController = TextEditingController();

    addressFocusNode = FocusNode();
    amountFocusNode = FocusNode();
    baseFocusNode = FocusNode();

    amountController.addListener(_cryptoAmountChanged);

    super.initState();
  }

  @override
  void dispose() {
    amountController.removeListener(_cryptoAmountChanged);

    addressController.dispose();
    amountController.dispose();
    baseController.dispose();

    addressFocusNode.dispose();
    amountFocusNode.dispose();
    baseFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String locale = ref.watch(
      localeServiceChangeNotifierProvider.select(
        (value) => value.locale,
      ),
    );

    return RoundedWhiteContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              Constants.size.circularBorderRadius,
            ),
            child: TextField(
              key: const Key("sendViewAddressFieldKey"),
              controller: addressController,
              readOnly: false,
              autocorrect: false,
              enableSuggestions: false,
              focusNode: addressFocusNode,
              style: STextStyles.field(context),
              onChanged: (_) {
                setState(() {
                  _addressIsEmpty = addressController.text.isEmpty;
                });
              },
              decoration: standardInputDecoration(
                "Enter ${widget.coin.ticker} address",
                addressFocusNode,
                context,
              ).copyWith(
                contentPadding: const EdgeInsets.only(
                  left: 16,
                  top: 6,
                  bottom: 8,
                  right: 5,
                ),
                suffixIcon: Padding(
                  padding: _addressIsEmpty
                      ? const EdgeInsets.only(right: 8)
                      : const EdgeInsets.only(right: 0),
                  child: UnconstrainedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        !_addressIsEmpty
                            ? TextFieldIconButton(
                                semanticsLabel:
                                    "Clear Button. Clears The Address Field Input.",
                                key: const Key(
                                    "sendViewClearAddressFieldButtonKey"),
                                onTap: () {
                                  addressController.text = "";

                                  setState(() {
                                    _addressIsEmpty = true;
                                  });

                                  _updateRecipientData();
                                },
                                child: const XIcon(),
                              )
                            : TextFieldIconButton(
                                semanticsLabel:
                                    "Paste Button. Pastes From Clipboard To Address Field Input.",
                                key: const Key(
                                    "sendViewPasteAddressFieldButtonKey"),
                                onTap: () async {
                                  final ClipboardData? data = await ref
                                      .read(pClipboard)
                                      .getData(Clipboard.kTextPlain);
                                  if (data?.text != null &&
                                      data!.text!.isNotEmpty) {
                                    String content = data.text!.trim();
                                    if (content.contains("\n")) {
                                      content = content.substring(
                                          0, content.indexOf("\n"));
                                    }

                                    addressController.text = content.trim();

                                    setState(() {
                                      _addressIsEmpty =
                                          addressController.text.isEmpty;
                                    });

                                    _updateRecipientData();
                                  }
                                },
                                child: _addressIsEmpty
                                    ? const ClipboardIcon()
                                    : const XIcon(),
                              ),
                        if (_addressIsEmpty)
                          TextFieldIconButton(
                            semanticsLabel: "Address Book Button. "
                                "Opens Address Book For Address Field.",
                            key: const Key(
                              "sendViewAddressBookButtonKey",
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AddressBookView.routeName,
                                arguments: widget.coin,
                              );
                            },
                            child: const AddressBookIcon(),
                          ),
                        if (_addressIsEmpty)
                          TextFieldIconButton(
                            semanticsLabel: "Scan QR Button. "
                                "Opens Camera For Scanning QR Code.",
                            key: const Key(
                              "sendViewScanQrButtonKey",
                            ),
                            onTap: () async {
                              try {
                                if (FocusScope.of(context).hasFocus) {
                                  FocusScope.of(context).unfocus();
                                  await Future<void>.delayed(
                                    const Duration(
                                      milliseconds: 75,
                                    ),
                                  );
                                }

                                final qrResult =
                                    await ref.read(pBarcodeScanner).scan();

                                Logging.instance.log(
                                  "qrResult content: ${qrResult.rawContent}",
                                  level: LogLevel.Info,
                                );

                                /// TODO: deal with address utils
                                final results =
                                    AddressUtils.parseUri(qrResult.rawContent);

                                Logging.instance.log(
                                  "qrResult parsed: $results",
                                  level: LogLevel.Info,
                                );

                                if (results.isNotEmpty &&
                                    results["scheme"] ==
                                        widget.coin.uriScheme) {
                                  // auto fill address

                                  addressController.text =
                                      (results["address"] ?? "").trim();

                                  // autofill amount field
                                  if (results["amount"] != null) {
                                    final Amount amount =
                                        Decimal.parse(results["amount"]!)
                                            .toAmount(
                                      fractionDigits: widget.coin.decimals,
                                    );
                                    amountController.text = ref
                                        .read(pAmountFormatter(widget.coin))
                                        .format(
                                          amount,
                                          withUnitName: false,
                                        );
                                  }
                                } else {
                                  addressController.text =
                                      qrResult.rawContent.trim();
                                }

                                setState(() {
                                  _addressIsEmpty =
                                      addressController.text.isEmpty;
                                });

                                _updateRecipientData();
                              } on PlatformException catch (e, s) {
                                Logging.instance.log(
                                  "Failed to get camera permissions while "
                                  "trying to scan qr code in SendView: $e\n$s",
                                  level: LogLevel.Warning,
                                );
                              }
                            },
                            child: const QrCodeIcon(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          TextField(
            autocorrect: false,
            enableSuggestions: false,
            style: STextStyles.smallMed14(context).copyWith(
              color: Theme.of(context).extension<StackColors>()!.textDark,
            ),
            key: const Key("amountInputFieldCryptoTextFieldKey"),
            controller: amountController,
            focusNode: amountFocusNode,
            keyboardType: Util.isDesktop
                ? null
                : const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: true,
                  ),
            textAlign: TextAlign.right,
            inputFormatters: [
              AmountInputFormatter(
                decimals: widget.coin.decimals,
                unit: ref.watch(pAmountUnit(widget.coin)),
                locale: locale,
              ),
            ],
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                top: 12,
                right: 12,
              ),
              hintText: "0",
              hintStyle: STextStyles.fieldLabel(context).copyWith(
                fontSize: 14,
              ),
              prefixIcon: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    ref
                        .watch(pAmountUnit(widget.coin))
                        .unitForCoin(widget.coin),
                    style: STextStyles.smallMed14(context).copyWith(
                        color: Theme.of(context)
                            .extension<StackColors>()!
                            .accentColorDark),
                  ),
                ),
              ),
            ),
          ),
          if (ref.watch(prefsChangeNotifierProvider
              .select((value) => value.externalCalls)))
            const SizedBox(
              height: 8,
            ),
          if (ref.watch(prefsChangeNotifierProvider
              .select((value) => value.externalCalls)))
            TextField(
              autocorrect: Util.isDesktop ? false : true,
              enableSuggestions: Util.isDesktop ? false : true,
              style: STextStyles.smallMed14(context).copyWith(
                color: Theme.of(context).extension<StackColors>()!.textDark,
              ),
              key: const Key("amountInputFieldFiatTextFieldKey"),
              controller: baseController,
              focusNode: baseFocusNode,
              keyboardType: Util.isDesktop
                  ? null
                  : const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: true,
                    ),
              textAlign: TextAlign.right,
              inputFormatters: [
                AmountInputFormatter(
                  decimals: 2,
                  locale: locale,
                ),
              ],
              onChanged: (baseAmountString) {
                final baseAmount = Amount.tryParseFiatString(
                  baseAmountString,
                  locale: locale,
                );
                Amount? cryptoAmount;
                final int decimals = widget.coin.decimals;
                if (baseAmount != null) {
                  final _price = ref.read(_pPrice(widget.coin));

                  if (_price == Decimal.zero) {
                    cryptoAmount = 0.toAmountAsRaw(
                      fractionDigits: decimals,
                    );
                  } else {
                    cryptoAmount = baseAmount <= Amount.zero
                        ? 0.toAmountAsRaw(fractionDigits: decimals)
                        : (baseAmount.decimal / _price)
                            .toDecimal(
                              scaleOnInfinitePrecision: decimals,
                            )
                            .toAmount(fractionDigits: decimals);
                  }
                  if (ref.read(pRecipient(widget.index))?.amount != null &&
                      ref.read(pRecipient(widget.index))?.amount ==
                          cryptoAmount) {
                    return;
                  }

                  final amountString =
                      ref.read(pAmountFormatter(widget.coin)).format(
                            cryptoAmount,
                            withUnitName: false,
                          );

                  _cryptoAmountChangeLock = true;
                  amountController.text = amountString;
                  _cryptoAmountChangeLock = false;
                } else {
                  cryptoAmount = 0.toAmountAsRaw(
                    fractionDigits: decimals,
                  );
                  _cryptoAmountChangeLock = true;
                  amountController.text = "";
                  _cryptoAmountChangeLock = false;
                }

                _updateRecipientData();
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                  top: 12,
                  right: 12,
                ),
                hintText: "0",
                hintStyle: STextStyles.fieldLabel(context).copyWith(
                  fontSize: 14,
                ),
                prefixIcon: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      ref.watch(prefsChangeNotifierProvider
                          .select((value) => value.currency)),
                      style: STextStyles.smallMed14(context).copyWith(
                          color: Theme.of(context)
                              .extension<StackColors>()!
                              .accentColorDark),
                    ),
                  ),
                ),
              ),
            ),
          if (widget.remove != null)
            const SizedBox(
              height: 6,
            ),
          if (widget.remove != null)
            Row(
              children: [
                const Spacer(),
                CustomTextButton(
                  text: "Remove",
                  onTap: () {
                    ref.read(pRecipient(widget.index).notifier).state = null;
                    widget.remove?.call();
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
