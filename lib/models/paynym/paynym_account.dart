/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:stackfrost/models/paynym/paynym_account_lite.dart';
import 'package:stackfrost/models/paynym/paynym_code.dart';

class PaynymAccount {
  final String nymID;
  final String nymName;
  final bool segwit;

  final List<PaynymCode> codes;

  /// list of nymId
  final List<PaynymAccountLite> followers;

  /// list of nymId
  final List<PaynymAccountLite> following;

  PaynymCode get nonSegwitPaymentCode =>
      codes.firstWhere((element) => !element.segwit);

  PaynymAccount(
    this.nymID,
    this.nymName,
    this.segwit,
    this.codes,
    this.followers,
    this.following,
  );

  PaynymAccount.fromMap(Map<String, dynamic> map)
      : nymID = map["nymID"] as String,
        nymName = map["nymName"] as String,
        segwit = map["segwit"] as bool,
        codes = (map["codes"] as List<dynamic>)
            .map((e) => PaynymCode.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList(),
        followers = (map["followers"] as List<dynamic>)
            .map((e) =>
                PaynymAccountLite.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList(),
        following = (map["following"] as List<dynamic>)
            .map((e) =>
                PaynymAccountLite.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList();

  PaynymAccount copyWith({
    String? nymID,
    String? nymName,
    bool? segwit,
    List<PaynymCode>? codes,
    List<PaynymAccountLite>? followers,
    List<PaynymAccountLite>? following,
  }) {
    return PaynymAccount(
      nymID ?? this.nymID,
      nymName ?? this.nymName,
      segwit ?? this.segwit,
      codes ?? this.codes,
      followers ?? this.followers,
      following ?? this.following,
    );
  }

  Map<String, dynamic> toMap() => {
        "nymID": nymID,
        "nymName": nymName,
        "segwit": segwit,
        "codes": codes.map((e) => e.toMap()),
        "followers": followers.map((e) => e.toMap()),
        "following": followers.map((e) => e.toMap()),
      };

  @override
  String toString() {
    return toMap().toString();
  }
}
