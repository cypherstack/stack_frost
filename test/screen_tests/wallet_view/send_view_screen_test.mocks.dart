// Mocks generated by Mockito 5.3.2 from annotations
// in stackwallet/test/screen_tests/wallet_view/send_view_screen_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;
import 'dart:ui' as _i10;

import 'package:barcode_scan2/barcode_scan2.dart' as _i2;
import 'package:decimal/decimal.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:stackwallet/models/models.dart' as _i4;
import 'package:stackwallet/services/coins/coin_service.dart' as _i3;
import 'package:stackwallet/services/coins/manager.dart' as _i8;
import 'package:stackwallet/services/notes_service.dart' as _i11;
import 'package:stackwallet/utilities/barcode_scanner_interface.dart' as _i6;
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
// ignore_for_file: subtype_of_sealed_class

class _FakeScanResult_0 extends _i1.SmartFake implements _i2.ScanResult {
  _FakeScanResult_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCoinServiceAPI_1 extends _i1.SmartFake
    implements _i3.CoinServiceAPI {
  _FakeCoinServiceAPI_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFeeObject_2 extends _i1.SmartFake implements _i4.FeeObject {
  _FakeFeeObject_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDecimal_3 extends _i1.SmartFake implements _i5.Decimal {
  _FakeDecimal_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeTransactionData_4 extends _i1.SmartFake
    implements _i4.TransactionData {
  _FakeTransactionData_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [BarcodeScannerWrapper].
///
/// See the documentation for Mockito's code generation for more information.
class MockBarcodeScannerWrapper extends _i1.Mock
    implements _i6.BarcodeScannerWrapper {
  MockBarcodeScannerWrapper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<_i2.ScanResult> scan(
          {_i2.ScanOptions? options = const _i2.ScanOptions()}) =>
      (super.noSuchMethod(
        Invocation.method(
          #scan,
          [],
          {#options: options},
        ),
        returnValue: _i7.Future<_i2.ScanResult>.value(_FakeScanResult_0(
          this,
          Invocation.method(
            #scan,
            [],
            {#options: options},
          ),
        )),
      ) as _i7.Future<_i2.ScanResult>);
}

/// A class which mocks [Manager].
///
/// See the documentation for Mockito's code generation for more information.
class MockManager extends _i1.Mock implements _i8.Manager {
  @override
  bool get isActiveWallet => (super.noSuchMethod(
        Invocation.getter(#isActiveWallet),
        returnValue: false,
      ) as bool);
  @override
  set isActiveWallet(bool? isActive) => super.noSuchMethod(
        Invocation.setter(
          #isActiveWallet,
          isActive,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i3.CoinServiceAPI get wallet => (super.noSuchMethod(
        Invocation.getter(#wallet),
        returnValue: _FakeCoinServiceAPI_1(
          this,
          Invocation.getter(#wallet),
        ),
      ) as _i3.CoinServiceAPI);
  @override
  bool get hasBackgroundRefreshListener => (super.noSuchMethod(
        Invocation.getter(#hasBackgroundRefreshListener),
        returnValue: false,
      ) as bool);
  @override
  _i9.Coin get coin => (super.noSuchMethod(
        Invocation.getter(#coin),
        returnValue: _i9.Coin.bitcoin,
      ) as _i9.Coin);
  @override
  bool get isRefreshing => (super.noSuchMethod(
        Invocation.getter(#isRefreshing),
        returnValue: false,
      ) as bool);
  @override
  bool get shouldAutoSync => (super.noSuchMethod(
        Invocation.getter(#shouldAutoSync),
        returnValue: false,
      ) as bool);
  @override
  set shouldAutoSync(bool? shouldAutoSync) => super.noSuchMethod(
        Invocation.setter(
          #shouldAutoSync,
          shouldAutoSync,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get isFavorite => (super.noSuchMethod(
        Invocation.getter(#isFavorite),
        returnValue: false,
      ) as bool);
  @override
  set isFavorite(bool? markFavorite) => super.noSuchMethod(
        Invocation.setter(
          #isFavorite,
          markFavorite,
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i7.Future<_i4.FeeObject> get fees => (super.noSuchMethod(
        Invocation.getter(#fees),
        returnValue: _i7.Future<_i4.FeeObject>.value(_FakeFeeObject_2(
          this,
          Invocation.getter(#fees),
        )),
      ) as _i7.Future<_i4.FeeObject>);
  @override
  _i7.Future<int> get maxFee => (super.noSuchMethod(
        Invocation.getter(#maxFee),
        returnValue: _i7.Future<int>.value(0),
      ) as _i7.Future<int>);
  @override
  _i7.Future<String> get currentReceivingAddress => (super.noSuchMethod(
        Invocation.getter(#currentReceivingAddress),
        returnValue: _i7.Future<String>.value(''),
      ) as _i7.Future<String>);
  @override
  _i7.Future<_i5.Decimal> get availableBalance => (super.noSuchMethod(
        Invocation.getter(#availableBalance),
        returnValue: _i7.Future<_i5.Decimal>.value(_FakeDecimal_3(
          this,
          Invocation.getter(#availableBalance),
        )),
      ) as _i7.Future<_i5.Decimal>);
  @override
  _i5.Decimal get cachedAvailableBalance => (super.noSuchMethod(
        Invocation.getter(#cachedAvailableBalance),
        returnValue: _FakeDecimal_3(
          this,
          Invocation.getter(#cachedAvailableBalance),
        ),
      ) as _i5.Decimal);
  @override
  _i7.Future<_i5.Decimal> get pendingBalance => (super.noSuchMethod(
        Invocation.getter(#pendingBalance),
        returnValue: _i7.Future<_i5.Decimal>.value(_FakeDecimal_3(
          this,
          Invocation.getter(#pendingBalance),
        )),
      ) as _i7.Future<_i5.Decimal>);
  @override
  _i7.Future<_i5.Decimal> get balanceMinusMaxFee => (super.noSuchMethod(
        Invocation.getter(#balanceMinusMaxFee),
        returnValue: _i7.Future<_i5.Decimal>.value(_FakeDecimal_3(
          this,
          Invocation.getter(#balanceMinusMaxFee),
        )),
      ) as _i7.Future<_i5.Decimal>);
  @override
  _i7.Future<_i5.Decimal> get totalBalance => (super.noSuchMethod(
        Invocation.getter(#totalBalance),
        returnValue: _i7.Future<_i5.Decimal>.value(_FakeDecimal_3(
          this,
          Invocation.getter(#totalBalance),
        )),
      ) as _i7.Future<_i5.Decimal>);
  @override
  _i5.Decimal get cachedTotalBalance => (super.noSuchMethod(
        Invocation.getter(#cachedTotalBalance),
        returnValue: _FakeDecimal_3(
          this,
          Invocation.getter(#cachedTotalBalance),
        ),
      ) as _i5.Decimal);
  @override
  _i7.Future<List<String>> get allOwnAddresses => (super.noSuchMethod(
        Invocation.getter(#allOwnAddresses),
        returnValue: _i7.Future<List<String>>.value(<String>[]),
      ) as _i7.Future<List<String>>);
  @override
  _i7.Future<_i4.TransactionData> get transactionData => (super.noSuchMethod(
        Invocation.getter(#transactionData),
        returnValue:
            _i7.Future<_i4.TransactionData>.value(_FakeTransactionData_4(
          this,
          Invocation.getter(#transactionData),
        )),
      ) as _i7.Future<_i4.TransactionData>);
  @override
  _i7.Future<List<_i4.UtxoObject>> get unspentOutputs => (super.noSuchMethod(
        Invocation.getter(#unspentOutputs),
        returnValue: _i7.Future<List<_i4.UtxoObject>>.value(<_i4.UtxoObject>[]),
      ) as _i7.Future<List<_i4.UtxoObject>>);
  @override
  set walletName(String? newName) => super.noSuchMethod(
        Invocation.setter(
          #walletName,
          newName,
        ),
        returnValueForMissingStub: null,
      );
  @override
  String get walletName => (super.noSuchMethod(
        Invocation.getter(#walletName),
        returnValue: '',
      ) as String);
  @override
  String get walletId => (super.noSuchMethod(
        Invocation.getter(#walletId),
        returnValue: '',
      ) as String);
  @override
  _i7.Future<List<String>> get mnemonic => (super.noSuchMethod(
        Invocation.getter(#mnemonic),
        returnValue: _i7.Future<List<String>>.value(<String>[]),
      ) as _i7.Future<List<String>>);
  @override
  bool get isConnected => (super.noSuchMethod(
        Invocation.getter(#isConnected),
        returnValue: false,
      ) as bool);
  @override
  int get currentHeight => (super.noSuchMethod(
        Invocation.getter(#currentHeight),
        returnValue: 0,
      ) as int);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i7.Future<void> updateNode(bool? shouldRefresh) => (super.noSuchMethod(
        Invocation.method(
          #updateNode,
          [shouldRefresh],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  _i7.Future<Map<String, dynamic>> prepareSend({
    required String? address,
    required int? satoshiAmount,
    Map<String, dynamic>? args,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #prepareSend,
          [],
          {
            #address: address,
            #satoshiAmount: satoshiAmount,
            #args: args,
          },
        ),
        returnValue:
            _i7.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i7.Future<Map<String, dynamic>>);
  @override
  _i7.Future<String> confirmSend({required Map<String, dynamic>? txData}) =>
      (super.noSuchMethod(
        Invocation.method(
          #confirmSend,
          [],
          {#txData: txData},
        ),
        returnValue: _i7.Future<String>.value(''),
      ) as _i7.Future<String>);
  @override
  _i7.Future<String> send({
    required String? toAddress,
    required int? amount,
    Map<String, String>? args = const {},
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #send,
          [],
          {
            #toAddress: toAddress,
            #amount: amount,
            #args: args,
          },
        ),
        returnValue: _i7.Future<String>.value(''),
      ) as _i7.Future<String>);
  @override
  _i7.Future<void> refresh() => (super.noSuchMethod(
        Invocation.method(
          #refresh,
          [],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  bool validateAddress(String? address) => (super.noSuchMethod(
        Invocation.method(
          #validateAddress,
          [address],
        ),
        returnValue: false,
      ) as bool);
  @override
  _i7.Future<bool> testNetworkConnection() => (super.noSuchMethod(
        Invocation.method(
          #testNetworkConnection,
          [],
        ),
        returnValue: _i7.Future<bool>.value(false),
      ) as _i7.Future<bool>);
  @override
  _i7.Future<void> initializeNew() => (super.noSuchMethod(
        Invocation.method(
          #initializeNew,
          [],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> initializeExisting() => (super.noSuchMethod(
        Invocation.method(
          #initializeExisting,
          [],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> recoverFromMnemonic({
    required String? mnemonic,
    required int? maxUnusedAddressGap,
    required int? maxNumberOfIndexesToCheck,
    required int? height,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #recoverFromMnemonic,
          [],
          {
            #mnemonic: mnemonic,
            #maxUnusedAddressGap: maxUnusedAddressGap,
            #maxNumberOfIndexesToCheck: maxNumberOfIndexesToCheck,
            #height: height,
          },
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> exitCurrentWallet() => (super.noSuchMethod(
        Invocation.method(
          #exitCurrentWallet,
          [],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> fullRescan(
    int? maxUnusedAddressGap,
    int? maxNumberOfIndexesToCheck,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fullRescan,
          [
            maxUnusedAddressGap,
            maxNumberOfIndexesToCheck,
          ],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<bool> isOwnAddress(String? address) => (super.noSuchMethod(
        Invocation.method(
          #isOwnAddress,
          [address],
        ),
        returnValue: _i7.Future<bool>.value(false),
      ) as _i7.Future<bool>);
  @override
  _i7.Future<int> estimateFeeFor(
    int? satoshiAmount,
    int? feeRate,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #estimateFeeFor,
          [
            satoshiAmount,
            feeRate,
          ],
        ),
        returnValue: _i7.Future<int>.value(0),
      ) as _i7.Future<int>);
  @override
  _i7.Future<bool> generateNewAddress() => (super.noSuchMethod(
        Invocation.method(
          #generateNewAddress,
          [],
        ),
        returnValue: _i7.Future<bool>.value(false),
      ) as _i7.Future<bool>);
  @override
  void addListener(_i10.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i10.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [NotesService].
///
/// See the documentation for Mockito's code generation for more information.
class MockNotesService extends _i1.Mock implements _i11.NotesService {
  @override
  String get walletId => (super.noSuchMethod(
        Invocation.getter(#walletId),
        returnValue: '',
      ) as String);
  @override
  Map<String, String> get notesSync => (super.noSuchMethod(
        Invocation.getter(#notesSync),
        returnValue: <String, String>{},
      ) as Map<String, String>);
  @override
  _i7.Future<Map<String, String>> get notes => (super.noSuchMethod(
        Invocation.getter(#notes),
        returnValue: _i7.Future<Map<String, String>>.value(<String, String>{}),
      ) as _i7.Future<Map<String, String>>);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i7.Future<Map<String, String>> search(String? text) => (super.noSuchMethod(
        Invocation.method(
          #search,
          [text],
        ),
        returnValue: _i7.Future<Map<String, String>>.value(<String, String>{}),
      ) as _i7.Future<Map<String, String>>);
  @override
  _i7.Future<String> getNoteFor({required String? txid}) => (super.noSuchMethod(
        Invocation.method(
          #getNoteFor,
          [],
          {#txid: txid},
        ),
        returnValue: _i7.Future<String>.value(''),
      ) as _i7.Future<String>);
  @override
  _i7.Future<void> editOrAddNote({
    required String? txid,
    required String? note,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #editOrAddNote,
          [],
          {
            #txid: txid,
            #note: note,
          },
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> deleteNote({required String? txid}) => (super.noSuchMethod(
        Invocation.method(
          #deleteNote,
          [],
          {#txid: txid},
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  void addListener(_i10.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i10.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
