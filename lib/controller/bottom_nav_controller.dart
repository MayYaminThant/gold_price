import 'package:flutter/material.dart';

class BottomNavController with ChangeNotifier {
  BottomNavController(this._selectedIndex);
  int _selectedIndex;
  int get selectedIndex => _selectedIndex;

  set selectedIndex(int selectedIndex) {
    if (_selectedIndex == selectedIndex) return;
    _selectedIndex = selectedIndex;
    notifyListeners();
  }
}
