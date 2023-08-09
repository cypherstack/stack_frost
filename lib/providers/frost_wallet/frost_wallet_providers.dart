import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frostdart/frostdart_bindings_generated.dart';

final pCurrentMultisigConfig = StateProvider<String?>((ref) => null);

final pStartKeyGenData = StateProvider<
    ({
      String seed,
      String commitments,
      Pointer<MultisigConfigWithName> multisigConfigWithNamePtr,
      Pointer<SecretShareMachineWrapper> secretShareMachineWrapperPtr,
    })?>((_) => null);
