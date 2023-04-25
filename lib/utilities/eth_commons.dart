import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:decimal/decimal.dart';
import "package:hex/hex.dart";
import 'package:stackwallet/utilities/amount/amount.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';

class GasTracker {
  final Decimal average;
  final Decimal fast;
  final Decimal slow;

  final int numberOfBlocksFast;
  final int numberOfBlocksAverage;
  final int numberOfBlocksSlow;

  final String lastBlock;

  const GasTracker({
    required this.average,
    required this.fast,
    required this.slow,
    required this.numberOfBlocksFast,
    required this.numberOfBlocksAverage,
    required this.numberOfBlocksSlow,
    required this.lastBlock,
  });

  factory GasTracker.fromJson(Map<String, dynamic> json) {
    final targetTime = Constants.targetBlockTimeInSeconds(Coin.ethereum);
    return GasTracker(
      fast: Decimal.parse(json["FastGasPrice"].toString()),
      average: Decimal.parse(json["ProposeGasPrice"].toString()),
      slow: Decimal.parse(json["SafeGasPrice"].toString()),
      // TODO fix hardcoded
      numberOfBlocksFast: 30 ~/ targetTime,
      numberOfBlocksAverage: 180 ~/ targetTime,
      numberOfBlocksSlow: 240 ~/ targetTime,
      lastBlock: json["LastBlock"] as String,
    );
  }
}

const hdPathEthereum = "m/44'/60'/0'/0";

// equal to "0x${keccak256("Transfer(address,address,uint256)".toUint8ListFromUtf8).toHex}";
const kTransferEventSignature =
    "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef";

String getPrivateKey(String mnemonic, String mnemonicPassphrase) {
  final isValidMnemonic = bip39.validateMnemonic(mnemonic);
  if (!isValidMnemonic) {
    throw 'Invalid mnemonic';
  }

  final seed = bip39.mnemonicToSeed(mnemonic, passphrase: mnemonicPassphrase);
  final root = bip32.BIP32.fromSeed(seed);
  const index = 0;
  final addressAtIndex = root.derivePath("$hdPathEthereum/$index");

  return HEX.encode(addressAtIndex.privateKey as List<int>);
}

Amount estimateFee(int feeRate, int gasLimit, int decimals) {
  final gweiAmount = feeRate.toDecimal() / (Decimal.ten.pow(9).toDecimal());
  final fee = gasLimit.toDecimal() *
      gweiAmount.toDecimal(
        scaleOnInfinitePrecision: Coin.ethereum.decimals,
      );

  //Convert gwei to ETH
  final feeInWei = fee * Decimal.ten.pow(9).toDecimal();
  final ethAmount = feeInWei / Decimal.ten.pow(decimals).toDecimal();
  return Amount.fromDecimal(
    ethAmount.toDecimal(
      scaleOnInfinitePrecision: Coin.ethereum.decimals,
    ),
    fractionDigits: decimals,
  );
}
