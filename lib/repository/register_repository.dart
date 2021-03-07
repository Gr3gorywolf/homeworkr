import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homeworkr/models/user.dart';

class RegisterRepository {
  registerCurrentUserWithRole(UserRoles role) async {
    var instance = FirebaseFirestore.instance.collection("users");

    var query = await instance
        .where("UUID", isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get();
    var user = FirebaseAuth.instance.currentUser;
    if (query.docs.length == 0) {
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
}
