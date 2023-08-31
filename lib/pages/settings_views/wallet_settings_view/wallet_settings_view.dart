/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackfrost/pages/home_view/home_view.dart';
import 'package:stackfrost/pages/pinpad_views/lock_screen_view.dart';
import 'package:stackfrost/pages/settings_views/global_settings_view/advanced_views/debug_view.dart';
import 'package:stackfrost/pages/settings_views/sub_widgets/settings_list_button.dart';
import 'package:stackfrost/pages/settings_views/wallet_settings_view/frost_ms/frost_ms_options_view.dart';
import 'package:stackfrost/pages/settings_views/wallet_settings_view/wallet_backup_views/wallet_backup_view.dart';
import 'package:stackfrost/pages/settings_views/wallet_settings_view/wallet_network_settings_view/wallet_network_settings_view.dart';
import 'package:stackfrost/pages/settings_views/wallet_settings_view/wallet_settings_wallet_settings/wallet_settings_wallet_settings_view.dart';
import 'package:stackfrost/pages/settings_views/wallet_settings_view/wallet_settings_wallet_settings/xpub_view.dart';
import 'package:stackfrost/providers/global/wallets_provider.dart';
import 'package:stackfrost/providers/ui/transaction_filter_provider.dart';
import 'package:stackfrost/route_generator.dart';
import 'package:stackfrost/services/coins/bitcoin/frost_wallet.dart';
import 'package:stackfrost/services/event_bus/events/global/node_connection_status_changed_event.dart';
import 'package:stackfrost/services/event_bus/events/global/wallet_sync_status_changed_event.dart';
import 'package:stackfrost/services/event_bus/global_event_bus.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/assets.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/widgets/background.dart';
import 'package:stackfrost/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackfrost/widgets/rounded_white_container.dart';
import 'package:tuple/tuple.dart';

/// [eventBus] should only be set during testing
class WalletSettingsView extends ConsumerStatefulWidget {
  const WalletSettingsView({
    Key? key,
    required this.walletId,
    required this.coin,
    required this.initialSyncStatus,
    required this.initialNodeStatus,
    this.eventBus,
  }) : super(key: key);

  static const String routeName = "/walletSettings";

  final String walletId;
  final Coin coin;
  final WalletSyncStatus initialSyncStatus;
  final NodeConnectionStatus initialNodeStatus;
  final EventBus? eventBus;

  @override
  ConsumerState<WalletSettingsView> createState() => _WalletSettingsViewState();
}

class _WalletSettingsViewState extends ConsumerState<WalletSettingsView> {
  late final String walletId;
  late final Coin coin;
  late String xpub;
  late final bool xPubEnabled;

  late final EventBus eventBus;

  late WalletSyncStatus _currentSyncStatus;
  // late NodeConnectionStatus _currentNodeStatus;

  late StreamSubscription<dynamic> _syncStatusSubscription;
  // late StreamSubscription _nodeStatusSubscription;

  @override
  void initState() {
    walletId = widget.walletId;
    coin = widget.coin;
    xPubEnabled =
        ref.read(walletsChangeNotifierProvider).getManager(walletId).hasXPub;
    xpub = "";

    _currentSyncStatus = widget.initialSyncStatus;
    // _currentNodeStatus = widget.initialNodeStatus;

    eventBus =
        widget.eventBus != null ? widget.eventBus! : GlobalEventBus.instance;

    _syncStatusSubscription =
        eventBus.on<WalletSyncStatusChangedEvent>().listen(
      (event) async {
        if (event.walletId == walletId) {
          switch (event.newStatus) {
            case WalletSyncStatus.unableToSync:
              // TODO: Handle this case.
              break;
            case WalletSyncStatus.synced:
              // TODO: Handle this case.
              break;
            case WalletSyncStatus.syncing:
              // TODO: Handle this case.
              break;
          }
          setState(() {
            _currentSyncStatus = event.newStatus;
          });
        }
      },
    );

    // _nodeStatusSubscription =
    //     eventBus.on<NodeConnectionStatusChangedEvent>().listen(
    //   (event) async {
    //     if (event.walletId == widget.walletId) {
    //       switch (event.newStatus) {
    //         case NodeConnectionStatus.disconnected:
    //           // TODO: Handle this case.
    //           break;
    //         case NodeConnectionStatus.connected:
    //           // TODO: Handle this case.
    //           break;
    //         case NodeConnectionStatus.connecting:
    //           // TODO: Handle this case.
    //           break;
    //       }
    //       setState(() {
    //         _currentNodeStatus = event.newStatus;
    //       });
    //     }
    //   },
    // );
    super.initState();
  }

  @override
  void dispose() {
    // _nodeStatusSubscription.cancel();
    _syncStatusSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");
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
            "Settings",
            style: STextStyles.navBarTitle(context),
          ),
        ),
        body: LayoutBuilder(
          builder: (builderContext, constraints) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 12,
                top: 12,
                right: 12,
              ),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 24,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RoundedWhiteContainer(
                            padding: const EdgeInsets.all(4),
                            child: Column(
                              children: [
                                if (ref.watch(walletsChangeNotifierProvider
                                    .select((value) => value
                                        .getManager(widget.walletId)
                                        .wallet)) is FrostWallet)
                                  SettingsListButton(
                                    iconAssetName: Assets.svg.addressBook,
                                    iconSize: 16,
                                    title: "FROST Multisig options",
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                        FrostMSWalletOptionsView.routeName,
                                        arguments: walletId,
                                      );
                                    },
                                  ),
                                if (ref.watch(walletsChangeNotifierProvider
                                    .select((value) => value
                                        .getManager(widget.walletId)
                                        .wallet)) is FrostWallet)
                                  const SizedBox(
                                    height: 8,
                                  ),
                                SettingsListButton(
                                  iconAssetName: Assets.svg.node,
                                  iconSize: 16,
                                  title: "Network",
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      WalletNetworkSettingsView.routeName,
                                      arguments: Tuple3(
                                        walletId,
                                        _currentSyncStatus,
                                        widget.initialNodeStatus,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Consumer(
                                  builder: (_, ref, __) {
                                    return SettingsListButton(
                                      iconAssetName: Assets.svg.lock,
                                      iconSize: 16,
                                      title: "Wallet backup",
                                      onPressed: () async {
                                        final wallet = ref
                                            .read(walletsChangeNotifierProvider)
                                            .getManager(walletId)
                                            .wallet;

                                        ({
                                          String myName,
                                          String config,
                                          String keys,
                                          ({
                                            String config,
                                            String keys
                                          })? prevGen,
                                        })? frostWalletData;

                                        List<Future<dynamic>> futures = [
                                          wallet.mnemonic,
                                        ];

                                        if (wallet is FrostWallet) {
                                          futures.addAll(
                                            [
                                              wallet.getSerializedKeys,
                                              wallet.multisigConfig,
                                              wallet.getSerializedKeysPrevGen,
                                              wallet.multisigConfigPrevGen,
                                            ],
                                          );
                                        }

                                        final results =
                                            await Future.wait(futures);

                                        final List<String> mnemonic =
                                            results.first as List<String>;

                                        if (results.length == 5) {
                                          frostWalletData = (
                                            myName:
                                                (wallet as FrostWallet).myName,
                                            config: results[2],
                                            keys: results[1],
                                            prevGen: results[3] == null ||
                                                    results[4] == null
                                                ? null
                                                : (
                                                    config: results[3],
                                                    keys: results[4],
                                                  ),
                                          );
                                        }

                                        if (mounted) {
                                          await Navigator.push(
                                            context,
                                            RouteGenerator.getRoute(
                                              shouldUseMaterialRoute:
                                                  RouteGenerator
                                                      .useMaterialPageRoute,
                                              builder: (_) => LockscreenView(
                                                routeOnSuccessArguments: (
                                                  walletId: walletId,
                                                  mnemonic: mnemonic,
                                                  frostWalletData:
                                                      frostWalletData,
                                                ),
                                                showBackButton: true,
                                                routeOnSuccess:
                                                    WalletBackupView.routeName,
                                                biometricsCancelButtonString:
                                                    "CANCEL",
                                                biometricsLocalizedReason:
                                                    "Authenticate to view recovery info",
                                                biometricsAuthenticationTitle:
                                                    "View recovery phrase",
                                              ),
                                              settings: const RouteSettings(
                                                  name:
                                                      "/viewRecoverPhraseLockscreen"),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SettingsListButton(
                                  iconAssetName: Assets.svg.downloadFolder,
                                  title: "Wallet settings",
                                  iconSize: 16,
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      WalletSettingsWalletSettingsView
                                          .routeName,
                                      arguments: walletId,
                                    );
                                  },
                                ),
                                if (xPubEnabled)
                                  const SizedBox(
                                    height: 8,
                                  ),
                                if (xPubEnabled)
                                  Consumer(
                                    builder: (_, ref, __) {
                                      return SettingsListButton(
                                        iconAssetName: Assets.svg.eye,
                                        title: "Wallet xPub",
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                            XPubView.routeName,
                                            arguments: widget.walletId,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SettingsListButton(
                                  iconAssetName: Assets.svg.ellipsis,
                                  title: "Debug Info",
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(DebugView.routeName);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Spacer(),
                          Consumer(
                            builder: (_, ref, __) {
                              return TextButton(
                                onPressed: () {
                                  ref
                                      .read(walletsChangeNotifierProvider)
                                      .getManager(walletId)
                                      .isActiveWallet = false;
                                  ref
                                      .read(transactionFilterProvider.state)
                                      .state = null;

                                  Navigator.of(context).popUntil(
                                    ModalRoute.withName(HomeView.routeName),
                                  );
                                },
                                style: Theme.of(context)
                                    .extension<StackColors>()!
                                    .getSecondaryEnabledButtonStyle(context),
                                child: Text(
                                  "Log out",
                                  style: STextStyles.button(context).copyWith(
                                      color: Theme.of(context)
                                          .extension<StackColors>()!
                                          .accentColorDark),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
