import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart' as flushRoute;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/enums/flush_bar_type.dart';
import 'package:stackwallet/utilities/theme/stack_theme.dart';

Future<dynamic> showFloatingFlushBar({
  required FlushBarType type,
  required String message,
  String? iconAsset,
  required BuildContext context,
  Duration? duration = const Duration(milliseconds: 1500),
  FlushbarPosition flushbarPosition = FlushbarPosition.TOP,
  VoidCallback? onTap,
}) {
  Color bg;
  Color fg;
  switch (type) {
    case FlushBarType.success:
      fg = StackTheme.instance.color.snackBarTextSuccess;
      bg = StackTheme.instance.color.snackBarBackSuccess;
      break;
    case FlushBarType.info:
      fg = StackTheme.instance.color.snackBarTextInfo;
      bg = StackTheme.instance.color.snackBarBackInfo;
      break;
    case FlushBarType.warning:
      fg = StackTheme.instance.color.snackBarTextError;
      bg = StackTheme.instance.color.snackBarBackError;
      break;
  }
  final bar = Flushbar<dynamic>(
    onTap: (_) {
      onTap?.call();
    },
    icon: iconAsset != null
        ? SvgPicture.asset(
            iconAsset,
            height: 16,
            width: 16,
            color: fg,
          )
        : null,
    message: message,
    messageColor: fg,
    flushbarPosition: flushbarPosition,
    backgroundColor: bg,
    duration: duration,
    flushbarStyle: FlushbarStyle.FLOATING,
    borderRadius: BorderRadius.circular(
      Constants.size.circularBorderRadius,
    ),
    margin: const EdgeInsets.all(20),
    maxWidth: 550,
  );

  final _route = flushRoute.showFlushbar<dynamic>(
    context: context,
    flushbar: bar,
  );

  return Navigator.of(context, rootNavigator: true).push(_route);
}
