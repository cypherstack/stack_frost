// Mocks generated by Mockito 5.3.2 from annotations
// in stackwallet/test/screen_tests/address_book_view/address_book_view_screen_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:ui' as _i5;

import 'package:mockito/mockito.dart' as _i1;
import 'package:stackwallet/models/isar/models/contact_entry.dart' as _i2;
import 'package:stackwallet/services/address_book_service.dart' as _i3;

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

class _FakeContactEntry_0 extends _i1.SmartFake implements _i2.ContactEntry {
  _FakeContactEntry_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [AddressBookService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAddressBookService extends _i1.Mock
    implements _i3.AddressBookService {
  @override
  List<_i2.ContactEntry> get contacts => (super.noSuchMethod(
        Invocation.getter(#contacts),
        returnValue: <_i2.ContactEntry>[],
      ) as List<_i2.ContactEntry>);
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);
  @override
  _i2.ContactEntry getContactById(String? id) => (super.noSuchMethod(
        Invocation.method(
          #getContactById,
          [id],
        ),
        returnValue: _FakeContactEntry_0(
          this,
          Invocation.method(
            #getContactById,
            [id],
          ),
        ),
      ) as _i2.ContactEntry);
  @override
  _i4.Future<List<_i2.ContactEntry>> search(String? text) =>
      (super.noSuchMethod(
        Invocation.method(
          #search,
          [text],
        ),
        returnValue:
            _i4.Future<List<_i2.ContactEntry>>.value(<_i2.ContactEntry>[]),
      ) as _i4.Future<List<_i2.ContactEntry>>);
  @override
  bool matches(
    String? term,
    _i2.ContactEntry? contact,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #matches,
          [
            term,
            contact,
          ],
        ),
        returnValue: false,
      ) as bool);
  @override
  _i4.Future<bool> addContact(_i2.ContactEntry? contact) => (super.noSuchMethod(
        Invocation.method(
          #addContact,
          [contact],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<bool> editContact(_i2.ContactEntry? editedContact) =>
      (super.noSuchMethod(
        Invocation.method(
          #editContact,
          [editedContact],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<void> removeContact(String? id) => (super.noSuchMethod(
        Invocation.method(
          #removeContact,
          [id],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  void addListener(_i5.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i5.VoidCallback? listener) => super.noSuchMethod(
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
