import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_store/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homeworkr/models/user.dart';

class UserStore extends Store {
  String _idToken = null;
  AppUser _user = null;
  String get token => _idToken;

  AppUser get user => _user;
  bool get userLogged => _user != null;
  setToken(String token) {
    setState(() {
      _idToken = token;
    });
  }


  refreshToken() async {
    if (_user != null) {
      var token = await FirebaseAuth.instance.currentUser.getIdToken();
      setState(() {
        _idToken = token;
      });
    }
  }
  



  UserRoles get userRole {
    for (var role in UserRoles.values) {
      if (user.role == role.toString().split('.').last) {
        return role;
      }
    }
  }

  setUser(AppUser user) async {
    setState(() {
      _user = user;
    });
  }

  login() async {
    var result = await FirebaseFirestore.instance
        .collection("users")
        .where("UUID", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (result.docs.length > 0) {
      setUser(AppUser.fromJson(result.docs.first.data()));
    } else {
      throw Exception("Usuario no encontrado");
    }
  }

  logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (err) {}
    setState(() {
      _user = null;
      _idToken = null;
    });
  }
}
