import 'dart:core';

class Gold {
  String id;
  String name;
  String imageUrl;
  String goldShopPassword;
  String sixteenPrice;
  String fifteenPrice;
  String phoneNo;
  String website;
  String facebook;
  String createdDate;
  String modifiedDate;
  String color;
  Map<String, String> sixteenPriceList;
  Map<String, String> fifteenPriceList;

  Gold({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.goldShopPassword,
    required this.sixteenPrice,
    required this.fifteenPrice,
    required this.phoneNo,
    required this.website,
    required this.facebook,
    required this.createdDate,
    required this.modifiedDate,
    required this.color,
    required this.sixteenPriceList,
    required this.fifteenPriceList,
  });

  isEqual(Gold object) {
    if (object.id == id &&
        object.name == name &&
        object.imageUrl == imageUrl &&
        object.goldShopPassword == goldShopPassword &&
        object.sixteenPrice == sixteenPrice &&
        object.fifteenPrice == fifteenPrice &&
        object.createdDate == createdDate &&
        object.modifiedDate == modifiedDate &&
        object.phoneNo == phoneNo &&
        object.website == website &&
        object.facebook == facebook &&
        object.createdDate == createdDate &&
        object.modifiedDate == modifiedDate &&
        object.color == color &&
        object.sixteenPriceList == sixteenPriceList &&
        object.fifteenPriceList == fifteenPriceList) {
      return true;
    } else {
      return false;
    }
  }

  factory Gold.fromJson(Map<String, dynamic> json) => Gold(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        imageUrl: json['imageUrl'] ?? '',
        goldShopPassword: json['goldShopPassword'] ?? '',
        sixteenPrice: json['sixteenPrice'] ?? '',
        fifteenPrice: json['fifteenPrice'] ?? '',
        createdDate: json['createdDate'] ?? '',
        modifiedDate: json['modifiedDate'] ?? '',
        phoneNo: json['phoneNo'] ?? '',
        website: json['website'] ?? '',
        facebook: json['facebook'] ?? '',
        color: json['color'] ?? '',
        sixteenPriceList: json['sixteenPriceList'] ?? <String, String>{},
        fifteenPriceList: json['fifteenPriceList'] ?? <String, String>{},
      );
}
