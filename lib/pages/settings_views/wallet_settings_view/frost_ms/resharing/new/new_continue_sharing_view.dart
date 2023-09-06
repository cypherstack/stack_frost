import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stackfrost/pages/home_view/home_view.dart';
import 'package:stackfrost/pages/settings_views/wallet_settings_view/frost_ms/resharing/finish_resharing_view.dart';
import 'package:stackfrost/pages/wallet_view/transaction_views/transaction_details_view.dart';
import 'package:stackfrost/pages_desktop_specific/desktop_home_view.dart';
import 'package:stackfrost/pages_desktop_specific/my_stack_view/exit_to_my_stack_button.dart';
import 'package:stackfrost/providers/frost_wallet/frost_wallet_providers.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/utilities/util.dart';
import 'package:stackfrost/widgets/background.dart';
import 'package:stackfrost/widgets/conditional_parent.dart';
import 'package:stackfrost/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackfrost/widgets/custom_buttons/simple_copy_button.dart';
import 'package:stackfrost/widgets/desktop/desktop_app_bar.dart';
import 'package:stackfrost/widgets/desktop/desktop_scaffold.dart';
import 'package:stackfrost/widgets/desktop/primary_button.dart';
import 'package:stackfrost/widgets/detail_item.dart';
import 'package:stackfrost/widgets/dialogs/frost_interruption_dialog.dart';

class NewContinueSharingView extends ConsumerStatefulWidget {
  const NewContinueSharingView({
    super.key,
    required this.walletId,
  });

  static const String routeName = "/NewContinueSharingView";

  final String walletId;

  @override
  ConsumerState<NewContinueSharingView> createState() =>
      _NewContinueSharingViewState();
}

class _NewContinueSharingViewState
    extends ConsumerState<NewContinueSharingView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await showDialog<void>(
          context: context,
          builder: (_) => FrostInterruptionDialog(
            type: FrostInterruptionDialogType.resharing,
            popUntilOnYesRouteName:
                Util.isDesktop ? DesktopHomeView.routeName : HomeView.routeName,
          ),
        );
        return false;
      },
      child: ConditionalParent(
        condition: Util.isDesktop,
        builder: (child) => DesktopScaffold(
          background: Theme.of(context).extension<StackColors>()!.background,
          appBar: DesktopAppBar(
            isCompactHeight: false,
            leading: AppBarBackButton(
              onPressed: () async {
                await showDialog<void>(
                  context: context,
                  builder: (_) => const FrostInterruptionDialog(
                    type: FrostInterruptionDialogType.resharing,
                    popUntilOnYesRouteName: DesktopHomeView.routeName,
                  ),
                );
              },
            ),
            trailing: ExitToMyStackButton(
              onPressed: () async {
                await showDialog<void>(
                  context: context,
                  builder: (_) => const FrostInterruptionDialog(
                    type: FrostInterruptionDialogType.resharing,
                    popUntilOnYesRouteName: DesktopHomeView.routeName,
                  ),
                );
              },
            ),
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
                  onPressed: () async {
                    await showDialog<void>(
                      context: context,
                      builder: (_) => const FrostInterruptionDialog(
                        type: FrostInterruptionDialogType.resharing,
                        popUntilOnYesRouteName: HomeView.routeName,
                      ),
                    );
                  },
                ),
                title: Text(
                  "Encryption keys",
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
            children: [
              SizedBox(
                height: 220,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    QrImageView(
                      data: ref
                          .watch(pFrostResharingData)
                          .startResharedData!
                          .resharedStart,
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
              const _Div(),
              DetailItem(
                title: "My encryption key",
                detail: ref
                    .watch(pFrostResharingData)
                    .startResharedData!
                    .resharedStart,
                button: Util.isDesktop
                    ? IconCopyButton(
                        data: ref
                            .watch(pFrostResharingData)
                            .startResharedData!
                            .resharedStart,
                      )
                    : SimpleCopyButton(
                        data: ref
                            .watch(pFrostResharingData)
                            .startResharedData!
                            .resharedStart,
                      ),
              ),
              if (!Util.isDesktop) const Spacer(),
              const _Div(),
              PrimaryButton(
                label: "Continue",
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    FinishResharingView.routeName,
                    arguments: widget.walletId,
                  );
                },
              ),
            ],
          ),
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
