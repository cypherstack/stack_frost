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
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/themes/theme_service.dart';
import 'package:stackfrost/utilities/assets.dart';
import 'package:stackfrost/utilities/logger.dart';
import 'package:stackfrost/utilities/show_loading.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/utilities/util.dart';
import 'package:stackfrost/widgets/desktop/primary_button.dart';
import 'package:stackfrost/widgets/desktop/secondary_button.dart';
import 'package:stackfrost/widgets/stack_dialog.dart';

class InstallThemeFromFileDialog extends ConsumerStatefulWidget {
  const InstallThemeFromFileDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<InstallThemeFromFileDialog> createState() =>
      _InstallThemeFromFileDialogState();
}

class _InstallThemeFromFileDialogState
    extends ConsumerState<InstallThemeFromFileDialog> {
  late final TextEditingController controller;

  Future<bool> _install() async {
    try {
      final timedFuture = Future<void>.delayed(const Duration(seconds: 2));
      final installFuture = File(controller.text).readAsBytes().then(
            (fileBytes) => ref.read(pThemeService).install(
                  themeArchiveData: fileBytes,
                ),
          );

      // wait for at least 2 seconds to prevent annoying screen flashing
      await Future.wait([
        installFuture,
        timedFuture,
      ]);
      return true;
    } catch (e, s) {
      Logging.instance.log(
        "Failed to install theme: $e\n$s",
        level: LogLevel.Warning,
      );
      return false;
    }
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: "Choose theme file",
        type: FileType.custom,
        allowedExtensions: ["zip"],
        lockParentWindow: true, // windows only
      );

      if (result != null && mounted) {
        setState(() {
          controller.text = result.paths.first ?? "";
        });
      }
    } catch (e, s) {
      Logging.instance.log("$e\n$s", level: LogLevel.Error);
    }
  }

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StackDialogBase(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Install theme file",
            style: STextStyles.pageTitleH2(context),
          ),
          const SizedBox(
            height: 12,
          ),
          TextField(
            autocorrect: Util.isDesktop ? false : true,
            enableSuggestions: Util.isDesktop ? false : true,
            onTap: _pickFile,
            controller: controller,
            style: STextStyles.field(context),
            decoration: InputDecoration(
              hintText: "Choose file...",
              hintStyle: STextStyles.fieldLabel(context),
              suffixIcon: UnconstrainedBox(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    SvgPicture.asset(
                      Assets.svg.folder,
                      color:
                          Theme.of(context).extension<StackColors>()!.textDark3,
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                  ],
                ),
              ),
            ),
            readOnly: true,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: "Cancel",
                  onPressed: Navigator.of(context).pop,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: PrimaryButton(
                  label: "Install",
                  enabled: controller.text.isNotEmpty,
                  onPressed: () async {
                    final result = await showLoading(
                      whileFuture: _install(),
                      context: context,
                      message: "Installing ${controller.text}...",
                    );
                    if (mounted) {
                      Navigator.of(context).pop();
                      if (!result!) {
                        unawaited(
                          showDialog(
                            context: context,
                            builder: (_) => StackOkDialog(
                              title: "Failed to install theme:",
                              message: controller.text,
                            ),
                          ),
                        );
                      } else {
                        unawaited(
                          showDialog(
                            context: context,
                            builder: (_) => const StackOkDialog(
                              title: "Theme install succeeded!",
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
