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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackfrost/pages/settings_views/wallet_settings_view/frost_ms/resharing/step_1/begin_reshare_config_view.dart';
import 'package:stackfrost/pages/settings_views/wallet_settings_view/wallet_settings_wallet_settings/xpub_view.dart';
import 'package:stackfrost/pages_desktop_specific/addresses/desktop_wallet_addresses_view.dart';
import 'package:stackfrost/pages_desktop_specific/my_stack_view/wallet_view/sub_widgets/desktop_delete_wallet_dialog.dart';
import 'package:stackfrost/providers/frost_wallet/frost_wallet_providers.dart';
import 'package:stackfrost/providers/providers.dart';
import 'package:stackfrost/route_generator.dart';
import 'package:stackfrost/services/coins/bitcoin/frost_wallet.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/assets.dart';
import 'package:stackfrost/utilities/constants.dart';
import 'package:stackfrost/utilities/text_styles.dart';

enum _WalletOptions {
  addressList,
  deleteWallet,
  resharing,
  // changeRepresentative,
  showXpub;

  String get prettyName {
    switch (this) {
      case _WalletOptions.addressList:
        return "Address list";
      case _WalletOptions.deleteWallet:
        return "Delete wallet";
      case _WalletOptions.resharing:
        return "Resharing";
      // case _WalletOptions.changeRepresentative:
      //   return "Change representative";
      case _WalletOptions.showXpub:
        return "Show xPub";
    }
  }
}

class WalletOptionsButton extends ConsumerWidget {
  const WalletOptionsButton({
    Key? key,
    required this.walletId,
  }) : super(key: key);

  final String walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RawMaterialButton(
      constraints: const BoxConstraints(
        minHeight: 32,
        minWidth: 32,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1000),
      ),
      onPressed: () async {
        final func = await showDialog<_WalletOptions?>(
          context: context,
          barrierColor: Colors.transparent,
          builder: (context) {
            return WalletOptionsPopupMenu(
              onDeletePressed: () async {
                Navigator.of(context).pop(_WalletOptions.deleteWallet);
              },
              onAddressListPressed: () async {
                Navigator.of(context).pop(_WalletOptions.addressList);
              },
              onResharingPressed: () async {
                Navigator.of(context).pop(_WalletOptions.resharing);
              },
              // onChangeRepPressed: () async {
              //   Navigator.of(context).pop(_WalletOptions.changeRepresentative);
              // },
              onShowXpubPressed: () async {
                Navigator.of(context).pop(_WalletOptions.showXpub);
              },
              walletId: walletId,
            );
          },
        );

        if (context.mounted && func != null) {
          switch (func) {
            case _WalletOptions.addressList:
              unawaited(
                Navigator.of(context).pushNamed(
                  DesktopWalletAddressesView.routeName,
                  arguments: walletId,
                ),
              );
              break;
            case _WalletOptions.resharing:
              ref.read(pFrostMyName.state).state = (ref
                      .read(walletsChangeNotifierProvider)
                      .getManager(walletId)
                      .wallet as FrostWallet)
                  .myName;
              unawaited(
                Navigator.of(context).pushNamed(
                  BeginReshareConfigView.routeName,
                  arguments: walletId,
                ),
              );
              break;
            case _WalletOptions.deleteWallet:
              final result = await showDialog<bool?>(
                context: context,
                barrierDismissible: false,
                builder: (context) => Navigator(
                  initialRoute: DesktopDeleteWalletDialog.routeName,
                  onGenerateRoute: RouteGenerator.generateRoute,
                  onGenerateInitialRoutes: (_, __) {
                    return [
                      RouteGenerator.generateRoute(
                        RouteSettings(
                          name: DesktopDeleteWalletDialog.routeName,
                          arguments: walletId,
                        ),
                      ),
                    ];
                  },
                ),
              );

              if (result == true) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
              break;
            case _WalletOptions.showXpub:
              final result = await showDialog<bool?>(
                context: context,
                barrierDismissible: false,
                builder: (context) => Navigator(
                  initialRoute: XPubView.routeName,
                  onGenerateRoute: RouteGenerator.generateRoute,
                  onGenerateInitialRoutes: (_, __) {
                    return [
                      RouteGenerator.generateRoute(
                        RouteSettings(
                          name: XPubView.routeName,
                          arguments: walletId,
                        ),
                      ),
                    ];
                  },
                ),
              );

              if (result == true) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
              break;
              // case _WalletOptions.changeRepresentative:
              //   final result = await showDialog<bool?>(
              //     context: context,
              //     barrierDismissible: false,
              //     builder: (context) => Navigator(
              //       initialRoute: ChangeRepresentativeView.routeName,
              //       onGenerateRoute: RouteGenerator.generateRoute,
              //       onGenerateInitialRoutes: (_, __) {
              //         return [
              //           RouteGenerator.generateRoute(
              //             RouteSettings(
              //               name: ChangeRepresentativeView.routeName,
              //               arguments: walletId,
              //             ),
              //           ),
              //         ];
              //       },
              //     ),
              //   );

              if (result == true) {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
              break;
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 19,
          horizontal: 32,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              Assets.svg.ellipsis,
              width: 20,
              height: 20,
              color: Theme.of(context)
                  .extension<StackColors>()!
                  .buttonTextSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class WalletOptionsPopupMenu extends ConsumerWidget {
  const WalletOptionsPopupMenu({
    Key? key,
    required this.onDeletePressed,
    required this.onAddressListPressed,
    required this.onShowXpubPressed,
    required this.onResharingPressed,
    // required this.onChangeRepPressed,
    required this.walletId,
  }) : super(key: key);

  final VoidCallback onDeletePressed;
  final VoidCallback onAddressListPressed;
  final VoidCallback onShowXpubPressed;
  final VoidCallback onResharingPressed;
  // final VoidCallback onChangeRepPressed;
  final String walletId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.watch(walletsChangeNotifierProvider
        .select((value) => value.getManager(walletId)));
    final bool xpubEnabled = manager.hasXPub;

    final bool canChangeRep = false;
    // manager.coin == Coin.nano || manager.coin == Coin.banano;

    return Stack(
      children: [
        Positioned(
          top: 24,
          left: MediaQuery.of(context).size.width - 234,
          child: Container(
            width: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                Constants.size.circularBorderRadius * 2,
              ),
              color: Theme.of(context).extension<StackColors>()!.popupBG,
              boxShadow: [
                Theme.of(context).extension<StackColors>()!.standardBoxShadow,
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TransparentButton(
                    onPressed: onAddressListPressed,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            Assets.svg.list,
                            width: 20,
                            height: 20,
                            color: Theme.of(context)
                                .extension<StackColors>()!
                                .textFieldActiveSearchIconLeft,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _WalletOptions.addressList.prettyName,
                              style: STextStyles.desktopTextExtraExtraSmall(
                                      context)
                                  .copyWith(
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // if (canChangeRep)
                  //   const SizedBox(
                  //     height: 8,
                  //   ),
                  // if (canChangeRep)
                  //   TransparentButton(
                  //     onPressed: onChangeRepPressed,
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           SvgPicture.asset(
                  //             Assets.svg.eye,
                  //             width: 20,
                  //             height: 20,
                  //             color: Theme.of(context)
                  //                 .extension<StackColors>()!
                  //                 .textFieldActiveSearchIconLeft,
                  //           ),
                  //           const SizedBox(width: 14),
                  //           // Expanded(
                  //           //   child: Text(
                  //           //     _WalletOptions.changeRepresentative.prettyName,
                  //           //     style: STextStyles.desktopTextExtraExtraSmall(
                  //           //             context)
                  //           //         .copyWith(
                  //           //       color: Theme.of(context)
                  //           //           .extension<StackColors>()!
                  //           //           .textDark,
                  //           //     ),
                  //           //   ),
                  //           // ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  if (xpubEnabled)
                    const SizedBox(
                      height: 8,
                    ),
                  if (xpubEnabled)
                    TransparentButton(
                      onPressed: onShowXpubPressed,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              Assets.svg.eye,
                              width: 20,
                              height: 20,
                              color: Theme.of(context)
                                  .extension<StackColors>()!
                                  .textFieldActiveSearchIconLeft,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                _WalletOptions.showXpub.prettyName,
                                style: STextStyles.desktopTextExtraExtraSmall(
                                        context)
                                    .copyWith(
                                  color: Theme.of(context)
                                      .extension<StackColors>()!
                                      .textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  TransparentButton(
                    onPressed: onResharingPressed,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            Assets.svg.exchangeDesktop,
                            width: 20,
                            height: 20,
                            color: Theme.of(context)
                                .extension<StackColors>()!
                                .textFieldActiveSearchIconLeft,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _WalletOptions.resharing.prettyName,
                              style: STextStyles.desktopTextExtraExtraSmall(
                                      context)
                                  .copyWith(
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TransparentButton(
                    onPressed: onDeletePressed,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            Assets.svg.trash,
                            width: 20,
                            height: 20,
                            color: Theme.of(context)
                                .extension<StackColors>()!
                                .textFieldActiveSearchIconLeft,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _WalletOptions.deleteWallet.prettyName,
                              style: STextStyles.desktopTextExtraExtraSmall(
                                      context)
                                  .copyWith(
                                color: Theme.of(context)
                                    .extension<StackColors>()!
                                    .textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TransparentButton extends StatelessWidget {
  const TransparentButton({
    Key? key,
    required this.child,
    this.onPressed,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: const BoxConstraints(
        minHeight: 32,
        minWidth: 32,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          Constants.size.circularBorderRadius,
        ),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
