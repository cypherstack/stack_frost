import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackwallet/models/exchange/exchange_form_state.dart';
import 'package:stackwallet/providers/providers.dart';
import 'package:stackwallet/services/exchange/change_now/change_now_loading_service.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';
import 'package:stackwallet/widgets/stack_dialog.dart';

class HomeViewButtonBar extends ConsumerStatefulWidget {
  const HomeViewButtonBar({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeViewButtonBar> createState() => _HomeViewButtonBarState();
}

class _HomeViewButtonBarState extends ConsumerState<HomeViewButtonBar> {
  final DateTime _lastRefreshed = DateTime.now();
  final Duration _refreshInterval = const Duration(hours: 1);

  @override
  void initState() {
    ref.read(exchangeFormStateProvider).setOnError(
          onError: (String message) => showDialog<dynamic>(
            context: context,
            barrierDismissible: true,
            builder: (_) => StackDialog(
              title: "ChangeNOW API Call Failed",
              message: message,
            ),
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: HomeViewButtonBar");
    final selectedIndex = ref.watch(homeViewPageIndexStateProvider.state).state;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: TextButton(
            style: selectedIndex == 0
                ? Theme.of(context)
                    .extension<StackColors>()!
                    .getPrimaryEnabledButtonColor(context)!
                    .copyWith(
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(46, 36)),
                    )
                : Theme.of(context)
                    .extension<StackColors>()!
                    .getSecondaryEnabledButtonColor(context)!
                    .copyWith(
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(46, 36)),
                    ),
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (selectedIndex != 0) {
                ref.read(homeViewPageIndexStateProvider.state).state = 0;
              }
            },
            child: Text(
              "Wallets",
              style: STextStyles.button(context).copyWith(
                fontSize: 14,
                color: selectedIndex == 0
                    ? Theme.of(context)
                        .extension<StackColors>()!
                        .buttonTextPrimary
                    : Theme.of(context).extension<StackColors>()!.textDark,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: TextButton(
            style: selectedIndex == 1
                ? Theme.of(context)
                    .extension<StackColors>()!
                    .getPrimaryEnabledButtonColor(context)!
                    .copyWith(
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(46, 36)),
                    )
                : Theme.of(context)
                    .extension<StackColors>()!
                    .getSecondaryEnabledButtonColor(context)!
                    .copyWith(
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(46, 36)),
                    ),
            onPressed: () async {
              FocusScope.of(context).unfocus();
              if (selectedIndex != 1) {
                ref.read(homeViewPageIndexStateProvider.state).state = 1;
              }
              DateTime now = DateTime.now();

              if (now.difference(_lastRefreshed) > _refreshInterval) {
                // bool okPressed = false;
                // showDialog<dynamic>(
                //   context: context,
                //   barrierDismissible: false,
                //   builder: (_) => const StackDialog(
                //     // builder: (_) => StackOkDialog(
                //     title: "Refreshing ChangeNOW data",
                //     message: "This may take a while",
                //     // onOkPressed: (value) {
                //     //   if (value == "OK") {
                //     //     okPressed = true;
                //     //   }
                //     // },
                //   ),
                // );
                await ChangeNowLoadingService().loadAll(ref);
                // if (!okPressed && mounted) {
                //   Navigator.of(context).pop();
                // }
              }
            },
            child: Text(
              "Exchange",
              style: STextStyles.button(context).copyWith(
                fontSize: 14,
                color: selectedIndex == 1
                    ? Theme.of(context)
                        .extension<StackColors>()!
                        .buttonTextPrimary
                    : Theme.of(context).extension<StackColors>()!.textDark,
              ),
            ),
          ),
        ),
        // TODO: Do not delete this code.
        // only temporarily disabled
        // SizedBox(
        //   width: 8,
        // ),
        // Expanded(
        //   child: TextButton(
        //     style: ButtonStyle(
        //       minimumSize: MaterialStateProperty.all<Size>(Size(46, 36)),
        //       backgroundColor: MaterialStateProperty.all<Color>(
        //         selectedIndex == 2
        //             ? CFColors.stackAccent
        //             : CFColors.disabledButton,
        //       ),
        //     ),
        //     onPressed: () {
        //       FocusScope.of(context).unfocus();
        //       if (selectedIndex != 2) {
        //         ref.read(homeViewPageIndexStateProvider.state).state = 2;
        //       }
        //     },
        //     child: Text(
        //       "Buy",
        //       style: STextStyles.button(context).copyWith(
        //         fontSize: 14,
        //         color:
        //             selectedIndex == 2 ? CFColors.light1 : Theme.of(context).extension<StackColors>()!.accentColorDark
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
