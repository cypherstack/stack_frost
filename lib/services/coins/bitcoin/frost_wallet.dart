import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:bitcoindart/bitcoindart.dart';
import 'package:frostdart/frostdart.dart' as frost;
import 'package:frostdart/frostdart_bindings_generated.dart';
import 'package:isar/isar.dart';
import 'package:stackfrost/db/hive/db.dart';
import 'package:stackfrost/db/isar/main_db.dart';
import 'package:stackfrost/electrumx_rpc/cached_electrumx.dart';
import 'package:stackfrost/electrumx_rpc/electrumx.dart';
import 'package:stackfrost/exceptions/electrumx/no_such_transaction.dart';
import 'package:stackfrost/models/balance.dart';
import 'package:stackfrost/models/isar/models/isar_models.dart' as isar_models;
import 'package:stackfrost/models/paymint/fee_object_model.dart';
import 'package:stackfrost/services/coins/bitcoin/bitcoin_wallet.dart';
import 'package:stackfrost/services/coins/coin_service.dart';
import 'package:stackfrost/services/event_bus/events/global/node_connection_status_changed_event.dart';
import 'package:stackfrost/services/event_bus/events/global/refresh_percent_changed_event.dart';
import 'package:stackfrost/services/event_bus/events/global/updated_in_background_event.dart';
import 'package:stackfrost/services/event_bus/events/global/wallet_sync_status_changed_event.dart';
import 'package:stackfrost/services/event_bus/global_event_bus.dart';
import 'package:stackfrost/services/frost.dart';
import 'package:stackfrost/services/mixins/coin_control_interface.dart';
import 'package:stackfrost/services/mixins/electrum_x_parsing.dart';
import 'package:stackfrost/services/mixins/wallet_cache.dart';
import 'package:stackfrost/services/mixins/wallet_db.dart';
import 'package:stackfrost/services/node_service.dart';
import 'package:stackfrost/services/transaction_notification_tracker.dart';
import 'package:stackfrost/utilities/address_utils.dart';
import 'package:stackfrost/utilities/amount/amount.dart';
import 'package:stackfrost/utilities/constants.dart';
import 'package:stackfrost/utilities/default_nodes.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';
import 'package:stackfrost/utilities/flutter_secure_storage_interface.dart';
import 'package:stackfrost/utilities/format.dart';
import 'package:stackfrost/utilities/logger.dart';
import 'package:stackfrost/utilities/prefs.dart';
import 'package:stackfrost/widgets/crypto_notifications.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

class FrostWallet extends CoinServiceAPI
    with WalletCache, WalletDB, ElectrumXParsing, CoinControlInterface {
  FrostWallet({
    required String walletId,
    required String walletName,
    required Coin coin,
    required ElectrumX client,
    required CachedElectrumX cachedClient,
    required TransactionNotificationTracker tracker,
    required SecureStorageInterface secureStore,
    MainDB? mockableOverride,
  }) {
    txTracker = tracker;
    _walletId = walletId;
    _walletName = walletName;
    _coin = coin;
    _electrumXClient = client;
    _cachedElectrumXClient = cachedClient;
    _secureStore = secureStore;
    initCache(walletId, coin);
    initWalletDB(mockableOverride: mockableOverride);
    initCoinControlInterface(
      walletId: walletId,
      walletName: walletName,
      coin: coin,
      db: db,
      getChainHeight: () => chainHeight,
      refreshedBalanceCallback: (balance) async {
        _balance = balance;
        await updateCachedBalance(_balance!);
      },
    );
  }

  final _prefs = Prefs.instance;

  Timer? timer;

  late final TransactionNotificationTracker txTracker;

  bool longMutex = false;

  NetworkType get _network {
    switch (coin) {
      case Coin.bitcoin:
        return bitcoin;
      case Coin.bitcoinTestNet:
        return testnet;
      default:
        throw Exception("Invalid network type!");
    }
  }

  Future<int> get chainHeight async {
    try {
      final result = await _electrumXClient.getBlockHeadTip();
      final height = result["height"] as int;
      await updateCachedChainHeight(height);
      if (height > storedChainHeight) {
        GlobalEventBus.instance.fire(
          UpdatedInBackgroundEvent(
            "Updated current chain height in $walletId $walletName!",
            walletId,
          ),
        );
      }
      return height;
    } catch (e, s) {
      Logging.instance.log(
        "Exception caught in chainHeight: $e\n$s",
        level: LogLevel.Error,
      );
      return storedChainHeight;
    }
  }

  @override
  set isFavorite(bool markFavorite) {
    _isFavorite = markFavorite;
    updateCachedIsFavorite(markFavorite);
  }

  @override
  bool get isFavorite => _isFavorite ??= getCachedIsFavorite();
  bool? _isFavorite;

  @override
  bool get shouldAutoSync => _shouldAutoSync;
  bool _shouldAutoSync = false;
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

  Timer? _networkAliveTimer;

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

  void _periodicPingCheck() async {
    bool hasNetwork = await testNetworkConnection();

    if (_isConnected != hasNetwork) {
      NodeConnectionStatus status = hasNetwork
          ? NodeConnectionStatus.connected
          : NodeConnectionStatus.disconnected;
      GlobalEventBus.instance
          .fire(NodeConnectionStatusChangedEvent(status, walletId, coin));

      _isConnected = hasNetwork;
      if (hasNetwork) {
        unawaited(refresh());
      }
    }
  }

  void stopNetworkAlivePinging() {
    _networkAliveTimer?.cancel();
    _networkAliveTimer = null;
  }

  @override
  String get walletName => _walletName;
  late String _walletName;

  // setter for updating on rename
  @override
  set walletName(String newName) => _walletName = newName;

  late ElectrumX _electrumXClient;

  ElectrumX get electrumXClient => _electrumXClient;

  late CachedElectrumX _cachedElectrumXClient;

  CachedElectrumX get cachedElectrumXClient => _cachedElectrumXClient;

  late SecureStorageInterface _secureStore;

  @override
  Balance get balance => _balance ??= getCachedBalance();
  Balance? _balance;

  @override
  Coin get coin => _coin;
  late final Coin _coin;

  Future<String> frostCreateSignConfig({
    required List<({String address, Amount amount})> outputs,
    required String changeAddress,
    required int feePerWeight,
  }) async {
    if (outputs.map((e) => e.amount).reduce((value, e) => value += e) >
        balance.spendable) {
      throw Exception("Insufficient available funds");
    }

    List<isar_models.UTXO> utxos =
        await db.getUTXOs(walletId).filter().isBlockedEqualTo(false).findAll();

    if (utxos.isEmpty) {
      throw Exception("No UTXOs found");
    } else {
      final currentHeight = await chainHeight;
      utxos.removeWhere(
        (e) => !e.isConfirmed(
          currentHeight,
          MINIMUM_CONFIRMATIONS,
        ),
      );
      if (utxos.isEmpty) {
        throw Exception("No confirmed UTXOs found");
      }
    }

    final serializedKeys = await _serializedKeys;
    final keys = frost.deserializeKeys(keys: serializedKeys!);

    final int network =
        coin == Coin.bitcoin ? Network.Mainnet : Network.Testnet;

    final publicKey = frost.scriptPubKeyForKeys(keys: keys);

    final config = Frost.createSignConfig(
      network: network,
      inputs: utxos
          .map((e) => (
                utxo: e,
                scriptPubKey: publicKey,
              ))
          .toList(),
      outputs: outputs,
      changeAddress: (await _currentReceivingAddress).value,
      feePerWeight: feePerWeight,
    );

    return config;
  }

  Future<
      ({
        Pointer<TransactionSignMachineWrapper> machinePtr,
        String preprocess,
      })> frostAttemptSignConfig({
    required String config,
  }) async {
    final int network =
        coin == Coin.bitcoin ? Network.Mainnet : Network.Testnet;
    final serializedKeys = await _serializedKeys;

    return Frost.attemptSignConfig(
      network: network,
      config: config,
      serializedKeys: serializedKeys!,
    );
  }

  @override
  Future<Map<String, dynamic>> prepareSend({
    required String address,
    required Amount amount,
    Map<String, dynamic>? args,
  }) async {
    // not used in frost ms
    throw UnimplementedError();
  }

  @override
  Future<String> confirmSend({
    required Map<String, dynamic> txData,
  }) {
    // TODO: implement confirmSend
    throw UnimplementedError();
  }

  @override
  Future<String> get currentReceivingAddress async =>
      (await _currentReceivingAddress).value;

  Future<isar_models.Address> get _currentReceivingAddress async => (await db
      .getAddresses(walletId)
      .filter()
      .typeEqualTo(isar_models.AddressType.unknown)
      .subTypeEqualTo(isar_models.AddressSubType.receiving)
      .sortByDerivationIndexDesc()
      .findFirst())!;

  @override
  Future<Amount> estimateFeeFor(Amount amount, int feeRate) async {
    final available = balance.spendable;

    if (available == amount) {
      return amount - (await sweepAllEstimate(feeRate));
    } else if (amount <= Amount.zero || amount > available) {
      return roughFeeEstimate(1, 2, feeRate);
    }

    Amount runningBalance = Amount(
      rawValue: BigInt.zero,
      fractionDigits: coin.decimals,
    );
    int inputCount = 0;
    for (final output in (await utxos)) {
      if (!output.isBlocked) {
        runningBalance += Amount(
          rawValue: BigInt.from(output.value),
          fractionDigits: coin.decimals,
        );
        inputCount++;
        if (runningBalance > amount) {
          break;
        }
      }
    }

    final oneOutPutFee = roughFeeEstimate(inputCount, 1, feeRate);
    final twoOutPutFee = roughFeeEstimate(inputCount, 2, feeRate);

    if (runningBalance - amount > oneOutPutFee) {
      if (runningBalance - amount > oneOutPutFee + DUST_LIMIT) {
        final change = runningBalance - amount - twoOutPutFee;
        if (change > DUST_LIMIT &&
            runningBalance - amount - change == twoOutPutFee) {
          return runningBalance - amount - change;
        } else {
          return runningBalance - amount;
        }
      } else {
        return runningBalance - amount;
      }
    } else if (runningBalance - amount == oneOutPutFee) {
      return oneOutPutFee;
    } else {
      return twoOutPutFee;
    }
  }

  Amount roughFeeEstimate(int inputCount, int outputCount, int feeRatePerKB) {
    return Amount(
      rawValue: BigInt.from(
          ((42 + (272 * inputCount) + (128 * outputCount)) / 4).ceil() *
              (feeRatePerKB / 1000).ceil()),
      fractionDigits: coin.decimals,
    );
  }

  Future<Amount> sweepAllEstimate(int feeRate) async {
    int available = 0;
    int inputCount = 0;
    for (final output in (await utxos)) {
      if (!output.isBlocked &&
          output.isConfirmed(storedChainHeight, MINIMUM_CONFIRMATIONS)) {
        available += output.value;
        inputCount++;
      }
    }

    // transaction will only have 1 output minus the fee
    final estimatedFee = roughFeeEstimate(inputCount, 1, feeRate);

    return Amount(
          rawValue: BigInt.from(available),
          fractionDigits: coin.decimals,
        ) -
        estimatedFee;
  }

  @override
  Future<void> exit() async {
    _hasCalledExit = true;
    timer?.cancel();
    timer = null;
    stopNetworkAlivePinging();
  }

  bool _hasCalledExit = false;

  @override
  bool get hasCalledExit => _hasCalledExit;

  @override
  Future<FeeObject> get fees => _feeObject ??= _getFees();
  Future<FeeObject>? _feeObject;

  Future<FeeObject> _getFees() async {
    try {
      // adjust numbers for different speeds?
      const int f = 1, m = 5, s = 20;

      final fast = await electrumXClient.estimateFee(blocks: f);
      final medium = await electrumXClient.estimateFee(blocks: m);
      final slow = await electrumXClient.estimateFee(blocks: s);

      final feeObject = FeeObject(
        numberOfBlocksFast: f,
        numberOfBlocksAverage: m,
        numberOfBlocksSlow: s,
        fast: Amount.fromDecimal(
          fast,
          fractionDigits: coin.decimals,
        ).raw.toInt(),
        medium: Amount.fromDecimal(
          medium,
          fractionDigits: coin.decimals,
        ).raw.toInt(),
        slow: Amount.fromDecimal(
          slow,
          fractionDigits: coin.decimals,
        ).raw.toInt(),
      );

      Logging.instance.log("fetched fees: $feeObject", level: LogLevel.Info);
      return feeObject;
    } catch (e) {
      Logging.instance
          .log("Exception rethrown from _getFees(): $e", level: LogLevel.Error);
      rethrow;
    }
  }

  Future<void> recoverFromSerializedKeys({
    required String serializedKeys,
    required String mnemonic,
    required String mnemonicPassphrase,
    required bool isRescan,
  }) async {
    try {
      final keys = frost.deserializeKeys(keys: serializedKeys);
      await _saveSerializedKeys(serializedKeys);

      final addressString = frost.addressForKeys(
        network: coin == Coin.bitcoin ? Network.Mainnet : Network.Testnet,
        keys: keys,
      );

      final publicKey = frost.scriptPubKeyForKeys(keys: keys);

      final address = isar_models.Address(
        walletId: walletId,
        value: addressString,
        publicKey: publicKey,
        derivationIndex: 0,
        derivationPath: null,
        subType: isar_models.AddressSubType.receiving,
        type: isar_models.AddressType.unknown,
      );

      if (isRescan) {
        await db.updateOrPutAddresses([address]);
      } else {
        await db.putAddresses([address]);
      }
      await Future.wait([
        _refreshTransactions(),
        _updateUTXOs(),
      ]);

      await Future.wait([
        updateCachedId(walletId),
        updateCachedIsFavorite(false),
      ]);
    } catch (e, s) {
      Logging.instance.log(
        "recoverFromSerializedKeys failed to deserialize keys: $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    } finally {
      longMutex = false;
    }
  }

  Future<String?> get _serializedKeys async => await _secureStore.read(
        key: "{$walletId}_serializedFROSTKeys",
      );
  Future<void> _saveSerializedKeys(String keys) async =>
      await _secureStore.write(
        key: "{$walletId}_serializedFROSTKeys",
        value: keys,
      );

  Future<Uint8List?> get _multisigId async {
    final id = await _secureStore.read(
      key: "{$walletId}_multisigIdFROST",
    );
    if (id == null) {
      return null;
    } else {
      return Format.stringToUint8List(id);
    }
  }

  Future<void> _saveMultisigId(Uint8List id) async => await _secureStore.write(
        key: "{$walletId}_multisigIdFROST",
        value: Format.uint8listToString(id),
      );

  Future<String?> get _recoveryString async => await _secureStore.read(
        key: "{$walletId}_recoveryStringFROST",
      );
  Future<void> _saveRecoveryString(String recoveryString) async =>
      await _secureStore.write(
        key: "{$walletId}_recoveryStringFROST",
        value: recoveryString,
      );

  List<String> get participants {
    final list = DB.instance.get<dynamic>(
          boxName: walletId,
          key: "_frostParticipants",
        ) as List? ??
        [];
    return List<String>.from(list);
  }

  Future<void> _updateParticipants(List<String> participants) async {
    await DB.instance.put<dynamic>(
      boxName: walletId,
      key: "_frostParticipants",
      value: participants,
    );
  }

  String get myName => DB.instance.get<dynamic>(
        boxName: walletId,
        key: "_frostMyName",
      ) as String;
  Future<void> _saveMyName(String myName) async =>
      await DB.instance.put<dynamic>(
        boxName: walletId,
        key: "_frostMyName",
        value: myName,
      );

  @override
  Future<void> fullRescan(
    int maxUnusedAddressGap,
    int maxNumberOfIndexesToCheck,
  ) async {
    Logging.instance.log("Starting full rescan!", level: LogLevel.Info);
    longMutex = true;
    GlobalEventBus.instance.fire(
      WalletSyncStatusChangedEvent(
        WalletSyncStatus.syncing,
        walletId,
        coin,
      ),
    );

    // clear cache
    await _cachedElectrumXClient.clearSharedTransactionCache(coin: coin);

    // back up data
    // await _rescanBackup();

    await db.deleteWalletBlockchainData(walletId);

    try {
      final keys = await _serializedKeys;
      final _mnemonic = await mnemonicString;
      final _mnemonicPassphrase = await mnemonicPassphrase;

      await recoverFromSerializedKeys(
        serializedKeys: keys!,
        mnemonic: _mnemonic!,
        mnemonicPassphrase: _mnemonicPassphrase!,
        isRescan: true,
      );

      longMutex = false;
      await refresh();
      Logging.instance.log("Full rescan complete!", level: LogLevel.Info);
      GlobalEventBus.instance.fire(
        WalletSyncStatusChangedEvent(
          WalletSyncStatus.synced,
          walletId,
          coin,
        ),
      );
    } catch (e, s) {
      GlobalEventBus.instance.fire(
        WalletSyncStatusChangedEvent(
          WalletSyncStatus.unableToSync,
          walletId,
          coin,
        ),
      );

      // restore from backup
      // await _rescanRestore();

      longMutex = false;
      Logging.instance.log("Exception rethrown from fullRescan(): $e\n$s",
          level: LogLevel.Error);
      rethrow;
    }
  }

  @override
  Future<bool> generateNewAddress() {
    throw UnsupportedError(
        "generateNewAddress not available in FROST wallets (yet)");
  }

  @override
  Future<void> initializeExisting() async {
    Logging.instance.log(
      "initializeExisting() ${coin.prettyName} FROST wallet.",
      level: LogLevel.Info,
    );

    if (getCachedId() == null) {
      throw Exception(
        "Attempted to initialize an existing wallet using an unknown wallet ID!",
      );
    }

    await _prefs.init();
  }

  Future<void> initializeNewFrost({
    required String mnemonic,
    required String recoveryString,
    required String serializedKeys,
    required Uint8List multisigId,
    required String myName,
    required List<String> participants,
  }) async {
    Logging.instance.log("Generating new ${coin.prettyName} FROST wallet.",
        level: LogLevel.Info);

    if (getCachedId() != null) {
      throw Exception(
        "Attempted to initialize a new wallet using an existing wallet ID!",
      );
    }

    await _prefs.init();
    try {
      await _secureStore.write(
        key: '${_walletId}_mnemonic',
        value: mnemonic,
      );
      await _secureStore.write(
          key: '${_walletId}_mnemonicPassphrase', value: "");
      await _saveSerializedKeys(serializedKeys);
      await _saveRecoveryString(recoveryString);
      await _saveMultisigId(multisigId);
      await _saveMyName(myName);
      await _updateParticipants(participants);

      final keys = frost.deserializeKeys(keys: serializedKeys);

      final addressString = frost.addressForKeys(
        network: coin == Coin.bitcoin ? Network.Mainnet : Network.Testnet,
        keys: keys,
      );

      final publicKey = frost.scriptPubKeyForKeys(keys: keys);

      final address = isar_models.Address(
        walletId: walletId,
        value: addressString,
        publicKey: publicKey,
        derivationIndex: 0,
        derivationPath: null,
        subType: isar_models.AddressSubType.receiving,
        type: isar_models.AddressType.unknown,
      );

      await db.putAddresses([address]);
    } catch (e, s) {
      Logging.instance.log(
        "Exception rethrown from initializeNewFrost(): $e\n$s",
        level: LogLevel.Fatal,
      );
      rethrow;
    }
    await Future.wait([
      updateCachedId(walletId),
      updateCachedIsFavorite(false),
    ]);
  }

  @override
  Future<void> initializeNew() async {
    throw Exception(
      "Attempted to initialize a new frost wallet with the wrong function",
    );
  }

  @override
  bool get isConnected => _isConnected;
  bool _isConnected = false;

  @override
  Future<int> get maxFee => throw UnimplementedError();

  @override
  Future<List<String>> get mnemonic => _getMnemonicList();

  @override
  // TODO: implement mnemonicPassphrase
  Future<String?> get mnemonicPassphrase => throw UnimplementedError();

  @override
  Future<String?> get mnemonicString async => (await mnemonic).join(" ");

  @override
  Future<void> recoverFromMnemonic({
    required String mnemonic,
    String? mnemonicPassphrase,
    required int maxUnusedAddressGap,
    required int maxNumberOfIndexesToCheck,
    required int height,
  }) {
    throw UnimplementedError("Not used for FROST multisig wallets");
  }

  @override
  bool get isRefreshing => refreshMutex;

  bool refreshMutex = false;

  @override
  Future<void> refresh() async {
    if (refreshMutex) {
      Logging.instance.log("$walletId $walletName refreshMutex denied",
          level: LogLevel.Info);
      return;
    } else {
      refreshMutex = true;
    }

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
      // Logging.instance
      //     .log("cached height: $storedHeight", level: LogLevel.Info);

      if (currentHeight != storedHeight) {
        GlobalEventBus.instance.fire(RefreshPercentChangedEvent(0.2, walletId));

        GlobalEventBus.instance.fire(RefreshPercentChangedEvent(0.3, walletId));

        GlobalEventBus.instance.fire(RefreshPercentChangedEvent(0.4, walletId));

        final fetchFuture = _refreshTransactions();
        GlobalEventBus.instance
            .fire(RefreshPercentChangedEvent(0.50, walletId));

        final feeObj = _getFees();
        GlobalEventBus.instance
            .fire(RefreshPercentChangedEvent(0.60, walletId));

        GlobalEventBus.instance
            .fire(RefreshPercentChangedEvent(0.70, walletId));
        _feeObject = Future(() => feeObj);

        await fetchFuture;
        GlobalEventBus.instance
            .fire(RefreshPercentChangedEvent(0.80, walletId));

        await _updateUTXOs();
        await _getAllTxsToWatch();
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
          level: LogLevel.Error);
    }
  }

  Future<void> _updateUTXOs() async {
    final allAddresses = [await _currentReceivingAddress];

    try {
      final fetchedUtxoList = <List<Map<String, dynamic>>>[];

      final Map<int, Map<String, List<dynamic>>> batches = {};
      const batchSizeMax = 100;
      int batchNumber = 0;
      for (int i = 0; i < allAddresses.length; i++) {
        if (batches[batchNumber] == null) {
          batches[batchNumber] = {};
        }
        final scriptHash = AddressUtils.convertBytesToScriptHash(
          Uint8List.fromList(
            allAddresses[i].publicKey!,
          ),
        );
        batches[batchNumber]!.addAll({
          scriptHash: [scriptHash]
        });
        if (i % batchSizeMax == batchSizeMax - 1) {
          batchNumber++;
        }
      }

      for (int i = 0; i < batches.length; i++) {
        final response =
            await _electrumXClient.getBatchUTXOs(args: batches[i]!);
        for (final entry in response.entries) {
          if (entry.value.isNotEmpty) {
            fetchedUtxoList.add(entry.value);
          }
        }
      }

      final List<isar_models.UTXO> outputArray = [];

      for (int i = 0; i < fetchedUtxoList.length; i++) {
        for (int j = 0; j < fetchedUtxoList[i].length; j++) {
          final jsonUTXO = fetchedUtxoList[i][j];

          final txn = await cachedElectrumXClient.getTransaction(
            txHash: jsonUTXO["tx_hash"] as String,
            verbose: true,
            coin: coin,
          );

          // fetch stored tx to see if paynym notification tx and block utxo
          final storedTx = await db.getTransaction(
            walletId,
            jsonUTXO["tx_hash"] as String,
          );

          bool shouldBlock = false;
          String? blockReason;
          String? label;

          if (storedTx?.subType ==
              isar_models.TransactionSubType.bip47Notification) {
            if (storedTx?.type == isar_models.TransactionType.incoming) {
              shouldBlock = true;
              blockReason = "Incoming paynym notification transaction.";
            } else if (storedTx?.type == isar_models.TransactionType.outgoing) {
              shouldBlock = false;
              blockReason = "Paynym notification change output. Incautious "
                  "handling of change outputs from notification transactions "
                  "may cause unintended loss of privacy.";
              label = blockReason;
            }
          }

          final vout = jsonUTXO["tx_pos"] as int;

          final outputs = txn["vout"] as List;

          String? utxoOwnerAddress;
          // get UTXO owner address
          for (final output in outputs) {
            if (output["n"] == vout) {
              utxoOwnerAddress =
                  output["scriptPubKey"]?["addresses"]?[0] as String? ??
                      output["scriptPubKey"]?["address"] as String?;
            }
          }

          final utxo = isar_models.UTXO(
            walletId: walletId,
            txid: txn["txid"] as String,
            vout: vout,
            value: jsonUTXO["value"] as int,
            name: label ?? "",
            isBlocked: shouldBlock,
            blockedReason: blockReason,
            isCoinbase: txn["is_coinbase"] as bool? ?? false,
            blockHash: txn["blockhash"] as String?,
            blockHeight: jsonUTXO["height"] as int?,
            blockTime: txn["blocktime"] as int?,
            address: utxoOwnerAddress,
          );

          outputArray.add(utxo);
        }
      }

      Logging.instance
          .log('Outputs fetched: $outputArray', level: LogLevel.Info);

      await db.updateUTXOs(walletId, outputArray);

      // finally update balance
      await refreshBalance();
    } catch (e, s) {
      Logging.instance
          .log("Output fetch unsuccessful: $e\n$s", level: LogLevel.Error);
    }
  }

  Future<void> _getAllTxsToWatch() async {
    if (_hasCalledExit) return;
    List<isar_models.Transaction> unconfirmedTxnsToNotifyPending = [];
    List<isar_models.Transaction> unconfirmedTxnsToNotifyConfirmed = [];

    final currentChainHeight = await chainHeight;

    final txCount = await db.getTransactions(walletId).count();

    const paginateLimit = 50;

    for (int i = 0; i < txCount; i += paginateLimit) {
      final transactions = await db
          .getTransactions(walletId)
          .offset(i)
          .limit(paginateLimit)
          .findAll();
      for (final tx in transactions) {
        if (tx.isConfirmed(currentChainHeight, MINIMUM_CONFIRMATIONS)) {
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
      final confirmations = tx.getConfirmations(currentChainHeight);

      if (tx.type == isar_models.TransactionType.incoming) {
        CryptoNotificationsEventBus.instance.fire(
          CryptoNotificationEvent(
            title: "Incoming transaction",
            walletId: walletId,
            walletName: walletName,
            date: DateTime.fromMillisecondsSinceEpoch(tx.timestamp * 1000),
            shouldWatchForUpdates: confirmations < MINIMUM_CONFIRMATIONS,
            coin: coin,
            txid: tx.txid,
            confirmations: confirmations,
            requiredConfirmations: MINIMUM_CONFIRMATIONS,
          ),
        );
        await txTracker.addNotifiedPending(tx.txid);
      } else if (tx.type == isar_models.TransactionType.outgoing) {
        CryptoNotificationsEventBus.instance.fire(
          CryptoNotificationEvent(
            title: "Sending transaction",
            walletId: walletId,
            date: DateTime.fromMillisecondsSinceEpoch(tx.timestamp * 1000),
            shouldWatchForUpdates: confirmations < MINIMUM_CONFIRMATIONS,
            txid: tx.txid,
            confirmations: confirmations,
            requiredConfirmations: MINIMUM_CONFIRMATIONS,
            walletName: walletName,
            coin: coin,
          ),
        );

        await txTracker.addNotifiedPending(tx.txid);
      }
    }

    // notify on confirmed
    for (final tx in unconfirmedTxnsToNotifyConfirmed) {
      if (tx.type == isar_models.TransactionType.incoming) {
        CryptoNotificationsEventBus.instance.fire(
          CryptoNotificationEvent(
            title: "Incoming transaction confirmed",
            walletId: walletId,
            date: DateTime.fromMillisecondsSinceEpoch(tx.timestamp * 1000),
            shouldWatchForUpdates: false,
            txid: tx.txid,
            requiredConfirmations: MINIMUM_CONFIRMATIONS,
            walletName: walletName,
            coin: coin,
          ),
        );

        await txTracker.addNotifiedConfirmed(tx.txid);
      } else if (tx.type == isar_models.TransactionType.outgoing) {
        CryptoNotificationsEventBus.instance.fire(
          CryptoNotificationEvent(
            title: "Outgoing transaction confirmed",
            walletId: walletId,
            date: DateTime.fromMillisecondsSinceEpoch(tx.timestamp * 1000),
            shouldWatchForUpdates: false,
            txid: tx.txid,
            requiredConfirmations: MINIMUM_CONFIRMATIONS,
            walletName: walletName,
            coin: coin,
          ),
        );

        await txTracker.addNotifiedConfirmed(tx.txid);
      }
    }
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

      for (String txid in txnsToCheck) {
        final txn = await electrumXClient.getTransaction(txHash: txid);
        int confirmations = txn["confirmations"] as int? ?? 0;
        bool isUnconfirmed = confirmations < MINIMUM_CONFIRMATIONS;
        if (!isUnconfirmed) {
          // unconfirmedTxs = {};
          needsRefresh = true;
          break;
        }
      }
      if (!needsRefresh) {
        final allOwnAddresses = [await _currentReceivingAddress];
        List<Map<String, dynamic>> allTxs = await _fetchHistory(
          allOwnAddresses,
        );
        for (Map<String, dynamic> transaction in allTxs) {
          final txid = transaction['tx_hash'] as String;
          if ((await db
                  .getTransactions(walletId)
                  .filter()
                  .txidMatches(txid)
                  .findFirst()) ==
              null) {
            Logging.instance.log(
                " txid not found in address history already ${transaction['tx_hash']}",
                level: LogLevel.Info);
            needsRefresh = true;
            break;
          }
        }
      }
      return needsRefresh;
    } on NoSuchTransactionException catch (e) {
      await db.isar.writeTxn(() async {
        await db.isar.transactions.deleteByTxidWalletId(e.txid, walletId);
      });
      await txTracker.deleteTransaction(e.txid);
      return true;
    } catch (e, s) {
      Logging.instance.log(
          "Exception caught in refreshIfThereIsNewData: $e\n$s",
          level: LogLevel.Error);
      rethrow;
    }
  }

  Future<void> _refreshTransactions() async {
    final List<isar_models.Address> allAddresses = [
      await _currentReceivingAddress,
    ];

    final Set<Map<String, dynamic>> allTxHashes =
        (await _fetchHistory(allAddresses)).toSet();

    List<Map<String, dynamic>> allTransactions = [];

    final currentHeight = await chainHeight;

    for (final txHash in allTxHashes) {
      final storedTx = await db
          .getTransactions(walletId)
          .filter()
          .txidEqualTo(txHash["tx_hash"] as String)
          .findFirst();

      if (storedTx == null ||
          !storedTx.isConfirmed(currentHeight, MINIMUM_CONFIRMATIONS)) {
        final tx = await cachedElectrumXClient.getTransaction(
          txHash: txHash["tx_hash"] as String,
          verbose: true,
          coin: coin,
        );

        if (!_duplicateTxCheck(allTransactions, tx["txid"] as String)) {
          tx["address"] = await db
              .getAddresses(walletId)
              .filter()
              .valueEqualTo(txHash["address"] as String)
              .findFirst();
          tx["height"] = txHash["height"];
          allTransactions.add(tx);
        }
      }
    }

    final List<Tuple2<isar_models.Transaction, isar_models.Address?>> txnsData =
        [];

    for (final txObject in allTransactions) {
      final data = await parseTransaction(
        txObject,
        cachedElectrumXClient,
        allAddresses,
        coin,
        MINIMUM_CONFIRMATIONS,
        walletId,
      );

      txnsData.add(data);
    }
    await db.addNewTransactionData(txnsData, walletId);

    // quick hack to notify manager to call notifyListeners if
    // transactions changed
    if (txnsData.isNotEmpty) {
      GlobalEventBus.instance.fire(
        UpdatedInBackgroundEvent(
          "Transactions updated/added for: $walletId $walletName  ",
          walletId,
        ),
      );
    }
  }

  Future<List<Map<String, dynamic>>> _fetchHistory(
      List<isar_models.Address> addresses) async {
    try {
      List<Map<String, dynamic>> allTxHashes = [];

      final allAddresses = addresses.map((e) => e.value).toList();

      final Map<int, Map<String, List<dynamic>>> batches = {};
      final Map<String, String> requestIdToAddressMap = {};
      const batchSizeMax = 100;
      int batchNumber = 0;
      for (int i = 0; i < allAddresses.length; i++) {
        if (batches[batchNumber] == null) {
          batches[batchNumber] = {};
        }
        final scriptHash = AddressUtils.convertBytesToScriptHash(
          Uint8List.fromList(
            addresses[i].publicKey!,
          ),
        );
        final id = Logger.isTestEnv ? "$i" : const Uuid().v1();
        requestIdToAddressMap[id] = allAddresses[i];
        batches[batchNumber]!.addAll({
          id: [scriptHash]
        });
        if (i % batchSizeMax == batchSizeMax - 1) {
          batchNumber++;
        }
      }

      for (int i = 0; i < batches.length; i++) {
        final response =
            await _electrumXClient.getBatchHistory(args: batches[i]!);
        for (final entry in response.entries) {
          for (int j = 0; j < entry.value.length; j++) {
            entry.value[j]["address"] = requestIdToAddressMap[entry.key];
            if (!allTxHashes.contains(entry.value[j])) {
              allTxHashes.add(entry.value[j]);
            }
          }
        }
      }

      return allTxHashes;
    } catch (e, s) {
      Logging.instance.log("_fetchHistory: $e\n$s", level: LogLevel.Error);
      rethrow;
    }
  }

  bool _duplicateTxCheck(
      List<Map<String, dynamic>> allTransactions, String txid) {
    for (int i = 0; i < allTransactions.length; i++) {
      if (allTransactions[i]["txid"] == txid) {
        return true;
      }
    }
    return false;
  }

  @override
  int get storedChainHeight => getCachedChainHeight();

  @override
  Future<bool> testNetworkConnection() async {
    try {
      final result = await _electrumXClient.ping();
      return result;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<List<isar_models.Transaction>> get transactions =>
      db.getTransactions(walletId).sortByTimestampDesc().findAll();

  @override
  Future<void> updateNode(bool shouldRefresh) async {
    final failovers = NodeService(secureStorageInterface: _secureStore)
        .failoverNodesFor(coin: coin)
        .map((e) => ElectrumXNode(
              address: e.host,
              port: e.port,
              name: e.name,
              id: e.id,
              useSSL: e.useSSL,
            ))
        .toList();
    final newNode = await getCurrentNode();
    _electrumXClient = ElectrumX.from(
      node: newNode,
      prefs: _prefs,
      failovers: failovers,
    );
    _cachedElectrumXClient = CachedElectrumX.from(
      electrumXClient: _electrumXClient,
    );

    if (shouldRefresh) {
      unawaited(refresh());
    }
  }

  Future<List<String>> _getMnemonicList() async {
    final _mnemonicString = await mnemonicString;
    if (_mnemonicString == null) {
      return [];
    }
    final List<String> data = _mnemonicString.split(' ');
    return data;
  }

  Future<ElectrumXNode> getCurrentNode() async {
    final node = NodeService(secureStorageInterface: _secureStore)
            .getPrimaryNodeFor(coin: coin) ??
        DefaultNodes.getNodeFor(coin);

    return ElectrumXNode(
      address: node.host,
      port: node.port,
      name: node.name,
      useSSL: node.useSSL,
      id: node.id,
    );
  }

  // hack to add tx to txData before refresh completes
  // required based on current app architecture where we don't properly store
  // transactions locally in a good way
  @override
  Future<void> updateSentCachedTxData(Map<String, dynamic> txData) async {
    final transaction = isar_models.Transaction(
      walletId: walletId,
      txid: txData["txid"] as String,
      timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      type: isar_models.TransactionType.outgoing,
      subType: isar_models.TransactionSubType.none,
      // precision may be lost here hence the following amountString
      amount: (txData["recipientAmt"] as Amount).raw.toInt(),
      amountString: (txData["recipientAmt"] as Amount).toJsonString(),
      fee: txData["fee"] as int,
      height: null,
      isCancelled: false,
      isLelantus: false,
      otherData: null,
      slateId: null,
      nonce: null,
      inputs: [],
      outputs: [],
      numberOfMessages: null,
    );

    final address = txData["address"] is String
        ? await db.getAddress(walletId, txData["address"] as String)
        : null;

    await db.addNewTransactionData(
      [
        Tuple2(transaction, address),
      ],
      walletId,
    );
  }

  @override
  Future<List<isar_models.UTXO>> get utxos => db.getUTXOs(walletId).findAll();

  @override
  bool validateAddress(String address) {
    // TODO: implement validateAddress
    return true;
  }

  @override
  String get walletId => _walletId;
  late final String _walletId;
}
