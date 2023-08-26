import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackfrost/electrumx_rpc/cached_electrumx.dart';
import 'package:stackfrost/electrumx_rpc/electrumx.dart';
import 'package:stackfrost/models/node_model.dart';
import 'package:stackfrost/pages/settings_views/wallet_settings_view/frost_ms/resharing/new/new_start_resharing_view.dart';
import 'package:stackfrost/pages_desktop_specific/my_stack_view/exit_to_my_stack_button.dart';
import 'package:stackfrost/providers/frost_wallet/frost_wallet_providers.dart';
import 'package:stackfrost/providers/global/node_service_provider.dart';
import 'package:stackfrost/providers/global/prefs_provider.dart';
import 'package:stackfrost/providers/global/secure_store_provider.dart';
import 'package:stackfrost/providers/global/wallets_service_provider.dart';
import 'package:stackfrost/services/coins/bitcoin/frost_wallet.dart';
import 'package:stackfrost/services/transaction_notification_tracker.dart';
import 'package:stackfrost/services/wallets_service.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/constants.dart';
import 'package:stackfrost/utilities/default_nodes.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';
import 'package:stackfrost/utilities/logger.dart';
import 'package:stackfrost/utilities/show_loading.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/utilities/util.dart';
import 'package:stackfrost/widgets/background.dart';
import 'package:stackfrost/widgets/conditional_parent.dart';
import 'package:stackfrost/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackfrost/widgets/desktop/desktop_app_bar.dart';
import 'package:stackfrost/widgets/desktop/desktop_scaffold.dart';
import 'package:stackfrost/widgets/desktop/primary_button.dart';
import 'package:stackfrost/widgets/icon_widgets/clipboard_icon.dart';
import 'package:stackfrost/widgets/icon_widgets/qrcode_icon.dart';
import 'package:stackfrost/widgets/icon_widgets/x_icon.dart';
import 'package:stackfrost/widgets/stack_dialog.dart';
import 'package:stackfrost/widgets/stack_text_field.dart';
import 'package:stackfrost/widgets/textfield_icon_button.dart';

class NewImportResharerConfigView extends ConsumerStatefulWidget {
  const NewImportResharerConfigView({
    super.key,
    required this.walletName,
    required this.coin,
  });

  static const String routeName = "/newImportResharerConfigView";

  final String walletName;
  final Coin coin;

  @override
  ConsumerState<NewImportResharerConfigView> createState() =>
      _NewImportResharerConfigViewState();
}

class _NewImportResharerConfigViewState
    extends ConsumerState<NewImportResharerConfigView> {
  late final TextEditingController myNameFieldController, configFieldController;
  late final FocusNode myNameFocusNode, configFocusNode;

  bool _nameEmpty = true, _configEmpty = true;

  bool _buttonLock = false;

  Future<FrostWallet> _createWallet() async {
    final walletsService = ref.read(walletsServiceChangeNotifierProvider);

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
      await ref.read(nodeServiceChangeNotifierProvider).setPrimaryNodeFor(
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

    return wallet;
  }

  @override
  void initState() {
    myNameFieldController = TextEditingController();
    configFieldController = TextEditingController();
    myNameFocusNode = FocusNode();
    configFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    myNameFieldController.dispose();
    configFieldController.dispose();
    myNameFocusNode.dispose();
    configFocusNode.dispose();
    super.dispose();
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
                "Import FROST reshare config",
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
            const SizedBox(
              height: 16,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                Constants.size.circularBorderRadius,
              ),
              child: TextField(
                key: const Key("frMyNameTextFieldKey"),
                controller: myNameFieldController,
                onChanged: (_) {
                  setState(() {
                    _nameEmpty = myNameFieldController.text.isEmpty;
                  });
                },
                focusNode: myNameFocusNode,
                readOnly: false,
                autocorrect: false,
                enableSuggestions: false,
                style: STextStyles.field(context),
                decoration: standardInputDecoration(
                  "My name",
                  myNameFocusNode,
                  context,
                ).copyWith(
                  contentPadding: const EdgeInsets.only(
                    left: 16,
                    top: 6,
                    bottom: 8,
                    right: 5,
                  ),
                  suffixIcon: Padding(
                    padding: _nameEmpty
                        ? const EdgeInsets.only(right: 8)
                        : const EdgeInsets.only(right: 0),
                    child: UnconstrainedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          !_nameEmpty
                              ? TextFieldIconButton(
                                  semanticsLabel:
                                      "Clear Button. Clears The Config Field.",
                                  key: const Key("frMyNameClearButtonKey"),
                                  onTap: () {
                                    myNameFieldController.text = "";

                                    setState(() {
                                      _nameEmpty = true;
                                    });
                                  },
                                  child: const XIcon(),
                                )
                              : TextFieldIconButton(
                                  semanticsLabel:
                                      "Paste Button. Pastes From Clipboard To Name Field.",
                                  key: const Key("frMyNamePasteButtonKey"),
                                  onTap: () async {
                                    final ClipboardData? data =
                                        await Clipboard.getData(
                                            Clipboard.kTextPlain);
                                    if (data?.text != null &&
                                        data!.text!.isNotEmpty) {
                                      myNameFieldController.text =
                                          data.text!.trim();
                                    }

                                    setState(() {
                                      _nameEmpty =
                                          myNameFieldController.text.isEmpty;
                                    });
                                  },
                                  child: _nameEmpty
                                      ? const ClipboardIcon()
                                      : const XIcon(),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                Constants.size.circularBorderRadius,
              ),
              child: TextField(
                key: const Key("frConfigTextFieldKey"),
                controller: configFieldController,
                onChanged: (_) {
                  setState(() {
                    _configEmpty = configFieldController.text.isEmpty;
                  });
                },
                focusNode: configFocusNode,
                readOnly: false,
                autocorrect: false,
                enableSuggestions: false,
                style: STextStyles.field(context),
                decoration: standardInputDecoration(
                  "Enter config",
                  configFocusNode,
                  context,
                ).copyWith(
                  contentPadding: const EdgeInsets.only(
                    left: 16,
                    top: 6,
                    bottom: 8,
                    right: 5,
                  ),
                  suffixIcon: Padding(
                    padding: _configEmpty
                        ? const EdgeInsets.only(right: 8)
                        : const EdgeInsets.only(right: 0),
                    child: UnconstrainedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          !_configEmpty
                              ? TextFieldIconButton(
                                  semanticsLabel:
                                      "Clear Button. Clears The Config Field.",
                                  key: const Key("frConfigClearButtonKey"),
                                  onTap: () {
                                    configFieldController.text = "";

                                    setState(() {
                                      _configEmpty = true;
                                    });
                                  },
                                  child: const XIcon(),
                                )
                              : TextFieldIconButton(
                                  semanticsLabel:
                                      "Paste Button. Pastes From Clipboard To Config Field Input.",
                                  key: const Key("frConfigPasteButtonKey"),
                                  onTap: () async {
                                    final ClipboardData? data =
                                        await Clipboard.getData(
                                            Clipboard.kTextPlain);
                                    if (data?.text != null &&
                                        data!.text!.isNotEmpty) {
                                      configFieldController.text =
                                          data.text!.trim();
                                    }

                                    setState(() {
                                      _configEmpty =
                                          configFieldController.text.isEmpty;
                                    });
                                  },
                                  child: _configEmpty
                                      ? const ClipboardIcon()
                                      : const XIcon(),
                                ),
                          if (_configEmpty)
                            TextFieldIconButton(
                              semanticsLabel:
                                  "Scan QR Button. Opens Camera For Scanning QR Code.",
                              key: const Key("frConfigScanQrButtonKey"),
                              onTap: () async {
                                try {
                                  if (FocusScope.of(context).hasFocus) {
                                    FocusScope.of(context).unfocus();
                                    await Future<void>.delayed(
                                        const Duration(milliseconds: 75));
                                  }

                                  final qrResult = await BarcodeScanner.scan();

                                  configFieldController.text =
                                      qrResult.rawContent;

                                  setState(() {
                                    _configEmpty =
                                        configFieldController.text.isEmpty;
                                  });
                                } on PlatformException catch (e, s) {
                                  Logging.instance.log(
                                    "Failed to get camera permissions while trying to scan qr code: $e\n$s",
                                    level: LogLevel.Warning,
                                  );
                                }
                              },
                              child: const QrCodeIcon(),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            if (!Util.isDesktop) const Spacer(),
            const SizedBox(
              height: 16,
            ),
            PrimaryButton(
              label: "Start",
              enabled: !_nameEmpty && !_configEmpty,
              onPressed: () async {
                if (FocusScope.of(context).hasFocus) {
                  FocusScope.of(context).unfocus();
                }
                if (_buttonLock) {
                  return;
                }
                _buttonLock = true;

                try {
                  ref.read(pFrostResharingData).reset();
                  ref.read(pFrostResharingData).myName =
                      myNameFieldController.text;
                  ref.read(pFrostResharingData).resharerConfig =
                      configFieldController.text;

                  if (!ref
                      .read(pFrostResharingData)
                      .configData!
                      .newParticipants
                      .contains(ref.read(pFrostResharingData).myName!)) {
                    ref.read(pFrostResharingData).reset();
                    return await showDialog<void>(
                      context: context,
                      builder: (_) => StackOkDialog(
                        title: "My name not found in config participants",
                        desktopPopRootNavigator: Util.isDesktop,
                      ),
                    );
                  }

                  Exception? ex;
                  final wallet = await showLoading(
                    whileFuture: _createWallet(),
                    context: context,
                    message: "Setting up wallet",
                    isDesktop: Util.isDesktop,
                    onException: (e) => ex = e,
                  );

                  if (ex != null) {
                    throw ex!;
                  }

                  if (mounted) {
                    ref.read(pFrostResharingData).incompleteWallet = wallet!;
                    await Navigator.of(context).pushNamed(
                      NewStartResharingView.routeName,
                      arguments: wallet.walletId,
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
