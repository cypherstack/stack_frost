import 'dart:convert';

import 'package:stackwallet/models/node_model.dart';
import 'package:stackwallet/utilities/enums/coin_enum.dart';

abstract class DefaultNodes {
  static const String defaultNodeIdPrefix = "default_";
  static String _nodeId(Coin coin) => "$defaultNodeIdPrefix${coin.name}";
  static const String defaultName = "Stack Default";

  static List<NodeModel> get all => [
        bitcoin,
        litecoin,
        dogecoin,
        firo,
        monero,
        epicCash,
        bitcoincash,
        namecoin,
        wownero,
        bitcoinTestnet,
        litecoinTestNet,
        bitcoincashTestnet,
        dogecoinTestnet,
        firoTestnet,
      ];

  static NodeModel get bitcoin => NodeModel(
        host: "bitcoin.stackwallet.com",
        port: 50002,
        name: defaultName,
        id: _nodeId(Coin.bitcoin),
        useSSL: true,
        enabled: true,
        coinName: Coin.bitcoin.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get litecoin => NodeModel(
        host: "litecoin.stackwallet.com",
        port: 20063,
        name: defaultName,
        id: _nodeId(Coin.litecoin),
        useSSL: true,
        enabled: true,
        coinName: Coin.litecoin.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get litecoinTestNet => NodeModel(
        host: "litecoin.stackwallet.com",
        port: 51002,
        name: defaultName,
        id: _nodeId(Coin.litecoinTestNet),
        useSSL: true,
        enabled: true,
        coinName: Coin.litecoinTestNet.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get bitcoincash => NodeModel(
        host: "bitcoincash.stackwallet.com",
        port: 50002,
        name: defaultName,
        id: _nodeId(Coin.bitcoincash),
        useSSL: true,
        enabled: true,
        coinName: Coin.bitcoincash.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get dogecoin => NodeModel(
        host: "dogecoin.stackwallet.com",
        port: 50022,
        name: defaultName,
        id: _nodeId(Coin.dogecoin),
        useSSL: true,
        enabled: true,
        coinName: Coin.dogecoin.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get firo => NodeModel(
        host: "firo.stackwallet.com",
        port: 50002,
        name: defaultName,
        id: _nodeId(Coin.firo),
        useSSL: true,
        enabled: true,
        coinName: Coin.firo.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get monero => NodeModel(
        host: "https://monero.stackwallet.com",
        port: 18081,
        name: defaultName,
        id: _nodeId(Coin.monero),
        useSSL: true,
        enabled: true,
        coinName: Coin.monero.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get wownero => NodeModel(
        host: "https://wownero.stackwallet.com",
        port: 34568,
        name: defaultName,
        id: _nodeId(Coin.wownero),
        useSSL: true,
        enabled: true,
        coinName: Coin.wownero.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get epicCash => NodeModel(
        host: "http://epiccash.stackwallet.com",
        port: 3413,
        name: defaultName,
        id: _nodeId(Coin.epicCash),
        useSSL: false,
        enabled: true,
        coinName: Coin.epicCash.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get namecoin => NodeModel(
        host: "namecoin.stackwallet.com",
        port: 57002,
        name: defaultName,
        id: _nodeId(Coin.namecoin),
        useSSL: true,
        enabled: true,
        coinName: Coin.namecoin.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get particl => NodeModel(
      host: "host",
      port: 123,
      name: defaultName,
      id: _nodeId(Coin.particl),
      useSSL: true,
      enabled: true,
      coinName: Coin.particl.name,
      isFailover: true,
      isDown: false); //TODO - UPDATE WITH CORRECT DETAILS

  static NodeModel get bitcoinTestnet => NodeModel(
        host: "electrumx-testnet.cypherstack.com",
        port: 51002,
        name: defaultName,
        id: _nodeId(Coin.bitcoinTestNet),
        useSSL: true,
        enabled: true,
        coinName: Coin.bitcoinTestNet.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get firoTestnet => NodeModel(
        host: "firo-testnet.stackwallet.com",
        port: 50002,
        name: defaultName,
        id: _nodeId(Coin.firoTestNet),
        useSSL: true,
        enabled: true,
        coinName: Coin.firoTestNet.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get dogecoinTestnet => NodeModel(
        host: "dogecoin-testnet.stackwallet.com",
        port: 50022,
        name: defaultName,
        id: _nodeId(Coin.dogecoinTestNet),
        useSSL: true,
        enabled: true,
        coinName: Coin.dogecoinTestNet.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get bitcoincashTestnet => NodeModel(
        host: "bitcoincash-testnet.stackwallet.com",
        port: 60002,
        name: defaultName,
        id: _nodeId(Coin.bitcoincashTestnet),
        useSSL: true,
        enabled: true,
        coinName: Coin.bitcoincashTestnet.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel get particlTestnet => NodeModel(
        host: "host",
        port: 60002,
        name: defaultName,
        id: _nodeId(Coin.particlTestNet),
        useSSL: true,
        enabled: true,
        coinName: Coin.particlTestNet.name,
        isFailover: true,
        isDown: false,
      );

  static NodeModel getNodeFor(Coin coin) {
    switch (coin) {
      case Coin.bitcoin:
        return bitcoin;

      case Coin.litecoin:
        return litecoin;

      case Coin.bitcoincash:
        return bitcoincash;

      case Coin.dogecoin:
        return dogecoin;

      case Coin.epicCash:
        return epicCash;

      case Coin.firo:
        return firo;

      case Coin.monero:
        return monero;

      case Coin.wownero:
        return wownero;

      case Coin.namecoin:
        return namecoin;

      case Coin.particl:
        return namecoin;

      case Coin.bitcoinTestNet:
        return bitcoinTestnet;

      case Coin.litecoinTestNet:
        return litecoinTestNet;

      case Coin.bitcoincashTestnet:
        return bitcoincashTestnet;

      case Coin.firoTestNet:
        return firoTestnet;

      case Coin.dogecoinTestNet:
        return dogecoinTestnet;

      case Coin.particlTestNet:
        return particlTestnet;
    }
  }

  static final String defaultEpicBoxConfig = jsonEncode({
    "domain": "209.127.179.199",
    "port": 13420,
  });
}
