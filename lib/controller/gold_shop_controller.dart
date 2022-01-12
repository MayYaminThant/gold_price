import 'package:gold_price/model/gold.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class GoldShopController with ChangeNotifier {
  GoldShopController(this._goldShopSelectedIndex);

  int _goldShopSelectedIndex;
  int get goldShopSelectedIndex => _goldShopSelectedIndex;

  List<Gold> _goldShopLst = [];
  List<Gold> get goldShopLst => _goldShopLst;

  List<Gold> _filterGoldShopLst = [];
  List<Gold> get filterGoldShopLst => _filterGoldShopLst;

  String _searchTerm = "";
  String get searchTerm => _searchTerm;

  bool _isSortByName = true;
  bool get isSortByName => _isSortByName;

  bool _isAscending = true;
  bool get isAscending => _isAscending;

  Gold newGold = Gold(
    id: '0',
    name: '',
    imageUrl: '',
    goldShopPassword: '',
    sixteenPrice: '0',
    fifteenPrice: '0',
    phoneNo: '0',
    website: '',
    facebook: '',
    createdDate: '',
    modifiedDate: '',
    color: '',
  );

  Gold _currentEditGold = Gold(
    id: '',
    name: '',
    imageUrl: '',
    goldShopPassword: '',
    sixteenPrice: '',
    fifteenPrice: '',
    phoneNo: '',
    website: '',
    facebook: '',
    createdDate: '',
    modifiedDate: '',
    color: '',
  );
  Gold get currentEditGold => _currentEditGold;

  set currentEditGold(Gold currentEditGold) {
    if (_currentEditGold == currentEditGold) return;

    _currentEditGold = currentEditGold;

    notifyListeners();
  }

  resetCurrentEditGold() {
    _currentEditGold = Gold(
      id: '',
      name: '',
      imageUrl: '',
      goldShopPassword: '',
      sixteenPrice: '',
      fifteenPrice: '',
      phoneNo: '',
      website: '',
      facebook: '',
      createdDate: '',
      modifiedDate: '',
      color: '',
    );

    notifyListeners();
  }

  set searchTerm(String searchTerm) {
    if (_searchTerm == searchTerm) return;

    _searchTerm = searchTerm;
    setFilterGoldLst();

    notifyListeners();
  }

  set isSortByName(bool isSortByName) {
    if (isSortByName == _isSortByName) return;
    _isSortByName = isSortByName;
    getGoldShopData();
    notifyListeners();
  }

  set isAscending(bool isAscending) {
    if (isAscending == _isAscending) return;
    _isAscending = isAscending;
    getGoldShopData();
    notifyListeners();
  }

  set goldShopSelectedIndex(int goldShopSelectedIndex) {
    if (_goldShopSelectedIndex == goldShopSelectedIndex) return;
    _goldShopSelectedIndex = goldShopSelectedIndex;
    notifyListeners();
  }

  Future<void> getGoldShopData() async {
    _goldShopLst = [];
    _filterGoldShopLst = [];
    notifyListeners();
    FirebaseFirestore.instance
        .collection('goldShop')
        .orderBy(isSortByName ? 'name' : 'sixteen_price',
            descending: !isAscending)
        .get()
        .then((QuerySnapshot snapshot) async {
      _goldShopLst = [];
      _filterGoldShopLst = [];
      for (var element in snapshot.docs) {
        final ref = FirebaseStorage.instance
            .ref()
            .child(element.data()['imageUrl'].split('/').last);
        var url = await ref.getDownloadURL();

        var createdDate = getDate(element.data()['created_date']);
        var modifiedDate = getDate(element.data()['modified_date']);
        Gold goldObj = Gold(
          id: element.data()['id'],
          name: element.data()['name'],
          imageUrl: url,
          goldShopPassword: element.data()['gold_shop_password'] ?? '',
          sixteenPrice: element.data()['sixteen_price'] ?? '',
          fifteenPrice: element.data()['fifteen_price'] ?? '',
          phoneNo: element.data()['phoneNo'] ?? '',
          website: element.data()['website'] ?? '',
          facebook: element.data()['facebook'] ?? '',
          createdDate: createdDate,
          modifiedDate: modifiedDate,
          color: element.data()['color_hex'] ?? '',
        );
        var existingItem = _goldShopLst.firstWhere(
            (itemToCheck) => goldObj.isEqual(itemToCheck),
            orElse: () => newGold);
        if (existingItem.isEqual(newGold)) {
          _goldShopLst.add(goldObj);
          setFilterGoldLst();
        }
      }
      notifyListeners();
    });
  }

  // Future<void> checkGoldPassword(String id) async {
  //   _goldShopLst = [];
  //   _filterGoldShopLst = [];
  //   notifyListeners();
  //   FirebaseFirestore.instance
  //       .collection('goldShop')
  //       .where("id", isEqualTo: id)
  //       .where("gold_shop_password", isEqualTo: "123456")
  //       .get()
  //       .then((QuerySnapshot snapshot) async {

  //   });
  // }

  getDate(value) {
    var dateParse;
    if (value != null) {
      var date = value.toDate().toString();
      dateParse = DateFormat('yyyy-MM-dd').parse(date);
    }
    var dateFormat =
        value != null ? DateFormat('yyyy-MM-dd').format(dateParse) : '';
    return dateFormat;
  }

  setFilterGoldLst() {
    if (searchTerm.isEmpty) {
      _filterGoldShopLst = _goldShopLst;
      notifyListeners();
    } else {
      _filterGoldShopLst = [];
      notifyListeners();
      for (Gold gold in goldShopLst) {
        if (gold.name.toLowerCase().contains(searchTerm.toLowerCase())) {
          _filterGoldShopLst.add(gold);
        }
      }
      notifyListeners();
    }
  }
}
