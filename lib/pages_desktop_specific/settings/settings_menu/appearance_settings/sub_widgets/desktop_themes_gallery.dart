/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackfrost/pages/settings_views/global_settings_view/appearance_settings/manage_themes.dart';
import 'package:stackfrost/pages/settings_views/global_settings_view/appearance_settings/sub_widgets/stack_theme_card.dart';
import 'package:stackfrost/providers/global/prefs_provider.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/themes/theme_service.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/widgets/desktop/primary_button.dart';
import 'package:stackfrost/widgets/loading_indicator.dart';
import 'package:stackfrost/widgets/rounded_white_container.dart';

class DesktopThemeGallery extends ConsumerStatefulWidget {
  const DesktopThemeGallery({
    Key? key,
    required this.dialogWidth,
  }) : super(key: key);

  final double dialogWidth;

  @override
  ConsumerState<DesktopThemeGallery> createState() =>
      _DesktopThemeGalleryState();
}

class _DesktopThemeGalleryState extends ConsumerState<DesktopThemeGallery> {
  late bool _showThemes;
  Future<List<StackThemeMetaData>> Function() future = () async => [];

  @override
  void initState() {
    _showThemes = ref.read(prefsChangeNotifierProvider).externalCalls;
    if (_showThemes) {
      future = ref.read(pThemeService).fetchThemes;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(
                "Theme Gallery",
                style: STextStyles.desktopTextExtraExtraSmall(context),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SingleChildScrollView(
              child: _showThemes
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder(
                          future: future(),
                          builder: (
                            context,
                            AsyncSnapshot<List<StackThemeMetaData>> snapshot,
                          ) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: snapshot.data!
                                    .map(
                                      (e) => SizedBox(
                                        key: Key(
                                            "_DesktopThemeGalleryState_card_${e.id}_key"),
                                        width:
                                            (widget.dialogWidth - 64 - 32) / 3,
                                        child: StackThemeCard(
                                          data: e,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            } else {
                              return const Center(
                                child: LoadingIndicator(
                                  width: 200,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RoundedWhiteContainer(
                          borderColor: Theme.of(context)
                              .extension<StackColors>()!
                              .textSubtitle6,
                          child: Text(
                            "You are using Incognito Mode."
                            " Please press the button below to load "
                            "available themes from our server or install a "
                            "theme file manually from your computer.",
                            style:
                                STextStyles.desktopTextExtraExtraSmall(context),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PrimaryButton(
                              label: "Load themes",
                              width: 140,
                              buttonHeight: ButtonHeight.s,
                              onPressed: () {
                                setState(() {
                                  _showThemes = true;
                                  future = ref.read(pThemeService).fetchThemes;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        IncognitoInstalledThemes(
                          cardWidth: (widget.dialogWidth - 64 - 32) / 3,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
