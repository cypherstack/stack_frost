import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackfrost/pages/add_wallet_views/frost_ms/share_new_multisig_config_view.dart';
import 'package:stackfrost/providers/frost_wallet/frost_wallet_providers.dart';
import 'package:stackfrost/services/frost.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/widgets/background.dart';
import 'package:stackfrost/widgets/conditional_parent.dart';
import 'package:stackfrost/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackfrost/widgets/desktop/primary_button.dart';
import 'package:stackfrost/widgets/stack_dialog.dart';

class NewFrostMsWalletView extends ConsumerStatefulWidget {
  const NewFrostMsWalletView({
    super.key,
    required this.walletName,
    required this.coin,
  });

  static const String routeName = "/newFrostMsWalletView";

  final String walletName;
  final Coin coin;

  @override
  ConsumerState<NewFrostMsWalletView> createState() =>
      _NewFrostMsWalletViewState();
}

class _NewFrostMsWalletViewState extends ConsumerState<NewFrostMsWalletView> {
  final _thresholdController = TextEditingController();
  final _participantsController = TextEditingController();

  final List<TextEditingController> controllers = [];

  int _participantsCount = 0;

  String _validateInputData() {
    final threshold = int.tryParse(_thresholdController.text);
    if (threshold == null) {
      return "Choose a threshold";
    }

    final partsCount = int.tryParse(_participantsController.text);
    if (partsCount == null) {
      return "Choose total number of participants";
    }

    if (threshold > partsCount) {
      return "Threshold cannot be greater than the number of participants";
    }

    if (controllers.length != partsCount) {
      return "Participants count error";
    }

    final hasEmptyParticipants = controllers
        .map((e) => e.text.isEmpty)
        .reduce((value, element) => value |= element);
    if (hasEmptyParticipants) {
      return "Participants must not be empty";
    }

    // TODO not sure if duplicate participant names are allowed
    if (controllers.length != controllers.map((e) => e.text).toSet().length) {
      return "Duplicate participant name found";
    }

    return "valid";
  }

  void _participantsCountChanged(String newValue) {
    final count = int.tryParse(newValue);
    if (count != null) {
      if (count > _participantsCount) {
        for (int i = _participantsCount; i < count; i++) {
          controllers.add(TextEditingController());
        }

        _participantsCount = count;
        setState(() {});
      } else if (count < _participantsCount) {
        for (int i = _participantsCount; i > count; i--) {
          final last = controllers.removeLast();
          last.dispose();
        }

        _participantsCount = count;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            "New FROST multisig config",
            style: STextStyles.navBarTitle(context),
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Threshold",
                            style: STextStyles.label(context),
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: _thresholdController,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Number of participants",
                            style: STextStyles.label(context),
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: _participantsController,
                            onChanged: _participantsCountChanged,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (controllers.isNotEmpty)
                            Text(
                              "Participants",
                              style: STextStyles.label(context),
                            ),
                          Column(
                            children: [
                              for (int i = 0; i < controllers.length; i++)
                                ConditionalParent(
                                  condition: controllers.length > 1,
                                  builder: (child) => Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                    ),
                                    child: child,
                                  ),
                                  child: TextField(
                                    controller: controllers[i],
                                  ),
                                ),
                            ],
                          ),
                          const Spacer(),
                          const SizedBox(
                            height: 16,
                          ),
                          PrimaryButton(
                            label: "Create config",
                            onPressed: () async {
                              final validationMessage = _validateInputData();

                              if (validationMessage != "valid") {
                                return await showDialog<void>(
                                  context: context,
                                  builder: (_) => StackOkDialog(
                                    title: validationMessage,
                                  ),
                                );
                              }

                              final config = Frost.createMultisigConfig(
                                name: controllers.first.text,
                                threshold:
                                    int.parse(_participantsController.text),
                                participants:
                                    controllers.map((e) => e.text).toList(),
                              );

                              ref.read(pCurrentMultisigConfig.notifier).state =
                                  config;

                              await Navigator.of(context).pushNamed(
                                ShareNewMultisigConfigView.routeName,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
