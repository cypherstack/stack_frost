/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:stackfrost/db/isar/main_db.dart';

mixin WalletDB {
  MainDB? _db;
  MainDB get db => _db!;

  void initWalletDB({MainDB? mockableOverride}) async {
    _db = mockableOverride ?? MainDB.instance;
  }
}
