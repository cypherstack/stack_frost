import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stackfrost/pages_desktop_specific/my_stack_view/exit_to_my_stack_button.dart';
import 'package:stackfrost/providers/frost_wallet/frost_wallet_providers.dart';
import 'package:stackfrost/services/frost.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';
import 'package:stackfrost/utilities/logger.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/utilities/util.dart';
import 'package:stackfrost/widgets/background.dart';
import 'package:stackfrost/widgets/conditional_parent.dart';
import 'package:stackfrost/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackfrost/widgets/desktop/desktop_app_bar.dart';
import 'package:stackfrost/widgets/desktop/desktop_scaffold.dart';
import 'package:stackfrost/widgets/desktop/primary_button.dart';
import 'package:stackfrost/widgets/stack_dialog.dart';

class FrostShareCommitmentsView extends ConsumerStatefulWidget {
  const FrostShareCommitmentsView({
    super.key,
    required this.walletName,
    required this.coin,
  });

  static const String routeName = "/frostShareCommitmentsView";

  final String walletName;
  final Coin coin;

  @override
  ConsumerState<FrostShareCommitmentsView> createState() =>
      _StartKeyGenMsViewState();
}

class _StartKeyGenMsViewState extends ConsumerState<FrostShareCommitmentsView> {
  final List<TextEditingController> controllers = [];

  late final List<String> participants;
  late final String commitment;

  @override
  void initState() {
    participants = Frost.getParticipants(
      multisigConfig: ref.read(pFrostMultisigConfig.state).state!,
    );
    commitment = ref.read(pFrostStartKeyGenData.state).state!.commitments;
    for (int i = 0; i < participants.length; i++) {
      controllers.add(TextEditingController());
    }
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalParent(
      condition: Util.isDesktop,
      builder: (child) => DesktopScaffold(
        background: Theme.of(context).extension<StackColors>()!.background,
        appBar: const DesktopAppBar(
          isCompactHeight: false,
          leading: AppBarBackButton(),
          trailing: ExitToMyStackButton(),
        ),
        body: SizedBox(
          width: 480,
          child: child,
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
                "Generate shares",
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
                          child: child,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 220,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageView(
                    data: commitment,
                    size: 220,
                    backgroundColor:
                        Theme.of(context).extension<StackColors>()!.background,
                    foregroundColor: Theme.of(context)
                        .extension<StackColors>()!
                        .accentColorDark,
                  ),
                ],
              ),
            ),
            const _Div(),
            _Item(
              label: "My name",
              detail: ref.watch(pFrostMyName.state).state!,
            ),
            const _Div(),
            _Item(
              label: "My commitment",
              detail: commitment,
            ),
            const _Div(),
            Text("Enter remaining participant's commitments:"),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < participants.length; i++)
                  Builder(
                    builder: (_) {
                      final name = participants[i];

                      if (name == ref.read(pFrostMyName.state).state!) {
                        controllers[i].text = commitment;
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name),
                          TextField(
                            enabled:
                                name != ref.read(pFrostMyName.state).state!,
                            controller: controllers[i],
                          )
                        ],
                      );
                    },
                  ),
              ],
            ),
            if (!Util.isDesktop) const Spacer(),
            const _Div(),
            PrimaryButton(
              label: "Generate",
              onPressed: () async {
                // check for empty commitments
                if (controllers
                    .map((e) => e.text.isEmpty)
                    .reduce((value, element) => value |= element)) {
                  return await showDialog<void>(
                    context: context,
                    builder: (_) => const StackOkDialog(
                      title: "Missing commitments",
                    ),
                  );
                }

                try {
                  ref.read(pFrostSecretSharesData.notifier).state =
                      Frost.generateSecretShares(
                    multisigConfigWithNamePtr: ref
                        .read(pFrostStartKeyGenData.state)
                        .state!
                        .multisigConfigWithNamePtr,
                    mySeed: ref.read(pFrostStartKeyGenData.state).state!.seed,
                    secretShareMachineWrapperPtr: ref
                        .read(pFrostStartKeyGenData.state)
                        .state!
                        .secretShareMachineWrapperPtr,
                    commitments: controllers.map((e) => e.text).toList(),
                  );
                } catch (e, s) {
                  Logging.instance.log(
                    "$e\n$s",
                    level: LogLevel.Fatal,
                  );
                  return await showDialog<void>(
                    context: context,
                    builder: (_) => const StackOkDialog(
                      title: "Failed to generate shares",
                    ),
                  );
                }

                print(
                    "AAAAAAAAAAAAAAAAAAAAAAAAAAAA: ${ref.read(pFrostSecretSharesData.notifier).state?.share}");

                // final config = configFieldController.text;
                //
                // if (!Frost.validateEncodedMultisigConfig(
                //     encodedConfig: config)) {
                //   return await showDialog<void>(
                //     context: context,
                //     builder: (_) => const StackOkDialog(
                //       title: "Invalid config",
                //     ),
                //   );
                // }
                //
                // ref.read(pCurrentMultisigConfig.notifier).state =
                //     config;

                // await Navigator.of(context).pushNamed(
                //   ShareNewMultisigConfigView.routeName,
                //   arguments: (walletName: widget.walletName, coin: widget.coin,),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Div extends StatelessWidget {
  const _Div({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 12,
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    super.key,
    required this.label,
    required this.detail,
  });

  final String label;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Text(detail),
      ],
    );
  }
}
