import 'package:flutter/material.dart';

class GoldTypeController with ChangeNotifier {
  GoldTypeController(this._goldTypeSelectedIndex);

  int _goldTypeSelectedIndex;
  int get goldTypeSelectedIndex => _goldTypeSelectedIndex;

  set goldTypeSelectedIndex(int goldTypeSelectedIndex) {
    if (_goldTypeSelectedIndex == goldTypeSelectedIndex) return;
    _goldTypeSelectedIndex = goldTypeSelectedIndex;
    notifyListeners();
  }
}
