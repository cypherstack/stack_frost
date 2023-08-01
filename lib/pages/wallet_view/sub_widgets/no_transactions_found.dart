/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/widgets/rounded_white_container.dart';

class NoTransActionsFound extends StatelessWidget {
  const NoTransActionsFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RoundedWhiteContainer(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Transactions will appear here",
              style: STextStyles.itemSubtitle(context),
            ),
          ),
        ),
      ],
    );
  }
}
