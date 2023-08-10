import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stackfrost/pages/add_wallet_views/frost_ms/new/frost_share_commitments_view.dart';
import 'package:stackfrost/providers/frost_wallet/frost_wallet_providers.dart';
import 'package:stackfrost/services/frost.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/utilities/util.dart';
import 'package:stackfrost/widgets/background.dart';
import 'package:stackfrost/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackfrost/widgets/desktop/primary_button.dart';
import 'package:stackfrost/widgets/rounded_white_container.dart';

class ShareNewMultisigConfigView extends ConsumerStatefulWidget {
  const ShareNewMultisigConfigView({
    super.key,
    required this.walletName,
    required this.coin,
  });

  static const String routeName = "/shareNewMultisigConfigView";

  final String walletName;
  final Coin coin;

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
                        if (!Util.isDesktop) const Spacer(),
                        SizedBox(
                          height: 220,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              QrImageView(
                                data: ref
                                    .watch(pFrostMultisigConfig.state)
                                    .state!,
                                size: 220,
                                backgroundColor: Theme.of(context)
                                    .extension<StackColors>()!
                                    .background,
                                foregroundColor: Theme.of(context)
                                    .extension<StackColors>()!
                                    .accentColorDark,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        RoundedWhiteContainer(
                          child: SelectableText(
                            ref.watch(pFrostMultisigConfig.state).state!,
                            style: STextStyles.itemSubtitle(context),
                          ),
                        ),
                        if (!Util.isDesktop)
                          const Spacer(
                            flex: 2,
                          ),
                        PrimaryButton(
                          label: "Start key generation",
                          onPressed: () async {
                            ref.read(pFrostStartKeyGenData.notifier).state =
                                Frost.startKeyGeneration(
                              multisigConfig:
                                  ref.watch(pFrostMultisigConfig.state).state!,
                              myName: Frost.getName(
                                  multisigConfig: ref
                                      .read(pFrostMultisigConfig.state)
                                      .state!),
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
          }),
        ),
      ),
    );
  }
}
