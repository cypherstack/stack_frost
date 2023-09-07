import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frostdart/frostdart_bindings_generated.dart';
import 'package:stackfrost/models/tx_data.dart';
import 'package:stackfrost/services/coins/bitcoin/frost_wallet.dart';
import 'package:stackfrost/services/frost.dart';

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
final pFrostResharingData = Provider((ref) => _ResharingData());

class _ResharingData {
  String? myName;

  // resharer encoded config string
  String? resharerConfig;
  ({
    int newThreshold,
    List<int> resharers,
    List<String> newParticipants,
  })? get configData => resharerConfig != null
      ? Frost.extractResharerConfigData(resharerConfig: resharerConfig!)
      : null;

  // resharer start string (for sharing) and machine
  ({
    String resharerStart,
    Pointer<StartResharerRes> machine,
  })? startResharerData;

  // reshared start string (for sharing) and machine
  ({
    String resharedStart,
    Pointer<StartResharedRes> prior,
  })? startResharedData;

  // resharer complete string (for sharing)
  String? resharerComplete;

  // new keys and config with an ID
  ({
    String multisigConfig,
    String serializedKeys,
    String resharedId,
  })? newWalletData;

  /// Incomplete wallet which must only be used by new participants added to wallet
  FrostWallet? incompleteWallet;

  // reset/clear all data
  void reset() {
    resharerConfig = null;
    startResharerData = null;
    startResharedData = null;
    resharerComplete = null;
    newWalletData = null;
    incompleteWallet = null;
  }
}
