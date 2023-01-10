import 'package:flutter/cupertino.dart';
import 'package:stackwallet/hive/db.dart';
import 'package:stackwallet/models/buy/response_objects/buy.dart';

class BuysService extends ChangeNotifier {
  List<Buy> get Buys {
    final list = DB.instance.values<Buy>(boxName: DB.boxNameBuys);
    list.sort((a, b) =>
        b.timestamp.millisecondsSinceEpoch -
        a.timestamp.millisecondsSinceEpoch);
    return list;
  }

  Buy? get(String BuyId) {
    try {
      return DB.instance
          .values<Buy>(boxName: DB.boxNameBuys)
          .firstWhere((e) => e.BuyId == BuyId);
    } catch (_) {
      return null;
    }
  }

  Future<void> add({
    required Buy Buy,
    required bool shouldNotifyListeners,
  }) async {
    await DB.instance
        .put<Buy>(boxName: DB.boxNameBuys, key: Buy.uuid, value: Buy);

    if (shouldNotifyListeners) {
      notifyListeners();
    }
  }

  Future<void> edit({
    required Buy Buy,
    required bool shouldNotifyListeners,
  }) async {
    if (DB.instance.get<Buy>(boxName: DB.boxNameBuys, key: Buy.uuid) == null) {
      throw Exception("Attempted to edit a Buy that does not exist in Hive!");
    }

    // add overwrites so this edit function is just a wrapper with an extra check
    await add(Buy: Buy, shouldNotifyListeners: shouldNotifyListeners);
  }

  Future<void> delete({
    required Buy Buy,
    required bool shouldNotifyListeners,
  }) async {
    await deleteByUuid(
        uuid: Buy.uuid, shouldNotifyListeners: shouldNotifyListeners);
  }

  Future<void> deleteByUuid({
    required String uuid,
    required bool shouldNotifyListeners,
  }) async {
    await DB.instance.delete<Buy>(boxName: DB.boxNameBuys, key: uuid);

    if (shouldNotifyListeners) {
      notifyListeners();
    }
  }
}
