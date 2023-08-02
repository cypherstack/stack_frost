/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackfrost/models/add_wallet_list_entity/sub_classes/coin_entity.dart';
import 'package:stackfrost/pages/add_wallet_views/create_or_restore_wallet_view/create_or_restore_wallet_view.dart';
import 'package:stackfrost/providers/providers.dart';
import 'package:stackfrost/services/coins/manager.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/assets.dart';
import 'package:stackfrost/utilities/constants.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/utilities/util.dart';
import 'package:stackfrost/widgets/background.dart';
import 'package:stackfrost/widgets/conditional_parent.dart';
import 'package:stackfrost/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackfrost/widgets/icon_widgets/x_icon.dart';
import 'package:stackfrost/widgets/rounded_white_container.dart';
import 'package:stackfrost/widgets/stack_text_field.dart';
import 'package:stackfrost/widgets/textfield_icon_button.dart';
import 'package:stackfrost/widgets/wallet_card.dart';

class WalletsOverview extends ConsumerStatefulWidget {
  const WalletsOverview({
    Key? key,
    required this.coin,
    this.navigatorState,
  }) : super(key: key);

  final Coin coin;
  final NavigatorState? navigatorState;

  static const routeName = "/walletsOverview";

  @override
  ConsumerState<WalletsOverview> createState() => _EthWalletsOverviewState();
}

class _EthWalletsOverviewState extends ConsumerState<WalletsOverview> {
  final isDesktop = Util.isDesktop;

  late final TextEditingController _searchController;
  late final FocusNode searchFieldFocusNode;

  String _searchString = "";

  final List<Manager> wallets = [];

  List<Manager> _filter(String searchTerm) {
    if (searchTerm.isEmpty) {
      return wallets;
    }

    final List<Manager> results = [];
    final term = searchTerm.toLowerCase();

    for (final tuple in wallets) {
      bool includeManager = false;
      // search wallet name and total balance
      includeManager |= _elementContains(tuple.walletName, term);
      includeManager |= _elementContains(
        tuple.balance.total.decimal.toString(),
        term,
      );

      // TODO: look at this; #stackFrost
      // if (includeManager) {
      //   results.add(Tuple2(tuple.item1, contracts));
      // }
    }

    return results;
  }

  bool _elementContains(String element, String term) {
    return element.toLowerCase().contains(term);
  }

  @override
  void initState() {
    _searchController = TextEditingController();
    searchFieldFocusNode = FocusNode();

    final walletsData =
        ref.read(walletsServiceChangeNotifierProvider).fetchWalletsData();
    walletsData.removeWhere((key, value) => value.coin != widget.coin);

    // add non token wallet tuple to list
    for (final data in walletsData.values) {
      wallets.add(
        ref.read(walletsChangeNotifierProvider).getManager(
              data.walletId,
            ),
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    searchFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalParent(
      condition: !isDesktop,
      builder: (child) => Background(
        child: Scaffold(
          backgroundColor:
              Theme.of(context).extension<StackColors>()!.background,
          appBar: AppBar(
            leading: const AppBarBackButton(),
            title: Text(
              "${widget.coin.prettyName} (${widget.coin.ticker}) wallets",
              style: STextStyles.navBarTitle(context),
            ),
            actions: [
              AspectRatio(
                aspectRatio: 1,
                child: AppBarIconButton(
                  icon: SvgPicture.asset(
                    Assets.svg.plus,
                    width: 18,
                    height: 18,
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .topNavIconPrimary,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      CreateOrRestoreWalletView.routeName,
                      arguments: CoinEntity(widget.coin),
                    );
                  },
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              Constants.size.circularBorderRadius,
            ),
            child: TextField(
              autocorrect: !isDesktop,
              enableSuggestions: !isDesktop,
              controller: _searchController,
              focusNode: searchFieldFocusNode,
              onChanged: (value) {
                setState(() {
                  _searchString = value;
                });
              },
              style: isDesktop
                  ? STextStyles.desktopTextExtraSmall(context).copyWith(
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .textFieldActiveText,
                      height: 1.8,
                    )
                  : STextStyles.field(context),
              decoration: standardInputDecoration(
                "Search...",
                searchFieldFocusNode,
                context,
                desktopMed: isDesktop,
              ).copyWith(
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 12 : 10,
                    vertical: isDesktop ? 18 : 16,
                  ),
                  child: SvgPicture.asset(
                    Assets.svg.search,
                    width: isDesktop ? 20 : 16,
                    height: isDesktop ? 20 : 16,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: UnconstrainedBox(
                          child: Row(
                            children: [
                              TextFieldIconButton(
                                child: const XIcon(),
                                onTap: () async {
                                  setState(() {
                                    _searchController.text = "";
                                    _searchString = "";
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                final data = _filter(_searchString);
                return ListView.separated(
                  itemBuilder: (_, index) {
                    final element = data[index];

                    return ConditionalParent(
                      condition: isDesktop,
                      builder: (child) => RoundedWhiteContainer(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        borderColor: Theme.of(context)
                            .extension<StackColors>()!
                            .backgroundAppBar,
                        child: child,
                      ),
                      child: SimpleWalletCard(
                        walletId: element.walletId,
                        popPrevious: isDesktop,
                        desktopNavigatorState:
                            isDesktop ? widget.navigatorState : null,
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => SizedBox(
                    height: isDesktop ? 10 : 8,
                  ),
                  itemCount: data.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
