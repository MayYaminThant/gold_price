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

  set goldShopSelectedIndex(int goldShopSelectedIndex) {
    if (_goldShopSelectedIndex == goldShopSelectedIndex) return;
    _goldShopSelectedIndex = goldShopSelectedIndex;
    notifyListeners();
  }

  Future<void> getGoldShopData() async {
    _goldShopLst = [];
    notifyListeners();
    FirebaseFirestore.instance
        .collection('goldShop')
        .orderBy('created_date')
        .get()
        .then((QuerySnapshot snapshot) async {
      _goldShopLst = [];
      for (var element in snapshot.docs) {
        final ref = FirebaseStorage.instance
            .ref()
            .child(element.data()['imageUrl'].split('/').last);
        var url = await ref.getDownloadURL();

        var createdDate = getDate(element.data()['created_date']);
        var modifiedDate = getDate(element.data()['modified_date']);
        _goldShopLst.add(
          Gold(
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
          ),
        );
      }
      notifyListeners();
    });
  }

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
}
