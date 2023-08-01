/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:stackfrost/utilities/enums/coin_enum.dart';
import 'package:stackfrost/utilities/logger.dart';

enum NodeConnectionStatus { disconnected, connected }

class NodeConnectionStatusChangedEvent {
  NodeConnectionStatus newStatus;
  String walletId;
  Coin coin;

  NodeConnectionStatusChangedEvent(this.newStatus, this.walletId, this.coin) {
    Logging.instance.log(
        "NodeConnectionStatusChangedEvent fired in $walletId with arg newStatus = $newStatus",
        level: LogLevel.Info);
  }
}
