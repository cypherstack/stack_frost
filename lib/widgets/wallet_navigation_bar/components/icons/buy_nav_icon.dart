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
import 'package:stackfrost/themes/theme_providers.dart';

class BuyNavIcon extends ConsumerWidget {
  const BuyNavIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SvgPicture.file(
      File(
        ref.watch(
          themeProvider.select(
            (value) => value.assets.buy,
          ),
        ),
      ),
      width: 24,
      height: 24,
    );
  }
}
