// Mocks generated by Mockito 5.3.2 from annotations
// in stackwallet/test/services/coins/firo/firo_wallet_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:decimal/decimal.dart' as _i2;
import 'package:http/http.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:stackwallet/electrumx_rpc/cached_electrumx.dart' as _i7;
import 'package:stackwallet/electrumx_rpc/electrumx.dart' as _i5;
import 'package:stackwallet/services/price.dart' as _i9;
import 'package:stackwallet/services/transaction_notification_tracker.dart'
    as _i11;
import 'package:stackwallet/utilities/enums/coin_enum.dart' as _i8;
import 'package:stackwallet/utilities/prefs.dart' as _i3;
import 'package:tuple/tuple.dart' as _i10;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDecimal_0 extends _i1.SmartFake implements _i2.Decimal {
  _FakeDecimal_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakePrefs_1 extends _i1.SmartFake implements _i3.Prefs {
  _FakePrefs_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeClient_2 extends _i1.SmartFake implements _i4.Client {
  _FakeClient_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ElectrumX].
///
/// See the documentation for Mockito's code generation for more information.
class MockElectrumX extends _i1.Mock implements _i5.ElectrumX {
  MockElectrumX() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set failovers(List<_i5.ElectrumXNode>? _failovers) => super.noSuchMethod(
        Invocation.setter(
          #failovers,
          _failovers,
        ),
        returnValueForMissingStub: null,
      );
  @override
  int get currentFailoverIndex => (super.noSuchMethod(
        Invocation.getter(#currentFailoverIndex),
        returnValue: 0,
      ) as int);
  @override
  set currentFailoverIndex(int? _currentFailoverIndex) => super.noSuchMethod(
        Invocation.setter(
          #currentFailoverIndex,
          _currentFailoverIndex,
        ),
        returnValueForMissingStub: null,
      );
  @override
  String get host => (super.noSuchMethod(
        Invocation.getter(#host),
        returnValue: '',
      ) as String);
  @override
  int get port => (super.noSuchMethod(
        Invocation.getter(#port),
        returnValue: 0,
      ) as int);
  @override
  bool get useSSL => (super.noSuchMethod(
        Invocation.getter(#useSSL),
        returnValue: false,
      ) as bool);
  @override
  _i6.Future<dynamic> request({
    required String? command,
    List<dynamic>? args = const [],
    Duration? connectionTimeout = const Duration(seconds: 60),
    String? requestID,
    int? retries = 2,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #request,
          [],
          {
            #command: command,
            #args: args,
            #connectionTimeout: connectionTimeout,
            #requestID: requestID,
            #retries: retries,
          },
        ),
        returnValue: _i6.Future<dynamic>.value(),
      ) as _i6.Future<dynamic>);
  @override
  _i6.Future<List<Map<String, dynamic>>> batchRequest({
    required String? command,
    required Map<String, List<dynamic>>? args,
    Duration? connectionTimeout = const Duration(seconds: 60),
    int? retries = 2,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #batchRequest,
          [],
          {
            #command: command,
            #args: args,
            #connectionTimeout: connectionTimeout,
            #retries: retries,
          },
        ),
        returnValue: _i6.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i6.Future<List<Map<String, dynamic>>>);
  @override
  _i6.Future<bool> ping({
    String? requestID,
    int? retryCount = 1,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #ping,
          [],
          {
            #requestID: requestID,
            #retryCount: retryCount,
          },
        ),
        returnValue: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
  @override
  _i6.Future<Map<String, dynamic>> getBlockHeadTip({String? requestID}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getBlockHeadTip,
          [],
          {#requestID: requestID},
        ),
        returnValue:
            _i6.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i6.Future<Map<String, dynamic>>);
  @override
  _i6.Future<Map<String, dynamic>> getServerFeatures({String? requestID}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getServerFeatures,
          [],
          {#requestID: requestID},
        ),
        returnValue:
            _i6.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i6.Future<Map<String, dynamic>>);
  @override
  _i6.Future<String> broadcastTransaction({
    required String? rawTx,
    String? requestID,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #broadcastTransaction,
          [],
          {
            #rawTx: rawTx,
            #requestID: requestID,
          },
        ),
        returnValue: _i6.Future<String>.value(''),
      ) as _i6.Future<String>);
  @override
  _i6.Future<Map<String, dynamic>> getBalance({
    required String? scripthash,
    String? requestID,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getBalance,
          [],
          {
            #scripthash: scripthash,
            #requestID: requestID,
          },
        ),
        returnValue:
            _i6.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i6.Future<Map<String, dynamic>>);
  @override
  _i6.Future<List<Map<String, dynamic>>> getHistory({
    required String? scripthash,
    String? requestID,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getHistory,
          [],
          {
            #scripthash: scripthash,
            #requestID: requestID,
          },
        ),
        returnValue: _i6.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i6.Future<List<Map<String, dynamic>>>);
  @override
  _i6.Future<Map<String, List<Map<String, dynamic>>>> getBatchHistory(
          {required Map<String, List<dynamic>>? args}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getBatchHistory,
          [],
          {#args: args},
        ),
        returnValue: _i6.Future<Map<String, List<Map<String, dynamic>>>>.value(
            <String, List<Map<String, dynamic>>>{}),
      ) as _i6.Future<Map<String, List<Map<String, dynamic>>>>);
  @override
  _i6.Future<List<Map<String, dynamic>>> getUTXOs({
    required String? scripthash,
    String? requestID,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUTXOs,
          [],
          {
            #scripthash: scripthash,
            #requestID: requestID,
          },
        ),
        returnValue: _i6.Future<List<Map<String, dynamic>>>.value(
            <Map<String, dynamic>>[]),
      ) as _i6.Future<List<Map<String, dynamic>>>);
  @override
  _i6.Future<Map<String, List<Map<String, dynamic>>>> getBatchUTXOs(
          {required Map<String, List<dynamic>>? args}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getBatchUTXOs,
          [],
          {#args: args},
        ),
        returnValue: _i6.Future<Map<String, List<Map<String, dynamic>>>>.value(
            <String, List<Map<String, dynamic>>>{}),
      ) as _i6.Future<Map<String, List<Map<String, dynamic>>>>);
  @override
  _i6.Future<Map<String, dynamic>> getTransaction({
    required String? txHash,
    bool? verbose = true,
    String? requestID,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTransaction,
          [],
          {
            #txHash: txHash,
            #verbose: verbose,
            #requestID: requestID,
          },
        ),
        returnValue:
            _i6.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i6.Future<Map<String, dynamic>>);
  @override
  _i6.Future<Map<String, dynamic>> getAnonymitySet({
    String? groupId = r'1',
    String? blockhash = r'',
    String? requestID,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAnonymitySet,
          [],
          {
            #groupId: groupId,
            #blockhash: blockhash,
            #requestID: requestID,
          },
        ),
        returnValue:
            _i6.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i6.Future<Map<String, dynamic>>);
  @override
  _i6.Future<dynamic> getMintData({
    dynamic mints,
    String? requestID,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMintData,
          [],
          {
            #mints: mints,
            #requestID: requestID,
          },
        ),
        returnValue: _i6.Future<dynamic>.value(),
      ) as _i6.Future<dynamic>);
  @override
  _i6.Future<Map<String, dynamic>> getUsedCoinSerials({
    String? requestID,
    required int? startNumber,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUsedCoinSerials,
          [],
          {
            #requestID: requestID,
            #startNumber: startNumber,
          },
        ),
        returnValue:
            _i6.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i6.Future<Map<String, dynamic>>);
  @override
  _i6.Future<int> getLatestCoinId({String? requestID}) => (super.noSuchMethod(
        Invocation.method(
          #getLatestCoinId,
          [],
          {#requestID: requestID},
        ),
        returnValue: _i6.Future<int>.value(0),
      ) as _i6.Future<int>);
  @override
  _i6.Future<Map<String, dynamic>> getFeeRate({String? requestID}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFeeRate,
          [],
          {#requestID: requestID},
        ),
        returnValue:
            _i6.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i6.Future<Map<String, dynamic>>);
  @override
  _i6.Future<_i2.Decimal> estimateFee({
    String? requestID,
    required int? blocks,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #estimateFee,
          [],
          {
            #requestID: requestID,
            #blocks: blocks,
          },
        ),
        returnValue: _i6.Future<_i2.Decimal>.value(_FakeDecimal_0(
          this,
          Invocation.method(
            #estimateFee,
            [],
            {
              #requestID: requestID,
              #blocks: blocks,
            },
          ),
        )),
      ) as _i6.Future<_i2.Decimal>);
  @override
  _i6.Future<_i2.Decimal> relayFee({String? requestID}) => (super.noSuchMethod(
        Invocation.method(
          #relayFee,
          [],
          {#requestID: requestID},
        ),
        returnValue: _i6.Future<_i2.Decimal>.value(_FakeDecimal_0(
          this,
          Invocation.method(
            #relayFee,
            [],
            {#requestID: requestID},
          ),
        )),
      ) as _i6.Future<_i2.Decimal>);
}

/// A class which mocks [CachedElectrumX].
///
/// See the documentation for Mockito's code generation for more information.
class MockCachedElectrumX extends _i1.Mock implements _i7.CachedElectrumX {
  MockCachedElectrumX() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get server => (super.noSuchMethod(
        Invocation.getter(#server),
        returnValue: '',
      ) as String);
  @override
  int get port => (super.noSuchMethod(
        Invocation.getter(#port),
        returnValue: 0,
      ) as int);
  @override
  bool get useSSL => (super.noSuchMethod(
        Invocation.getter(#useSSL),
        returnValue: false,
      ) as bool);
  @override
  _i3.Prefs get prefs => (super.noSuchMethod(
        Invocation.getter(#prefs),
        returnValue: _FakePrefs_1(
          this,
          Invocation.getter(#prefs),
        ),
      ) as _i3.Prefs);
  @override
  List<_i5.ElectrumXNode> get failovers => (super.noSuchMethod(
        Invocation.getter(#failovers),
        returnValue: <_i5.ElectrumXNode>[],
      ) as List<_i5.ElectrumXNode>);
  @override
  _i6.Future<Map<String, dynamic>> getAnonymitySet({
    required String? groupId,
    String? blockhash = r'',
    required _i8.Coin? coin,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAnonymitySet,
          [],
          {
            #groupId: groupId,
            #blockhash: blockhash,
            #coin: coin,
          },
        ),
        returnValue:
            _i6.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i6.Future<Map<String, dynamic>>);
  @override
  String base64ToHex(String? source) => (super.noSuchMethod(
        Invocation.method(
          #base64ToHex,
          [source],
        ),
        returnValue: '',
      ) as String);
  @override
  String base64ToReverseHex(String? source) => (super.noSuchMethod(
        Invocation.method(
          #base64ToReverseHex,
          [source],
        ),
        returnValue: '',
      ) as String);
  @override
  _i6.Future<Map<String, dynamic>> getTransaction({
    required String? txHash,
    required _i8.Coin? coin,
    bool? verbose = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTransaction,
          [],
          {
            #txHash: txHash,
            #coin: coin,
            #verbose: verbose,
          },
        ),
        returnValue:
            _i6.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i6.Future<Map<String, dynamic>>);
  @override
  _i6.Future<List<dynamic>> getUsedCoinSerials({
    required _i8.Coin? coin,
    int? startNumber = 0,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUsedCoinSerials,
          [],
          {
            #coin: coin,
            #startNumber: startNumber,
          },
        ),
        returnValue: _i6.Future<List<dynamic>>.value(<dynamic>[]),
      ) as _i6.Future<List<dynamic>>);
  @override
  _i6.Future<void> clearSharedTransactionCache({required _i8.Coin? coin}) =>
      (super.noSuchMethod(
        Invocation.method(
          #clearSharedTransactionCache,
          [],
          {#coin: coin},
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
}

/// A class which mocks [PriceAPI].
///
/// See the documentation for Mockito's code generation for more information.
class MockPriceAPI extends _i1.Mock implements _i9.PriceAPI {
  MockPriceAPI() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Client get client => (super.noSuchMethod(
        Invocation.getter(#client),
        returnValue: _FakeClient_2(
          this,
          Invocation.getter(#client),
        ),
      ) as _i4.Client);
  @override
  void resetLastCalledToForceNextCallToUpdateCache() => super.noSuchMethod(
        Invocation.method(
          #resetLastCalledToForceNextCallToUpdateCache,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i6.Future<
      Map<_i8.Coin, _i10.Tuple2<_i2.Decimal, double>>> getPricesAnd24hChange(
          {required String? baseCurrency}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getPricesAnd24hChange,
          [],
          {#baseCurrency: baseCurrency},
        ),
        returnValue:
            _i6.Future<Map<_i8.Coin, _i10.Tuple2<_i2.Decimal, double>>>.value(
                <_i8.Coin, _i10.Tuple2<_i2.Decimal, double>>{}),
      ) as _i6.Future<Map<_i8.Coin, _i10.Tuple2<_i2.Decimal, double>>>);
}

/// A class which mocks [TransactionNotificationTracker].
///
/// See the documentation for Mockito's code generation for more information.
class MockTransactionNotificationTracker extends _i1.Mock
    implements _i11.TransactionNotificationTracker {
  MockTransactionNotificationTracker() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get walletId => (super.noSuchMethod(
        Invocation.getter(#walletId),
        returnValue: '',
      ) as String);
  @override
  List<String> get pendings => (super.noSuchMethod(
        Invocation.getter(#pendings),
        returnValue: <String>[],
      ) as List<String>);
  @override
  List<String> get confirmeds => (super.noSuchMethod(
        Invocation.getter(#confirmeds),
        returnValue: <String>[],
      ) as List<String>);
  @override
  bool wasNotifiedPending(String? txid) => (super.noSuchMethod(
        Invocation.method(
          #wasNotifiedPending,
          [txid],
        ),
        returnValue: false,
      ) as bool);
  @override
  _i6.Future<void> addNotifiedPending(String? txid) => (super.noSuchMethod(
        Invocation.method(
          #addNotifiedPending,
          [txid],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
  @override
  bool wasNotifiedConfirmed(String? txid) => (super.noSuchMethod(
        Invocation.method(
          #wasNotifiedConfirmed,
          [txid],
        ),
        returnValue: false,
      ) as bool);
  @override
  _i6.Future<void> addNotifiedConfirmed(String? txid) => (super.noSuchMethod(
        Invocation.method(
          #addNotifiedConfirmed,
          [txid],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
}
