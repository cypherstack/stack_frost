/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:typed_data';

import 'package:stackfrost/utilities/constants.dart';
import 'package:stackfrost/utilities/enums/backup_frequency_type.dart';

abstract class Format {
  static String shorten(String value, int beginCount, int endCount) {
    return "${value.substring(0, beginCount)}...${value.substring(value.length - endCount)}";
  }

  // static Decimal satoshisToAmount(int sats, {required Coin coin}) {
  //   return (Decimal.fromInt(sats) /
  //           Decimal.fromInt(Constants.satsPerCoin(coin)))
  //       .toDecimal(
  //           scaleOnInfinitePrecision: Constants.decimalPlacesForCoin(coin));
  // }
  //
  // static Decimal satoshisToEthTokenAmount(int sats, int decimalPlaces) {
  //   return (Decimal.fromInt(sats) /
  //           Decimal.fromInt(pow(10, decimalPlaces).toInt()))
  //       .toDecimal(scaleOnInfinitePrecision: decimalPlaces);
  // }
  //
  // ///
  // static String satoshiAmountToPrettyString(
  //     int sats, String locale, Coin coin) {
  //   final amount = satoshisToAmount(sats, coin: coin);
  //   return localizedStringAsFixed(
  //     value: amount,
  //     locale: locale,
  //     decimalPlaces: Constants.decimalPlacesForCoin(coin),
  //   );
  // }
  //
  // static int decimalAmountToSatoshis(Decimal amount, Coin coin) {
  //   final value = (Decimal.fromInt(Constants.satsPerCoin(coin)) * amount)
  //       .floor()
  //       .toBigInt();
  //   return value.toInt();
  // }

  // format date string from unix timestamp
  static String extractDateFrom(int timestamp, {bool localized = true}) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    if (!localized) {
      date = date.toUtc();
    }

    final minutes =
        date.minute < 10 ? "0${date.minute}" : date.minute.toString();
    return "${date.day} ${Constants.monthMapShort[date.month]} ${date.year}, ${date.hour}:$minutes";
  }

  // static String localizedStringAsFixed({
  //   required Decimal value,
  //   required String locale,
  //   int decimalPlaces = 0,
  // }) {
  //   assert(decimalPlaces >= 0);
  //
  //   final String separator =
  //       (numberFormatSymbols[locale] as NumberSymbols?)?.DECIMAL_SEP ??
  //           (numberFormatSymbols[locale.substring(0, 2)] as NumberSymbols?)
  //               ?.DECIMAL_SEP ??
  //           ".";
  //
  //   final intValue = value.truncate();
  //   final fraction = value - intValue;
  //
  //   return intValue.toStringAsFixed(0) +
  //       separator +
  //       fraction.toStringAsFixed(decimalPlaces).substring(2);
  // }

  /// format date string as dd/mm/yy from DateTime object
  static String formatDate(DateTime date) {
    // prepend '0' if needed
    final day = date.day < 10 ? "0${date.day}" : "${date.day}";

    // prepend '0' if needed
    final month = date.month < 10 ? "0${date.month}" : "${date.month}";

    // get last two digits of value
    final shortYear = date.year % 100;

    // prepend '0' if needed
    final year = shortYear < 10 ? "0$shortYear" : "$shortYear";

    return "$month/$day/$year";
  }

  static String uint8listToString(Uint8List list) {
    String result = "";
    for (var n in list) {
      result +=
          (n.toRadixString(16).length == 1 ? "0" : "") + n.toRadixString(16);
    }
    return result;
  }

  static Uint8List stringToUint8List(String string) {
    List<int> list = [];
    for (var leg = 0; leg < string.length; leg = leg + 2) {
      list.add(int.parse(string.substring(leg, leg + 2), radix: 16));
    }
    return Uint8List.fromList(list);
  }

  static bool isAscii(String string) {
    final asciiRegex = RegExp(r'^[\x00-\x7F]+$');
    return asciiRegex.hasMatch(string);
  }

  static String prettyFrequencyType(BackupFrequencyType type) {
    switch (type) {
      case BackupFrequencyType.everyTenMinutes:
        return "Every 10 minutes";
      case BackupFrequencyType.everyAppStart:
        return "Every app start";
      case BackupFrequencyType.afterClosingAWallet:
        return "After closing a cryptocurrency wallet";
    }
  }
}
