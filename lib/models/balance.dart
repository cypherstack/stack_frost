/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:convert';

import 'package:stackfrost/utilities/amount/amount.dart';

class Balance {
  final Amount total;
  final Amount spendable;
  final Amount blockedTotal;
  final Amount pendingSpendable;

  Balance({
    required this.total,
    required this.spendable,
    required this.blockedTotal,
    required this.pendingSpendable,
  });

  String toJsonIgnoreCoin() => jsonEncode({
        "total": total.toJsonString(),
        "spendable": spendable.toJsonString(),
        "blockedTotal": blockedTotal.toJsonString(),
        "pendingSpendable": pendingSpendable.toJsonString(),
      });

  // need to fall back to parsing from int due to cached balances being previously
  // stored as int values instead of Amounts
  factory Balance.fromJson(String json, int deprecatedValue) {
    final decoded = jsonDecode(json);
    return Balance(
      total: decoded["total"] is String
          ? Amount.fromSerializedJsonString(decoded["total"] as String)
          : Amount(
              rawValue: BigInt.from(decoded["total"] as int),
              fractionDigits: deprecatedValue,
            ),
      spendable: decoded["spendable"] is String
          ? Amount.fromSerializedJsonString(decoded["spendable"] as String)
          : Amount(
              rawValue: BigInt.from(decoded["spendable"] as int),
              fractionDigits: deprecatedValue,
            ),
      blockedTotal: decoded["blockedTotal"] is String
          ? Amount.fromSerializedJsonString(decoded["blockedTotal"] as String)
          : Amount(
              rawValue: BigInt.from(decoded["blockedTotal"] as int),
              fractionDigits: deprecatedValue,
            ),
      pendingSpendable: decoded["pendingSpendable"] is String
          ? Amount.fromSerializedJsonString(
              decoded["pendingSpendable"] as String)
          : Amount(
              rawValue: BigInt.from(decoded["pendingSpendable"] as int),
              fractionDigits: deprecatedValue,
            ),
    );
  }

  Map<String, dynamic> toMap() => {
        "total": total,
        "spendable": spendable,
        "blockedTotal": blockedTotal,
        "pendingSpendable": pendingSpendable,
      };

  @override
  String toString() {
    return toMap().toString();
  }
}
