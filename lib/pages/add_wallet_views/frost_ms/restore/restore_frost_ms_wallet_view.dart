import 'package:flutter/material.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';

class RestoreFrostMsWalletView extends StatefulWidget {
  const RestoreFrostMsWalletView({
    super.key,
    required this.walletName,
    required this.coin,
  });

  static const String routeName = "/restoreFrostMsWalletView";

  final String walletName;
  final Coin coin;

  @override
  State<RestoreFrostMsWalletView> createState() =>
      _RestoreFrostMsWalletViewState();
}

class _RestoreFrostMsWalletViewState extends State<RestoreFrostMsWalletView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
