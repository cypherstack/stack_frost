// Mocks generated by Mockito 5.4.2 from annotations
// in stackwallet/test/models/type_adapter_tests/lelantus_coin_adapter_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:convert' as _i5;
import 'dart:typed_data' as _i4;

import 'package:hive/hive.dart' as _i3;
import 'package:hive/src/object/hive_object.dart' as _i1;
import 'package:mockito/mockito.dart' as _i2;

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

class _FakeHiveList_0<E extends _i1.HiveObjectMixin> extends _i2.SmartFake
    implements _i3.HiveList<E> {
  _FakeHiveList_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [BinaryReader].
///
/// See the documentation for Mockito's code generation for more information.
class MockBinaryReader extends _i2.Mock implements _i3.BinaryReader {
  MockBinaryReader() {
    _i2.throwOnMissingStub(this);
  }

  @override
  int get availableBytes => (super.noSuchMethod(
        Invocation.getter(#availableBytes),
        returnValue: 0,
      ) as int);
  @override
  int get usedBytes => (super.noSuchMethod(
        Invocation.getter(#usedBytes),
        returnValue: 0,
      ) as int);
  @override
  void skip(int? bytes) => super.noSuchMethod(
        Invocation.method(
          #skip,
          [bytes],
        ),
        returnValueForMissingStub: null,
      );
  @override
  int readByte() => (super.noSuchMethod(
        Invocation.method(
          #readByte,
          [],
        ),
        returnValue: 0,
      ) as int);
  @override
  _i4.Uint8List viewBytes(int? bytes) => (super.noSuchMethod(
        Invocation.method(
          #viewBytes,
          [bytes],
        ),
        returnValue: _i4.Uint8List(0),
      ) as _i4.Uint8List);
  @override
  _i4.Uint8List peekBytes(int? bytes) => (super.noSuchMethod(
        Invocation.method(
          #peekBytes,
          [bytes],
        ),
        returnValue: _i4.Uint8List(0),
      ) as _i4.Uint8List);
  @override
  int readWord() => (super.noSuchMethod(
        Invocation.method(
          #readWord,
          [],
        ),
        returnValue: 0,
      ) as int);
  @override
  int readInt32() => (super.noSuchMethod(
        Invocation.method(
          #readInt32,
          [],
        ),
        returnValue: 0,
      ) as int);
  @override
  int readUint32() => (super.noSuchMethod(
        Invocation.method(
          #readUint32,
          [],
        ),
        returnValue: 0,
      ) as int);
  @override
  int readInt() => (super.noSuchMethod(
        Invocation.method(
          #readInt,
          [],
        ),
        returnValue: 0,
      ) as int);
  @override
  double readDouble() => (super.noSuchMethod(
        Invocation.method(
          #readDouble,
          [],
        ),
        returnValue: 0.0,
      ) as double);
  @override
  bool readBool() => (super.noSuchMethod(
        Invocation.method(
          #readBool,
          [],
        ),
        returnValue: false,
      ) as bool);
  @override
  String readString([
    int? byteCount,
    _i5.Converter<List<int>, String>? decoder = const _i5.Utf8Decoder(),
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #readString,
          [
            byteCount,
            decoder,
          ],
        ),
        returnValue: '',
      ) as String);
  @override
  _i4.Uint8List readByteList([int? length]) => (super.noSuchMethod(
        Invocation.method(
          #readByteList,
          [length],
        ),
        returnValue: _i4.Uint8List(0),
      ) as _i4.Uint8List);
  @override
  List<int> readIntList([int? length]) => (super.noSuchMethod(
        Invocation.method(
          #readIntList,
          [length],
        ),
        returnValue: <int>[],
      ) as List<int>);
  @override
  List<double> readDoubleList([int? length]) => (super.noSuchMethod(
        Invocation.method(
          #readDoubleList,
          [length],
        ),
        returnValue: <double>[],
      ) as List<double>);
  @override
  List<bool> readBoolList([int? length]) => (super.noSuchMethod(
        Invocation.method(
          #readBoolList,
          [length],
        ),
        returnValue: <bool>[],
      ) as List<bool>);
  @override
  List<String> readStringList([
    int? length,
    _i5.Converter<List<int>, String>? decoder = const _i5.Utf8Decoder(),
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #readStringList,
          [
            length,
            decoder,
          ],
        ),
        returnValue: <String>[],
      ) as List<String>);
  @override
  List<dynamic> readList([int? length]) => (super.noSuchMethod(
        Invocation.method(
          #readList,
          [length],
        ),
        returnValue: <dynamic>[],
      ) as List<dynamic>);
  @override
  Map<dynamic, dynamic> readMap([int? length]) => (super.noSuchMethod(
        Invocation.method(
          #readMap,
          [length],
        ),
        returnValue: <dynamic, dynamic>{},
      ) as Map<dynamic, dynamic>);
  @override
  _i3.HiveList<_i1.HiveObjectMixin> readHiveList([int? length]) =>
      (super.noSuchMethod(
        Invocation.method(
          #readHiveList,
          [length],
        ),
        returnValue: _FakeHiveList_0<_i1.HiveObjectMixin>(
          this,
          Invocation.method(
            #readHiveList,
            [length],
          ),
        ),
      ) as _i3.HiveList<_i1.HiveObjectMixin>);
}

/// A class which mocks [BinaryWriter].
///
/// See the documentation for Mockito's code generation for more information.
class MockBinaryWriter extends _i2.Mock implements _i3.BinaryWriter {
  MockBinaryWriter() {
    _i2.throwOnMissingStub(this);
  }

  @override
  void writeByte(int? byte) => super.noSuchMethod(
        Invocation.method(
          #writeByte,
          [byte],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void writeWord(int? value) => super.noSuchMethod(
        Invocation.method(
          #writeWord,
          [value],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void writeInt32(int? value) => super.noSuchMethod(
        Invocation.method(
          #writeInt32,
          [value],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void writeUint32(int? value) => super.noSuchMethod(
        Invocation.method(
          #writeUint32,
          [value],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void writeInt(int? value) => super.noSuchMethod(
        Invocation.method(
          #writeInt,
          [value],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void writeDouble(double? value) => super.noSuchMethod(
        Invocation.method(
          #writeDouble,
          [value],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void writeBool(bool? value) => super.noSuchMethod(
        Invocation.method(
          #writeBool,
          [value],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void writeString(
    String? value, {
    bool? writeByteCount = true,
    _i5.Converter<String, List<int>>? encoder = const _i5.Utf8Encoder(),
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #writeString,
          [value],
          {
            #writeByteCount: writeByteCount,
            #encoder: encoder,
          },
        ),
        returnValueForMissingStub: null,
      );
  @override
  void writeByteList(
    List<int>? bytes, {
    bool? writeLength = true,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #writeByteList,
          [bytes],
          {#writeLength: writeLength},
        ),
        returnValueForMissingStub: null,
      );
  @override
  void writeIntList(
    List<int>? list, {
    bool? writeLength = true,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #writeIntList,
          [list],
          {#writeLength: writeLength},
        ),
        returnValueForMissingStub: null,
      );
  @override
  void writeDoubleList(
    List<double>? list, {
    bool? writeLength = true,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #writeDoubleList,
          [list],
          {#writeLength: writeLength},
        ),
        returnValueForMissingStub: null,
      );
  @override
  void writeBoolList(
    List<bool>? list, {
    bool? writeLength = true,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #writeBoolList,
          [list],
          {#writeLength: writeLength},
        ),
        returnValueForMissingStub: null,
      );
  @override
  void writeStringList(
    List<String>? list, {
    bool? writeLength = true,
    _i5.Converter<String, List<int>>? encoder = const _i5.Utf8Encoder(),
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #writeStringList,
          [list],
          {
            #writeLength: writeLength,
            #encoder: encoder,
          },
        ),
        returnValueForMissingStub: null,
      );
  @override
  void writeList(
    List<dynamic>? list, {
    bool? writeLength = true,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #writeList,
          [list],
          {#writeLength: writeLength},
        ),
        returnValueForMissingStub: null,
      );
  @override
  void writeMap(
    Map<dynamic, dynamic>? map, {
    bool? writeLength = true,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #writeMap,
          [map],
          {#writeLength: writeLength},
        ),
        returnValueForMissingStub: null,
      );
  @override
  void writeHiveList(
    _i3.HiveList<_i1.HiveObjectMixin>? list, {
    bool? writeLength = true,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #writeHiveList,
          [list],
          {#writeLength: writeLength},
        ),
        returnValueForMissingStub: null,
      );
  @override
  void write<T>(
    T? value, {
    bool? writeTypeId = true,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #write,
          [value],
          {#writeTypeId: writeTypeId},
        ),
        returnValueForMissingStub: null,
      );
}
