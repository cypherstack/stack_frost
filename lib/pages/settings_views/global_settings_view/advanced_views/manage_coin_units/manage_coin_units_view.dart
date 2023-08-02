import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackfrost/pages/settings_views/global_settings_view/advanced_views/manage_coin_units/edit_coin_units_view.dart';
import 'package:stackfrost/providers/global/prefs_provider.dart';
import 'package:stackfrost/themes/coin_icon_provider.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/assets.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/utilities/util.dart';
import 'package:stackfrost/widgets/background.dart';
import 'package:stackfrost/widgets/conditional_parent.dart';
import 'package:stackfrost/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackfrost/widgets/desktop/desktop_dialog.dart';
import 'package:stackfrost/widgets/desktop/desktop_dialog_close_button.dart';
import 'package:stackfrost/widgets/rounded_white_container.dart';

class ManageCoinUnitsView extends ConsumerWidget {
  const ManageCoinUnitsView({Key? key}) : super(key: key);

  static const String routeName = "/manageCoinUnitsView";

  void onEditPressed(Coin coin, BuildContext context) {
    if (Util.isDesktop) {
      showDialog<void>(
        context: context,
        builder: (context) => EditCoinUnitsView(coin: coin),
      );
    } else {
      Navigator.of(context).pushNamed(
        EditCoinUnitsView.routeName,
        arguments: coin,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool showTestNet = ref.watch(
      prefsChangeNotifierProvider.select((value) => value.showTestNetCoins),
    );

    // todo: a change from e != Coin.firoTestnet
    final _coins = Coin.values
        .where((e) => e == Coin.bitcoin || e == Coin.bitcoinTestNet)
        .toList();

    List<Coin> coins = showTestNet
        ? _coins
        : _coins.sublist(0, _coins.length - kTestNetCoinCount);

    return ConditionalParent(
      condition: Util.isDesktop,
      builder: (child) => DesktopDialog(
        maxHeight: 850,
        maxWidth: 600,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Text(
                    "Units",
                    style: STextStyles.desktopH3(context),
                  ),
                ),
                const DesktopDialogCloseButton(),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 32,
                  right: 32,
                  bottom: 32,
                ),
                child: child,
              ),
            ),
          ],
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
                "Units",
                style: STextStyles.navBarTitle(context),
              ),
            ),
            body: child,
          ),
        ),
        child: ListView.separated(
          itemCount: Util.isDesktop ? coins.length : coins.length + 2,
          separatorBuilder: (_, __) => const SizedBox(
            height: 12,
          ),
          itemBuilder: (_, index) {
            if (!Util.isDesktop) {
              if (index == 0) {
                return const SizedBox(height: 0);
              } else if (index > coins.length) {
                return const SizedBox(height: 10);
              }
            }

            final coin = coins[Util.isDesktop ? index : index - 1];
            return Padding(
              padding: Util.isDesktop
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
              child: RoundedWhiteContainer(
                padding: Util.isDesktop
                    ? const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 14,
                      )
                    : const EdgeInsets.all(12),
                borderColor: Util.isDesktop
                    ? Theme.of(context).extension<StackColors>()!.textSubtitle6
                    : null,
                onPressed: () {
                  onEditPressed(coin, context);
                },
                child: Row(
                  children: [
                    SvgPicture.file(
                      File(
                        ref.watch(
                          coinIconProvider(coin),
                        ),
                      ),
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text(
                        "Edit ${coin.prettyName} units",
                        style: STextStyles.titleBold12(context),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    SvgPicture.asset(
                      Assets.svg.chevronRight,
                      width: Util.isDesktop ? 20 : 14,
                      height: Util.isDesktop ? 20 : 14,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
