import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackfrost/pages/settings_views/wallet_settings_view/frost_ms/resharing/complete_resharing_config_view.dart';
import 'package:stackfrost/pages_desktop_specific/my_stack_view/exit_to_my_stack_button.dart';
import 'package:stackfrost/providers/frost_wallet/frost_wallet_providers.dart';
import 'package:stackfrost/providers/global/wallets_provider.dart';
import 'package:stackfrost/services/coins/bitcoin/frost_wallet.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/constants.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/utilities/util.dart';
import 'package:stackfrost/widgets/background.dart';
import 'package:stackfrost/widgets/conditional_parent.dart';
import 'package:stackfrost/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackfrost/widgets/desktop/desktop_app_bar.dart';
import 'package:stackfrost/widgets/desktop/desktop_scaffold.dart';
import 'package:stackfrost/widgets/desktop/primary_button.dart';

final class StartResharingConfigView extends ConsumerStatefulWidget {
  const StartResharingConfigView({
    super.key,
    required this.walletId,
  });

  static const String routeName = "/startResharingConfigView";

  final String walletId;

  @override
  ConsumerState<StartResharingConfigView> createState() =>
      _StartResharingConfigViewState();
}

class _StartResharingConfigViewState
    extends ConsumerState<StartResharingConfigView> {
  late final int currentThreshold;
  late final List<String> currentParticipants;

  @override
  void initState() {
    ref.read(pFrostResharers).removeWhere((key, value) => true);

    final wallet = ref
        .read(walletsChangeNotifierProvider)
        .getManager(widget.walletId)
        .wallet as FrostWallet;

    currentThreshold = wallet.threshold;
    currentParticipants = wallet.participants;

    // ref.read(pFrostResharers)[ref.read(pFrostMyName)!] =
    //     currentParticipants.indexOf(ref.read(pFrostMyName)!);

    super.initState();
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
              // title: Text(
              //   "Modify Participants",
              //   style: STextStyles.navBarTitle(context),
              // ),
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select participants for resharing",
              style: STextStyles.label(context),
            ),
            const SizedBox(
              height: 16,
            ),
            Column(
              children: [
                for (int i = 0; i < currentParticipants.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: RawMaterialButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Constants.size.circularBorderRadius,
                        ),
                      ),
                      onPressed: () {
                        if (ref.read(pFrostResharers)[currentParticipants[i]] ==
                            null) {
                          ref.read(pFrostResharers)[currentParticipants[i]] = i;
                        } else {
                          ref
                              .read(pFrostResharers)
                              .remove(currentParticipants[i]);
                        }

                        setState(() {});
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: IgnorePointer(
                          child: Row(
                            children: [
                              Checkbox(
                                value: ref.watch(pFrostResharers)[
                                        currentParticipants[i]] ==
                                    i,
                                onChanged: (bool? value) {},
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                currentParticipants[i],
                                style: STextStyles.itemSubtitle12(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (!Util.isDesktop) const Spacer(),
            const SizedBox(
              height: 16,
            ),
            PrimaryButton(
              label: "Continue",
              enabled: ref.watch(pFrostResharers).length >= currentThreshold,
              onPressed: () async {
                await Navigator.of(context).pushNamed(
                  CompleteResharingConfigView.routeName,
                  arguments: widget.walletId,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
