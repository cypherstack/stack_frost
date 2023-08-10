import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frostdart/frostdart_bindings_generated.dart';

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
