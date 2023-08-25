import 'package:flutter/material.dart';

class VerifyUpdatedWalletView extends StatefulWidget {
  const VerifyUpdatedWalletView({
    super.key,
    required this.walletId,
  });

  static const String routeName = "/verifyUpdatedWalletView";

  final String walletId;

  @override
  State<VerifyUpdatedWalletView> createState() =>
      _VerifyUpdatedWalletViewState();
}

class _VerifyUpdatedWalletViewState extends State<VerifyUpdatedWalletView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
