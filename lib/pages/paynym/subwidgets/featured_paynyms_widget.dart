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
import 'package:stackfrost/pages/paynym/subwidgets/paynym_card.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/featured_paynyms.dart';
import 'package:stackfrost/utilities/util.dart';
import 'package:stackfrost/widgets/conditional_parent.dart';
import 'package:stackfrost/widgets/rounded_white_container.dart';

class FeaturedPaynymsWidget extends StatelessWidget {
  const FeaturedPaynymsWidget({
    Key? key,
    required this.walletId,
  }) : super(key: key);

  final String walletId;

  @override
  Widget build(BuildContext context) {
    final entries = FeaturedPaynyms.featured.entries.toList(growable: false);
    final isDesktop = Util.isDesktop;

    return ConditionalParent(
      condition: !isDesktop,
      builder: (child) => RoundedWhiteContainer(
        padding: const EdgeInsets.all(0),
        child: child,
      ),
      child: Column(
        children: [
          for (int i = 0; i < entries.length; i++)
            Column(
              children: [
                if (i > 0)
                  isDesktop
                      ? const SizedBox(
                          height: 10,
                        )
                      : Container(
                          color: Theme.of(context)
                              .extension<StackColors>()!
                              .backgroundAppBar,
                          height: 1,
                        ),
                ConditionalParent(
                  condition: isDesktop,
                  builder: (child) => RoundedWhiteContainer(
                    padding: const EdgeInsets.all(0),
                    borderColor: Theme.of(context)
                        .extension<StackColors>()!
                        .backgroundAppBar,
                    child: child,
                  ),
                  child: PaynymCard(
                    walletId: walletId,
                    label: entries[i].key,
                    paymentCodeString: entries[i].value,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
