import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frostdart/frostdart_bindings_generated.dart';

// =================== wallet creation =========================================
final pFrostMultisigConfig = StateProvider<String?>((ref) => null);
final pFrostMyName = StateProvider<String?>((ref) => null);

final pFrostStartKeyGenData = StateProvider<
    ({
      String seed,
      String commitments,
      Pointer<MultisigConfigWithName> multisigConfigWithNamePtr,
      Pointer<SecretShareMachineWrapper> secretShareMachineWrapperPtr,
    })?>((_) => null);

final pFrostSecretSharesData = StateProvider<
    ({
      String share,
      Pointer<SecretSharesRes> secretSharesResPtr,
    })?>((ref) => null);

final pFrostCompletedKeyGenData = StateProvider<
    ({
      Uint8List multisigId,
      String recoveryString,
      String serializedKeys,
    })?>((ref) => null);

// ================= transaction creation ======================================
final pFrostSignConfig = StateProvider<String?>((ref) => null);

final pFrostAttemptSignData = StateProvider<
    ({
      Pointer<TransactionSignMachineWrapper> machinePtr,
      String preprocess,
    })?>((ref) => null);

final pFrostContinueSignData = StateProvider<
    ({
      Pointer<TransactionSignatureMachineWrapper> machinePtr,
      String share,
    })?>((ref) => null);

final pFrostCompleteSignRawTx = StateProvider<String?>((ref) => null);
