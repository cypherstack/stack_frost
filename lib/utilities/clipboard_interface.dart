/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter/services.dart';

abstract class ClipboardInterface {
  Future<void> setData(ClipboardData data);
  Future<ClipboardData?> getData(String format);
}

class ClipboardWrapper implements ClipboardInterface {
  const ClipboardWrapper();

  @override
  Future<ClipboardData?> getData(String format) {
    return Clipboard.getData(format);
  }

  @override
  Future<void> setData(ClipboardData data) async {
    await Clipboard.setData(data);
  }
}

class FakeClipboard implements ClipboardInterface {
  String? _value;

  @override
  Future<ClipboardData?> getData(String format) async {
    return _value == null ? null : ClipboardData(text: _value!);
  }

  @override
  Future<void> setData(ClipboardData data) async {
    _value = data.text;
  }
}
