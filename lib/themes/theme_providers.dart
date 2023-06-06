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
import 'package:stackwallet/models/isar/stack_theme.dart';
import 'package:stackwallet/themes/stack_colors.dart';
import 'package:stackwallet/themes/theme_service.dart';

final applicationThemesDirectoryPathProvider = StateProvider((ref) => "");

final colorProvider = StateProvider<StackColors>(
  (ref) => StackColors.fromStackColorTheme(
    ref.watch(themeProvider.state).state,
  ),
);

final themeProvider = StateProvider<StackTheme>(
  (ref) => ref.watch(
    pThemeService.select(
      (value) => value.getTheme(
        themeId: "light",
      )!,
    ),
  ),
);

final themeAssetsProvider = StateProvider<IThemeAssets>(
  (ref) => ref.watch(
    themeProvider.select(
      (value) => value.assets,
    ),
  ),
);
