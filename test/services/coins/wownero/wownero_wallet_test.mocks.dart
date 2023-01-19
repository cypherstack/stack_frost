// Mocks generated by Mockito 5.3.2 from annotations
// in stackwallet/test/services/coins/wownero/wownero_wallet_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:isar/isar.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:stackwallet/db/main_db.dart' as _i3;
import 'package:stackwallet/models/isar/models/isar_models.dart' as _i5;
import 'package:tuple/tuple.dart' as _i6;

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

class _FakeIsar_0 extends _i1.SmartFake implements _i2.Isar {
  _FakeIsar_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeQueryBuilder_1<OBJ, R, S> extends _i1.SmartFake
    implements _i2.QueryBuilder<OBJ, R, S> {
  _FakeQueryBuilder_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [MainDB].
///
/// See the documentation for Mockito's code generation for more information.
class MockMainDB extends _i1.Mock implements _i3.MainDB {
  MockMainDB() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Isar get isar => (super.noSuchMethod(
        Invocation.getter(#isar),
        returnValue: _FakeIsar_0(
          this,
          Invocation.getter(#isar),
        ),
      ) as _i2.Isar);
  @override
  _i4.Future<bool> isarInit() => (super.noSuchMethod(
        Invocation.method(
          #isarInit,
          [],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i2.QueryBuilder<_i5.Address, _i5.Address, _i2.QAfterWhereClause>
      getAddresses(String? walletId) => (super.noSuchMethod(
            Invocation.method(
              #getAddresses,
              [walletId],
            ),
            returnValue: _FakeQueryBuilder_1<_i5.Address, _i5.Address,
                _i2.QAfterWhereClause>(
              this,
              Invocation.method(
                #getAddresses,
                [walletId],
              ),
            ),
          ) as _i2
              .QueryBuilder<_i5.Address, _i5.Address, _i2.QAfterWhereClause>);
  @override
  _i4.Future<void> putAddress(_i5.Address? address) => (super.noSuchMethod(
        Invocation.method(
          #putAddress,
          [address],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> putAddresses(List<_i5.Address>? addresses) =>
      (super.noSuchMethod(
        Invocation.method(
          #putAddresses,
          [addresses],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> updateAddress(
    _i5.Address? oldAddress,
    _i5.Address? newAddress,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateAddress,
          [
            oldAddress,
            newAddress,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i2.QueryBuilder<_i5.Transaction, _i5.Transaction, _i2.QAfterWhereClause>
      getTransactions(String? walletId) => (super.noSuchMethod(
            Invocation.method(
              #getTransactions,
              [walletId],
            ),
            returnValue: _FakeQueryBuilder_1<_i5.Transaction, _i5.Transaction,
                _i2.QAfterWhereClause>(
              this,
              Invocation.method(
                #getTransactions,
                [walletId],
              ),
            ),
          ) as _i2.QueryBuilder<_i5.Transaction, _i5.Transaction,
              _i2.QAfterWhereClause>);
  @override
  _i4.Future<void> putTransaction(_i5.Transaction? transaction) =>
      (super.noSuchMethod(
        Invocation.method(
          #putTransaction,
          [transaction],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> putTransactions(List<_i5.Transaction>? transactions) =>
      (super.noSuchMethod(
        Invocation.method(
          #putTransactions,
          [transactions],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i2.QueryBuilder<_i5.UTXO, _i5.UTXO, _i2.QAfterWhereClause> getUTXOs(
          String? walletId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUTXOs,
          [walletId],
        ),
        returnValue:
            _FakeQueryBuilder_1<_i5.UTXO, _i5.UTXO, _i2.QAfterWhereClause>(
          this,
          Invocation.method(
            #getUTXOs,
            [walletId],
          ),
        ),
      ) as _i2.QueryBuilder<_i5.UTXO, _i5.UTXO, _i2.QAfterWhereClause>);
  @override
  _i4.Future<void> putUTXO(_i5.UTXO? utxo) => (super.noSuchMethod(
        Invocation.method(
          #putUTXO,
          [utxo],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> putUTXOs(List<_i5.UTXO>? utxos) => (super.noSuchMethod(
        Invocation.method(
          #putUTXOs,
          [utxos],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i2.QueryBuilder<_i5.Input, _i5.Input, _i2.QAfterWhereClause> getInputs(
          String? walletId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getInputs,
          [walletId],
        ),
        returnValue:
            _FakeQueryBuilder_1<_i5.Input, _i5.Input, _i2.QAfterWhereClause>(
          this,
          Invocation.method(
            #getInputs,
            [walletId],
          ),
        ),
      ) as _i2.QueryBuilder<_i5.Input, _i5.Input, _i2.QAfterWhereClause>);
  @override
  _i4.Future<void> putInput(_i5.Input? input) => (super.noSuchMethod(
        Invocation.method(
          #putInput,
          [input],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> putInputs(List<_i5.Input>? inputs) => (super.noSuchMethod(
        Invocation.method(
          #putInputs,
          [inputs],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i2.QueryBuilder<_i5.Output, _i5.Output, _i2.QAfterWhereClause> getOutputs(
          String? walletId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getOutputs,
          [walletId],
        ),
        returnValue:
            _FakeQueryBuilder_1<_i5.Output, _i5.Output, _i2.QAfterWhereClause>(
          this,
          Invocation.method(
            #getOutputs,
            [walletId],
          ),
        ),
      ) as _i2.QueryBuilder<_i5.Output, _i5.Output, _i2.QAfterWhereClause>);
  @override
  _i4.Future<void> putOutput(_i5.Output? output) => (super.noSuchMethod(
        Invocation.method(
          #putOutput,
          [output],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> putOutputs(List<_i5.Output>? outputs) => (super.noSuchMethod(
        Invocation.method(
          #putOutputs,
          [outputs],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i2.QueryBuilder<_i5.TransactionNote, _i5.TransactionNote,
      _i2.QAfterWhereClause> getTransactionNotes(
          String? walletId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTransactionNotes,
          [walletId],
        ),
        returnValue: _FakeQueryBuilder_1<_i5.TransactionNote,
            _i5.TransactionNote, _i2.QAfterWhereClause>(
          this,
          Invocation.method(
            #getTransactionNotes,
            [walletId],
          ),
        ),
      ) as _i2.QueryBuilder<_i5.TransactionNote, _i5.TransactionNote,
          _i2.QAfterWhereClause>);
  @override
  _i4.Future<void> putTransactionNote(_i5.TransactionNote? transactionNote) =>
      (super.noSuchMethod(
        Invocation.method(
          #putTransactionNote,
          [transactionNote],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> putTransactionNotes(
          List<_i5.TransactionNote>? transactionNotes) =>
      (super.noSuchMethod(
        Invocation.method(
          #putTransactionNotes,
          [transactionNotes],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> deleteWalletBlockchainData(String? walletId) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteWalletBlockchainData,
          [walletId],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> addNewTransactionData(
    List<
            _i6.Tuple4<_i5.Transaction, List<_i5.Output>, List<_i5.Input>,
                _i5.Address?>>?
        transactionsData,
    String? walletId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addNewTransactionData,
          [
            transactionsData,
            walletId,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}
