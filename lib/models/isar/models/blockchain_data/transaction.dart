import 'dart:math';

import 'package:isar/isar.dart';
import 'package:stackwallet/models/isar/models/blockchain_data/address.dart';
import 'package:stackwallet/models/isar/models/blockchain_data/input.dart';
import 'package:stackwallet/models/isar/models/blockchain_data/output.dart';
import 'package:tuple/tuple.dart';

part 'transaction.g.dart';

@Collection()
class Transaction {
  Transaction({
    required this.walletId,
    required this.txid,
    required this.timestamp,
    required this.type,
    required this.subType,
    required this.amount,
    required this.fee,
    required this.height,
    required this.isCancelled,
    required this.isLelantus,
    required this.slateId,
    required this.otherData,
    required this.inputs,
    required this.outputs,
  });

  Tuple2<Transaction, Address?> copyWith({
    String? walletId,
    String? txid,
    int? timestamp,
    TransactionType? type,
    TransactionSubType? subType,
    int? amount,
    int? fee,
    int? height,
    bool? isCancelled,
    bool? isLelantus,
    String? slateId,
    String? otherData,
    List<Input>? inputs,
    List<Output>? outputs,
    Id? id,
    Address? address,
  }) {
    return Tuple2(
      Transaction(
          walletId: walletId ?? this.walletId,
          txid: txid ?? this.txid,
          timestamp: timestamp ?? this.timestamp,
          type: type ?? this.type,
          subType: subType ?? this.subType,
          amount: amount ?? this.amount,
          fee: fee ?? this.fee,
          height: height ?? this.height,
          isCancelled: isCancelled ?? this.isCancelled,
          isLelantus: isLelantus ?? this.isLelantus,
          slateId: slateId ?? this.slateId,
          otherData: otherData ?? this.otherData,
          inputs: inputs ?? this.inputs,
          outputs: outputs ?? this.outputs)
        ..id = id ?? this.id,
      address ?? this.address.value,
    );
  }

  Id id = Isar.autoIncrement;

  @Index()
  late final String walletId;

  @Index(unique: true, composite: [CompositeIndex("walletId")])
  late final String txid;

  @Index()
  late final int timestamp;

  @enumerated
  late final TransactionType type;

  @enumerated
  late final TransactionSubType subType;

  late final int amount;

  late final int fee;

  late final int? height;

  late final bool isCancelled;

  late bool? isLelantus;

  late final String? slateId;

  late final String? otherData;

  late final List<Input> inputs;

  late final List<Output> outputs;

  @Backlink(to: "transactions")
  final address = IsarLink<Address>();

  int getConfirmations(int currentChainHeight) {
    if (height == null || height! <= 0) return 0;
    return max(0, currentChainHeight - (height! - 1));
  }

  bool isConfirmed(int currentChainHeight, int minimumConfirms) {
    final confirmations = getConfirmations(currentChainHeight);
    return confirmations >= minimumConfirms;
  }

  @override
  toString() => "{ "
      "id: $id, "
      "walletId: $walletId, "
      "txid: $txid, "
      "timestamp: $timestamp, "
      "type: ${type.name}, "
      "subType: ${subType.name}, "
      "amount: $amount, "
      "fee: $fee, "
      "height: $height, "
      "isCancelled: $isCancelled, "
      "isLelantus: $isLelantus, "
      "slateId: $slateId, "
      "otherData: $otherData, "
      "address: ${address.value}, "
      "inputsLength: ${inputs.length}, "
      "outputsLength: ${outputs.length}, "
      "}";
}

// Used in Isar db and stored there as int indexes so adding/removing values
// in this definition should be done extremely carefully in production
enum TransactionType {
  // TODO: add more types before prod release?
  outgoing,
  incoming,
  sentToSelf, // should we keep this?
  unknown;
}

// Used in Isar db and stored there as int indexes so adding/removing values
// in this definition should be done extremely carefully in production
enum TransactionSubType {
  // TODO: add more types before prod release?
  none,
  bip47Notification, // bip47 payment code notification transaction flag
  mint, // firo specific
  join; // firo specific
}
