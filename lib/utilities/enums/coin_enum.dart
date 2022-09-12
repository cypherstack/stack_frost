import 'package:stackwallet/services/coins/bitcoin/bitcoin_wallet.dart' as btc;
import 'package:stackwallet/services/coins/dogecoin/dogecoin_wallet.dart'
    as doge;
import 'package:stackwallet/services/coins/epiccash/epiccash_wallet.dart'
    as epic;
import 'package:stackwallet/services/coins/firo/firo_wallet.dart' as firo;
import 'package:stackwallet/services/coins/monero/monero_wallet.dart' as xmr;
import 'package:stackwallet/services/coins/bitcoincash/bitcoincash_wallet.dart'
    as bch;

enum Coin {
  bitcoin,
  bitcoincash,
  dogecoin,
  epicCash,
  firo,
  monero,
  namecoin,

  ///
  ///
  ///

  bitcoinTestNet,
  dogecoinTestNet,
  firoTestNet,
}

// remove firotestnet for now
const int kTestNetCoinCount = 2;

extension CoinExt on Coin {
  String get prettyName {
    switch (this) {
      case Coin.bitcoin:
        return "Bitcoin";
      case Coin.bitcoincash:
        return "Bitcoin Cash";
      case Coin.dogecoin:
        return "Dogecoin";
      case Coin.epicCash:
        return "Epic Cash";
      case Coin.firo:
        return "Firo";
      case Coin.monero:
        return "Monero";
      case Coin.namecoin:
        return "Namecoin";
      case Coin.bitcoinTestNet:
        return "tBitcoin";
      case Coin.firoTestNet:
        return "tFiro";
      case Coin.dogecoinTestNet:
        return "tDogecoin";
    }
  }

  String get ticker {
    switch (this) {
      case Coin.bitcoin:
        return "BTC";
      case Coin.bitcoincash:
        return "BCH";
      case Coin.dogecoin:
        return "DOGE";
      case Coin.epicCash:
        return "EPIC";
      case Coin.firo:
        return "FIRO";
      case Coin.monero:
        return "XMR";
      case Coin.bitcoinTestNet:
        return "tBTC";
      case Coin.firoTestNet:
        return "tFIRO";
      case Coin.dogecoinTestNet:
        return "tDOGE";
    }
  }

  String get uriScheme {
    switch (this) {
      case Coin.bitcoin:
        return "bitcoin";
      case Coin.bitcoincash:
        return "bitcoincash";
      case Coin.dogecoin:
        return "dogecoin";
      case Coin.epicCash:
        // TODO: is this actually the right one?
        return "epic";
      case Coin.firo:
        return "firo";
      case Coin.monero:
        return "monero";
      case Coin.bitcoinTestNet:
        return "bitcoin";
      case Coin.firoTestNet:
        return "firo";
      case Coin.dogecoinTestNet:
        return "dogecoin";
    }
  }

  bool get isElectrumXCoin {
    switch (this) {
      case Coin.bitcoin:
      case Coin.bitcoincash:
      case Coin.dogecoin:
      case Coin.firo:
      case Coin.bitcoinTestNet:
      case Coin.firoTestNet:
      case Coin.dogecoinTestNet:
        return true;

      case Coin.epicCash:
      case Coin.monero:
        return false;
    }
  }

  int get requiredConfirmations {
    switch (this) {
      case Coin.bitcoin:
      case Coin.bitcoinTestNet:
        return btc.MINIMUM_CONFIRMATIONS;

      case Coin.bitcoincash:
        return bch.MINIMUM_CONFIRMATIONS;

      case Coin.firo:
      case Coin.firoTestNet:
        return firo.MINIMUM_CONFIRMATIONS;

      case Coin.dogecoin:
      case Coin.dogecoinTestNet:
        return doge.MINIMUM_CONFIRMATIONS;

      case Coin.epicCash:
        return epic.MINIMUM_CONFIRMATIONS;

      case Coin.monero:
        return xmr.MINIMUM_CONFIRMATIONS;
    }
  }
}

Coin coinFromPrettyName(String name) {
  switch (name) {
    case "Bitcoin":
    case "bitcoin":
      return Coin.bitcoin;
    case "Bitcoincash":
    case "bitcoincash":
    case "Bitcoin Cash":
      return Coin.bitcoincash;
    case "Dogecoin":
    case "dogecoin":
      return Coin.dogecoin;
    case "Epic Cash":
    case "epicCash":
      return Coin.epicCash;
    case "Firo":
    case "firo":
      return Coin.firo;
    case "Monero":
    case "monero":
      return Coin.monero;
    case "Bitcoin Testnet":
    case "tBitcoin":
    case "bitcoinTestNet":
      return Coin.bitcoinTestNet;
    case "Firo Testnet":
    case "tFiro":
    case "firoTestNet":
      return Coin.firoTestNet;
    case "Dogecoin Testnet":
    case "tDogecoin":
    case "dogecoinTestNet":
      return Coin.dogecoinTestNet;
    default:
      throw ArgumentError.value(
          name, "name", "No Coin enum value with that prettyName");
  }
}

Coin coinFromTickerCaseInsensitive(String ticker) {
  switch (ticker.toLowerCase()) {
    case "btc":
      return Coin.bitcoin;
    case "bch":
      return Coin.bitcoincash;
    case "doge":
      return Coin.dogecoin;
    case "epic":
      return Coin.epicCash;
    case "firo":
      return Coin.firo;
    case "xmr":
      return Coin.monero;
    case "tbtc":
      return Coin.bitcoinTestNet;
    case "tfiro":
      return Coin.firoTestNet;
    case "tdoge":
      return Coin.dogecoinTestNet;
    default:
      throw ArgumentError.value(
          ticker, "name", "No Coin enum value with that ticker");
  }
}
