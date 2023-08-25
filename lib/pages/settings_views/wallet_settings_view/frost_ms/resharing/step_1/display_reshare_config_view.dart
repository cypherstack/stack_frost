import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stackfrost/pages/settings_views/wallet_settings_view/frost_ms/resharing/step_2/begin_resharing_view.dart';
import 'package:stackfrost/pages_desktop_specific/my_stack_view/exit_to_my_stack_button.dart';
import 'package:stackfrost/providers/frost_wallet/frost_wallet_providers.dart';
import 'package:stackfrost/providers/global/wallets_provider.dart';
import 'package:stackfrost/services/coins/bitcoin/frost_wallet.dart';
import 'package:stackfrost/services/frost.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/logger.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/utilities/util.dart';
import 'package:stackfrost/widgets/background.dart';
import 'package:stackfrost/widgets/conditional_parent.dart';
import 'package:stackfrost/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackfrost/widgets/desktop/desktop_app_bar.dart';
import 'package:stackfrost/widgets/desktop/desktop_scaffold.dart';
import 'package:stackfrost/widgets/desktop/primary_button.dart';
import 'package:stackfrost/widgets/rounded_white_container.dart';
import 'package:stackfrost/widgets/stack_dialog.dart';

class DisplayReshareConfigView extends ConsumerStatefulWidget {
  const DisplayReshareConfigView({
    super.key,
    required this.walletId,
  });

  static const String routeName = "/displayReshareConfigView";

  final String walletId;

  @override
  ConsumerState<DisplayReshareConfigView> createState() =>
      _DisplayReshareConfigViewState();
}

class _DisplayReshareConfigViewState
    extends ConsumerState<DisplayReshareConfigView> {
  late final bool iAmInvolved;

  bool _buttonLock = false;

  Future<void> _onPressed() async {
    if (_buttonLock) {
      return;
    }
    _buttonLock = true;

    try {
      final wallet = ref
          .read(walletsChangeNotifierProvider)
          .getManager(widget.walletId)
          .wallet as FrostWallet;

      final serializedKeys = await wallet.getSerializedKeys;
      if (mounted) {
        final result = Frost.beginResharer(
          serializedKeys: serializedKeys!,
          config: ref.read(pFrostResharerConfig)!,
        );

        ref.read(pFrostResharerData.state).state = result;

        await Navigator.of(context).pushNamed(
          BeginResharingView.routeName,
          arguments: widget.walletId,
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
          title: e.toString(),
          desktopPopRootNavigator: Util.isDesktop,
        ),
      );
    } finally {
      _buttonLock = false;
    }
  }

  @override
  void initState() {
    iAmInvolved =
        ref.read(pFrostResharers).keys.contains(ref.read(pFrostMyName)!);
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
              title: Text(
                "Resharer config",
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
            if (!Util.isDesktop) const Spacer(),
            SizedBox(
              height: 220,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageView(
                    data: ref.watch(pFrostResharerConfig.state).state!,
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
            const SizedBox(
              height: 32,
            ),
            RoundedWhiteContainer(
              child: SelectableText(
                ref.watch(pFrostResharerConfig.state).state!,
                style: STextStyles.itemSubtitle(context),
              ),
            ),
            SizedBox(
              height: Util.isDesktop ? 64 : 16,
            ),
            if (!Util.isDesktop)
              const Spacer(
                flex: 2,
              ),
            if (iAmInvolved)
              PrimaryButton(
                label: "Start resharing",
                onPressed: _onPressed,
              ),
          ],
        ),
      ),
    );
  }
}
