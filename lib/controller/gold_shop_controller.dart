import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gold_price/model/gold.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../common/common_widget.dart';

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

  bool _isEditing = true;
  bool get isEditing => _isEditing;

  // ignore: prefer_final_fields
  Image _goldImage = Image.asset('assets/images/4.jpg');
  Image get goldImage => _goldImage;

  set goldImage(Image pickedFile) {
    if (_goldImage == pickedFile) return;
    _goldImage = pickedFile;
    notifyListeners();
  }

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
    sixteenPriceList: <String, String>{},
    fifteenPriceList: <String, String>{},
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
    sixteenPriceList: <String, String>{},
    fifteenPriceList: <String, String>{},
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
      sixteenPriceList: <String, String>{},
      fifteenPriceList: <String, String>{},
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

  set isEditing(bool isEditing) {
    if (isEditing == _isEditing) return;
    _isEditing = isEditing;
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

        var createdDate = getModifiedDateFormat(element.data()['created_date']);
        var modifiedDate =
            getModifiedDateFormat(element.data()['modified_date']);
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
          sixteenPriceList:
              element.data()['sixteen_price_list'].cast<String, String>() ??
                  <String, String>{},
          fifteenPriceList:
              element.data()['fifteen_price_list'].cast<String, String>() ??
                  <String, String>{},
        );
        var existingItem = _goldShopLst.firstWhere(
            (itemToCheck) => goldObj.isEqual(itemToCheck),
            orElse: () => newGold);
        if (existingItem.isEqual(newGold)) {
          _goldShopLst.add(goldObj);
          setFilterGoldLst();
        }
        notifyListeners();
      }
    });
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

  static void checkGoldPassword(
    String id,
    String password,
    VoidCallback successCallback,
    VoidCallback failureCallback,
  ) {
    FirebaseFirestore.instance
        .collection('goldShop')
        .where("id", isEqualTo: id)
        .where("gold_shop_password", isEqualTo: password)
        .get()
        .then((QuerySnapshot snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        successCallback.call();
      } else {
        failureCallback.call();
      }
    });
  }

  updateGoldData(
    BuildContext context,
    String id,
    Map<String, dynamic> data,
  ) {
    FocusManager.instance.primaryFocus?.unfocus();
    FirebaseFirestore.instance
        .collection('goldShop')
        .doc(id)
        .update(data)
        .then((_) {
      currentEditGold = Gold.fromJson(data);

      showSimpleSnackBar(
        context,
        'Updated Successful',
        Colors.green.shade200,
      );
      getGoldShopData();
      notifyListeners();
    }).catchError(
      (error) {
        log('Update failed: $error');
        showSimpleSnackBar(
          context,
          'Update failed: $error',
          Colors.green.shade200,
        );
      },
    );
  }

  Future uploadPic(
    BuildContext context,
    ImageSource source,
    GoldShopController controller,
  ) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: source,
      );
      final String fileName = path.basename(pickedFile!.path);
      File imageFile = File(pickedFile.path);
      try {
        await storage.ref(fileName).putFile(imageFile).then((snapshot) =>
            currentEditGold.imageUrl = snapshot.ref.getDownloadURL() as String);
      } on FirebaseException catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  void refreshData() {
    notifyListeners();
  }
}
