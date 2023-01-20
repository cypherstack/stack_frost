import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackwallet/pages/token_view/sub_widgets/my_token_select_item.dart';

class MyTokensList extends StatelessWidget {
  const MyTokensList({
    Key? key,
    required this.tokens,
    required this.walletAddress,
  }) : super(key: key);

  final List<dynamic> tokens;
  final String walletAddress;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        print("TOKENS LENGTH IS ${tokens.length}");
        return ListView.builder(
          itemCount: tokens.length,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsets.all(4),
              child: MyTokenSelectItem(
                walletAddress: walletAddress,
                tokenData: tokens[index] as Map<String, String>,
              ),
            );
          },
        );
      },
    );
  }
}
