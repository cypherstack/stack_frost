import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackwallet/models/isar/exchange_cache/currency.dart';
import 'package:stackwallet/pages/buy_view/sub_widgets/crypto_selection_view.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';
import 'package:stackwallet/utilities/util.dart';
import 'package:stackwallet/widgets/loading_indicator.dart';

class ExchangeTextField extends StatefulWidget {
  const ExchangeTextField({
    Key? key,
    this.borderRadius = 0,
    this.background,
    required this.controller,
    this.buttonColor,
    required this.focusNode,
    this.buttonContent,
    required this.textStyle,
    this.onButtonTap,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    required this.isWalletCoin,
    this.currency,
    this.readOnly = false,
  }) : super(key: key);

  final double borderRadius;
  final Color? background;
  final Color? buttonColor;
  final Widget? buttonContent;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextStyle textStyle;
  final VoidCallback? onTap;
  final VoidCallback? onButtonTap;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  final bool isWalletCoin;
  final bool readOnly;
  final Currency? currency;

  @override
  State<ExchangeTextField> createState() => _ExchangeTextFieldState();
}

class _ExchangeTextFieldState extends State<ExchangeTextField> {
  late final TextEditingController controller;
  late final FocusNode focusNode;
  late final TextStyle textStyle;

  late final double borderRadius;

  late final Color? background;
  late final Color? buttonColor;
  late final Widget? buttonContent;
  late final VoidCallback? onButtonTap;
  late final VoidCallback? onTap;
  late final void Function(String)? onChanged;
  late final void Function(String)? onSubmitted;

  final isDesktop = Util.isDesktop;

  @override
  void initState() {
    borderRadius = widget.borderRadius;
    background = widget.background;
    buttonColor = widget.buttonColor;
    controller = widget.controller;
    focusNode = widget.focusNode;
    buttonContent = widget.buttonContent;
    textStyle = widget.textStyle;
    onButtonTap = widget.onButtonTap;
    onChanged = widget.onChanged;
    onSubmitted = widget.onSubmitted;
    onTap = widget.onTap;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextField(
                style: textStyle,
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                onTap: onTap,
                enableSuggestions: false,
                autocorrect: false,
                readOnly: widget.readOnly,
                keyboardType: isDesktop
                    ? null
                    : const TextInputType.numberWithOptions(
                        signed: false,
                        decimal: true,
                      ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(
                    top: 12,
                    left: 12,
                  ),
                  hintText: widget.currency == null ? "select currency" : "0",
                  hintStyle: STextStyles.fieldLabel(context).copyWith(
                    fontSize: 14,
                  ),
                ),
                inputFormatters: [
                  // regex to validate a crypto amount with 8 decimal places
                  TextInputFormatter.withFunction((oldValue, newValue) =>
                      RegExp(r'^([0-9]*[,.]?[0-9]{0,8}|[,.][0-9]{0,8})$')
                              .hasMatch(newValue.text)
                          ? newValue
                          : oldValue),
                ],
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => onButtonTap?.call(),
                child: Container(
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(
                        borderRadius,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Builder(
                            builder: (context) {
                              if (isStackCoin(widget.currency?.ticker)) {
                                return Center(
                                  child: getIconForTicker(
                                    widget.currency!.ticker,
                                    size: 18,
                                  ),
                                );
                              } else if (widget.currency != null &&
                                  widget.currency!.image.isNotEmpty) {
                                return Center(
                                  child: SvgPicture.network(
                                    widget.currency!.image,
                                    height: 18,
                                    placeholderBuilder: (_) => Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .extension<StackColors>()!
                                            .textFieldDefaultBG,
                                        borderRadius: BorderRadius.circular(
                                          18,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          18,
                                        ),
                                        child: const LoadingIndicator(),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    // color: Theme.of(context).extension<StackColors>()!.accentColorDark
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: SvgPicture.asset(
                                    Assets.svg.circleQuestion,
                                    width: 18,
                                    height: 18,
                                    color: Theme.of(context)
                                        .extension<StackColors>()!
                                        .textFieldDefaultBG,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          widget.currency?.ticker.toUpperCase() ?? "n/a",
                          style: STextStyles.smallMed14(context).copyWith(
                            color: Theme.of(context)
                                .extension<StackColors>()!
                                .textDark,
                          ),
                        ),
                        if (!widget.isWalletCoin)
                          const SizedBox(
                            width: 6,
                          ),
                        if (!widget.isWalletCoin)
                          SvgPicture.asset(
                            Assets.svg.chevronDown,
                            width: 5,
                            height: 2.5,
                            color: Theme.of(context)
                                .extension<StackColors>()!
                                .textDark,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
