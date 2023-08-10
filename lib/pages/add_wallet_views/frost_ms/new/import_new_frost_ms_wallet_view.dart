import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackfrost/pages/add_wallet_views/frost_ms/new/frost_share_commitments_view.dart';
import 'package:stackfrost/providers/frost_wallet/frost_wallet_providers.dart';
import 'package:stackfrost/services/frost.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/widgets/background.dart';
import 'package:stackfrost/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackfrost/widgets/desktop/primary_button.dart';
import 'package:stackfrost/widgets/stack_dialog.dart';

class ImportNewFrostMsWalletView extends ConsumerStatefulWidget {
  const ImportNewFrostMsWalletView({
    super.key,
    required this.walletName,
    required this.coin,
  });

  static const String routeName = "/importNewFrostMsWalletView";

  final String walletName;
  final Coin coin;

  @override
  ConsumerState<ImportNewFrostMsWalletView> createState() =>
      _ImportNewFrostMsWalletViewState();
}

class _ImportNewFrostMsWalletViewState
    extends ConsumerState<ImportNewFrostMsWalletView> {
  late final TextEditingController configFieldController;
  late final TextEditingController myNameFieldController;

  @override
  void initState() {
    myNameFieldController = TextEditingController();
    configFieldController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    myNameFieldController.dispose();
    configFieldController.dispose();
    super.dispose();
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
            "Import FROST multisig config",
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
                          const SizedBox(
                            height: 16,
                          ),
                          Text("My name"),
                          TextField(
                            controller: myNameFieldController,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text("Config"),
                          TextField(
                            controller: configFieldController,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Spacer(),
                          const SizedBox(
                            height: 16,
                          ),
                          PrimaryButton(
                            label: "Start key generation",
                            enabled: configFieldController.text.isNotEmpty &&
                                myNameFieldController.text.isNotEmpty,
                            onPressed: () async {
                              if (FocusScope.of(context).hasFocus) {
                                FocusScope.of(context).unfocus();
                              }

                              final config = configFieldController.text;

                              if (!Frost.validateEncodedMultisigConfig(
                                  encodedConfig: config)) {
                                return await showDialog<void>(
                                  context: context,
                                  builder: (_) => const StackOkDialog(
                                    title: "Invalid config",
                                  ),
                                );
                              }

                              if (!Frost.getParticipants(multisigConfig: config)
                                  .contains(myNameFieldController.text)) {
                                return await showDialog<void>(
                                  context: context,
                                  builder: (_) => const StackOkDialog(
                                    title:
                                        "My name not found in config participants",
                                  ),
                                );
                              }

                              ref.read(pFrostMyName.state).state =
                                  myNameFieldController.text;
                              ref.read(pFrostMultisigConfig.notifier).state =
                                  config;

                              ref.read(pFrostStartKeyGenData.state).state =
                                  Frost.startKeyGeneration(
                                multisigConfig:
                                    ref.read(pFrostMultisigConfig.state).state!,
                                myName: ref.read(pFrostMyName.state).state!,
                              );

                              await Navigator.of(context).pushNamed(
                                FrostShareCommitmentsView.routeName,
                                arguments: (
                                  walletName: widget.walletName,
                                  coin: widget.coin,
                                ),
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
