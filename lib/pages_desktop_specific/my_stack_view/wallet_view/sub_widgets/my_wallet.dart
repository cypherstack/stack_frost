import 'package:flutter/material.dart';
import 'package:stackwallet/pages_desktop_specific/my_stack_view/wallet_view/sub_widgets/desktop_receive.dart';
import 'package:stackwallet/pages_desktop_specific/my_stack_view/wallet_view/sub_widgets/desktop_send.dart';
import 'package:stackwallet/pages_desktop_specific/my_stack_view/wallet_view/sub_widgets/desktop_token_send.dart';
import 'package:stackwallet/pages_desktop_specific/my_stack_view/wallet_view/sub_widgets/send_receive_tab_menu.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({
    Key? key,
    required this.walletId,
    this.contractAddress,
  }) : super(key: key);

  final String walletId;
  final String? contractAddress;

  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      primary: false,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).extension<StackColors>()!.popupBG,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                Constants.size.circularBorderRadius,
              ),
            ),
          ),
          child: SendReceiveTabMenu(
            onChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).extension<StackColors>()!.popupBG,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(
                Constants.size.circularBorderRadius,
              ),
            ),
          ),
          child: AnimatedCrossFade(
            firstChild: Padding(
              key: const Key("desktopSendViewPortKey"),
              padding: const EdgeInsets.all(20),
              child: widget.contractAddress == null
                  ? DesktopSend(
                      walletId: widget.walletId,
                    )
                  : DesktopTokenSend(
                      walletId: widget.walletId,
                    ),
            ),
            secondChild: Padding(
              key: const Key("desktopReceiveViewPortKey"),
              padding: const EdgeInsets.all(20),
              child: DesktopReceive(
                walletId: widget.walletId,
                contractAddress: widget.contractAddress,
              ),
            ),
            crossFadeState: _selectedIndex == 0
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 250),
          ),
        ),
      ],
    );
  }
}
