// /*
//  * This file is part of Stack Wallet.
//  *
//  * Copyright (c) 2023 Cypher Stack
//  * All Rights Reserved.
//  * The code is distributed under GPLv3 license, see LICENSE file for details.
//  * Generated by Cypher Stack on 2023-05-26
//  *
//  */
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:stackfrost/providers/providers.dart';
// import 'package:stackfrost/themes/stack_colors.dart';
// import 'package:stackfrost/utilities/text_styles.dart';
//
// class HomeViewButtonBar extends ConsumerStatefulWidget {
//   const HomeViewButtonBar({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<HomeViewButtonBar> createState() => _HomeViewButtonBarState();
// }
//
// class _HomeViewButtonBarState extends ConsumerState<HomeViewButtonBar> {
//   // final DateTime _lastRefreshed = DateTime.now();
//   // final Duration _refreshInterval = const Duration(hours: 1);
//
//   @override
//   void initState() {
//     // ref.read(exchangeFormStateProvider).setOnError(
//     //       onError: (String message) => showDialog<dynamic>(
//     //         context: context,
//     //         barrierDismissible: true,
//     //         builder: (_) => StackDialog(
//     //           title: "Exchange API Call Failed",
//     //           message: message,
//     //         ),
//     //       ),
//     //     );
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //todo: check if print needed
//     // debugPrint("BUILD: HomeViewButtonBar");
//     final selectedIndex = ref.watch(homeViewPageIndexStateProvider.state).state;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Expanded(
//           child: TextButton(
//             style: selectedIndex == 0
//                 ? Theme.of(context)
//                     .extension<StackColors>()!
//                     .getPrimaryEnabledButtonStyle(context)!
//                     .copyWith(
//                       minimumSize:
//                           MaterialStateProperty.all<Size>(const Size(46, 36)),
//                     )
//                 : Theme.of(context)
//                     .extension<StackColors>()!
//                     .getSecondaryEnabledButtonStyle(context)!
//                     .copyWith(
//                       minimumSize:
//                           MaterialStateProperty.all<Size>(const Size(46, 36)),
//                     ),
//             onPressed: () {
//               FocusScope.of(context).unfocus();
//               if (selectedIndex != 0) {
//                 ref.read(homeViewPageIndexStateProvider.state).state = 0;
//               }
//             },
//             child: Text(
//               "Wallets",
//               style: STextStyles.button(context).copyWith(
//                 fontSize: 14,
//                 color: selectedIndex == 0
//                     ? Theme.of(context)
//                         .extension<StackColors>()!
//                         .buttonTextPrimary
//                     : Theme.of(context)
//                         .extension<StackColors>()!
//                         .buttonTextSecondary,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
