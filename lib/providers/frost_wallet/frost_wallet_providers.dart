import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frostdart/frostdart_bindings_generated.dart';
import 'package:stackfrost/models/tx_data.dart';

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
final pFrostTxData = StateProvider<TxData?>((ref) => null);

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

// ===================== shared/util ===========================================
final pFrostSelectParticipantsUnordered =
    StateProvider<List<String>?>((ref) => null);

// ========================= resharing =========================================
final pFrostResharers = Provider<Map<String, int>>((ref) => {});
final pFrostResharerConfig = StateProvider<String?>((ref) => null);

final pFrostResharerData = StateProvider<
    ({
      String resharerStart,
      Pointer<StartResharerRes> machine,
    })?>((ref) => null);

final pFrostResharedData = StateProvider<
    ({
      String resharedStart,
      Pointer<StartResharedRes> prior,
    })?>((ref) => null);

final pFrostResharerComplete = StateProvider<String?>((ref) => null);
