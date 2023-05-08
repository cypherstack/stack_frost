import 'package:decimal/decimal.dart';

class TrocadorTradeNew {
  final String tradeId;
  final DateTime date;
  final String tickerFrom;
  final String tickerTo;
  final String coinFrom;
  final String coinTo;
  final String networkFrom;
  final String networkTo;
  final Decimal amountFrom;
  final Decimal amountTo;
  final String provider;
  final bool fixed;
  final String status;
  final String addressProvider;
  final String addressProviderMemo;
  final String addressUser;
  final String addressUserMemo;
  final String refundAddress;
  final String refundAddressMemo;
  final String password;
  final String idProvider;
  final bool payment;

  TrocadorTradeNew({
    required this.tradeId,
    required this.date,
    required this.tickerFrom,
    required this.tickerTo,
    required this.coinFrom,
    required this.coinTo,
    required this.networkFrom,
    required this.networkTo,
    required this.amountFrom,
    required this.amountTo,
    required this.provider,
    required this.fixed,
    required this.status,
    required this.addressProvider,
    required this.addressProviderMemo,
    required this.addressUser,
    required this.addressUserMemo,
    required this.refundAddress,
    required this.refundAddressMemo,
    required this.password,
    required this.idProvider,
    required this.payment,
  });

  factory TrocadorTradeNew.fromMap(Map<String, dynamic> map) {
    return TrocadorTradeNew(
      tradeId: map['trade_id'] as String,
      date: DateTime.parse(map['date'] as String),
      tickerFrom: map['ticker_from'] as String,
      tickerTo: map['ticker_to'] as String,
      coinFrom: map['coin_from'] as String,
      coinTo: map['coin_to'] as String,
      networkFrom: map['network_from'] as String,
      networkTo: map['network_to'] as String,
      amountFrom: Decimal.parse(map['amount_from'].toString()),
      amountTo: Decimal.parse(map['amount_to'].toString()),
      provider: map['provider'] as String,
      fixed: map['fixed'] as bool,
      status: map['status'] as String,
      addressProvider: map['address_provider'] as String,
      addressProviderMemo: map['address_provider_memo'] as String,
      addressUser: map['address_user'] as String,
      addressUserMemo: map['address_user_memo'] as String,
      refundAddress: map['refund_address'] as String,
      refundAddressMemo: map['refund_address_memo'] as String,
      password: map['password'] as String,
      idProvider: map['id_provider'] as String,
      payment: map['payment'] as bool,
    );
  }

  @override
  String toString() {
    return 'TrocadorTradeNew( '
        'tradeId: $tradeId, '
        'date: $date, '
        'tickerFrom: $tickerFrom, '
        'tickerTo: $tickerTo, '
        'coinFrom: $coinFrom, '
        'coinTo: $coinTo, '
        'networkFrom: $networkFrom, '
        'networkTo: $networkTo, '
        'amountFrom: $amountFrom, '
        'amountTo: $amountTo, '
        'provider: $provider, '
        'fixed: $fixed, '
        'status: $status, '
        'addressProvider: $addressProvider, '
        'addressProviderMemo: $addressProviderMemo, '
        'addressUser: $addressUser, '
        'addressUserMemo: $addressUserMemo, '
        'refundAddress: $refundAddress, '
        'refundAddressMemo: $refundAddressMemo, '
        'password: $password, '
        'idProvider: $idProvider, '
        'payment: $payment '
        ')';
  }
}
