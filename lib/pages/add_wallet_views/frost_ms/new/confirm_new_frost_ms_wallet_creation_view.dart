import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackfrost/electrumx_rpc/cached_electrumx.dart';
import 'package:stackfrost/electrumx_rpc/electrumx.dart';
import 'package:stackfrost/models/node_model.dart';
import 'package:stackfrost/notifications/show_flush_bar.dart';
import 'package:stackfrost/pages/home_view/home_view.dart';
import 'package:stackfrost/pages/wallet_view/transaction_views/transaction_details_view.dart';
import 'package:stackfrost/pages_desktop_specific/desktop_home_view.dart';
import 'package:stackfrost/pages_desktop_specific/my_stack_view/exit_to_my_stack_button.dart';
import 'package:stackfrost/providers/frost_wallet/frost_wallet_providers.dart';
import 'package:stackfrost/providers/global/node_service_provider.dart';
import 'package:stackfrost/providers/global/prefs_provider.dart';
import 'package:stackfrost/providers/global/secure_store_provider.dart';
import 'package:stackfrost/providers/global/wallets_provider.dart';
import 'package:stackfrost/providers/global/wallets_service_provider.dart';
import 'package:stackfrost/services/coins/bitcoin/frost_wallet.dart';
import 'package:stackfrost/services/coins/manager.dart';
import 'package:stackfrost/services/frost.dart';
import 'package:stackfrost/services/transaction_notification_tracker.dart';
import 'package:stackfrost/services/wallets_service.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/assets.dart';
import 'package:stackfrost/utilities/default_nodes.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';
import 'package:stackfrost/utilities/logger.dart';
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
import 'package:stackfrost/widgets/loading_indicator.dart';

class ConfirmNewFrostMSWalletCreationView extends ConsumerStatefulWidget {
  const ConfirmNewFrostMSWalletCreationView({
    super.key,
    required this.walletName,
    required this.coin,
  });

  static const String routeName = "/confirmNewFrostMSWalletCreationView";

  final String walletName;
  final Coin coin;

  @override
  ConsumerState<ConfirmNewFrostMSWalletCreationView> createState() =>
      _ConfirmNewFrostMSWalletCreationViewState();
}

class _ConfirmNewFrostMSWalletCreationViewState
    extends ConsumerState<ConfirmNewFrostMSWalletCreationView> {
  late final String seed, recoveryString, serializedKeys, multisigConfig;
  late final Uint8List multisigId;

  @override
  void initState() {
    seed = ref.read(pFrostStartKeyGenData.state).state!.seed;
    serializedKeys =
        ref.read(pFrostCompletedKeyGenData.state).state!.serializedKeys;
    recoveryString =
        ref.read(pFrostCompletedKeyGenData.state).state!.recoveryString;
    multisigId = ref.read(pFrostCompletedKeyGenData.state).state!.multisigId;
    multisigConfig = ref.read(pFrostMultisigConfig.state).state!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await showDialog<void>(
          context: context,
          builder: (_) => FrostInterruptionDialog(
            type: FrostInterruptionDialogType.walletCreation,
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
                    type: FrostInterruptionDialogType.walletCreation,
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
                    type: FrostInterruptionDialogType.walletCreation,
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
                        type: FrostInterruptionDialogType.walletCreation,
                        popUntilOnYesRouteName: HomeView.routeName,
                      ),
                    );
                  },
                ),
                title: Text(
                  "Finalize FROST multisig wallet",
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
              Text(
                "Ensure your multisig ID matches that of each other participant",
                style: STextStyles.pageTitleH2(context),
              ),
              const _Div(),
              DetailItem(
                title: "ID",
                detail: multisigId.toString(),
                button: Util.isDesktop
                    ? IconCopyButton(
                        data: multisigId.toString(),
                      )
                    : SimpleCopyButton(
                        data: multisigId.toString(),
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
                title: "Multisig Config",
                detail: multisigConfig,
                button: Util.isDesktop
                    ? IconCopyButton(
                        data: multisigConfig,
                      )
                    : SimpleCopyButton(
                        data: multisigConfig,
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
                onPressed: () async {
                  bool progressPopped = false;
                  try {
                    unawaited(
                      showDialog<dynamic>(
                        context: context,
                        barrierDismissible: false,
                        useSafeArea: true,
                        builder: (ctx) {
                          return const Center(
                            child: LoadingIndicator(
                              width: 50,
                              height: 50,
                            ),
                          );
                        },
                      ),
                    );

                    final walletsService =
                        ref.read(walletsServiceChangeNotifierProvider);

                    final walletId = await walletsService.addNewWallet(
                      name: widget.walletName,
                      coin: widget.coin,
                      type: WalletType.frostMS,
                      shouldNotifyListeners: false,
                    );

                    NodeModel? node = ref
                        .read(nodeServiceChangeNotifierProvider)
                        .getPrimaryNodeFor(coin: widget.coin);

                    if (node == null) {
                      node = DefaultNodes.getNodeFor(widget.coin);
                      await ref
                          .read(nodeServiceChangeNotifierProvider)
                          .setPrimaryNodeFor(
                            coin: widget.coin,
                            node: node,
                          );
                    }

                    final txTracker = TransactionNotificationTracker(
                      walletId: walletId!,
                    );

                    final failovers = ref
                        .read(nodeServiceChangeNotifierProvider)
                        .failoverNodesFor(coin: widget.coin);

                    final electrumxNode = ElectrumXNode(
                      address: node.host,
                      port: node.port,
                      name: node.name,
                      id: node.id,
                      useSSL: node.useSSL,
                    );
                    final client = ElectrumX.from(
                      node: electrumxNode,
                      failovers: failovers
                          .map((e) => ElectrumXNode(
                                address: e.host,
                                port: e.port,
                                name: e.name,
                                id: e.id,
                                useSSL: e.useSSL,
                              ))
                          .toList(),
                      prefs: ref.read(prefsChangeNotifierProvider),
                    );
                    final cachedClient = CachedElectrumX.from(
                      electrumXClient: client,
                    );

                    final wallet = FrostWallet(
                      walletId: walletId,
                      walletName: widget.walletName,
                      coin: widget.coin,
                      client: client,
                      cachedClient: cachedClient,
                      tracker: txTracker,
                      secureStore: ref.read(secureStoreProvider),
                    );

                    await wallet.initializeNewFrost(
                      mnemonic: seed,
                      multisigConfig: multisigConfig,
                      recoveryString: recoveryString,
                      serializedKeys: serializedKeys,
                      multisigId: multisigId,
                      myName: ref.read(pFrostMyName.state).state!,
                      participants: Frost.getParticipants(
                        multisigConfig:
                            ref.read(pFrostMultisigConfig.state).state!,
                      ),
                      threshold: Frost.getThreshold(
                        multisigConfig:
                            ref.read(pFrostMultisigConfig.state).state!,
                      ),
                    );

                    final manager = Manager(wallet);

                    await ref
                        .read(walletsServiceChangeNotifierProvider)
                        .setMnemonicVerified(
                          walletId: manager.walletId,
                        );

                    ref.read(walletsChangeNotifierProvider.notifier).addWallet(
                          walletId: manager.walletId,
                          manager: manager,
                        );

                    // pop progress dialog
                    if (mounted) {
                      Navigator.pop(context);
                      progressPopped = true;
                    }

                    if (mounted) {
                      if (Util.isDesktop) {
                        Navigator.of(context).popUntil(
                          ModalRoute.withName(
                            DesktopHomeView.routeName,
                          ),
                        );
                      } else {
                        unawaited(
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            HomeView.routeName,
                            (route) => false,
                          ),
                        );
                      }

                      ref.read(pFrostMultisigConfig.state).state = null;
                      ref.read(pFrostStartKeyGenData.state).state = null;
                      ref.read(pFrostSecretSharesData.state).state = null;

                      unawaited(
                        showFloatingFlushBar(
                          type: FlushBarType.success,
                          message: "Your wallet is set up.",
                          iconAsset: Assets.svg.check,
                          context: context,
                        ),
                      );
                    }
                  } catch (e, s) {
                    Logging.instance.log(
                      "$e\n$s",
                      level: LogLevel.Fatal,
                    );

                    // pop progress dialog
                    if (mounted && !progressPopped) {
                      Navigator.pop(context);
                      progressPopped = true;
                    }
                    // TODO: handle gracefully
                    rethrow;
                  }
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
