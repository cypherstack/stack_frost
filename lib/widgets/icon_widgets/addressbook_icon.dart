/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/assets.dart';

class AddressBookIcon extends StatelessWidget {
  const AddressBookIcon({
    Key? key,
    this.width = 16,
    this.height = 16,
    this.color,
  }) : super(key: key);

  final double width;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Assets.svg.addressBook,
      width: width,
      height: height,
      color: color ?? Theme.of(context).extension<StackColors>()!.textDark3,
    );
  }
}
