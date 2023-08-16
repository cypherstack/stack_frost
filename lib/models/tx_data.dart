import 'package:stackfrost/models/isar/models/blockchain_data/utxo.dart';
import 'package:stackfrost/utilities/amount/amount.dart';
import 'package:stackfrost/utilities/enums/fee_rate_type_enum.dart';

class TxData {
  final FeeRateType? feeRateType;
  final int? feeRateAmount;
  final int? satsPerVByte;

  final Amount? fee;
  final int? vSize;

  final String? raw;

  final String? txid;
  final String? txHash;

  final String? note;
  final String? noteOnChain;

  final List<({String address, Amount amount})>? recipients;
  final Set<UTXO>? utxos;

  TxData({
    this.feeRateType,
    this.feeRateAmount,
    this.satsPerVByte,
    this.fee,
    this.vSize,
    this.raw,
    this.txid,
    this.txHash,
    this.note,
    this.noteOnChain,
    this.recipients,
    this.utxos,
  });

  Amount? get amount => recipients != null && recipients!.isNotEmpty
      ? recipients!
          .map((e) => e.amount)
          .reduce((total, amount) => total += amount)
      : null;

  int? get estimatedSatsPerVByte => fee != null && vSize != null
      ? (fee!.raw ~/ BigInt.from(vSize!)).toInt()
      : null;

  TxData copyWith({
    FeeRateType? feeRateType,
    int? feeRateAmount,
    int? satsPerVByte,
    Amount? fee,
    int? vSize,
    String? raw,
    String? txid,
    String? txHash,
    String? note,
    String? noteOnChain,
    Set<UTXO>? utxos,
    List<({String address, Amount amount})>? recipients,
  }) {
    return TxData(
      feeRateType: feeRateType ?? this.feeRateType,
      feeRateAmount: feeRateAmount ?? this.feeRateAmount,
      satsPerVByte: satsPerVByte ?? this.satsPerVByte,
      fee: fee ?? this.fee,
      vSize: vSize ?? this.vSize,
      raw: raw ?? this.raw,
      txid: txid ?? this.txid,
      txHash: txHash ?? this.txHash,
      note: note ?? this.note,
      noteOnChain: noteOnChain ?? this.noteOnChain,
      utxos: utxos ?? this.utxos,
      recipients: recipients ?? this.recipients,
    );
  }
}
