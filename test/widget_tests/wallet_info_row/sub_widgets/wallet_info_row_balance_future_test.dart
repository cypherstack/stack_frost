import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stackfrost/models/balance.dart';
import 'package:stackfrost/models/isar/stack_theme.dart';
import 'package:stackfrost/providers/providers.dart';
import 'package:stackfrost/services/coins/bitcoin/bitcoin_wallet.dart';
import 'package:stackfrost/services/coins/coin_service.dart';
import 'package:stackfrost/services/coins/manager.dart';
import 'package:stackfrost/services/node_service.dart';
import 'package:stackfrost/services/wallets.dart';
import 'package:stackfrost/services/wallets_service.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/amount/amount.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';
import 'package:stackfrost/widgets/wallet_info_row/sub_widgets/wallet_info_row_balance.dart';

import '../../../sample_data/theme_json.dart';
import 'wallet_info_row_balance_future_test.mocks.dart';

@GenerateMocks([
  Wallets,
  WalletsService,
  BitcoinWallet
], customMocks: [
  MockSpec<NodeService>(returnNullOnMissingStub: true),
  MockSpec<Manager>(returnNullOnMissingStub: true),
  MockSpec<CoinServiceAPI>(returnNullOnMissingStub: true),
  // MockSpec<WalletsService>(returnNullOnMissingStub: true),
])
void main() {
  testWidgets("Test wallet info row balance loads correctly",
      (widgetTester) async {
    final wallets = MockWallets();
    final CoinServiceAPI wallet = MockBitcoinWallet();
    when(wallet.coin).thenAnswer((_) => Coin.bitcoin);
    when(wallet.walletName).thenAnswer((_) => "some wallet");
    when(wallet.walletId).thenAnswer((_) => "some-wallet-id");
    when(wallet.balance).thenAnswer(
      (_) => Balance(
        total: Amount.zero,
        spendable: Amount.zero,
        blockedTotal: Amount.zero,
        pendingSpendable: Amount.zero,
      ),
    );

    final manager = Manager(wallet);
    when(wallets.getManagerProvider("some-wallet-id")).thenAnswer(
        (realInvocation) => ChangeNotifierProvider((ref) => manager));

    const walletInfoRowBalance =
        WalletInfoRowBalance(walletId: "some-wallet-id");
    await widgetTester.pumpWidget(
      ProviderScope(
        overrides: [
          walletsChangeNotifierProvider.overrideWithValue(wallets),
        ],
        child: MaterialApp(
          theme: ThemeData(
            extensions: [
              StackColors.fromStackColorTheme(
                StackTheme.fromJson(
                  json: lightThemeJsonMap,
                ),
              ),
            ],
          ),
          home: const Material(
            child: walletInfoRowBalance,
          ),
        ),
      ),
    );
    //
    // expect(find.text("some wallet"), findsOneWidget);

    await widgetTester.pumpAndSettle();

    expect(find.byType(WalletInfoRowBalance), findsOneWidget);
  });
}
