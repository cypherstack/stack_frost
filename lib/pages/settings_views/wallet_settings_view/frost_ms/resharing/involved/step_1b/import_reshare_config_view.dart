import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frostdart/frostdart.dart';
import 'package:stackfrost/pages/settings_views/wallet_settings_view/frost_ms/resharing/involved/step_2/begin_resharing_view.dart';
import 'package:stackfrost/providers/frost_wallet/frost_wallet_providers.dart';
import 'package:stackfrost/providers/global/wallets_provider.dart';
import 'package:stackfrost/services/coins/bitcoin/frost_wallet.dart';
import 'package:stackfrost/services/frost.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/constants.dart';
import 'package:stackfrost/utilities/format.dart';
import 'package:stackfrost/utilities/logger.dart';
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

class ImportReshareConfigView extends ConsumerStatefulWidget {
  const ImportReshareConfigView({
    super.key,
    required this.walletId,
  });

  static const String routeName = "/importReshareConfigView";

  final String walletId;

  @override
  ConsumerState<ImportReshareConfigView> createState() =>
      _ImportReshareConfigViewState();
}

class _ImportReshareConfigViewState
    extends ConsumerState<ImportReshareConfigView> {
  late final TextEditingController configFieldController;
  late final FocusNode configFocusNode;

  bool _configEmpty = true;

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

      ref.read(pFrostResharingData).reset();
      ref.read(pFrostResharingData).myName = wallet.myName;
      ref.read(pFrostResharingData).resharerConfig = configFieldController.text;

      String? salt;
      try {
        salt = Format.uint8listToString(
          resharerSalt(
            resharerConfig: ref.read(pFrostResharingData).resharerConfig!,
          ),
        );
      } catch (_) {
        throw Exception("Bad resharer config");
      }

      if (wallet.knownSalts.contains(salt)) {
        throw Exception("Duplicate config salt");
      } else {
        final salts = wallet.knownSalts;
        salts.add(salt);
        await wallet.updateKnownSalts(salts);
      }

      final serializedKeys = await wallet.getSerializedKeys;
      if (mounted) {
        final result = Frost.beginResharer(
          serializedKeys: serializedKeys!,
          config: ref.read(pFrostResharingData).resharerConfig!,
        );

        ref.read(pFrostResharingData).startResharerData = result;

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
    configFieldController = TextEditingController();
    configFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    configFieldController.dispose();
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
              leading: const AppBarBackButton(),
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
              label: "Start resharing",
              enabled: !_configEmpty,
              onPressed: () async {
                if (FocusScope.of(context).hasFocus) {
                  FocusScope.of(context).unfocus();
                }

                await _onPressed();
              },
            ),
          ],
        ),
      ),
    );
  }
}
