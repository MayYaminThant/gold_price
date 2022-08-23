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

  File? _pickedImageFile;
  File? get pickedImageFile => _pickedImageFile;

  // ignore: prefer_final_fields
  Image _goldImage = Image.asset('assets/images/no_image_available.jpg');
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

  Gold _goldForDetail = Gold(
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
  Gold get goldForDetail => _goldForDetail;

  set goldForDetail(Gold goldForDetail) {
    if (_goldForDetail == goldForDetail) return;

    _goldForDetail = goldForDetail;

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

  set pickedImageFile(File? pickedImageFile) {
    if (pickedImageFile == _pickedImageFile) return;
    _pickedImageFile = pickedImageFile;
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
        String url;
        try {
          url = await ref.getDownloadURL();
        } catch (e) {
          url = '';
        }

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
          sixteenPriceList: element.data()['sixteen_price_list'] != null
              ? element.data()['sixteen_price_list'].cast<String, String>()
              : <String, String>{},
          fifteenPriceList: element.data()['fifteen_price_list'] != null
              ? element.data()['fifteen_price_list'].cast<String, String>()
              : <String, String>{},
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

  Future<void> listenGoldShopDatabase() async {
    FirebaseFirestore.instance
        .collection('goldShop')
        .orderBy(isSortByName ? 'name' : 'sixteen_price',
            descending: !isAscending)
        .snapshots()
        .listen((event) {
      if (event.docChanges.isNotEmpty) {
        for (int i = 0; i < event.docChanges.length; i++) {
          if (event.docChanges[i].doc.data() != null) {
            Gold gold = Gold.fromFirebase(event.docChanges[i].doc.data()!);
            _goldShopLst
                .removeWhere((itemToCheck) => gold.id == itemToCheck.id);

            _goldShopLst.add(gold);
          }
        }
      }
      setFilterGoldLst();
      // log(event.docChanges.toString());
    });
  }

  setFilterGoldLst() {
    if (searchTerm.isEmpty) {
      _filterGoldShopLst = _goldShopLst;
    } else {
      _filterGoldShopLst = [];
      notifyListeners();
      for (Gold gold in goldShopLst) {
        if (gold.name.toLowerCase().contains(searchTerm.toLowerCase())) {
          _filterGoldShopLst.add(gold);
        }
      }
    }
    notifyListeners();
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

  updateGoldData(String id, Map<String, dynamic> data, bool isUpdatedImage,
      String imageDownloadUrl,
      {VoidCallback? successCallback,
      Function(dynamic error)? failureCallback}) {
    FocusManager.instance.primaryFocus?.unfocus();
    Map<String, dynamic> updateData = Map<String, dynamic>.from(data);
    if (!isUpdatedImage) {
      updateData.remove('imageUrl');
    }
    FirebaseFirestore.instance
        .collection('goldShop')
        .doc(id)
        .update(updateData)
        .then((_) {
      if (isUpdatedImage) {
        data['imageUrl'] = imageDownloadUrl;
      }
      currentEditGold = Gold.fromFirebase(data);
      successCallback?.call();
      getGoldShopData();
      notifyListeners();
    }).catchError(
      (error) {
        log('Update failed: $error');
        failureCallback?.call(error);
      },
    );
  }

  insertGoldData(
      Map<String, dynamic> data, bool isInsertedImage, String imageDownloadUrl,
      {VoidCallback? successCallback,
      Function(dynamic error)? failureCallback}) {
    FocusManager.instance.primaryFocus?.unfocus();
    Map<String, dynamic> insertData = Map<String, dynamic>.from(data);
    if (!isInsertedImage) {
      insertData.remove('imageUrl');
    }

    FirebaseFirestore.instance
        .collection('goldShop')
        .add(data)
        .then((documentSnapshot) {
      updateGoldData(
        documentSnapshot.id,
        {"id": documentSnapshot.id},
        isInsertedImage,
        imageDownloadUrl,
        successCallback: successCallback,
        failureCallback: failureCallback,
      );
    }).catchError(
      (error) {
        log('Insert failed: $error');
        failureCallback?.call(error);
      },
    );
  }

  deleteGoldData(String id,
      {VoidCallback? successCallback,
      Function(dynamic error)? failureCallback}) {
    FocusManager.instance.primaryFocus?.unfocus();
    FirebaseFirestore.instance
        .collection('goldShop')
        .doc(id)
        .delete()
        .then((_) {
      successCallback?.call();
      getGoldShopData();
      notifyListeners();
    }).catchError(
      (error) {
        log('Delete failed: $error');
        failureCallback?.call(error);
      },
    );
  }

  void fetchInsertOrUpdateGold(Gold? gold, Map<String, dynamic> data,
      bool isInsertedOrUpdatedImage, String imageDownloadUrl,
      {VoidCallback? successCallback,
      Function(dynamic error)? failureCallback}) {
    if (gold == null || gold.id.isEmpty || gold.id == '0') {
      insertGoldData(
        data,
        isInsertedOrUpdatedImage,
        imageDownloadUrl,
        successCallback: successCallback,
        failureCallback: failureCallback,
      );
    } else {
      updateGoldData(
        gold.id,
        data,
        isInsertedOrUpdatedImage,
        imageDownloadUrl,
        successCallback: successCallback,
        failureCallback: failureCallback,
      );
    }
  }

  void pickImage(
    BuildContext context,
    ImageSource source,
    GoldShopController controller,
  ) async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: source,
      );
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        pickedImageFile = imageFile;
        isEditing = true;
      }
    } catch (err) {
      if (kDebugMode) {
        log(err.toString());
      }
    }
  }

  Future<String> uploadPic(BuildContext context) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    if (pickedImageFile == null) {
      showSimpleSnackBar(context, "Your picked image is invalid!", Colors.red);
      return "";
    }

    try {
      final String fileName = path.basename(pickedImageFile!.path);
      File imageFile = File(pickedImageFile!.path);
      try {
        var snapshot = await storage.ref(fileName).putFile(imageFile);

        var medaData = await snapshot.ref.getMetadata();
        var oldImageUrl = currentEditGold.imageUrl;
        currentEditGold.imageUrl =
            'gs://${medaData.bucket ?? ''}/${medaData.fullPath}';

        if (oldImageUrl.isNotEmpty) {
          await storage.refFromURL(oldImageUrl).delete();
        }
        return await snapshot.ref.getDownloadURL();
      } on FirebaseException catch (e) {
        if (kDebugMode) {
          log(e.toString());
        }
      }
      return "";
    } catch (err) {
      if (kDebugMode) {
        log(err.toString());
      }
      return "";
    }
  }

  void refreshData() {
    notifyListeners();
  }
}
