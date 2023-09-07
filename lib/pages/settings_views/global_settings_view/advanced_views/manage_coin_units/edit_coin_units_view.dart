import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackfrost/pages/settings_views/global_settings_view/advanced_views/manage_coin_units/choose_unit_sheet.dart';
import 'package:stackfrost/providers/global/prefs_provider.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/amount/amount_formatter.dart';
import 'package:stackfrost/utilities/amount/amount_unit.dart';
import 'package:stackfrost/utilities/assets.dart';
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
import 'package:stackfrost/widgets/desktop/secondary_button.dart';
import 'package:stackfrost/widgets/icon_widgets/x_icon.dart';
import 'package:stackfrost/widgets/stack_text_field.dart';
import 'package:stackfrost/widgets/textfield_icon_button.dart';

class EditCoinUnitsView extends ConsumerStatefulWidget {
  const EditCoinUnitsView({
    Key? key,
    required this.coin,
  }) : super(key: key);

  final Coin coin;

  static const String routeName = "/editCoinUnitsView";

  @override
  ConsumerState<EditCoinUnitsView> createState() => _EditCoinUnitsViewState();
}

class _EditCoinUnitsViewState extends ConsumerState<EditCoinUnitsView> {
  late final TextEditingController _decimalsController;
  late final FocusNode _decimalsFocusNode;

  late AmountUnit _currentUnit;

  void onSave() {
    final maxDecimals = int.tryParse(_decimalsController.text);

    if (maxDecimals == null) {
      // TODO show dialog error thing
      return;
    }

    ref.read(prefsChangeNotifierProvider).updateAmountUnit(
          coin: widget.coin,
          amountUnit: _currentUnit,
        );
    ref.read(prefsChangeNotifierProvider).updateMaxDecimals(
          coin: widget.coin,
          maxDecimals: maxDecimals,
        );

    Navigator.of(context).pop();
  }

  Future<void> chooseUnit() async {
    final chosenUnit = await showModalBottomSheet<AmountUnit?>(
      backgroundColor: Colors.transparent,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return ChooseUnitSheet(
          coin: widget.coin,
        );
      },
    );

    if (chosenUnit != null) {
      setState(() {
        _currentUnit = chosenUnit;
      });
    }
  }

  @override
  void initState() {
    _decimalsFocusNode = FocusNode();
    _decimalsController = TextEditingController()
      ..text = ref.read(pMaxDecimals(widget.coin)).toString();
    _currentUnit = ref.read(pAmountUnit(widget.coin));
    super.initState();
  }

  @override
  void dispose() {
    _decimalsFocusNode.dispose();
    _decimalsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalParent(
      condition: Util.isDesktop,
      builder: (child) => DesktopDialog(
        maxHeight: 350,
        maxWidth: 500,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Text(
                    "Edit ${widget.coin.prettyName} units",
                    style: STextStyles.desktopH3(context),
                  ),
                ),
                const DesktopDialogCloseButton(),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 32,
                  right: 32,
                  bottom: 32,
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
      child: ConditionalParent(
        condition: !Util.isDesktop,
        builder: (child) => Background(
          child: Scaffold(
            backgroundColor:
                Theme.of(context).extension<StackColors>()!.background,
            appBar: AppBar(
              leading: AppBarBackButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                "Edit ${widget.coin.prettyName} units",
                style: STextStyles.navBarTitle(context),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
        child: Column(
          children: [
            if (Util.isDesktop)
              DropdownButtonHideUnderline(
                child: DropdownButton2<AmountUnit>(
                  value: _currentUnit,
                  items: [
                    ...AmountUnit.valuesForCoin(widget.coin).map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e.unitForCoin(widget.coin),
                          style: STextStyles.desktopTextMedium(context),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value is AmountUnit) {
                      _currentUnit = value;
                    }
                  },
                  isExpanded: true,
                  iconStyleData: IconStyleData(
                    icon: SvgPicture.asset(
                      Assets.svg.chevronDown,
                      width: 12,
                      height: 6,
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .textFieldActiveSearchIconRight,
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    offset: const Offset(0, -10),
                    elevation: 0,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .textFieldDefaultBG,
                      borderRadius: BorderRadius.circular(
                        Constants.size.circularBorderRadius,
                      ),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            if (!Util.isDesktop)
              Stack(
                children: [
                  TextField(
                    autocorrect: Util.isDesktop ? false : true,
                    enableSuggestions: Util.isDesktop ? false : true,
                    // controller: _lengthController,
                    readOnly: true,
                    textInputAction: TextInputAction.none,
                  ),
                  Positioned.fill(
                    child: RawMaterialButton(
                      splashColor:
                          Theme.of(context).extension<StackColors>()!.highlight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Constants.size.circularBorderRadius,
                        ),
                      ),
                      onPressed: chooseUnit,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                          right: 17,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _currentUnit.unitForCoin(widget.coin),
                              style: STextStyles.itemSubtitle12(context),
                            ),
                            SvgPicture.asset(
                              Assets.svg.chevronDown,
                              width: 14,
                              height: 6,
                              color: Theme.of(context)
                                  .extension<StackColors>()!
                                  .textFieldActiveSearchIconRight,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            SizedBox(
              height: Util.isDesktop ? 24 : 8,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                Constants.size.circularBorderRadius,
              ),
              child: TextField(
                autocorrect: Util.isDesktop ? false : true,
                enableSuggestions: Util.isDesktop ? false : true,
                key: const Key("addCustomNodeNodeNameFieldKey"),
                controller: _decimalsController,
                focusNode: _decimalsFocusNode,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
                style: STextStyles.field(context),
                decoration: standardInputDecoration(
                  "Maximum precision",
                  _decimalsFocusNode,
                  context,
                ).copyWith(
                  labelStyle:
                      Util.isDesktop ? STextStyles.fieldLabel(context) : null,
                  suffixIcon: _decimalsController.text.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: UnconstrainedBox(
                            child: Row(
                              children: [
                                TextFieldIconButton(
                                  child: const XIcon(),
                                  onTap: () async {
                                    _decimalsController.text = "";
                                    setState(() {});
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
              height: 24,
            ),
            const Spacer(),
            ConditionalParent(
              condition: Util.isDesktop,
              builder: (child) => Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: "Cancel",
                      buttonHeight: ButtonHeight.l,
                      onPressed: Navigator.of(context).pop,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: child,
                  ),
                ],
              ),
              child: PrimaryButton(
                label: "Save",
                buttonHeight: Util.isDesktop ? ButtonHeight.l : ButtonHeight.xl,
                onPressed: onSave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
