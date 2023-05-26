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
import 'package:stackwallet/utilities/extensions/impl/string.dart';

extension GradientExt on Gradient {
  static Gradient fromJson(Map<String, dynamic> json) {
    switch (json["background"]["type"]) {
      case "Linear":
        final colorStrings =
            List<String>.from(json["background"]["colors"] as List);
        return LinearGradient(
          begin: Alignment(
            json["background"]["begin"]["x"] as double,
            json["background"]["begin"]["y"] as double,
          ),
          end: Alignment(
            json["background"]["end"]["x"] as double,
            json["background"]["end"]["y"] as double,
          ),
          colors: colorStrings
              .map(
                (e) => Color(
                  e.toBigIntFromHex.toInt(),
                ),
              )
              .toList(),
        );

      default:
        throw ArgumentError("Invalid json gradient: $json");
    }
  }
}
