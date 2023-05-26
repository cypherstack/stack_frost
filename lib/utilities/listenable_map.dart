import 'package:flutter/foundation.dart';

class ListenableMap<T1, T2> extends ChangeNotifier {
  final Map<T1, T2> _map = {};

  int get length => _map.length;
  bool get isNotEmpty => length > 0;
  bool get isEmpty => length == 0;

  Iterable<T1> get keys => _map.keys;
  Iterable<T2> get values => _map.values;

  void add(T1 key, T2 value, bool shouldNotifyListeners) {
    _map[key] = value;
    if (shouldNotifyListeners) {
      notifyListeners();
    }
  }

  T2? remove(T1 key, bool shouldNotifyListeners) {
    final value = _map.remove(key);
    if (shouldNotifyListeners) {
      notifyListeners();
    }
    return value;
  }

  T2? operator [](T1 key) => _map[key];

  void operator []=(T1 key, T2 value) {
    _map[key] = value;
    notifyListeners();
  }
}
