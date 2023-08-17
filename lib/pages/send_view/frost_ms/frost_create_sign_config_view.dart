import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stackfrost/pages/send_view/frost_ms/frost_attempt_sign_config_view.dart';
import 'package:stackfrost/providers/frost_wallet/frost_wallet_providers.dart';
import 'package:stackfrost/providers/global/wallets_provider.dart';
import 'package:stackfrost/services/coins/bitcoin/frost_wallet.dart';
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

class FrostCreateSignConfigView extends ConsumerStatefulWidget {
  const FrostCreateSignConfigView({
    super.key,
    required this.walletId,
  });

  static const String routeName = "/frostCreateSignConfigView";

  final String walletId;

  @override
  ConsumerState<FrostCreateSignConfigView> createState() =>
      _FrostCreateSignConfigViewState();
}

class _FrostCreateSignConfigViewState
    extends ConsumerState<FrostCreateSignConfigView> {
  bool _attemptSignLock = false;

  Future<void> _attemptSign() async {
    if (_attemptSignLock) {
      return;
    }

    _attemptSignLock = true;

    try {
      final wallet = ref
          .read(walletsChangeNotifierProvider)
          .getManager(widget.walletId)
          .wallet as FrostWallet;

      final attemptSignRes = await wallet.frostAttemptSignConfig(
        config: ref.read(pFrostTxData.state).state!.frostMSConfig!,
      );

      ref.read(pFrostAttemptSignData.notifier).state = attemptSignRes;

      await Navigator.of(context).pushNamed(
        FrostAttemptSignConfigView.routeName,
        arguments: widget.walletId,
      );
    } catch (e, s) {
      Logging.instance.log(
        "$e\n$s",
        level: LogLevel.Error,
      );
    } finally {
      _attemptSignLock = false;
    }
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
                "Sign config",
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
                    data: ref.watch(pFrostTxData.state).state!.frostMSConfig!,
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
                ref.watch(pFrostTxData.state).state!.frostMSConfig!,
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
            PrimaryButton(
              label: "Attempt sign",
              onPressed: () {
                _attemptSign();
              },
            ),
          ],
        ),
      ),
    );
  }
}
