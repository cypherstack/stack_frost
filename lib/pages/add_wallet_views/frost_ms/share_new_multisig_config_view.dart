import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackfrost/providers/frost_wallet/frost_wallet_providers.dart';
import 'package:stackfrost/services/frost.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/widgets/background.dart';
import 'package:stackfrost/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackfrost/widgets/desktop/primary_button.dart';

class ShareNewMultisigConfigView extends ConsumerStatefulWidget {
  const ShareNewMultisigConfigView({
    super.key,
  });

  static const String routeName = "/shareNewMultisigConfigView";

  @override
  ConsumerState<ShareNewMultisigConfigView> createState() =>
      _ShareNewMultisigConfigViewState();
}

class _ShareNewMultisigConfigViewState
    extends ConsumerState<ShareNewMultisigConfigView> {
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
            "Multisig config",
            style: STextStyles.navBarTitle(context),
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "Config",
                          style: STextStyles.label(context),
                        ),

                        const SizedBox(
                          height: 16,
                        ),
                        SelectableText(
                          ref.watch(pCurrentMultisigConfig.state).state!,
                          style: STextStyles.itemSubtitle(context),
                        ),

                        Text(
                          Frost.getParticipants(
                                  multisigConfig: ref
                                      .watch(pCurrentMultisigConfig.state)
                                      .state!)
                              .join("\n"),
                          style: STextStyles.label(context),
                        ),

                        // TODO QR code

                        const Spacer(),
                        PrimaryButton(
                          label: "Start key generation",
                          onPressed: () async {
                            ref.read(pStartKeyGenData.notifier).state =
                                Frost.startKeyGeneration(
                              multisigConfig: ref
                                  .watch(pCurrentMultisigConfig.state)
                                  .state!,
                              myName: Frost.getName(
                                  multisigConfig: ref
                                      .read(pCurrentMultisigConfig.state)
                                      .state!),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
