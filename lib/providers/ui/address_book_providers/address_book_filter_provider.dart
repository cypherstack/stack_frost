/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackfrost/models/address_book_filter.dart';

final addressBookFilterProvider =
    ChangeNotifierProvider<AddressBookFilter>((ref) => AddressBookFilter({}));
