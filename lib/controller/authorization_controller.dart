import 'package:cloud_firestore/cloud_firestore.dart';

class AuthorizationController {
  AuthorizationController();

  static Future<int?> getAuthorization(String id) async {
    final result = await FirebaseFirestore.instance
        .collection('authorization')
        .doc(id)
        .get();
    if (result.data() == null) {
      return null;
    }

    return result.data()!['permission'];
  }

  static Future<void> updateAuthorizationCount(String authorizedKey) async {
    await FirebaseFirestore.instance
        .collection('authorization')
        .doc(authorizedKey)
        .update({'permission': 1});
  }
}
