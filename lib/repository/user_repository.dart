import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  Future setBalance(String uuid, int balance) async {
    var instance = FirebaseFirestore.instance.collection("users");
    var result = await instance
        .where("UUID", isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get();
    if (result.docs.length > 0) {
      await result.docs.first.reference.update({"balance": balance});
    }
  }
}
