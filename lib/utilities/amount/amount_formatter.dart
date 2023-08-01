import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackfrost/models/isar/models/ethereum/eth_contract.dart';
import 'package:stackfrost/providers/global/locale_provider.dart';
import 'package:stackfrost/providers/global/prefs_provider.dart';
import 'package:stackfrost/utilities/amount/amount.dart';
import 'package:stackfrost/utilities/amount/amount_unit.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';

final pAmountUnit = Provider.family<AmountUnit, Coin>(
  (ref, coin) => ref.watch(
    prefsChangeNotifierProvider.select(
      (value) => value.amountUnit(coin),
    ),
  ),
);
final pMaxDecimals = Provider.family<int, Coin>(
  (ref, coin) => ref.watch(
    prefsChangeNotifierProvider.select(
      (value) => value.maxDecimals(coin),
    ),
  ),
);

final pAmountFormatter = Provider.family<AmountFormatter, Coin>((ref, coin) {
  final locale = ref.watch(
    localeServiceChangeNotifierProvider.select((value) => value.locale),
  );

  return AmountFormatter(
    unit: ref.watch(pAmountUnit(coin)),
    locale: locale,
    coin: coin,
    maxDecimals: ref.watch(pMaxDecimals(coin)),
  );
});

class AmountFormatter {
  final AmountUnit unit;
  final String locale;
  final Coin coin;
  final int maxDecimals;

  AmountFormatter({
    required this.unit,
    required this.locale,
    required this.coin,
    required this.maxDecimals,
  });

  String format(
    Amount amount, {
    String? overrideUnit,
    EthContract? ethContract,
    bool withUnitName = true,
    bool indicatePrecisionLoss = true,
  }) {
    return unit.displayAmount(
      amount: amount,
      locale: locale,
      coin: coin,
      maxDecimalPlaces: maxDecimals,
      withUnitName: withUnitName,
      indicatePrecisionLoss: indicatePrecisionLoss,
      overrideUnit: overrideUnit,
      tokenContract: ethContract,
    );
  }

  Amount? tryParse(
    String string, {
    EthContract? ethContract,
  }) {
    return unit.tryParse(
      string,
      locale: locale,
      coin: coin,
      tokenContract: ethContract,
    );
  }
}
