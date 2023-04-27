import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stackwallet/notifications/show_flush_bar.dart';
import 'package:stackwallet/providers/global/wallets_provider.dart';
import 'package:stackwallet/services/coins/manager.dart';
import 'package:stackwallet/services/mixins/xpubable.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/clipboard_interface.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';
import 'package:stackwallet/utilities/util.dart';
import 'package:stackwallet/widgets/background.dart';
import 'package:stackwallet/widgets/conditional_parent.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/desktop/desktop_dialog.dart';
import 'package:stackwallet/widgets/desktop/desktop_dialog_close_button.dart';
import 'package:stackwallet/widgets/desktop/primary_button.dart';
import 'package:stackwallet/widgets/desktop/secondary_button.dart';
import 'package:stackwallet/widgets/loading_indicator.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';

class XPubView extends ConsumerStatefulWidget {
  const XPubView({
    Key? key,
    required this.walletId,
    this.clipboardInterface = const ClipboardWrapper(),
  }) : super(key: key);

  final String walletId;
  final ClipboardInterface clipboardInterface;

  static const String routeName = "/xpub";

  @override
  ConsumerState<XPubView> createState() => _XPubViewState();
}

class _XPubViewState extends ConsumerState<XPubView> {
  final bool isDesktop = Util.isDesktop;

  late ClipboardInterface _clipboardInterface;
  late final Manager manager;

  String? xpub;

  @override
  void initState() {
    _clipboardInterface = widget.clipboardInterface;
    manager =
        ref.read(walletsChangeNotifierProvider).getManager(widget.walletId);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _copy() async {
    await _clipboardInterface.setData(ClipboardData(text: xpub!));
    if (mounted) {
      unawaited(showFloatingFlushBar(
        type: FlushBarType.info,
        message: "Copied to clipboard",
        iconAsset: Assets.svg.copy,
        context: context,
      ));
    }
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
            leading: AppBarBackButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              "Wallet xPub",
              style: STextStyles.navBarTitle(context),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: AppBarIconButton(
                    color:
                        Theme.of(context).extension<StackColors>()!.background,
                    shadows: const [],
                    icon: SvgPicture.asset(
                      Assets.svg.copy,
                      width: 24,
                      height: 24,
                      color: Theme.of(context)
                          .extension<StackColors>()!
                          .topNavIconPrimary,
                    ),
                    onPressed: () {
                      if (xpub != null) {
                        _copy();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              top: 12,
              left: 16,
              right: 16,
            ),
            child: child,
          ),
        ),
      ),
      child: ConditionalParent(
        condition: isDesktop,
        builder: (child) => DesktopDialog(
          maxWidth: 600,
          maxHeight: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 32,
                    ),
                    child: Text(
                      "${manager.walletName} xPub",
                      style: STextStyles.desktopH2(context),
                    ),
                  ),
                  DesktopDialogCloseButton(
                    onPressedOverride: Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pop,
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(
                  milliseconds: 150,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                  child: child,
                ),
              ),
            ],
          ),
        ),
        child: Column(
          children: [
            if (isDesktop) const SizedBox(height: 44),
            ConditionalParent(
              condition: !isDesktop,
              builder: (child) => Expanded(
                child: child,
              ),
              child: FutureBuilder(
                future: (manager.wallet as XPubAble).xpub,
                builder: (context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    xpub = snapshot.data!;
                  }

                  const height = 600.0;
                  Widget child;
                  if (xpub == null) {
                    child = const SizedBox(
                      key: Key("loadingXPUB"),
                      height: height,
                      child: Center(
                        child: LoadingIndicator(
                          width: 100,
                        ),
                      ),
                    );
                  } else {
                    child = _XPub(
                      xpub: xpub!,
                      height: height,
                    );
                  }

                  return AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 200,
                    ),
                    child: child,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _XPub extends StatelessWidget {
  const _XPub({
    Key? key,
    required this.xpub,
    required this.height,
    this.clipboardInterface = const ClipboardWrapper(),
  }) : super(key: key);

  final String xpub;
  final double height;
  final ClipboardInterface clipboardInterface;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Util.isDesktop;

    return SizedBox(
      height: isDesktop ? height : double.infinity,
      child: Column(
        children: [
          ConditionalParent(
            condition: !isDesktop,
            builder: (child) => RoundedWhiteContainer(
              child: child,
            ),
            child: QrImage(
              data: xpub,
              size: isDesktop ? 280 : MediaQuery.of(context).size.width / 1.5,
              foregroundColor:
                  Theme.of(context).extension<StackColors>()!.accentColorDark,
            ),
          ),
          const SizedBox(height: 25),
          RoundedWhiteContainer(
            padding: const EdgeInsets.all(16),
            borderColor:
                Theme.of(context).extension<StackColors>()!.backgroundAppBar,
            child: SelectableText(
              xpub,
              style: STextStyles.largeMedium14(context),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              if (isDesktop)
                Expanded(
                  child: SecondaryButton(
                    buttonHeight: ButtonHeight.xl,
                    label: "Cancel",
                    onPressed: Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pop,
                  ),
                ),
              if (isDesktop) const SizedBox(width: 16),
              Expanded(
                child: PrimaryButton(
                  buttonHeight: ButtonHeight.xl,
                  label: "Copy",
                  onPressed: () async {
                    await clipboardInterface.setData(
                      ClipboardData(
                        text: xpub,
                      ),
                    );
                    if (context.mounted) {
                      unawaited(
                        showFloatingFlushBar(
                          type: FlushBarType.info,
                          message: "Copied to clipboard",
                          iconAsset: Assets.svg.copy,
                          context: context,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          if (!isDesktop) const Spacer(),
        ],
      ),
    );
  }
}
