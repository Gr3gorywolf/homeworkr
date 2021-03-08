import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homeworkr/models/user.dart';

class RegisterRepository {
  Future<QuerySnapshot> _getCollection() async {
    var instance = FirebaseFirestore.instance.collection("users");
    return await instance
        .where("UUID", isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get();
  }

  registerCurrentUserWithRole(UserRoles role) async {
    var instance = FirebaseFirestore.instance.collection("users");

    var collection = await _getCollection();
    var user = FirebaseAuth.instance.currentUser;
    if (collection.docs.length == 0) {
      return await instance.add(AppUser(
              uUID: user.uid,
              bio: "",
              avatar: user.photoURL,
              lastName: user.displayName,
              firstName: user.displayName,
              balance: 0,
              categories: [],
              role: role.toString().split('.').last)
          .toJson());
    } else {
      throw new Exception("El usuario ya existe");
    }
  }

  setUserPreferredCategories(List<String> categories) async {
    var collection = await _getCollection();
    if (collection.docs.length == 0) {
      throw new Exception("El usuario no existe");
    } else {
      return await collection.docs.first.reference
          .update({'categories': categories});
    }
  }
}
