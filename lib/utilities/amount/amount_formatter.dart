import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackwallet/providers/global/locale_provider.dart';
import 'package:stackwallet/providers/global/prefs_provider.dart';
import 'package:stackwallet/utilities/amount/amount.dart';
import 'package:stackwallet/utilities/amount/amount_unit.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';

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
  return AmountFormatter(
    unit: ref.watch(pAmountUnit(coin)),
    locale: ref.watch(
      localeServiceChangeNotifierProvider.select((value) => value.locale),
    ),
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

  String format(Amount amount) {
    return unit.displayAmount(
      amount: amount,
      locale: locale,
      coin: coin,
      maxDecimalPlaces: maxDecimals,
    );
  }
}
