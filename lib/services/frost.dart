import 'dart:ffi';
import 'dart:typed_data';

import 'package:frostdart/frostdart.dart';
import 'package:frostdart/frostdart_bindings_generated.dart';
import 'package:frostdart/output.dart';
import 'package:frostdart/util.dart';
import 'package:stackfrost/models/isar/models/isar_models.dart' as isar_models;
import 'package:stackfrost/utilities/amount/amount.dart';
import 'package:stackfrost/utilities/format.dart';
import 'package:stackfrost/utilities/logger.dart';

abstract class Frost {
  //==================== utility ===============================================
  static List<String> getParticipants({
    required String multisigConfig,
  }) {
    try {
      final numberOfParticipants = multisigParticipants(
        multisigConfigPointer: decodeMultisigConfig(
          multisigConfig: multisigConfig,
        ),
      );

      final List<String> participants = [];
      for (int i = 0; i < numberOfParticipants; i++) {
        participants.add(
          multisigParticipant(
            multisigConfigPointer: decodeMultisigConfig(
              multisigConfig: multisigConfig,
            ),
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

  static String getName({
    required String multisigConfig,
  }) {
    try {
      final name = multisigName(
        multisigConfigPointer: decodeMultisigConfig(
          multisigConfig: multisigConfig,
        ),
      );

      return name;
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
        multisigConfigPointer: decodeMultisigConfig(
          multisigConfig: multisigConfig,
        ),
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

  //==================== wallet creation =======================================

  static String createMultisigConfig({
    required String name,
    required int threshold,
    required List<String> participants,
  }) {
    try {
      final configPtr = newMultisigConfig(
        name: name,
        threshold: threshold,
        participants: participants,
      );

      return configPtr.ref.encoded.toDartString();
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
        multisigConfig: decodeMultisigConfig(multisigConfig: multisigConfig),
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
      final signConfigRes = newSignConfig(
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

      return signConfigRes.ref.encoded.toDartString();
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
      final signConfigRes = decodeSignConfig(
        network: network,
        encodedSignConfig: config,
      );

      final keys = deserializeKeys(keys: serializedKeys);

      final attemptSignRes = attemptSign(
        thresholdKeysWrapperPointer: keys,
        signConfigPointer: signConfigRes,
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
}
