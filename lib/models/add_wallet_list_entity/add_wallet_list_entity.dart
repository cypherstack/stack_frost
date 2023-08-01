/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:equatable/equatable.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';

abstract class AddWalletListEntity extends Equatable {
  Coin get coin;
  String get name;
  String get ticker;
}
