import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:bip39/bip39.dart' as bip39;
import 'package:decimal/decimal.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:ethereum_addresses/ethereum_addresses.dart';
import 'package:flutter/foundation.dart';
import 'package:stackwallet/models/paymint/fee_object_model.dart';
import 'package:stackwallet/models/paymint/transactions_model.dart';
import 'package:stackwallet/models/paymint/utxo_model.dart';
import 'package:stackwallet/services/price.dart';
import 'package:stackwallet/services/transaction_notification_tracker.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';
import 'package:stackwallet/utilities/flutter_secure_storage_interface.dart';
import 'package:stackwallet/utilities/format.dart';
import 'package:stackwallet/utilities/prefs.dart';
import 'package:string_to_hex/string_to_hex.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:web3dart/web3dart.dart' as Transaction;
import 'package:stackwallet/models/models.dart' as models;

import 'package:http/http.dart';

import 'package:stackwallet/hive/db.dart';
import 'package:stackwallet/utilities/logger.dart';
import 'package:stackwallet/services/coins/coin_service.dart';

import 'package:stackwallet/services/event_bus/events/global/node_connection_status_changed_event.dart';
import 'package:stackwallet/services/event_bus/events/global/refresh_percent_changed_event.dart';
import 'package:stackwallet/services/event_bus/events/global/wallet_sync_status_changed_event.dart';
import 'package:stackwallet/services/event_bus/global_event_bus.dart';

import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/services/notifications_api.dart';

import 'package:stackwallet/services/event_bus/events/global/updated_in_background_event.dart';

const int MINIMUM_CONFIRMATIONS = 1;
const int DUST_LIMIT = 294;

const String GENESIS_HASH_MAINNET =
    "0x11bbe8db4e347b4e8c937c1c8370e4b5ed33adb3db69cbdb7a38e1e50b1b82fa";

class AddressTransaction {
  final String message;
  final List<dynamic> result;
  final String status;

  const AddressTransaction({
    required this.message,
    required this.result,
    required this.status,
  });

  factory AddressTransaction.fromJson(Map<String, dynamic> json) {
    return AddressTransaction(
      message: json['message'] as String,
      result: json['result'] as List<dynamic>,
      status: json['status'] as String,
    );
  }
}

class EthereumWallet extends CoinServiceAPI {
  @override
  set isFavorite(bool markFavorite) {
    DB.instance.put<dynamic>(
        boxName: walletId, key: "isFavorite", value: markFavorite);
  }

  @override
  bool get isFavorite {
    try {
      return DB.instance.get<dynamic>(boxName: walletId, key: "isFavorite")
          as bool;
    } catch (e, s) {
      Logging.instance.log(
          "isFavorite fetch failed (returning false by default): $e\n$s",
          level: LogLevel.Error);
      return false;
    }
  }

  @override
  Coin get coin => _coin;

  late SecureStorageInterface _secureStore;
  late final TransactionNotificationTracker txTracker;
  late PriceAPI _priceAPI;
  final _prefs = Prefs.instance;
  bool longMutex = false;

  final _client = Web3Client(
      "https://goerli.infura.io/v3/22677300bf774e49a458b73313ee56ba", Client());

  final _blockExplorer = "https://eth-goerli.blockscout.com/api?";

  late EthPrivateKey _credentials;
  final int _chainId = 5; //5 for testnet and 1 for mainnet

  EthereumWallet({
    required String walletId,
    required String walletName,
    required Coin coin,
    PriceAPI? priceAPI,
    required SecureStorageInterface secureStore,
    required TransactionNotificationTracker tracker,
  }) {
    txTracker = tracker;
    _walletId = walletId;
    _walletName = walletName;
    _coin = coin;

    _priceAPI = priceAPI ?? PriceAPI(Client());
    _secureStore = secureStore;
  }

  bool _shouldAutoSync = false;

  @override
  bool get shouldAutoSync => _shouldAutoSync;

  @override
  set shouldAutoSync(bool shouldAutoSync) {
    if (_shouldAutoSync != shouldAutoSync) {
      _shouldAutoSync = shouldAutoSync;
      if (!shouldAutoSync) {
        timer?.cancel();
        timer = null;
        stopNetworkAlivePinging();
      } else {
        startNetworkAlivePinging();
        refresh();
      }
    }
  }

  @override
  String get walletName => _walletName;
  late String _walletName;

  late Coin _coin;
  Timer? timer;
  Timer? _networkAliveTimer;

  @override
  Future<List<String>> get allOwnAddresses =>
      _allOwnAddresses ??= _fetchAllOwnAddresses();
  Future<List<String>>? _allOwnAddresses;

  Future<List<String>> _fetchAllOwnAddresses() async {
    List<String> addresses = [];
    final ownAddress = _credentials.address;
    addresses.add(ownAddress.toString());
    return addresses;
  }

  @override
  Future<Decimal> get availableBalance async {
    EtherAmount ethBalance = await _client.getBalance(_credentials.address);
    print("THIS ETH BALANCE IS $ethBalance");
    return Decimal.parse(ethBalance.getValueInUnit(EtherUnit.ether).toString());
  }

  @override
  // TODO: implement balanceMinusMaxFee
  Future<Decimal> get balanceMinusMaxFee => throw UnimplementedError();

  @override
  Future<String> confirmSend({required Map<String, dynamic> txData}) async {
    final gasPrice = await _client.getGasPrice();

    //Get Gas Limit for current block
    final blockInfo = await _client.getBlockInformation(blockNumber: 'latest');
    String gasLimit = blockInfo.gasLimit;

    final amount = txData['recipientAmt'];
    final decimalAmount =
        Format.satoshisToAmount(amount as int, coin: Coin.ethereum);
    final bigIntAmount = amountToBigInt(decimalAmount.toDouble());
    final tx = Transaction.Transaction(
        to: EthereumAddress.fromHex(txData['addresss'] as String),
        gasPrice: gasPrice,
        maxGas: int.parse(gasLimit),
        value: EtherAmount.inWei(bigIntAmount));
    final transaction =
        await _client.sendTransaction(_credentials, tx, chainId: _chainId);

    Logging.instance.log("Generated TX IS  $transaction", level: LogLevel.Info);
    return transaction;
  }

  BigInt amountToBigInt(num amount) {
    const decimal = 18; //Eth has up to 18 decimal places
    final amountToSendinDecimal = amount * (pow(10, decimal));
    return BigInt.from(amountToSendinDecimal);
  }

  @override
  Future<String> get currentReceivingAddress async {
    final _currentReceivingAddress = _credentials.address;
    final checkSumAddress =
        checksumEthereumAddress(_currentReceivingAddress.toString());
    return checkSumAddress;
  }

  @override
  Future<int> estimateFeeFor(int satoshiAmount, int feeRate) async {
    print("CALLING ESTIMATE FEE");
    // TODO: implement estimateFeeFor
    // throw UnimplementedError();
    return 1;
  }

  @override
  Future<void> exit() {
    // TODO: implement exit
    throw UnimplementedError();
  }

  @override
  Future<FeeObject> get fees => _feeObject ??= _getFees();
  Future<FeeObject>? _feeObject;

  Future<FeeObject> _getFees() async {
    return FeeObject(
        numberOfBlocksFast: 10,
        numberOfBlocksAverage: 10,
        numberOfBlocksSlow: 10,
        fast: 1,
        medium: 1,
        slow: 1);
  }

  @override
  Future<void> fullRescan(
      int maxUnusedAddressGap, int maxNumberOfIndexesToCheck) {
    // TODO: implement fullRescan
    throw UnimplementedError();
  }

  @override
  Future<bool> generateNewAddress() {
    // TODO: implement generateNewAddress
    throw UnimplementedError();
  }

  bool _hasCalledExit = false;

  @override
  bool get hasCalledExit => _hasCalledExit;

  @override
  Future<void> initializeExisting() async {
    //First get mnemonic so we can initialize credentials
    final mnemonicString =
        await _secureStore.read(key: '${_walletId}_mnemonic');

    _credentials =
        EthPrivateKey.fromHex(StringToHex.toHexString(mnemonicString));

    Logging.instance.log("Opening existing ${coin.prettyName} wallet.",
        level: LogLevel.Info);

    if ((DB.instance.get<dynamic>(boxName: walletId, key: "id")) == null) {
      throw Exception(
          "Attempted to initialize an existing wallet using an unknown wallet ID!");
    }
    await _prefs.init();
    final data =
        DB.instance.get<dynamic>(boxName: walletId, key: "latest_tx_model")
            as TransactionData?;
    if (data != null) {
      _transactionData = Future(() => data);
    }
  }

  @override
  Future<void> initializeNew() async {
    await _prefs.init();
    final String mnemonic = bip39.generateMnemonic(strength: 256);
    _credentials = EthPrivateKey.fromHex(StringToHex.toHexString(mnemonic));

    await _secureStore.write(key: '${_walletId}_mnemonic', value: mnemonic);

    //Store credentials in secure store
    await _secureStore.write(
        key: '${_walletId}_credentials', value: _credentials.toString());

    await DB.instance
        .put<dynamic>(boxName: walletId, key: "id", value: _walletId);
    await DB.instance.put<dynamic>(
        boxName: walletId, key: 'receivingAddresses', value: ["0"]);
    await DB.instance
        .put<dynamic>(boxName: walletId, key: "receivingIndex", value: 0);
    await DB.instance
        .put<dynamic>(boxName: walletId, key: "changeIndex", value: 0);
    await DB.instance.put<dynamic>(
      boxName: walletId,
      key: 'blocked_tx_hashes',
      value: ["0xdefault"],
    ); // A list of transaction hashes to represent frozen utxos in wallet
    // initialize address book entries
    await DB.instance.put<dynamic>(
        boxName: walletId,
        key: 'addressBookEntries',
        value: <String, String>{});
    await DB.instance
        .put<dynamic>(boxName: walletId, key: "isFavorite", value: false);
  }

  bool _isConnected = false;

  @override
  bool get isConnected => _isConnected;

  bool refreshMutex = false;
  @override
  bool get isRefreshing => refreshMutex;

  @override
  // TODO: implement maxFee
  Future<int> get maxFee => throw UnimplementedError();

  @override
  Future<List<String>> get mnemonic => _getMnemonicList();

  Future<int> get chainHeight async {
    try {
      final result = await _client.getBlockNumber();

      return result;
    } catch (e, s) {
      Logging.instance.log("Exception caught in chainHeight: $e\n$s",
          level: LogLevel.Error);
      return -1;
    }
  }

  int get storedChainHeight {
    final storedHeight = DB.instance
        .get<dynamic>(boxName: walletId, key: "storedChainHeight") as int?;
    return storedHeight ?? 0;
  }

  Future<void> updateStoredChainHeight({required int newHeight}) async {
    await DB.instance.put<dynamic>(
        boxName: walletId, key: "storedChainHeight", value: newHeight);
  }

  Future<List<String>> _getMnemonicList() async {
    final mnemonicString =
        await _secureStore.read(key: '${_walletId}_mnemonic');
    if (mnemonicString == null) {
      return [];
    }
    final List<String> data = mnemonicString.split(' ');
    return data;
  }

  @override
  // TODO: implement pendingBalance
  Future<Decimal> get pendingBalance => throw UnimplementedError();

  // Future<Decimal> transactionFee(int satoshiAmount) {}

  @override
  Future<Map<String, dynamic>> prepareSend(
      {required String address,
      required int satoshiAmount,
      Map<String, dynamic>? args}) async {
    final gasPrice = await _client.getGasPrice();

    Map<String, dynamic> txData = {
      "fee": Format.decimalAmountToSatoshis(
          Decimal.parse(gasPrice.getValueInUnit(EtherUnit.ether).toString()),
          coin),
      "addresss": address,
      "recipientAmt": satoshiAmount,
    };

    return txData;
  }

  @override
  Future<void> recoverFromMnemonic(
      {required String mnemonic,
      required int maxUnusedAddressGap,
      required int maxNumberOfIndexesToCheck,
      required int height}) async {
    longMutex = true;
    final start = DateTime.now();

    try {
      if ((await _secureStore.read(key: '${_walletId}_mnemonic')) != null) {
        print("DUPLICATE MNEMONIC");
        longMutex = false;
        throw Exception("Attempted to overwrite mnemonic on restore!");
      }

      await _secureStore.write(
          key: '${_walletId}_mnemonic', value: mnemonic.trim());

      _credentials = EthPrivateKey.fromHex(StringToHex.toHexString(mnemonic));
    } catch (e, s) {
      Logging.instance.log(
          "Exception rethrown from recoverFromMnemonic(): $e\n$s",
          level: LogLevel.Error);
      longMutex = false;
      rethrow;
    }

    longMutex = false;
    final end = DateTime.now();
    Logging.instance.log(
        "$walletName recovery time: ${end.difference(start).inMilliseconds} millis",
        level: LogLevel.Info);
  }

  Future<bool> refreshIfThereIsNewData() async {
    if (longMutex) return false;
    if (_hasCalledExit) return false;
    Logging.instance.log("refreshIfThereIsNewData", level: LogLevel.Info);

    try {
      bool needsRefresh = false;
      Set<String> txnsToCheck = {};

      for (final String txid in txTracker.pendings) {
        if (!txTracker.wasNotifiedConfirmed(txid)) {
          txnsToCheck.add(txid);
        }
      }

      // for (String txid in txnsToCheck) {
      //   final txn = await _client.getTransactionByHash(txid);
      //   int confirmations = txn["confirmations"] as int? ?? 0;
      //   bool isUnconfirmed = confirmations < MINIMUM_CONFIRMATIONS;
      //   if (!isUnconfirmed) {
      //     // unconfirmedTxs = {};
      //     needsRefresh = true;
      //     break;
      //   }
      // }
      // if (!needsRefresh) {
      //   var allOwnAddresses = await _fetchAllOwnAddresses();
      //   List<Map<String, dynamic>> allTxs =
      //       await _fetchHistory(allOwnAddresses);
      //   final txData = await transactionData;
      //   for (Map<String, dynamic> transaction in allTxs) {
      //     if (txData.findTransaction(transaction['tx_hash'] as String) ==
      //         null) {
      //       Logging.instance.log(
      //           " txid not found in address history already ${transaction['tx_hash']}",
      //           level: LogLevel.Info);
      //       needsRefresh = true;
      //       break;
      //     }
      //   }
      // }
      return needsRefresh;
    } catch (e, s) {
      Logging.instance.log(
          "Exception caught in refreshIfThereIsNewData: $e\n$s",
          level: LogLevel.Error);
      rethrow;
    }
  }

  Future<void> getAllTxsToWatch(
    TransactionData txData,
  ) async {
    if (_hasCalledExit) return;
    List<models.Transaction> unconfirmedTxnsToNotifyPending = [];
    List<models.Transaction> unconfirmedTxnsToNotifyConfirmed = [];

    for (final chunk in txData.txChunks) {
      for (final tx in chunk.transactions) {
        if (tx.confirmedStatus) {
          // get all transactions that were notified as pending but not as confirmed
          if (txTracker.wasNotifiedPending(tx.txid) &&
              !txTracker.wasNotifiedConfirmed(tx.txid)) {
            unconfirmedTxnsToNotifyConfirmed.add(tx);
          }
        } else {
          // get all transactions that were not notified as pending yet
          if (!txTracker.wasNotifiedPending(tx.txid)) {
            unconfirmedTxnsToNotifyPending.add(tx);
          }
        }
      }
    }

    // notify on unconfirmed transactions
    for (final tx in unconfirmedTxnsToNotifyPending) {
      if (tx.txType == "Received") {
        unawaited(NotificationApi.showNotification(
          title: "Incoming transaction",
          body: walletName,
          walletId: walletId,
          iconAssetName: Assets.svg.iconFor(coin: coin),
          date: DateTime.fromMillisecondsSinceEpoch(tx.timestamp * 1000),
          shouldWatchForUpdates: tx.confirmations < MINIMUM_CONFIRMATIONS,
          coinName: coin.name,
          txid: tx.txid,
          confirmations: tx.confirmations,
          requiredConfirmations: MINIMUM_CONFIRMATIONS,
        ));
        await txTracker.addNotifiedPending(tx.txid);
      } else if (tx.txType == "Sent") {
        unawaited(NotificationApi.showNotification(
          title: "Sending transaction",
          body: walletName,
          walletId: walletId,
          iconAssetName: Assets.svg.iconFor(coin: coin),
          date: DateTime.fromMillisecondsSinceEpoch(tx.timestamp * 1000),
          shouldWatchForUpdates: tx.confirmations < MINIMUM_CONFIRMATIONS,
          coinName: coin.name,
          txid: tx.txid,
          confirmations: tx.confirmations,
          requiredConfirmations: MINIMUM_CONFIRMATIONS,
        ));
        await txTracker.addNotifiedPending(tx.txid);
      }
    }

    // notify on confirmed
    for (final tx in unconfirmedTxnsToNotifyConfirmed) {
      if (tx.txType == "Received") {
        unawaited(NotificationApi.showNotification(
          title: "Incoming transaction confirmed",
          body: walletName,
          walletId: walletId,
          iconAssetName: Assets.svg.iconFor(coin: coin),
          date: DateTime.fromMillisecondsSinceEpoch(tx.timestamp * 1000),
          shouldWatchForUpdates: false,
          coinName: coin.name,
        ));
        await txTracker.addNotifiedConfirmed(tx.txid);
      } else if (tx.txType == "Sent") {
        unawaited(NotificationApi.showNotification(
          title: "Outgoing transaction confirmed",
          body: walletName,
          walletId: walletId,
          iconAssetName: Assets.svg.iconFor(coin: coin),
          date: DateTime.fromMillisecondsSinceEpoch(tx.timestamp * 1000),
          shouldWatchForUpdates: false,
          coinName: coin.name,
        ));
        await txTracker.addNotifiedConfirmed(tx.txid);
      }
    }
  }

  @override
  Future<void> refresh() async {
    if (refreshMutex) {
      Logging.instance.log("$walletId $walletName refreshMutex denied",
          level: LogLevel.Info);
      return;
    } else {
      refreshMutex = true;
    }

    // final blockNumber = await _client.getBlockNumber();

    try {
      GlobalEventBus.instance.fire(
        WalletSyncStatusChangedEvent(
          WalletSyncStatus.syncing,
          walletId,
          coin,
        ),
      );

      GlobalEventBus.instance.fire(RefreshPercentChangedEvent(0.0, walletId));
      GlobalEventBus.instance.fire(RefreshPercentChangedEvent(0.1, walletId));

      final currentHeight = await chainHeight;
      const storedHeight = 1; //await storedChainHeight;

      Logging.instance
          .log("chain height: $currentHeight", level: LogLevel.Info);
      Logging.instance
          .log("cached height: $storedHeight", level: LogLevel.Info);

      if (currentHeight != storedHeight) {
        if (currentHeight != -1) {
          // -1 failed to fetch current height
          unawaited(updateStoredChainHeight(newHeight: currentHeight));
        }

        GlobalEventBus.instance.fire(RefreshPercentChangedEvent(0.2, walletId));

        final newTxData = _fetchTransactionData();
        GlobalEventBus.instance
            .fire(RefreshPercentChangedEvent(0.50, walletId));

        final feeObj = _getFees();
        GlobalEventBus.instance
            .fire(RefreshPercentChangedEvent(0.60, walletId));

        _transactionData = Future(() => newTxData);

        GlobalEventBus.instance
            .fire(RefreshPercentChangedEvent(0.70, walletId));
        _feeObject = Future(() => feeObj);
        GlobalEventBus.instance
            .fire(RefreshPercentChangedEvent(0.80, walletId));

        final allTxsToWatch = getAllTxsToWatch(await newTxData);
        await Future.wait([
          newTxData,
          feeObj,

          /// TODO - GET fee object
          allTxsToWatch,
        ]);
        GlobalEventBus.instance
            .fire(RefreshPercentChangedEvent(0.90, walletId));
      }
      refreshMutex = false;
      GlobalEventBus.instance.fire(RefreshPercentChangedEvent(1.0, walletId));
      GlobalEventBus.instance.fire(
        WalletSyncStatusChangedEvent(
          WalletSyncStatus.synced,
          walletId,
          coin,
        ),
      );

      if (shouldAutoSync) {
        timer ??= Timer.periodic(const Duration(seconds: 30), (timer) async {
          Logging.instance.log(
              "Periodic refresh check for $walletId $walletName in object instance: $hashCode",
              level: LogLevel.Info);
          // chain height check currently broken
          // if ((await chainHeight) != (await storedChainHeight)) {
          if (await refreshIfThereIsNewData()) {
            await refresh();
            GlobalEventBus.instance.fire(UpdatedInBackgroundEvent(
                "New data found in $walletId $walletName in background!",
                walletId));
          }
          // }
        });
      }
    } catch (error, strace) {
      refreshMutex = false;
      GlobalEventBus.instance.fire(
        NodeConnectionStatusChangedEvent(
          NodeConnectionStatus.disconnected,
          walletId,
          coin,
        ),
      );
      GlobalEventBus.instance.fire(
        WalletSyncStatusChangedEvent(
          WalletSyncStatus.unableToSync,
          walletId,
          coin,
        ),
      );
      Logging.instance.log(
          "Caught exception in refreshWalletData(): $error\n$strace",
          level: LogLevel.Warning);
    }
  }

  @override
  Future<String> send(
      {required String toAddress,
      required int amount,
      Map<String, String> args = const {}}) {
    // TODO: implement send
    throw UnimplementedError();
  }

  @override
  Future<bool> testNetworkConnection() async {
    //TODO - LOOK for correct implementation of ping
    try {
      // final result = await _electrumXClient.ping();
      // return result;
      return true;
    } catch (_) {
      return false;
    }
  }

  void _periodicPingCheck() async {
    bool hasNetwork = await testNetworkConnection();
    _isConnected = hasNetwork;
    if (_isConnected != hasNetwork) {
      NodeConnectionStatus status = hasNetwork
          ? NodeConnectionStatus.connected
          : NodeConnectionStatus.disconnected;
      GlobalEventBus.instance
          .fire(NodeConnectionStatusChangedEvent(status, walletId, coin));
    }
  }

  @override
  // TODO: Check difference between total and available balance for eth
  Future<Decimal> get totalBalance async {
    EtherAmount ethBalance = await _client.getBalance(_credentials.address);
    return Decimal.parse(ethBalance.getValueInUnit(EtherUnit.ether).toString());
  }

  @override
  Future<TransactionData> get transactionData =>
      _transactionData ??= _fetchTransactionData();
  Future<TransactionData>? _transactionData;

  TransactionData? cachedTxData;

  @override
  // TODO: implement unspentOutputs
  Future<List<UtxoObject>> get unspentOutputs => throw UnimplementedError();

  @override
  Future<void> updateNode(bool shouldRefresh) {
    // TODO: implement updateNode
    throw UnimplementedError();
  }

  @override
  Future<void> updateSentCachedTxData(Map<String, dynamic> txData) async {
    final priceData =
        await _priceAPI.getPricesAnd24hChange(baseCurrency: _prefs.currency);
    Decimal currentPrice = priceData[coin]?.item1 ?? Decimal.zero;
    final locale = await Devicelocale.currentLocale;
    final String worthNow = Format.localizedStringAsFixed(
        value:
            ((currentPrice * Decimal.fromInt(txData["recipientAmt"] as int)) /
                    Decimal.fromInt(Constants.satsPerCoin(coin)))
                .toDecimal(scaleOnInfinitePrecision: 2),
        decimalPlaces: 2,
        locale: locale!);

    final tx = models.Transaction(
      txid: txData["txid"] as String,
      confirmedStatus: false,
      timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      txType: "Sent",
      amount: txData["recipientAmt"] as int,
      worthNow: worthNow,
      worthAtBlockTimestamp: worthNow,
      fees: txData["fee"] as int,
      inputSize: 0,
      outputSize: 0,
      inputs: [],
      outputs: [],
      address: txData["address"] as String,
      height: -1,
      confirmations: 0,
    );

    if (cachedTxData == null) {
      final data = await _fetchTransactionData();
      _transactionData = Future(() => data);
    } else {
      final transactions = cachedTxData!.getAllTransactions();
      transactions[tx.txid] = tx;
      cachedTxData = models.TransactionData.fromMap(transactions);
      _transactionData = Future(() => cachedTxData!);
    }
  }

  @override
  bool validateAddress(String address) {
    return isValidEthereumAddress(address);
  }

  Future<AddressTransaction> fetchAddressTransactions(String address) async {
    final response = await get(Uri.parse(
        "${_blockExplorer}module=account&action=txlist&address=$address"));

    if (response.statusCode == 200) {
      return AddressTransaction.fromJson(
          json.decode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  Future<TransactionData> _fetchTransactionData() async {
    String thisAddress = await currentReceivingAddress;
    final cachedTransactions =
        DB.instance.get<dynamic>(boxName: walletId, key: 'latest_tx_model')
            as TransactionData?;
    int latestTxnBlockHeight =
        DB.instance.get<dynamic>(boxName: walletId, key: "storedTxnDataHeight")
                as int? ??
            0;

    final priceData =
        await _priceAPI.getPricesAnd24hChange(baseCurrency: _prefs.currency);
    Decimal currentPrice = priceData[coin]?.item1 ?? Decimal.zero;
    final List<Map<String, dynamic>> midSortedArray = [];

    AddressTransaction txs = await fetchAddressTransactions(thisAddress);
    if (txs.message == "OK") {
      final allTxs = txs.result;
      allTxs.forEach((element) {
        Map<String, dynamic> midSortedTx = {};

        // create final tx map
        midSortedTx["txid"] = element["hash"];
        int confirmations = int.parse(element['confirmations'].toString());

        int transactionAmount = int.parse(element['value'].toString());
        const decimal = 18; //Eth has up to 18 decimal places
        final transactionAmountInDecimal =
            transactionAmount / (pow(10, decimal));

        //Convert to satoshi, default display for other coins
        // Decimal.parse(gasPrice.getValueInUnit(EtherUnit.ether).toString())
        final satAmount = Format.decimalAmountToSatoshis(
            Decimal.parse(transactionAmountInDecimal.toString()), coin);

        midSortedTx["confirmed_status"] =
            (confirmations != 0) && (confirmations >= MINIMUM_CONFIRMATIONS);
        midSortedTx["confirmations"] = confirmations;
        midSortedTx["timestamp"] = element["timeStamp"];

        if (checksumEthereumAddress(element["from"].toString()) ==
            thisAddress) {
          midSortedTx["txType"] = "Sent";
        } else {
          midSortedTx["txType"] = "Received";
        }

        midSortedTx["amount"] = satAmount;
        final String worthNow = ((currentPrice * Decimal.fromInt(satAmount)) /
                Decimal.fromInt(Constants.satsPerCoin(coin)))
            .toDecimal(scaleOnInfinitePrecision: 2)
            .toStringAsFixed(2);

        //Calculate fees (GasLimit * gasPrice)
        int txFee = int.parse(element['gasPrice'].toString()) *
            int.parse(element['gasUsed'].toString());
        final txFeeDecimal = txFee / (pow(10, decimal));

        midSortedTx["worthNow"] = worthNow;
        midSortedTx["worthAtBlockTimestamp"] = worthNow;
        midSortedTx["aliens"] = <dynamic>[];
        midSortedTx["fees"] = Format.decimalAmountToSatoshis(
            Decimal.parse(txFeeDecimal.toString()), coin);
        midSortedTx["address"] = element["to"];
        midSortedTx["inputSize"] = 1;
        midSortedTx["outputSize"] = 1;
        midSortedTx["inputs"] = <dynamic>[];
        midSortedTx["outputs"] = <dynamic>[];
        midSortedTx["height"] = int.parse(element['blockNumber'].toString());

        midSortedArray.add(midSortedTx);
      });
    }

    midSortedArray.sort((a, b) =>
        (int.parse(b['timestamp'].toString())) -
        (int.parse(a['timestamp'].toString())));

    // buildDateTimeChunks
    final Map<String, dynamic> result = {"dateTimeChunks": <dynamic>[]};
    final dateArray = <dynamic>[];

    for (int i = 0; i < midSortedArray.length; i++) {
      final txObject = midSortedArray[i];
      final date =
          extractDateFromTimestamp(int.parse(txObject['timestamp'].toString()));
      final txTimeArray = [txObject["timestamp"], date];

      if (dateArray.contains(txTimeArray[1])) {
        result["dateTimeChunks"].forEach((dynamic chunk) {
          if (extractDateFromTimestamp(
                  int.parse(chunk['timestamp'].toString())) ==
              txTimeArray[1]) {
            if (chunk["transactions"] == null) {
              chunk["transactions"] = <Map<String, dynamic>>[];
            }
            chunk["transactions"].add(txObject);
          }
        });
      } else {
        dateArray.add(txTimeArray[1]);
        final chunk = {
          "timestamp": txTimeArray[0],
          "transactions": [txObject],
        };
        result["dateTimeChunks"].add(chunk);
      }
    }

    final transactionsMap = cachedTransactions?.getAllTransactions() ?? {};
    transactionsMap
        .addAll(TransactionData.fromJson(result).getAllTransactions());

    final txModel = TransactionData.fromMap(transactionsMap);

    await DB.instance.put<dynamic>(
        boxName: walletId,
        key: 'storedTxnDataHeight',
        value: latestTxnBlockHeight);
    await DB.instance.put<dynamic>(
        boxName: walletId, key: 'latest_tx_model', value: txModel);

    cachedTxData = txModel;
    return txModel;
  }

  @override
  String get walletId => _walletId;
  late String _walletId;

  @override
  set walletName(String newName) => _walletName = newName;

  void stopNetworkAlivePinging() {
    _networkAliveTimer?.cancel();
    _networkAliveTimer = null;
  }

  void startNetworkAlivePinging() {
    // call once on start right away
    _periodicPingCheck();

    // then periodically check
    _networkAliveTimer = Timer.periodic(
      Constants.networkAliveTimerDuration,
      (_) async {
        _periodicPingCheck();
      },
    );
  }
}
