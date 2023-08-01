/*
 * This file is part of Stack Wallet.
 *
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stackfrost/providers/providers.dart';
import 'package:stackfrost/themes/coin_card_provider.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/assets.dart';
import 'package:stackfrost/utilities/constants.dart';

class CoinCard extends ConsumerWidget {
  const CoinCard({
    super.key,
    required this.walletId,
    required this.width,
    required this.height,
    required this.isFavorite,
  });

  final String walletId;
  final double width;
  final double height;
  final bool isFavorite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coin = ref.watch(
      walletsChangeNotifierProvider
          .select((value) => value.getManager(walletId).coin),
    );

    final bool hasCardImageBg = (isFavorite)
        ? ref.watch(coinCardFavoritesProvider(coin)) != null
        : ref.watch(coinCardProvider(coin)) != null;

    return Stack(
      children: [
        if (hasCardImageBg)
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                Constants.size.circularBorderRadius,
              ),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(
                  File(
                    (isFavorite)
                        ? ref.watch(coinCardFavoritesProvider(coin))!
                        : ref.watch(coinCardProvider(coin))!,
                  ),
                ),
              ),
            ),
          ),
        if (!hasCardImageBg)
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .extension<StackColors>()!
                  .colorForCoin(coin),
              borderRadius: BorderRadius.circular(
                Constants.size.circularBorderRadius,
              ),
            ),
          ),
        if (!hasCardImageBg)
          Column(
            children: [
              const Spacer(),
              SizedBox(
                height: width * 0.3,
                child: Row(
                  children: [
                    const Spacer(
                      flex: 9,
                    ),
                    SvgPicture.asset(
                      Assets.svg.ellipse2,
                      height: width * 0.3,
                    ),
                    // ),
                    const Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        if (!hasCardImageBg)
          Row(
            children: [
              const Spacer(
                flex: 5,
              ),
              SizedBox(
                width: width * 0.45,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      Assets.svg.ellipse1,
                      width: width * 0.45,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const Spacer(
                flex: 1,
              ),
            ],
          ),
      ],
    );
  }
}
