import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homeworkr/models/user.dart';

class UserRepository {
  CollectionReference get reference {
    return FirebaseFirestore.instance.collection("users");
  }

  Future setBalance(String uuid, int balance) async {
    var result = await reference
        .where("UUID", isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get();
    if (result.docs.length > 0) {
      await result.docs.first.reference.update({"balance": balance});
    }
  }

  Future<AppUser> getUser(String uuid) async {
    var user = await reference.where("UUID", isEqualTo: uuid).get();

    if (user.docs.length > 0) {
      return AppUser.fromJson(user.docs.first.data());
    } else {
      return null;
    }
  }

  Future<List<AppUser>> getUsers(List<String> uuids) async {
    print(uuids);
    var collection =
        await reference.where("UUID", whereIn: uuids).get();
    List<AppUser> users = [];
    for (var doc in collection.docs) {
      users.add(AppUser.fromJson(doc.data()));
    }
    return users;
  }
}
