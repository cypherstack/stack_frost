// Mocks generated by Mockito 5.2.0 from annotations
// in stackwallet/test/services/coins/manager_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i8;

import 'package:decimal/decimal.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:stackwallet/electrumx_rpc/cached_electrumx.dart' as _i6;
import 'package:stackwallet/electrumx_rpc/electrumx.dart' as _i5;
import 'package:stackwallet/models/lelantus_coin.dart' as _i10;
import 'package:stackwallet/models/models.dart' as _i4;
import 'package:stackwallet/services/coins/firo/firo_wallet.dart' as _i7;
import 'package:stackwallet/services/transaction_notification_tracker.dart'
    as _i2;
import 'package:stackwallet/utilities/enums/coin_enum.dart' as _i9;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeTransactionNotificationTracker_0 extends _i1.Fake
    implements _i2.TransactionNotificationTracker {}

class _FakeDecimal_1 extends _i1.Fake implements _i3.Decimal {}

class _FakeTransactionData_2 extends _i1.Fake implements _i4.TransactionData {}

class _FakeUtxoData_3 extends _i1.Fake implements _i4.UtxoData {}

class _FakeFeeObject_4 extends _i1.Fake implements _i4.FeeObject {}

class _FakeElectrumX_5 extends _i1.Fake implements _i5.ElectrumX {}

class _FakeCachedElectrumX_6 extends _i1.Fake implements _i6.CachedElectrumX {}

/// A class which mocks [FiroWallet].
///
/// See the documentation for Mockito's code generation for more information.
class MockFiroWallet extends _i1.Mock implements _i7.FiroWallet {
  MockFiroWallet() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set timer(_i8.Timer? _timer) =>
      super.noSuchMethod(Invocation.setter(#timer, _timer),
          returnValueForMissingStub: null);
  @override
  _i2.TransactionNotificationTracker get txTracker =>
      (super.noSuchMethod(Invocation.getter(#txTracker),
              returnValue: _FakeTransactionNotificationTracker_0())
          as _i2.TransactionNotificationTracker);
  @override
  set txTracker(_i2.TransactionNotificationTracker? _txTracker) =>
      super.noSuchMethod(Invocation.setter(#txTracker, _txTracker),
          returnValueForMissingStub: null);
  @override
  bool get refreshMutex =>
      (super.noSuchMethod(Invocation.getter(#refreshMutex), returnValue: false)
          as bool);
  @override
  set refreshMutex(bool? _refreshMutex) =>
      super.noSuchMethod(Invocation.setter(#refreshMutex, _refreshMutex),
          returnValueForMissingStub: null);
  @override
  bool get longMutex =>
      (super.noSuchMethod(Invocation.getter(#longMutex), returnValue: false)
          as bool);
  @override
  set longMutex(bool? _longMutex) =>
      super.noSuchMethod(Invocation.setter(#longMutex, _longMutex),
          returnValueForMissingStub: null);
  @override
  bool get isActive =>
      (super.noSuchMethod(Invocation.getter(#isActive), returnValue: false)
          as bool);
  @override
  set isActive(bool? _isActive) =>
      super.noSuchMethod(Invocation.setter(#isActive, _isActive),
          returnValueForMissingStub: null);
  @override
  bool get shouldAutoSync => (super
          .noSuchMethod(Invocation.getter(#shouldAutoSync), returnValue: false)
      as bool);
  @override
  set shouldAutoSync(bool? shouldAutoSync) =>
      super.noSuchMethod(Invocation.setter(#shouldAutoSync, shouldAutoSync),
          returnValueForMissingStub: null);
  @override
  set isFavorite(bool? markFavorite) =>
      super.noSuchMethod(Invocation.setter(#isFavorite, markFavorite),
          returnValueForMissingStub: null);
  @override
  bool get isFavorite =>
      (super.noSuchMethod(Invocation.getter(#isFavorite), returnValue: false)
          as bool);
  @override
  _i9.Coin get coin => (super.noSuchMethod(Invocation.getter(#coin),
      returnValue: _i9.Coin.bitcoin) as _i9.Coin);
  @override
  _i8.Future<List<String>> get mnemonic =>
      (super.noSuchMethod(Invocation.getter(#mnemonic),
              returnValue: Future<List<String>>.value(<String>[]))
          as _i8.Future<List<String>>);
  @override
  _i8.Future<_i3.Decimal> get availableBalance =>
      (super.noSuchMethod(Invocation.getter(#availableBalance),
              returnValue: Future<_i3.Decimal>.value(_FakeDecimal_1()))
          as _i8.Future<_i3.Decimal>);
  @override
  _i8.Future<_i3.Decimal> get pendingBalance =>
      (super.noSuchMethod(Invocation.getter(#pendingBalance),
              returnValue: Future<_i3.Decimal>.value(_FakeDecimal_1()))
          as _i8.Future<_i3.Decimal>);
  @override
  _i8.Future<_i3.Decimal> get totalBalance =>
      (super.noSuchMethod(Invocation.getter(#totalBalance),
              returnValue: Future<_i3.Decimal>.value(_FakeDecimal_1()))
          as _i8.Future<_i3.Decimal>);
  @override
  _i8.Future<_i3.Decimal> get balanceMinusMaxFee =>
      (super.noSuchMethod(Invocation.getter(#balanceMinusMaxFee),
              returnValue: Future<_i3.Decimal>.value(_FakeDecimal_1()))
          as _i8.Future<_i3.Decimal>);
  @override
  _i8.Future<_i4.TransactionData> get transactionData =>
      (super.noSuchMethod(Invocation.getter(#transactionData),
              returnValue:
                  Future<_i4.TransactionData>.value(_FakeTransactionData_2()))
          as _i8.Future<_i4.TransactionData>);
  @override
  _i8.Future<_i4.UtxoData> get utxoData =>
      (super.noSuchMethod(Invocation.getter(#utxoData),
              returnValue: Future<_i4.UtxoData>.value(_FakeUtxoData_3()))
          as _i8.Future<_i4.UtxoData>);
  @override
  _i8.Future<List<_i4.UtxoObject>> get unspentOutputs => (super.noSuchMethod(
          Invocation.getter(#unspentOutputs),
          returnValue: Future<List<_i4.UtxoObject>>.value(<_i4.UtxoObject>[]))
      as _i8.Future<List<_i4.UtxoObject>>);
  @override
  _i8.Future<_i4.TransactionData> get lelantusTransactionData =>
      (super.noSuchMethod(Invocation.getter(#lelantusTransactionData),
              returnValue:
                  Future<_i4.TransactionData>.value(_FakeTransactionData_2()))
          as _i8.Future<_i4.TransactionData>);
  @override
  _i8.Future<int> get maxFee => (super.noSuchMethod(Invocation.getter(#maxFee),
      returnValue: Future<int>.value(0)) as _i8.Future<int>);
  @override
  _i8.Future<List<_i3.Decimal>> get balances =>
      (super.noSuchMethod(Invocation.getter(#balances),
              returnValue: Future<List<_i3.Decimal>>.value(<_i3.Decimal>[]))
          as _i8.Future<List<_i3.Decimal>>);
  @override
  _i8.Future<_i3.Decimal> get firoPrice =>
      (super.noSuchMethod(Invocation.getter(#firoPrice),
              returnValue: Future<_i3.Decimal>.value(_FakeDecimal_1()))
          as _i8.Future<_i3.Decimal>);
  @override
  _i8.Future<_i4.FeeObject> get fees =>
      (super.noSuchMethod(Invocation.getter(#fees),
              returnValue: Future<_i4.FeeObject>.value(_FakeFeeObject_4()))
          as _i8.Future<_i4.FeeObject>);
  @override
  _i8.Future<String> get currentReceivingAddress =>
      (super.noSuchMethod(Invocation.getter(#currentReceivingAddress),
          returnValue: Future<String>.value('')) as _i8.Future<String>);
  @override
  String get walletName =>
      (super.noSuchMethod(Invocation.getter(#walletName), returnValue: '')
          as String);
  @override
  set walletName(String? newName) =>
      super.noSuchMethod(Invocation.setter(#walletName, newName),
          returnValueForMissingStub: null);
  @override
  String get walletId =>
      (super.noSuchMethod(Invocation.getter(#walletId), returnValue: '')
          as String);
  @override
  _i8.Future<List<String>> get allOwnAddresses =>
      (super.noSuchMethod(Invocation.getter(#allOwnAddresses),
              returnValue: Future<List<String>>.value(<String>[]))
          as _i8.Future<List<String>>);
  @override
  bool get isConnected =>
      (super.noSuchMethod(Invocation.getter(#isConnected), returnValue: false)
          as bool);
  @override
  _i5.ElectrumX get electrumXClient =>
      (super.noSuchMethod(Invocation.getter(#electrumXClient),
          returnValue: _FakeElectrumX_5()) as _i5.ElectrumX);
  @override
  _i6.CachedElectrumX get cachedElectrumXClient =>
      (super.noSuchMethod(Invocation.getter(#cachedElectrumXClient),
          returnValue: _FakeCachedElectrumX_6()) as _i6.CachedElectrumX);
  @override
  bool get isRefreshing =>
      (super.noSuchMethod(Invocation.getter(#isRefreshing), returnValue: false)
          as bool);
  @override
  bool get hasCalledExit =>
      (super.noSuchMethod(Invocation.getter(#hasCalledExit), returnValue: false)
          as bool);
  @override
  set onIsActiveWalletChanged(void Function(bool)? _onIsActiveWalletChanged) =>
      super.noSuchMethod(
          Invocation.setter(#onIsActiveWalletChanged, _onIsActiveWalletChanged),
          returnValueForMissingStub: null);
  @override
  bool validateAddress(String? address) =>
      (super.noSuchMethod(Invocation.method(#validateAddress, [address]),
          returnValue: false) as bool);
  @override
  _i8.Future<bool> testNetworkConnection() =>
      (super.noSuchMethod(Invocation.method(#testNetworkConnection, []),
          returnValue: Future<bool>.value(false)) as _i8.Future<bool>);
  @override
  void startNetworkAlivePinging() =>
      super.noSuchMethod(Invocation.method(#startNetworkAlivePinging, []),
          returnValueForMissingStub: null);
  @override
  void stopNetworkAlivePinging() =>
      super.noSuchMethod(Invocation.method(#stopNetworkAlivePinging, []),
          returnValueForMissingStub: null);
  @override
  _i8.Future<Map<String, dynamic>> prepareSendPublic(
          {String? address, int? satoshiAmount, Map<String, dynamic>? args}) =>
      (super.noSuchMethod(
              Invocation.method(#prepareSendPublic, [], {
                #address: address,
                #satoshiAmount: satoshiAmount,
                #args: args
              }),
              returnValue:
                  Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i8.Future<Map<String, dynamic>>);
  @override
  _i8.Future<String> confirmSendPublic({dynamic txData}) => (super.noSuchMethod(
      Invocation.method(#confirmSendPublic, [], {#txData: txData}),
      returnValue: Future<String>.value('')) as _i8.Future<String>);
  @override
  _i8.Future<Map<String, dynamic>> prepareSend(
          {String? address, int? satoshiAmount, Map<String, dynamic>? args}) =>
      (super.noSuchMethod(
              Invocation.method(#prepareSend, [], {
                #address: address,
                #satoshiAmount: satoshiAmount,
                #args: args
              }),
              returnValue:
                  Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i8.Future<Map<String, dynamic>>);
  @override
  _i8.Future<String> confirmSend({Map<String, dynamic>? txData}) => (super
      .noSuchMethod(Invocation.method(#confirmSend, [], {#txData: txData}),
          returnValue: Future<String>.value('')) as _i8.Future<String>);
  @override
  _i8.Future<String> send(
          {String? toAddress,
          int? amount,
          Map<String, String>? args = const {}}) =>
      (super.noSuchMethod(
          Invocation.method(
              #send, [], {#toAddress: toAddress, #amount: amount, #args: args}),
          returnValue: Future<String>.value('')) as _i8.Future<String>);
  @override
  int estimateTxFee({int? vSize, int? feeRatePerKB}) => (super.noSuchMethod(
      Invocation.method(
          #estimateTxFee, [], {#vSize: vSize, #feeRatePerKB: feeRatePerKB}),
      returnValue: 0) as int);
  @override
  dynamic coinSelection(int? satoshiAmountToSend, int? selectedTxFeeRate,
          String? _recipientAddress, bool? isSendAll,
          {int? additionalOutputs = 0, List<_i4.UtxoObject>? utxos}) =>
      super.noSuchMethod(Invocation.method(#coinSelection, [
        satoshiAmountToSend,
        selectedTxFeeRate,
        _recipientAddress,
        isSendAll
      ], {
        #additionalOutputs: additionalOutputs,
        #utxos: utxos
      }));
  @override
  _i8.Future<Map<String, dynamic>> fetchBuildTxData(
          List<_i4.UtxoObject>? utxosToUse) =>
      (super.noSuchMethod(Invocation.method(#fetchBuildTxData, [utxosToUse]),
              returnValue:
                  Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i8.Future<Map<String, dynamic>>);
  @override
  _i8.Future<Map<String, dynamic>> buildTransaction(
          {List<_i4.UtxoObject>? utxosToUse,
          Map<String, dynamic>? utxoSigningData,
          List<String>? recipients,
          List<int>? satoshiAmounts}) =>
      (super.noSuchMethod(
              Invocation.method(#buildTransaction, [], {
                #utxosToUse: utxosToUse,
                #utxoSigningData: utxoSigningData,
                #recipients: recipients,
                #satoshiAmounts: satoshiAmounts
              }),
              returnValue:
                  Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i8.Future<Map<String, dynamic>>);
  @override
  _i8.Future<void> updateNode(bool? shouldRefresh) =>
      (super.noSuchMethod(Invocation.method(#updateNode, [shouldRefresh]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> initializeNew() =>
      (super.noSuchMethod(Invocation.method(#initializeNew, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> initializeExisting() =>
      (super.noSuchMethod(Invocation.method(#initializeExisting, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<bool> refreshIfThereIsNewData() =>
      (super.noSuchMethod(Invocation.method(#refreshIfThereIsNewData, []),
          returnValue: Future<bool>.value(false)) as _i8.Future<bool>);
  @override
  _i8.Future<void> getAllTxsToWatch(
          _i4.TransactionData? txData, _i4.TransactionData? lTxData) =>
      (super.noSuchMethod(
          Invocation.method(#getAllTxsToWatch, [txData, lTxData]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> refresh() =>
      (super.noSuchMethod(Invocation.method(#refresh, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  List<Map<dynamic, _i10.LelantusCoin>> getLelantusCoinMap() =>
      (super.noSuchMethod(Invocation.method(#getLelantusCoinMap, []),
              returnValue: <Map<dynamic, _i10.LelantusCoin>>[])
          as List<Map<dynamic, _i10.LelantusCoin>>);
  @override
  _i8.Future<void> anonymizeAllPublicFunds() =>
      (super.noSuchMethod(Invocation.method(#anonymizeAllPublicFunds, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<List<Map<String, dynamic>>> createMintsFromAmount(int? total) =>
      (super.noSuchMethod(Invocation.method(#createMintsFromAmount, [total]),
              returnValue: Future<List<Map<String, dynamic>>>.value(
                  <Map<String, dynamic>>[]))
          as _i8.Future<List<Map<String, dynamic>>>);
  @override
  _i8.Future<String> submitHexToNetwork(String? hex) =>
      (super.noSuchMethod(Invocation.method(#submitHexToNetwork, [hex]),
          returnValue: Future<String>.value('')) as _i8.Future<String>);
  @override
  _i8.Future<Map<String, dynamic>> buildMintTransaction(
          List<_i4.UtxoObject>? utxosToUse,
          int? satoshisPerRecipient,
          List<Map<String, dynamic>>? mintsMap) =>
      (super.noSuchMethod(
              Invocation.method(#buildMintTransaction,
                  [utxosToUse, satoshisPerRecipient, mintsMap]),
              returnValue:
                  Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i8.Future<Map<String, dynamic>>);
  @override
  _i8.Future<void> checkReceivingAddressForTransactions() =>
      (super.noSuchMethod(
          Invocation.method(#checkReceivingAddressForTransactions, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> checkChangeAddressForTransactions() => (super.noSuchMethod(
      Invocation.method(#checkChangeAddressForTransactions, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> fillAddresses(String? suppliedMnemonic,
          {int? perBatch = 50, int? numberOfThreads = 4}) =>
      (super.noSuchMethod(
          Invocation.method(#fillAddresses, [suppliedMnemonic],
              {#perBatch: perBatch, #numberOfThreads: numberOfThreads}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> incrementAddressIndexForChain(int? chain) => (super
      .noSuchMethod(Invocation.method(#incrementAddressIndexForChain, [chain]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> addToAddressesArrayForChain(String? address, int? chain) =>
      (super.noSuchMethod(
          Invocation.method(#addToAddressesArrayForChain, [address, chain]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> fullRescan(
          int? maxUnusedAddressGap, int? maxNumberOfIndexesToCheck) =>
      (super.noSuchMethod(
          Invocation.method(
              #fullRescan, [maxUnusedAddressGap, maxNumberOfIndexesToCheck]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> recoverFromMnemonic(
          {String? mnemonic,
          int? maxUnusedAddressGap,
          int? maxNumberOfIndexesToCheck,
          int? height}) =>
      (super.noSuchMethod(
          Invocation.method(#recoverFromMnemonic, [], {
            #mnemonic: mnemonic,
            #maxUnusedAddressGap: maxUnusedAddressGap,
            #maxNumberOfIndexesToCheck: maxNumberOfIndexesToCheck,
            #height: height
          }),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<Map<int, dynamic>> getSetDataMap(int? latestSetId) =>
      (super.noSuchMethod(Invocation.method(#getSetDataMap, [latestSetId]),
              returnValue: Future<Map<int, dynamic>>.value(<int, dynamic>{}))
          as _i8.Future<Map<int, dynamic>>);
  @override
  _i8.Future<List<Map<String, dynamic>>> fetchAnonymitySets() =>
      (super.noSuchMethod(Invocation.method(#fetchAnonymitySets, []),
              returnValue: Future<List<Map<String, dynamic>>>.value(
                  <Map<String, dynamic>>[]))
          as _i8.Future<List<Map<String, dynamic>>>);
  @override
  _i8.Future<int> getLatestSetId() =>
      (super.noSuchMethod(Invocation.method(#getLatestSetId, []),
          returnValue: Future<int>.value(0)) as _i8.Future<int>);
  @override
  _i8.Future<List<dynamic>> getUsedCoinSerials() =>
      (super.noSuchMethod(Invocation.method(#getUsedCoinSerials, []),
              returnValue: Future<List<dynamic>>.value(<dynamic>[]))
          as _i8.Future<List<dynamic>>);
  @override
  _i8.Future<void> exit() => (super.noSuchMethod(Invocation.method(#exit, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<dynamic> getCoinsToJoinSplit(int? required) =>
      (super.noSuchMethod(Invocation.method(#getCoinsToJoinSplit, [required]),
          returnValue: Future<dynamic>.value()) as _i8.Future<dynamic>);
  @override
  _i8.Future<int> estimateJoinSplitFee(int? spendAmount) => (super.noSuchMethod(
      Invocation.method(#estimateJoinSplitFee, [spendAmount]),
      returnValue: Future<int>.value(0)) as _i8.Future<int>);
  @override
  _i8.Future<int> estimateFeeFor(int? satoshiAmount, int? feeRate) =>
      (super.noSuchMethod(
          Invocation.method(#estimateFeeFor, [satoshiAmount, feeRate]),
          returnValue: Future<int>.value(0)) as _i8.Future<int>);
  @override
  _i8.Future<int> estimateFeeForPublic(int? satoshiAmount, int? feeRate) =>
      (super.noSuchMethod(
          Invocation.method(#estimateFeeForPublic, [satoshiAmount, feeRate]),
          returnValue: Future<int>.value(0)) as _i8.Future<int>);
  @override
  int roughFeeEstimate(int? inputCount, int? outputCount, int? feeRatePerKB) =>
      (super.noSuchMethod(
          Invocation.method(
              #roughFeeEstimate, [inputCount, outputCount, feeRatePerKB]),
          returnValue: 0) as int);
  @override
  int sweepAllEstimate(int? feeRate) =>
      (super.noSuchMethod(Invocation.method(#sweepAllEstimate, [feeRate]),
          returnValue: 0) as int);
  @override
  _i8.Future<List<Map<String, dynamic>>> fastFetch(List<String>? allTxHashes) =>
      (super.noSuchMethod(Invocation.method(#fastFetch, [allTxHashes]),
              returnValue: Future<List<Map<String, dynamic>>>.value(
                  <Map<String, dynamic>>[]))
          as _i8.Future<List<Map<String, dynamic>>>);
  @override
  _i8.Future<List<_i4.Transaction>> getJMintTransactions(
          _i6.CachedElectrumX? cachedClient,
          List<String>? transactions,
          String? currency,
          _i9.Coin? coin,
          _i3.Decimal? currentPrice,
          String? locale) =>
      (super.noSuchMethod(
              Invocation.method(#getJMintTransactions, [
                cachedClient,
                transactions,
                currency,
                coin,
                currentPrice,
                locale
              ]),
              returnValue:
                  Future<List<_i4.Transaction>>.value(<_i4.Transaction>[]))
          as _i8.Future<List<_i4.Transaction>>);
  @override
  _i8.Future<bool> generateNewAddress() =>
      (super.noSuchMethod(Invocation.method(#generateNewAddress, []),
          returnValue: Future<bool>.value(false)) as _i8.Future<bool>);
  @override
  _i8.Future<_i3.Decimal> availablePrivateBalance() =>
      (super.noSuchMethod(Invocation.method(#availablePrivateBalance, []),
              returnValue: Future<_i3.Decimal>.value(_FakeDecimal_1()))
          as _i8.Future<_i3.Decimal>);
  @override
  _i8.Future<_i3.Decimal> availablePublicBalance() =>
      (super.noSuchMethod(Invocation.method(#availablePublicBalance, []),
              returnValue: Future<_i3.Decimal>.value(_FakeDecimal_1()))
          as _i8.Future<_i3.Decimal>);
}

/// A class which mocks [ElectrumX].
///
/// See the documentation for Mockito's code generation for more information.
class MockElectrumX extends _i1.Mock implements _i5.ElectrumX {
  MockElectrumX() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set failovers(List<_i5.ElectrumXNode>? _failovers) =>
      super.noSuchMethod(Invocation.setter(#failovers, _failovers),
          returnValueForMissingStub: null);
  @override
  int get currentFailoverIndex =>
      (super.noSuchMethod(Invocation.getter(#currentFailoverIndex),
          returnValue: 0) as int);
  @override
  set currentFailoverIndex(int? _currentFailoverIndex) => super.noSuchMethod(
      Invocation.setter(#currentFailoverIndex, _currentFailoverIndex),
      returnValueForMissingStub: null);
  @override
  String get host =>
      (super.noSuchMethod(Invocation.getter(#host), returnValue: '') as String);
  @override
  int get port =>
      (super.noSuchMethod(Invocation.getter(#port), returnValue: 0) as int);
  @override
  bool get useSSL =>
      (super.noSuchMethod(Invocation.getter(#useSSL), returnValue: false)
          as bool);
  @override
  _i8.Future<dynamic> request(
          {String? command,
          List<dynamic>? args = const [],
          Duration? connectionTimeout = const Duration(seconds: 60),
          String? requestID,
          int? retries = 2}) =>
      (super.noSuchMethod(
          Invocation.method(#request, [], {
            #command: command,
            #args: args,
            #connectionTimeout: connectionTimeout,
            #requestID: requestID,
            #retries: retries
          }),
          returnValue: Future<dynamic>.value()) as _i8.Future<dynamic>);
  @override
  _i8.Future<List<Map<String, dynamic>>> batchRequest(
          {String? command,
          Map<String, List<dynamic>>? args,
          Duration? connectionTimeout = const Duration(seconds: 60),
          int? retries = 2}) =>
      (super.noSuchMethod(
              Invocation.method(#batchRequest, [], {
                #command: command,
                #args: args,
                #connectionTimeout: connectionTimeout,
                #retries: retries
              }),
              returnValue: Future<List<Map<String, dynamic>>>.value(
                  <Map<String, dynamic>>[]))
          as _i8.Future<List<Map<String, dynamic>>>);
  @override
  _i8.Future<bool> ping({String? requestID, int? retryCount = 1}) =>
      (super.noSuchMethod(
          Invocation.method(
              #ping, [], {#requestID: requestID, #retryCount: retryCount}),
          returnValue: Future<bool>.value(false)) as _i8.Future<bool>);
  @override
  _i8.Future<Map<String, dynamic>> getBlockHeadTip({String? requestID}) =>
      (super.noSuchMethod(
              Invocation.method(#getBlockHeadTip, [], {#requestID: requestID}),
              returnValue:
                  Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i8.Future<Map<String, dynamic>>);
  @override
  _i8.Future<Map<String, dynamic>> getServerFeatures({String? requestID}) =>
      (super.noSuchMethod(
          Invocation.method(#getServerFeatures, [], {#requestID: requestID}),
          returnValue:
              Future<Map<String, dynamic>>.value(<String, dynamic>{})) as _i8
          .Future<Map<String, dynamic>>);
  @override
  _i8.Future<String> broadcastTransaction({String? rawTx, String? requestID}) =>
      (super.noSuchMethod(
          Invocation.method(#broadcastTransaction, [],
              {#rawTx: rawTx, #requestID: requestID}),
          returnValue: Future<String>.value('')) as _i8.Future<String>);
  @override
  _i8.Future<Map<String, dynamic>> getBalance(
          {String? scripthash, String? requestID}) =>
      (super.noSuchMethod(
              Invocation.method(#getBalance, [],
                  {#scripthash: scripthash, #requestID: requestID}),
              returnValue:
                  Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i8.Future<Map<String, dynamic>>);
  @override
  _i8.Future<List<Map<String, dynamic>>> getHistory(
          {String? scripthash, String? requestID}) =>
      (super.noSuchMethod(
              Invocation.method(#getHistory, [],
                  {#scripthash: scripthash, #requestID: requestID}),
              returnValue: Future<List<Map<String, dynamic>>>.value(
                  <Map<String, dynamic>>[]))
          as _i8.Future<List<Map<String, dynamic>>>);
  @override
  _i8.Future<Map<String, List<Map<String, dynamic>>>> getBatchHistory(
          {Map<String, List<dynamic>>? args}) =>
      (super.noSuchMethod(
          Invocation.method(#getBatchHistory, [], {#args: args}),
          returnValue: Future<Map<String, List<Map<String, dynamic>>>>.value(
              <String, List<Map<String, dynamic>>>{})) as _i8
          .Future<Map<String, List<Map<String, dynamic>>>>);
  @override
  _i8.Future<List<Map<String, dynamic>>> getUTXOs(
          {String? scripthash, String? requestID}) =>
      (super.noSuchMethod(
          Invocation.method(
              #getUTXOs, [], {#scripthash: scripthash, #requestID: requestID}),
          returnValue: Future<List<Map<String, dynamic>>>.value(
              <Map<String, dynamic>>[])) as _i8
          .Future<List<Map<String, dynamic>>>);
  @override
  _i8.Future<Map<String, List<Map<String, dynamic>>>> getBatchUTXOs(
          {Map<String, List<dynamic>>? args}) =>
      (super.noSuchMethod(Invocation.method(#getBatchUTXOs, [], {#args: args}),
          returnValue: Future<Map<String, List<Map<String, dynamic>>>>.value(
              <String, List<Map<String, dynamic>>>{})) as _i8
          .Future<Map<String, List<Map<String, dynamic>>>>);
  @override
  _i8.Future<Map<String, dynamic>> getTransaction(
          {String? txHash, bool? verbose = true, String? requestID}) =>
      (super.noSuchMethod(
              Invocation.method(#getTransaction, [],
                  {#txHash: txHash, #verbose: verbose, #requestID: requestID}),
              returnValue:
                  Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i8.Future<Map<String, dynamic>>);
  @override
  _i8.Future<Map<String, dynamic>> getAnonymitySet(
          {String? groupId = r'1',
          String? blockhash = r'',
          String? requestID}) =>
      (super.noSuchMethod(
              Invocation.method(#getAnonymitySet, [], {
                #groupId: groupId,
                #blockhash: blockhash,
                #requestID: requestID
              }),
              returnValue:
                  Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i8.Future<Map<String, dynamic>>);
  @override
  _i8.Future<dynamic> getMintData({dynamic mints, String? requestID}) =>
      (super.noSuchMethod(
          Invocation.method(
              #getMintData, [], {#mints: mints, #requestID: requestID}),
          returnValue: Future<dynamic>.value()) as _i8.Future<dynamic>);
  @override
  _i8.Future<Map<String, dynamic>> getUsedCoinSerials(
          {String? requestID, int? startNumber}) =>
      (super.noSuchMethod(
              Invocation.method(#getUsedCoinSerials, [],
                  {#requestID: requestID, #startNumber: startNumber}),
              returnValue:
                  Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i8.Future<Map<String, dynamic>>);
  @override
  _i8.Future<int> getLatestCoinId({String? requestID}) => (super.noSuchMethod(
      Invocation.method(#getLatestCoinId, [], {#requestID: requestID}),
      returnValue: Future<int>.value(0)) as _i8.Future<int>);
  @override
  _i8.Future<Map<String, dynamic>> getFeeRate({String? requestID}) => (super
      .noSuchMethod(Invocation.method(#getFeeRate, [], {#requestID: requestID}),
          returnValue:
              Future<Map<String, dynamic>>.value(<String, dynamic>{})) as _i8
      .Future<Map<String, dynamic>>);
  @override
  _i8.Future<_i3.Decimal> estimateFee({String? requestID, int? blocks}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #estimateFee, [], {#requestID: requestID, #blocks: blocks}),
              returnValue: Future<_i3.Decimal>.value(_FakeDecimal_1()))
          as _i8.Future<_i3.Decimal>);
  @override
  _i8.Future<_i3.Decimal> relayFee({String? requestID}) => (super.noSuchMethod(
          Invocation.method(#relayFee, [], {#requestID: requestID}),
          returnValue: Future<_i3.Decimal>.value(_FakeDecimal_1()))
      as _i8.Future<_i3.Decimal>);
}
