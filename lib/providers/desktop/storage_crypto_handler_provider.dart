import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackwallet/utilities/desktop_password_service.dart';

final storageCryptoHandlerProvider = Provider<DPS>((ref) => DPS());
