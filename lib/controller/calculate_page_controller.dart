import 'package:flutter/material.dart';
import 'package:gold_price/model/calculating_gold.dart';

class CalulatePageController with ChangeNotifier {
  CalulatePageController();
  double _todayGoldPrice = 0;
  double get todayGoldPrice => _todayGoldPrice;

  set todayGoldPrice(double todayGoldPrice) {
    if (_todayGoldPrice == todayGoldPrice) return;

    _todayGoldPrice = todayGoldPrice;

    notifyListeners();
  }

  double _calculatedAmount = 0;
  double get calculatedAmount => _calculatedAmount;

  set calculatedAmount(double calculatedAmount) {
    if (_calculatedAmount == calculatedAmount) return;

    _calculatedAmount = calculatedAmount;

    notifyListeners();
  }

  bool _calculateGoldType = false;
  bool get calculateGoldType => _calculateGoldType;

  set calculateGoldType(bool calculateGoldType) {
    if (_calculateGoldType == calculateGoldType) return;

    _calculateGoldType = calculateGoldType;

    notifyListeners();
  }

  CalculatingGold _calculatingGold = CalculatingGold();
  CalculatingGold get calculatingGold => _calculatingGold;

  set calculatingGold(CalculatingGold calculatingGold) {
    if (_calculatingGold == calculatingGold) return;

    _calculatingGold = calculatingGold;

    notifyListeners();
  }
}
