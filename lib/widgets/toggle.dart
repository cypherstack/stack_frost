/* 
 * This file is part of Stack Wallet.
 * 
 * Copyright (c) 2023 Cypher Stack
 * All Rights Reserved.
 * The code is distributed under GPLv3 license, see LICENSE file for details.
 * Generated by Cypher Stack on 2023-05-26
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/utilities/util.dart';

class Toggle extends StatefulWidget {
  const Toggle({
    Key? key,
    this.onIcon,
    this.onText,
    this.offIcon,
    this.offText,
    this.onValueChanged,
    required this.isOn,
    // this.enabled = true,
    this.controller,
    required this.onColor,
    required this.offColor,
    this.decoration,
  }) : super(key: key);

  final String? onIcon;
  final String? onText;
  final String? offIcon;
  final String? offText;
  final void Function(bool)? onValueChanged;
  final bool isOn;
  // final bool enabled;
  final DSBController? controller;

  final Color onColor;
  final Color offColor;
  final BoxDecoration? decoration;

  @override
  ToggleState createState() => ToggleState();
}

class ToggleState extends State<Toggle> {
  late final BoxDecoration? decoration;
  late final Color onColor;
  late final Color offColor;
  late final DSBController? controller;

  final bool isDesktop = Util.isDesktop;

  late bool _isOn;
  bool get isOn => _isOn;

  // late bool _enabled;

  late ValueNotifier<double> valueListener;

  final tapAnimationDuration = const Duration(milliseconds: 150);
  bool _isDragging = false;

  // Color _colorBG(bool isOn, double alpha) {
  //   return Color.alphaBlend(
  //     onColor.withOpacity(alpha),
  //     offColor,
  //   );
  // }

  // Color _colorFG(bool isOn, double alpha) {
  //   return Color.alphaBlend(
  //     onColor.withOpacity(alpha),
  //     offColor,
  //   );
  // }

  @override
  initState() {
    onColor = widget.onColor;
    offColor = widget.offColor;
    decoration = widget.decoration;
    controller = widget.controller;
    _isOn = widget.isOn;
    // _enabled = widget.enabled;
    valueListener = _isOn ? ValueNotifier(1.0) : ValueNotifier(0.0);

    widget.controller?.activate = () {
      _isOn = !_isOn;
      // widget.onValueChanged?.call(_isOn);
      valueListener.value = _isOn ? 1.0 : 0.0;
    };
    super.initState();
  }

  @override
  void dispose() {
    valueListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");

    return GestureDetector(
      onTap: () {
        _isOn = !_isOn;
        widget.onValueChanged?.call(_isOn);
        valueListener.value = _isOn ? 1.0 : 0.0;
        setState(() {});
      },
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Stack(
            children: [
              AnimatedBuilder(
                animation: valueListener,
                builder: (context, child) {
                  return AnimatedContainer(
                    duration: tapAnimationDuration,
                    height: constraint.maxHeight,
                    width: constraint.maxWidth,
                    decoration: decoration?.copyWith(
                      color: offColor,
                    ),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  final handle = GestureDetector(
                    key: const Key("draggableSwitchButtonSwitch"),
                    onHorizontalDragStart: (_) => _isDragging = true,
                    onHorizontalDragUpdate: (details) {
                      valueListener.value = (valueListener.value +
                              details.delta.dx / constraint.maxWidth)
                          .clamp(0.0, 1.0);
                    },
                    onHorizontalDragEnd: (details) {
                      bool oldValue = _isOn;
                      if (valueListener.value > 0.5) {
                        valueListener.value = 1.0;
                        _isOn = true;
                      } else {
                        valueListener.value = 0.0;
                        _isOn = false;
                      }
                      if (_isOn != oldValue) {
                        widget.onValueChanged?.call(_isOn);
                        controller?.isOn = _isOn;
                        setState(() {});
                      }
                      _isDragging = false;
                    },
                    child: AnimatedBuilder(
                      animation: valueListener,
                      builder: (context, child) {
                        return AnimatedContainer(
                          duration: tapAnimationDuration,
                          height: constraint.maxHeight,
                          width: constraint.maxWidth / 2,
                          decoration: decoration?.copyWith(
                            color:
                                onColor, //_colorFG(_isOn, valueListener.value),
                          ),
                        );
                      },
                    ),
                  );
                  return AnimatedBuilder(
                    animation: valueListener,
                    builder: (context, child) {
                      return AnimatedAlign(
                        duration:
                            _isDragging ? Duration.zero : tapAnimationDuration,
                        alignment: Alignment(valueListener.value * 2 - 1, 0.5),
                        child: child,
                      );
                    },
                    child: handle,
                  );
                },
              ),
              IgnorePointer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: constraint.maxWidth / 2,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.onIcon != null)
                              SvgPicture.asset(
                                widget.onIcon ?? "",
                                width: 12,
                                height: 14,
                                color: isDesktop
                                    ? !_isOn
                                        ? Theme.of(context)
                                            .extension<StackColors>()!
                                            .accentColorBlue
                                        : Theme.of(context)
                                            .extension<StackColors>()!
                                            .buttonTextSecondary
                                    : !_isOn
                                        ? Theme.of(context)
                                            .extension<StackColors>()!
                                            .textDark
                                        : Theme.of(context)
                                            .extension<StackColors>()!
                                            .textSubtitle1,
                              ),
                            if (widget.onIcon != null)
                              const SizedBox(
                                width: 5,
                              ),
                            Text(
                              widget.onText ?? "",
                              style: isDesktop
                                  ? STextStyles.desktopTextExtraExtraSmall(
                                          context)
                                      .copyWith(
                                      color: !_isOn
                                          ? Theme.of(context)
                                              .extension<StackColors>()!
                                              .accentColorBlue
                                          : Theme.of(context)
                                              .extension<StackColors>()!
                                              .buttonTextSecondary,
                                    )
                                  : STextStyles.smallMed12(context).copyWith(
                                      color: !_isOn
                                          ? Theme.of(context)
                                              .extension<StackColors>()!
                                              .textDark
                                          : Theme.of(context)
                                              .extension<StackColors>()!
                                              .textSubtitle1,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: constraint.maxWidth / 2,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.offIcon != null)
                              SvgPicture.asset(
                                widget.offIcon ?? "",
                                width: 12,
                                height: 14,
                                color: isDesktop
                                    ? _isOn
                                        ? Theme.of(context)
                                            .extension<StackColors>()!
                                            .accentColorBlue
                                        : Theme.of(context)
                                            .extension<StackColors>()!
                                            .buttonTextSecondary
                                    : _isOn
                                        ? Theme.of(context)
                                            .extension<StackColors>()!
                                            .textDark
                                        : Theme.of(context)
                                            .extension<StackColors>()!
                                            .textSubtitle1,
                              ),
                            if (widget.offIcon != null)
                              const SizedBox(
                                width: 5,
                              ),
                            Text(
                              widget.offText ?? "",
                              style: isDesktop
                                  ? STextStyles.desktopTextExtraExtraSmall(
                                          context)
                                      .copyWith(
                                      color: _isOn
                                          ? Theme.of(context)
                                              .extension<StackColors>()!
                                              .accentColorBlue
                                          : Theme.of(context)
                                              .extension<StackColors>()!
                                              .buttonTextSecondary,
                                    )
                                  : STextStyles.smallMed12(context).copyWith(
                                      color: _isOn
                                          ? Theme.of(context)
                                              .extension<StackColors>()!
                                              .textDark
                                          : Theme.of(context)
                                              .extension<StackColors>()!
                                              .textSubtitle1,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DSBController {
  VoidCallback? activate;
  bool? isOn;
}
