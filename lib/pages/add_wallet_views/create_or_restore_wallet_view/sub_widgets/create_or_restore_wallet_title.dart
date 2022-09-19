import 'package:flutter/material.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/text_styles.dart';

class CreateRestoreWalletTitle extends StatelessWidget {
  const CreateRestoreWalletTitle({
    Key? key,
    required this.coin,
    required this.isDesktop,
  }) : super(key: key);

  final Coin coin;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Text(
      "Add ${coin.prettyName} wallet",
      textAlign: TextAlign.center,
      style: isDesktop ? STextStyles.desktopH2 : STextStyles.pageTitleH1,
    );
  }
}
