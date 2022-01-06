import 'package:flutter/material.dart';

class CalulatePageController with ChangeNotifier {
  CalulatePageController();
  String _result = '';
  String get result => _result;

  set result(String result) {
    if (_result == result) return;

    _result = result;

    notifyListeners();
  }

  bool _calculateGoldType = false;
  bool get calculateGoldType => _calculateGoldType;

  set calculateGoldType(bool calculateGoldType) {
    if (_calculateGoldType == calculateGoldType) return;

    _calculateGoldType = calculateGoldType;

    notifyListeners();
  }
}
