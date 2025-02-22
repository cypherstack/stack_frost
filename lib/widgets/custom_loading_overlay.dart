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

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/utilities/util.dart';
import 'package:stackfrost/widgets/conditional_parent.dart';
import 'package:stackfrost/widgets/loading_indicator.dart';

class CustomLoadingOverlay extends ConsumerStatefulWidget {
  const CustomLoadingOverlay({
    Key? key,
    required this.message,
    this.subMessage,
    required this.eventBus,
    this.textColor,
    this.actionButton,
  }) : super(key: key);

  final String message;
  final String? subMessage;
  final EventBus? eventBus;
  final Color? textColor;
  final Widget? actionButton;

  @override
  ConsumerState<CustomLoadingOverlay> createState() =>
      _CustomLoadingOverlayState();
}

class _CustomLoadingOverlayState extends ConsumerState<CustomLoadingOverlay> {
  double _percent = 0;

  late final StreamSubscription<double>? subscription;
  final bool isDesktop = Util.isDesktop;

  @override
  void initState() {
    subscription = widget.eventBus?.on<double>().listen((event) {
      setState(() {
        _percent = event;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ConditionalParent(
        condition: widget.actionButton != null,
        builder: (child) => Stack(
          children: [
            child,
            if (isDesktop)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: 100,
                      child: widget.actionButton!,
                    ),
                  ),
                ],
              ),
            if (!isDesktop)
              Positioned(
                bottom: 1,
                left: 0,
                right: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(child: widget.actionButton!),
                    ],
                  ),
                ),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: STextStyles.pageTitleH2(context).copyWith(
                color: widget.textColor ??
                    Theme.of(context)
                        .extension<StackColors>()!
                        .loadingOverlayTextColor,
              ),
            ),
            if (widget.eventBus != null)
              const SizedBox(
                height: 10,
              ),
            if (widget.eventBus != null)
              Text(
                "${(_percent * 100).toStringAsFixed(2)}%",
                style: STextStyles.pageTitleH2(context).copyWith(
                  color: widget.textColor ??
                      Theme.of(context)
                          .extension<StackColors>()!
                          .loadingOverlayTextColor,
                ),
              ),
            if (widget.subMessage != null)
              const SizedBox(
                height: 10,
              ),
            if (widget.subMessage != null)
              Text(
                widget.subMessage!,
                textAlign: TextAlign.center,
                style: STextStyles.pageTitleH2(context).copyWith(
                  fontSize: 14,
                  color: widget.textColor ??
                      Theme.of(context)
                          .extension<StackColors>()!
                          .loadingOverlayTextColor,
                ),
              ),
            const SizedBox(
              height: 64,
            ),
            const Center(
              child: LoadingIndicator(
                width: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
