import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:isar/isar.dart';
import 'package:stackwallet/db/isar/main_db.dart';
import 'package:stackwallet/models/isar/models/ethereum/eth_contract.dart';
import 'package:stackwallet/notifications/show_flush_bar.dart';
import 'package:stackwallet/pages/add_wallet_views/add_token_view/add_custom_token_view.dart';
import 'package:stackwallet/pages/add_wallet_views/add_token_view/sub_widgets/add_token_list.dart';
import 'package:stackwallet/pages/add_wallet_views/add_token_view/sub_widgets/add_token_list_element.dart';
import 'package:stackwallet/pages/add_wallet_views/add_token_view/sub_widgets/add_token_text.dart';
import 'package:stackwallet/pages/home_view/home_view.dart';
import 'package:stackwallet/pages_desktop_specific/desktop_home_view.dart';
import 'package:stackwallet/providers/global/wallets_provider.dart';
import 'package:stackwallet/services/coins/ethereum/ethereum_wallet.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/default_eth_tokens.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';
import 'package:stackwallet/utilities/util.dart';
import 'package:stackwallet/widgets/background.dart';
import 'package:stackwallet/widgets/conditional_parent.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/desktop/desktop_app_bar.dart';
import 'package:stackwallet/widgets/desktop/desktop_dialog.dart';
import 'package:stackwallet/widgets/desktop/desktop_dialog_close_button.dart';
import 'package:stackwallet/widgets/desktop/desktop_scaffold.dart';
import 'package:stackwallet/widgets/desktop/primary_button.dart';
import 'package:stackwallet/widgets/desktop/secondary_button.dart';
import 'package:stackwallet/widgets/icon_widgets/x_icon.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';
import 'package:stackwallet/widgets/stack_text_field.dart';
import 'package:stackwallet/widgets/textfield_icon_button.dart';

class EditWalletTokensView extends ConsumerStatefulWidget {
  const EditWalletTokensView({
    Key? key,
    required this.walletId,
    this.contractsToMarkSelected,
    this.isDesktopPopup = false,
  }) : super(key: key);

  final String walletId;
  final List<String>? contractsToMarkSelected;
  final bool isDesktopPopup;

  static const routeName = "/editWalletTokens";

  @override
  ConsumerState<EditWalletTokensView> createState() =>
      _EditWalletTokensViewState();
}

class _EditWalletTokensViewState extends ConsumerState<EditWalletTokensView> {
  late final TextEditingController _searchFieldController;
  late final FocusNode _searchFocusNode;

  String _searchTerm = "";

  final List<AddTokenListElementData> tokenEntities = [];

  final bool isDesktop = Util.isDesktop;

  List<AddTokenListElementData> filter(
    String text,
    List<AddTokenListElementData> entities,
  ) {
    final _entities = [...entities];
    if (text.isNotEmpty) {
      final lowercaseTerm = text.toLowerCase();
      _entities.retainWhere(
        (e) =>
            e.token.name.toLowerCase().contains(lowercaseTerm) ||
            e.token.symbol.toLowerCase().contains(lowercaseTerm) ||
            e.token.address.toLowerCase().contains(lowercaseTerm),
      );
    }

    return _entities;
  }

  Future<void> onNextPressed() async {
    final selectedTokens = tokenEntities
        .where((e) => e.selected)
        .map((e) => e.token.address)
        .toList();

    final ethWallet = ref
        .read(walletsChangeNotifierProvider)
        .getManager(widget.walletId)
        .wallet as EthereumWallet;

    await ethWallet.updateTokenContracts(selectedTokens);
    if (mounted) {
      if (widget.contractsToMarkSelected == null) {
        Navigator.of(context).pop(42);
      } else {
        if (isDesktop) {
          Navigator.of(context).popUntil(
            ModalRoute.withName(DesktopHomeView.routeName),
          );
        } else {
          await Navigator.of(context).pushNamedAndRemoveUntil(
            HomeView.routeName,
            (route) => false,
          );
        }
        if (mounted) {
          unawaited(
            showFloatingFlushBar(
              type: FlushBarType.success,
              message: "${ethWallet.walletName} tokens saved",
              context: context,
            ),
          );
        }
      }
    }
  }

  Future<void> _addToken() async {
    EthContract? contract;

    if (isDesktop) {
      contract = await showDialog(
        context: context,
        builder: (context) => const DesktopDialog(
          maxWidth: 580,
          maxHeight: 500,
          child: AddCustomTokenView(),
        ),
      );
    } else {
      final result = await Navigator.of(context).pushNamed(
        AddCustomTokenView.routeName,
      );
      contract = result as EthContract?;
    }

    if (contract != null) {
      await MainDB.instance.putEthContract(contract);
      if (mounted) {
        setState(() {
          if (tokenEntities
              .where((e) => e.token.address == contract!.address)
              .isEmpty) {
            tokenEntities
                .add(AddTokenListElementData(contract!)..selected = true);
            tokenEntities.sort((a, b) => a.token.name.compareTo(b.token.name));
          }
        });
      }
    }
  }

  @override
  void initState() {
    _searchFieldController = TextEditingController();
    _searchFocusNode = FocusNode();

    final contracts =
        MainDB.instance.getEthContracts().sortByName().findAllSync();

    if (contracts.isEmpty) {
      contracts.addAll(DefaultTokens.list);
      MainDB.instance.putEthContracts(contracts);
    }

    tokenEntities.addAll(contracts.map((e) => AddTokenListElementData(e)));

    final walletContracts = (ref
            .read(walletsChangeNotifierProvider)
            .getManager(widget.walletId)
            .wallet as EthereumWallet)
        .getWalletTokenContractAddresses();

    final shouldMarkAsSelectedContracts = [
      ...walletContracts,
      ...(widget.contractsToMarkSelected ?? []),
    ];

    for (final e in tokenEntities) {
      e.selected = shouldMarkAsSelectedContracts.contains(e.token.address);
    }

    super.initState();
  }

  @override
  void dispose() {
    _searchFieldController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");
    final walletName = ref.watch(walletsChangeNotifierProvider
        .select((value) => value.getManager(widget.walletId).walletName));

    if (isDesktop) {
      return ConditionalParent(
        condition: !widget.isDesktopPopup,
        builder: (child) => DesktopScaffold(
          appBar: DesktopAppBar(
            isCompactHeight: false,
            useSpacers: false,
            leading: const AppBarBackButton(),
            overlayCenter: Text(
              walletName,
              style: STextStyles.desktopSubtitleH2(context),
            ),
            trailing: widget.contractsToMarkSelected == null
                ? Padding(
                    padding: const EdgeInsets.only(
                      right: 24,
                    ),
                    child: SizedBox(
                      height: 56,
                      child: TextButton(
                        style: Theme.of(context)
                            .extension<StackColors>()!
                            .getSmallSecondaryEnabledButtonStyle(context),
                        onPressed: _addToken,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                          ),
                          child: Text(
                            "Add custom token",
                            style:
                                STextStyles.desktopButtonSmallSecondaryEnabled(
                                    context),
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
          ),
          body: SizedBox(
            width: 480,
            child: Column(
              children: [
                const AddTokenText(
                  isDesktop: true,
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: RoundedWhiteContainer(
                    radiusMultiplier: 2,
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 20,
                      right: 20,
                      bottom: 0,
                    ),
                    child: child,
                  ),
                ),
                const SizedBox(
                  height: 26,
                ),
                SizedBox(
                  height: 70,
                  width: 480,
                  child: PrimaryButton(
                    label: widget.contractsToMarkSelected != null
                        ? "Save"
                        : "Next",
                    onPressed: onNextPressed,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
        child: ConditionalParent(
          condition: widget.isDesktopPopup,
          builder: (child) => DesktopDialog(
            maxHeight: 670,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 32,
                      ),
                      child: Text(
                        "Edit tokens",
                        style: STextStyles.desktopH3(context),
                      ),
                    ),
                    const DesktopDialogCloseButton(),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    child: child,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          label: "Add custom token",
                          buttonHeight: ButtonHeight.l,
                          onPressed: _addToken,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: PrimaryButton(
                          label: "Done",
                          buttonHeight: ButtonHeight.l,
                          onPressed: onNextPressed,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  Constants.size.circularBorderRadius,
                ),
                child: TextField(
                  autocorrect: Util.isDesktop ? false : true,
                  enableSuggestions: Util.isDesktop ? false : true,
                  controller: _searchFieldController,
                  focusNode: _searchFocusNode,
                  onChanged: (value) {
                    setState(() {
                      _searchTerm = value;
                    });
                  },
                  style: STextStyles.desktopTextMedium(context).copyWith(
                    height: 2,
                  ),
                  decoration: standardInputDecoration(
                    "Search",
                    _searchFocusNode,
                    context,
                  ).copyWith(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        // vertical: 20,
                      ),
                      child: SvgPicture.asset(
                        Assets.svg.search,
                        width: 24,
                        height: 24,
                        color: Theme.of(context)
                            .extension<StackColors>()!
                            .textFieldDefaultSearchIconLeft,
                      ),
                    ),
                    suffixIcon: _searchFieldController.text.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: UnconstrainedBox(
                              child: Row(
                                children: [
                                  TextFieldIconButton(
                                    child: const XIcon(
                                      width: 24,
                                      height: 24,
                                    ),
                                    onTap: () async {
                                      setState(() {
                                        _searchFieldController.text = "";
                                        _searchTerm = "";
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
                height: 12,
              ),
              Expanded(
                child: AddTokenList(
                  walletId: widget.walletId,
                  items: filter(_searchTerm, tokenEntities),
                  addFunction: isDesktop ? null : _addToken,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      );
    } else {
      return Background(
        child: Scaffold(
          backgroundColor:
              Theme.of(context).extension<StackColors>()!.background,
          appBar: AppBar(
            leading: AppBarBackButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  right: 20,
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: AppBarIconButton(
                    size: 36,
                    shadows: const [],
                    color:
                        Theme.of(context).extension<StackColors>()!.background,
                    icon: SvgPicture.asset(
                      Assets.svg.circlePlusFilled,
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .topNavIconPrimary,
                      width: 20,
                      height: 20,
                    ),
                    onPressed: _addToken,
                  ),
                ),
              ),
            ],
          ),
          body: Container(
            color: Theme.of(context).extension<StackColors>()!.background,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AddTokenText(
                    isDesktop: false,
                    walletName: walletName,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Constants.size.circularBorderRadius,
                    ),
                    child: TextField(
                      autofocus: isDesktop,
                      autocorrect: !isDesktop,
                      enableSuggestions: !isDesktop,
                      controller: _searchFieldController,
                      focusNode: _searchFocusNode,
                      onChanged: (value) => setState(() => _searchTerm = value),
                      style: STextStyles.field(context),
                      decoration: standardInputDecoration(
                        "Search",
                        _searchFocusNode,
                        context,
                        desktopMed: isDesktop,
                      ).copyWith(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 16,
                          ),
                          child: SvgPicture.asset(
                            Assets.svg.search,
                            width: 16,
                            height: 16,
                          ),
                        ),
                        suffixIcon: _searchFieldController.text.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(right: 0),
                                child: UnconstrainedBox(
                                  child: Row(
                                    children: [
                                      TextFieldIconButton(
                                        child: const XIcon(),
                                        onTap: () async {
                                          setState(() {
                                            _searchFieldController.text = "";
                                            _searchTerm = "";
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
                    height: 10,
                  ),
                  Expanded(
                    child: AddTokenList(
                      walletId: widget.walletId,
                      items: filter(_searchTerm, tokenEntities),
                      addFunction: _addToken,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  PrimaryButton(
                    label: widget.contractsToMarkSelected != null
                        ? "Save"
                        : "Next",
                    onPressed: onNextPressed,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
