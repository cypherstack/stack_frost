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
import 'package:stackfrost/models/isar/stack_theme.dart';
import 'package:stackfrost/themes/theme_providers.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';

final coinImageProvider = Provider.family<String, Coin>((ref, coin) {
  final assets = ref.watch(themeAssetsProvider);

  if (assets is ThemeAssets) {
    switch (coin) {
      case Coin.bitcoin:
        return assets.bitcoinImage;
      case Coin.bitcoinTestNet:
        return assets.bitcoinImage;
      default:
        return assets.stackIcon;
    }
  } else if (assets is ThemeAssetsV2) {
    return (assets).coinImages[coin.mainNetVersion]!;
  } else {
    return (assets as ThemeAssetsV3).coinImages[coin.mainNetVersion]!;
  }
});

final coinImageSecondaryProvider = Provider.family<String, Coin>((ref, coin) {
  final assets = ref.watch(themeAssetsProvider);

  if (assets is ThemeAssets) {
    switch (coin) {
      case Coin.bitcoin:
        return assets.bitcoinImageSecondary;
      case Coin.bitcoinTestNet:
        return assets.bitcoinImageSecondary;
      default:
        return assets.stackIcon;
    }
  } else if (assets is ThemeAssetsV2) {
    return (assets).coinSecondaryImages[coin.mainNetVersion]!;
  } else {
    return (assets as ThemeAssetsV3).coinSecondaryImages[coin.mainNetVersion]!;
  }
});
