import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackfrost/pages/wallet_view/transaction_views/transaction_details_view.dart';
import 'package:stackfrost/pages/wallet_view/wallet_view.dart';
import 'package:stackfrost/pages_desktop_specific/my_stack_view/exit_to_my_stack_button.dart';
import 'package:stackfrost/pages_desktop_specific/my_stack_view/wallet_view/desktop_wallet_view.dart';
import 'package:stackfrost/providers/frost_wallet/frost_wallet_providers.dart';
import 'package:stackfrost/providers/global/wallets_provider.dart';
import 'package:stackfrost/services/coins/bitcoin/frost_wallet.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/logger.dart';
import 'package:stackfrost/utilities/show_loading.dart';
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
import 'package:stackfrost/widgets/stack_dialog.dart';

class VerifyUpdatedWalletView extends ConsumerStatefulWidget {
  const VerifyUpdatedWalletView({
    super.key,
    required this.walletId,
  });

  static const String routeName = "/verifyUpdatedWalletView";

  final String walletId;

  @override
  ConsumerState<VerifyUpdatedWalletView> createState() =>
      _VerifyUpdatedWalletViewState();
}

class _VerifyUpdatedWalletViewState
    extends ConsumerState<VerifyUpdatedWalletView> {
  late final String config;
  late final String serializedKeys;
  late final String reshareId;

  bool _buttonLock = false;
  Future<void> _onPressed() async {
    if (_buttonLock) {
      return;
    }
    _buttonLock = true;

    try {
      Exception? ex;

      await showLoading(
        whileFuture: (ref
                .read(walletsChangeNotifierProvider)
                .getManager(widget.walletId)
                .wallet as FrostWallet)
            .updateWithResharedData(
          serializedKeys: serializedKeys,
          multisigConfig: config,
        ),
        context: context,
        message: "Updating wallet data",
        isDesktop: Util.isDesktop,
        onException: (e) => ex = e,
      );

      if (ex != null) {
        throw ex!;
      }

      if (mounted) {
        Navigator.of(context).popUntil(
          ModalRoute.withName(
            Util.isDesktop ? DesktopWalletView.routeName : WalletView.routeName,
          ),
        );
      }
    } catch (e, s) {
      Logging.instance.log(
        "$e\n$s",
        level: LogLevel.Fatal,
      );

      await showDialog<void>(
        context: context,
        builder: (_) => StackOkDialog(
          title: "Error",
          message: e.toString(),
          desktopPopRootNavigator: Util.isDesktop,
        ),
      );
    } finally {
      _buttonLock = false;
    }
  }

  @override
  void initState() {
    config = ref.read(pFrostReshareNewWalletData)!.multisigConfig;
    serializedKeys = ref.read(pFrostReshareNewWalletData)!.serializedKeys;
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
              //   "Verify",
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
          children: [
            Text(
              "Ensure your reshare ID matches that of each other participant",
              style: STextStyles.pageTitleH2(context),
            ),
            const _Div(),
            DetailItem(
              title: "ID",
              detail: reshareId,
              button: Util.isDesktop
                  ? IconCopyButton(
                      data: reshareId,
                    )
                  : SimpleCopyButton(
                      data: reshareId,
                    ),
            ),
            const _Div(),
            const _Div(),
            Text(
              "Back up your keys and config",
              style: STextStyles.pageTitleH2(context),
            ),
            const _Div(),
            DetailItem(
              title: "Config",
              detail: config,
              button: Util.isDesktop
                  ? IconCopyButton(
                      data: config,
                    )
                  : SimpleCopyButton(
                      data: config,
                    ),
            ),
            const _Div(),
            DetailItem(
              title: "Keys",
              detail: serializedKeys,
              button: Util.isDesktop
                  ? IconCopyButton(
                      data: serializedKeys,
                    )
                  : SimpleCopyButton(
                      data: serializedKeys,
                    ),
            ),
            if (!Util.isDesktop) const Spacer(),
            const _Div(),
            PrimaryButton(
              label: "Confirm",
              onPressed: _onPressed,
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
