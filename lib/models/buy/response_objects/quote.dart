/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:decimal/decimal.dart';
import 'package:stackfrost/models/buy/response_objects/crypto.dart';
import 'package:stackfrost/models/buy/response_objects/fiat.dart';

class SimplexQuote {
  final Crypto crypto;
  final Fiat fiat;

  late final Decimal youPayFiatPrice;
  late final Decimal youReceiveCryptoAmount;

  late final String id;
  late final String receivingAddress;

  late final bool buyWithFiat;

  SimplexQuote({
    required this.crypto,
    required this.fiat,
    required this.youPayFiatPrice,
    required this.youReceiveCryptoAmount,
    required this.id,
    required this.receivingAddress,
    required this.buyWithFiat,
  });
}
