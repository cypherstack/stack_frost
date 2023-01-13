// Mocks generated by Mockito 5.3.2 from annotations
// in stackwallet/test/screen_tests/main_view_tests/main_view_screen_testC_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;
import 'dart:ui' as _i9;

import 'package:isar/isar.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:stackwallet/models/balance.dart' as _i4;
import 'package:stackwallet/models/isar/models/isar_models.dart' as _i11;
import 'package:stackwallet/models/models.dart' as _i3;
import 'package:stackwallet/services/coins/coin_service.dart' as _i2;
import 'package:stackwallet/services/coins/manager.dart' as _i10;
import 'package:stackwallet/services/locale_service.dart' as _i13;
import 'package:stackwallet/services/notes_service.dart' as _i12;
import 'package:stackwallet/services/wallets_service.dart' as _i6;
import 'package:stackwallet/utilities/enums/coin_enum.dart' as _i8;

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

class _FakeCoinServiceAPI_0 extends _i1.SmartFake
    implements _i2.CoinServiceAPI {
  _FakeCoinServiceAPI_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFeeObject_1 extends _i1.SmartFake implements _i3.FeeObject {
  _FakeFeeObject_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBalance_2 extends _i1.SmartFake implements _i4.Balance {
  _FakeBalance_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeIsar_3 extends _i1.SmartFake implements _i5.Isar {
  _FakeIsar_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [WalletsService].
///
/// See the documentation for Mockito's code generation for more information.
class MockWalletsService extends _i1.Mock implements _i6.WalletsService {
  @override
  _i7.Future<Map<String, _i6.WalletInfo>> get walletNames =>
      (super.noSuchMethod(
        Invocation.getter(#walletNames),
        returnValue: _i7.Future<Map<String, _i6.WalletInfo>>.value(
            <String, _i6.WalletInfo>{}),
      ) as _i7.Future<Map<String, _i6.WalletInfo>>);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i7.Future<bool> renameWallet({
    required String? from,
    required String? to,
    required bool? shouldNotifyListeners,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #renameWallet,
          [],
          {
            #from: from,
            #to: to,
            #shouldNotifyListeners: shouldNotifyListeners,
          },
        ),
        returnValue: _i7.Future<bool>.value(false),
      ) as _i7.Future<bool>);
  @override
  _i7.Future<void> addExistingStackWallet({
    required String? name,
    required String? walletId,
    required _i8.Coin? coin,
    required bool? shouldNotifyListeners,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addExistingStackWallet,
          [],
          {
            #name: name,
            #walletId: walletId,
            #coin: coin,
            #shouldNotifyListeners: shouldNotifyListeners,
          },
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<String?> addNewWallet({
    required String? name,
    required _i8.Coin? coin,
    required bool? shouldNotifyListeners,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addNewWallet,
          [],
          {
            #name: name,
            #coin: coin,
            #shouldNotifyListeners: shouldNotifyListeners,
          },
        ),
        returnValue: _i7.Future<String?>.value(),
      ) as _i7.Future<String?>);
  @override
  _i7.Future<List<String>> getFavoriteWalletIds() => (super.noSuchMethod(
        Invocation.method(
          #getFavoriteWalletIds,
          [],
        ),
        returnValue: _i7.Future<List<String>>.value(<String>[]),
      ) as _i7.Future<List<String>>);
  @override
  _i7.Future<void> saveFavoriteWalletIds(List<String>? walletIds) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveFavoriteWalletIds,
          [walletIds],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> addFavorite(String? walletId) => (super.noSuchMethod(
        Invocation.method(
          #addFavorite,
          [walletId],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> removeFavorite(String? walletId) => (super.noSuchMethod(
        Invocation.method(
          #removeFavorite,
          [walletId],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<void> moveFavorite({
    required int? fromIndex,
    required int? toIndex,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #moveFavorite,
          [],
          {
            #fromIndex: fromIndex,
            #toIndex: toIndex,
          },
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<bool> checkForDuplicate(String? name) => (super.noSuchMethod(
        Invocation.method(
          #checkForDuplicate,
          [name],
        ),
        returnValue: _i7.Future<bool>.value(false),
      ) as _i7.Future<bool>);
  @override
  _i7.Future<String?> getWalletId(String? walletName) => (super.noSuchMethod(
        Invocation.method(
          #getWalletId,
          [walletName],
        ),
        returnValue: _i7.Future<String?>.value(),
      ) as _i7.Future<String?>);
  @override
  _i7.Future<bool> isMnemonicVerified({required String? walletId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #isMnemonicVerified,
          [],
          {#walletId: walletId},
        ),
        returnValue: _i7.Future<bool>.value(false),
      ) as _i7.Future<bool>);
  @override
  _i7.Future<void> setMnemonicVerified({required String? walletId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #setMnemonicVerified,
          [],
          {#walletId: walletId},
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  _i7.Future<int> deleteWallet(
    String? name,
    bool? shouldNotifyListeners,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteWallet,
          [
            name,
            shouldNotifyListeners,
          ],
        ),
        returnValue: _i7.Future<int>.value(0),
      ) as _i7.Future<int>);
  @override
  _i7.Future<void> refreshWallets(bool? shouldNotifyListeners) =>
      (super.noSuchMethod(
        Invocation.method(
          #refreshWallets,
          [shouldNotifyListeners],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  void addListener(_i9.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i9.VoidCallback? listener) => super.noSuchMethod(
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

/// A class which mocks [Manager].
///
/// See the documentation for Mockito's code generation for more information.
class MockManager extends _i1.Mock implements _i10.Manager {
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
  _i2.CoinServiceAPI get wallet => (super.noSuchMethod(
        Invocation.getter(#wallet),
        returnValue: _FakeCoinServiceAPI_0(
          this,
          Invocation.getter(#wallet),
        ),
      ) as _i2.CoinServiceAPI);
  @override
  bool get hasBackgroundRefreshListener => (super.noSuchMethod(
        Invocation.getter(#hasBackgroundRefreshListener),
        returnValue: false,
      ) as bool);
  @override
  _i8.Coin get coin => (super.noSuchMethod(
        Invocation.getter(#coin),
        returnValue: _i8.Coin.bitcoin,
      ) as _i8.Coin);
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
  _i7.Future<_i3.FeeObject> get fees => (super.noSuchMethod(
        Invocation.getter(#fees),
        returnValue: _i7.Future<_i3.FeeObject>.value(_FakeFeeObject_1(
          this,
          Invocation.getter(#fees),
        )),
      ) as _i7.Future<_i3.FeeObject>);
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
  _i4.Balance get balance => (super.noSuchMethod(
        Invocation.getter(#balance),
        returnValue: _FakeBalance_2(
          this,
          Invocation.getter(#balance),
        ),
      ) as _i4.Balance);
  @override
  _i7.Future<List<_i11.Transaction>> get transactions => (super.noSuchMethod(
        Invocation.getter(#transactions),
        returnValue:
            _i7.Future<List<_i11.Transaction>>.value(<_i11.Transaction>[]),
      ) as _i7.Future<List<_i11.Transaction>>);
  @override
  _i7.Future<List<_i11.UTXO>> get utxos => (super.noSuchMethod(
        Invocation.getter(#utxos),
        returnValue: _i7.Future<List<_i11.UTXO>>.value(<_i11.UTXO>[]),
      ) as _i7.Future<List<_i11.UTXO>>);
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
  _i5.Isar get db => (super.noSuchMethod(
        Invocation.getter(#db),
        returnValue: _FakeIsar_3(
          this,
          Invocation.getter(#db),
        ),
      ) as _i5.Isar);
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
  void addListener(_i9.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i9.VoidCallback? listener) => super.noSuchMethod(
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
class MockNotesService extends _i1.Mock implements _i12.NotesService {
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
  void addListener(_i9.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i9.VoidCallback? listener) => super.noSuchMethod(
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

/// A class which mocks [LocaleService].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocaleService extends _i1.Mock implements _i13.LocaleService {
  @override
  String get locale => (super.noSuchMethod(
        Invocation.getter(#locale),
        returnValue: '',
      ) as String);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i7.Future<void> loadLocale({bool? notify = true}) => (super.noSuchMethod(
        Invocation.method(
          #loadLocale,
          [],
          {#notify: notify},
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
  @override
  void addListener(_i9.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i9.VoidCallback? listener) => super.noSuchMethod(
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
