/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackwallet/models/isar/stack_theme.dart';
import 'package:stackwallet/themes/theme_providers.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';

final coinIconProvider = Provider.family<String, Coin>((ref, coin) {
  final assets = ref.watch(themeAssetsProvider);

  if (assets is ThemeAssets) {
    switch (coin) {
      case Coin.bitcoin:
      case Coin.bitcoinTestNet:
        return assets.bitcoin;
      case Coin.litecoin:
      case Coin.litecoinTestNet:
        return assets.litecoin;
      case Coin.bitcoincash:
      case Coin.bitcoincashTestnet:
        return assets.bitcoincash;
      case Coin.dogecoin:
      case Coin.dogecoinTestNet:
        return assets.dogecoin;
      case Coin.eCash:
        return assets.bitcoin;
      case Coin.epicCash:
        return assets.epicCash;
      case Coin.firo:
      case Coin.firoTestNet:
        return assets.firo;
      case Coin.monero:
        return assets.monero;
      case Coin.wownero:
        return assets.wownero;
      case Coin.namecoin:
        return assets.namecoin;
      case Coin.particl:
        return assets.particl;
      case Coin.ethereum:
        return assets.ethereum;
      default:
        return assets.bitcoin;
    }
  } else if (assets is ThemeAssetsV2) {
    return (assets).coinIcons[coin.mainNetVersion]!;
  } else {
    return (assets as ThemeAssetsV3).coinIcons[coin.mainNetVersion]!;
  }
});
