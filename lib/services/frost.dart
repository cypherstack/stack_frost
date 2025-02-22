import 'dart:ffi';
import 'dart:typed_data';

import 'package:frostdart/frostdart.dart';
import 'package:frostdart/frostdart_bindings_generated.dart';
import 'package:frostdart/output.dart';
import 'package:frostdart/util.dart';
import 'package:stackfrost/models/isar/models/isar_models.dart' as isar_models;
import 'package:stackfrost/utilities/amount/amount.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';
import 'package:stackfrost/utilities/format.dart';
import 'package:stackfrost/utilities/logger.dart';

abstract class Frost {
  //==================== utility ===============================================
  static List<String> getParticipants({
    required String multisigConfig,
  }) {
    try {
      final numberOfParticipants = multisigParticipants(
        multisigConfig: multisigConfig,
      );

      final List<String> participants = [];
      for (int i = 0; i < numberOfParticipants; i++) {
        participants.add(
          multisigParticipant(
            multisigConfig: multisigConfig,
            index: i,
          ),
        );
      }

      return participants;
    } catch (e, s) {
      Logging.instance.log(
        "getParticipants failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
  }

  static bool validateEncodedMultisigConfig({required String encodedConfig}) {
    try {
      decodeMultisigConfig(multisigConfig: encodedConfig);
      return true;
    } catch (e, s) {
      Logging.instance.log(
        "validateEncodedMultisigConfig failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      return false;
    }
  }

  static int getThreshold({
    required String multisigConfig,
  }) {
    try {
      final threshold = multisigThreshold(
        multisigConfig: multisigConfig,
      );

      return threshold;
    } catch (e, s) {
      Logging.instance.log(
        "getThreshold failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
  }

  static ({
    List<({String address, Amount amount})> recipients,
    String changeAddress,
    int feePerWeight,
    List<Output> inputs,
  }) extractDataFromSignConfig({
    required String signConfig,
    required Coin coin,
  }) {
    try {
      final network = coin.isTestNet ? Network.Testnet : Network.Mainnet;
      final signConfigPointer = decodedSignConfig(
        encodedConfig: signConfig,
        network: network,
      );

      // get various data from config
      final feePerWeight =
          signFeePerWeight(signConfigPointer: signConfigPointer);
      final changeAddress = signChange(signConfigPointer: signConfigPointer);
      final recipientsCount = signPayments(
        signConfigPointer: signConfigPointer,
      );

      // get tx recipient info
      final List<({String address, Amount amount})> recipients = [];
      for (int i = 0; i < recipientsCount; i++) {
        final String address = signPaymentAddress(
          signConfigPointer: signConfigPointer,
          index: i,
        );
        final int amount = signPaymentAmount(
          signConfigPointer: signConfigPointer,
          index: i,
        );
        recipients.add(
          (
            address: address,
            amount: Amount(
              rawValue: BigInt.from(amount),
              fractionDigits: coin.decimals,
            ),
          ),
        );
      }

      // get utxos
      final count = signInputs(signConfigPointer: signConfigPointer);
      final List<Output> outputs = [];
      for (int i = 0; i < count; i++) {
        final output = signInput(
          signConfig: signConfig,
          index: i,
          network: network,
        );

        outputs.add(output);
      }

      return (
        recipients: recipients,
        changeAddress: changeAddress,
        feePerWeight: feePerWeight,
        inputs: outputs,
      );
    } catch (e, s) {
      Logging.instance.log(
        "extractDataFromSignConfig failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
  }

  //==================== wallet creation =======================================

  static String createMultisigConfig({
    required String name,
    required int threshold,
    required List<String> participants,
  }) {
    try {
      final config = newMultisigConfig(
        name: name,
        threshold: threshold,
        participants: participants,
      );

      return config;
    } catch (e, s) {
      Logging.instance.log(
        "createMultisigConfig failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
  }

  static ({
    String seed,
    String commitments,
    Pointer<MultisigConfigWithName> multisigConfigWithNamePtr,
    Pointer<SecretShareMachineWrapper> secretShareMachineWrapperPtr,
  }) startKeyGeneration({
    required String multisigConfig,
    required String myName,
  }) {
    try {
      final startKeyGenResPtr = startKeyGen(
        multisigConfig: multisigConfig,
        myName: myName,
        language: Language.english,
      );

      final seed = startKeyGenResPtr.ref.seed.toDartString();
      final commitments = startKeyGenResPtr.ref.commitments.toDartString();
      final configWithNamePtr = startKeyGenResPtr.ref.config;
      final machinePtr = startKeyGenResPtr.ref.machine;

      return (
        seed: seed,
        commitments: commitments,
        multisigConfigWithNamePtr: configWithNamePtr,
        secretShareMachineWrapperPtr: machinePtr,
      );
    } catch (e, s) {
      Logging.instance.log(
        "startKeyGeneration failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
  }

  static ({
    String share,
    Pointer<SecretSharesRes> secretSharesResPtr,
  }) generateSecretShares({
    required Pointer<MultisigConfigWithName> multisigConfigWithNamePtr,
    required String mySeed,
    required Pointer<SecretShareMachineWrapper> secretShareMachineWrapperPtr,
    required List<String> commitments,
  }) {
    try {
      final secretSharesResPtr = getSecretShares(
        multisigConfigWithName: multisigConfigWithNamePtr,
        seed: mySeed,
        language: Language.english,
        machine: secretShareMachineWrapperPtr,
        commitments: commitments,
      );

      final share = secretSharesResPtr.ref.shares.toDartString();

      return (share: share, secretSharesResPtr: secretSharesResPtr);
    } catch (e, s) {
      Logging.instance.log(
        "generateSecretShares failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
  }

  static ({
    Uint8List multisigId,
    String recoveryString,
    String serializedKeys,
  }) completeKeyGeneration({
    required Pointer<MultisigConfigWithName> multisigConfigWithNamePtr,
    required Pointer<SecretSharesRes> secretSharesResPtr,
    required List<String> shares,
  }) {
    try {
      final keyGenResPtr = completeKeyGen(
        multisigConfigWithName: multisigConfigWithNamePtr,
        machineAndCommitments: secretSharesResPtr,
        shares: shares,
      );

      final id = Uint8List.fromList(
        List<int>.generate(
          MULTISIG_ID_LENGTH,
          (index) => keyGenResPtr.ref.multisig_id[index],
        ),
      );

      final recoveryString = keyGenResPtr.ref.recovery.toDartString();

      final serializedKeys = serializeKeys(keys: keyGenResPtr.ref.keys);

      return (
        multisigId: id,
        recoveryString: recoveryString,
        serializedKeys: serializedKeys,
      );
    } catch (e, s) {
      Logging.instance.log(
        "completeKeyGeneration failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
  }

  //=================== transaction creation ===================================

  static String createSignConfig({
    required int network,
    required List<({isar_models.UTXO utxo, Uint8List scriptPubKey})> inputs,
    required List<({String address, Amount amount})> outputs,
    required String changeAddress,
    required int feePerWeight,
  }) {
    try {
      final signConfig = newSignConfig(
        network: network,
        outputs: inputs
            .map(
              (e) => Output(
                hash: Format.stringToUint8List(e.utxo.txid),
                vout: e.utxo.vout,
                value: e.utxo.value,
                scriptPubKey: e.scriptPubKey,
              ),
            )
            .toList(),
        paymentAddresses: outputs.map((e) => e.address).toList(),
        paymentAmounts: outputs.map((e) => e.amount.raw.toInt()).toList(),
        change: changeAddress,
        feePerWeight: feePerWeight,
      );

      return signConfig;
    } catch (e, s) {
      Logging.instance.log(
        "createSignConfig failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
  }

  static ({
    Pointer<TransactionSignMachineWrapper> machinePtr,
    String preprocess,
  }) attemptSignConfig({
    required int network,
    required String config,
    required String serializedKeys,
  }) {
    try {
      final keys = deserializeKeys(keys: serializedKeys);

      final attemptSignRes = attemptSign(
        thresholdKeysWrapperPointer: keys,
        network: network,
        signConfig: config,
      );

      return (
        preprocess: attemptSignRes.ref.preprocess.toDartString(),
        machinePtr: attemptSignRes.ref.machine,
      );
    } catch (e, s) {
      Logging.instance.log(
        "attemptSignConfig failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
  }

  static ({
    Pointer<TransactionSignatureMachineWrapper> machinePtr,
    String share,
  }) continueSigning({
    required Pointer<TransactionSignMachineWrapper> machinePtr,
    required List<String> preprocesses,
  }) {
    try {
      final continueSignRes = continueSign(
        machine: machinePtr,
        preprocesses: preprocesses,
      );

      return (
        share: continueSignRes.ref.preprocess.toDartString(),
        machinePtr: continueSignRes.ref.machine,
      );
    } catch (e, s) {
      Logging.instance.log(
        "continueSigning failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
  }

  static String completeSigning({
    required Pointer<TransactionSignatureMachineWrapper> machinePtr,
    required List<String> shares,
  }) {
    try {
      final rawTransaction = completeSign(
        machine: machinePtr,
        shares: shares,
      );

      return rawTransaction;
    } catch (e, s) {
      Logging.instance.log(
        "completeSigning failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
  }

  static Pointer<SignConfig> decodedSignConfig({
    required String encodedConfig,
    required int network,
  }) {
    try {
      final configPtr =
          decodeSignConfig(encodedSignConfig: encodedConfig, network: network);
      return configPtr;
    } catch (e, s) {
      Logging.instance.log(
        "decodedSignConfig failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
  }

  //========================== resharing =======================================

  static String createResharerConfig({
    required int newThreshold,
    required List<int> resharers,
    required List<String> newParticipants,
  }) {
    try {
      final config = newResharerConfig(
        newThreshold: newThreshold,
        newParticipants: newParticipants,
        resharers: resharers,
      );

      return config;
    } catch (e, s) {
      Logging.instance.log(
        "createResharerConfig failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
  }

  static ({
    String resharerStart,
    Pointer<StartResharerRes> machine,
  }) beginResharer({
    required String serializedKeys,
    required String config,
  }) {
    try {
      final result = startResharer(
        serializedKeys: serializedKeys,
        config: config,
      );

      return (
        resharerStart: result.encoded,
        machine: result.machine,
      );
    } catch (e, s) {
      Logging.instance.log(
        "beginResharer failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
  }

  /// expects [resharerStarts] of length equal to resharers.
  static ({
    String resharedStart,
    Pointer<StartResharedRes> prior,
  }) beginReshared({
    required String myName,
    required String resharerConfig,
    required List<String> resharerStarts,
  }) {
    try {
      final result = startReshared(
        newMultisigName: 'unused_property',
        myName: myName,
        resharerConfig: resharerConfig,
        resharerStarts: resharerStarts,
      );
      return (
        resharedStart: result.encoded,
        prior: result.machine,
      );
    } catch (e, s) {
      Logging.instance.log(
        "beginReshared failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
  }

  /// expects [encryptionKeysOfResharedTo] of length equal to new participants
  static String finishResharer({
    required StartResharerRes machine,
    required List<String> encryptionKeysOfResharedTo,
  }) {
    try {
      final result = completeResharer(
        machine: machine,
        encryptionKeysOfResharedTo: encryptionKeysOfResharedTo,
      );
      return result;
    } catch (e, s) {
      Logging.instance.log(
        "finishResharer failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
  }

  /// expects [resharerCompletes] of length equal to resharers
  static ({
    String multisigConfig,
    String serializedKeys,
    String resharedId,
  }) finishReshared({
    required StartResharedRes prior,
    required List<String> resharerCompletes,
  }) {
    try {
      final result = completeReshared(
        prior: prior,
        resharerCompletes: resharerCompletes,
      );
      return result;
    } catch (e, s) {
      Logging.instance.log(
        "finishReshared failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
  }

  static Pointer<ResharerConfig> decodedResharerConfig({
    required String resharerConfig,
  }) {
    try {
      final config = decodeResharerConfig(resharerConfig: resharerConfig);

      return config;
    } catch (e, s) {
      Logging.instance.log(
        "decodedResharerConfig failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
  }

  static ({
    int newThreshold,
    List<int> resharers,
    List<String> newParticipants,
  }) extractResharerConfigData({
    required String resharerConfig,
  }) {
    try {
      final newThreshold = resharerNewThreshold(
        resharerConfigPointer: decodedResharerConfig(
          resharerConfig: resharerConfig,
        ),
      );

      final resharersCount = resharerResharers(
        resharerConfigPointer: decodedResharerConfig(
          resharerConfig: resharerConfig,
        ),
      );
      final List<int> resharers = [];
      for (int i = 0; i < resharersCount; i++) {
        resharers.add(
          resharerResharer(
            resharerConfigPointer: decodedResharerConfig(
              resharerConfig: resharerConfig,
            ),
            index: i,
          ),
        );
      }

      final newParticipantsCount = resharerNewParticipants(
        resharerConfigPointer: decodedResharerConfig(
          resharerConfig: resharerConfig,
        ),
      );
      final List<String> newParticipants = [];
      for (int i = 0; i < newParticipantsCount; i++) {
        newParticipants.add(
          resharerNewParticipant(
            resharerConfigPointer: decodedResharerConfig(
              resharerConfig: resharerConfig,
            ),
            index: i,
          ),
        );
      }

      return (
        newThreshold: newThreshold,
        resharers: resharers,
        newParticipants: newParticipants,
      );
    } catch (e, s) {
      Logging.instance.log(
        "extractResharerConfigData failed: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
  }
}
