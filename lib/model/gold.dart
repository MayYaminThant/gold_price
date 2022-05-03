import 'dart:core';

class Gold {
  final String id;
  final String name;
  late final String imageUrl;
  final String goldShopPassword;
  final String sixteenPrice;
  final String fifteenPrice;
  final String phoneNo;
  final String website;
  final String facebook;
  final String createdDate;
  final String modifiedDate;
  late final String color;
  final List<String> sixteenPriceList;
  final List<String> fifteenPriceList;

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
}
