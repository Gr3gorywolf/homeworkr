import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_store/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homeworkr/models/user.dart';

class UserStore extends Store {
  String _idToken = null;
  AppUser _user = null;
  String get token => _idToken;
  StreamSubscription<DocumentSnapshot> _listenSubscription = null;
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

  enableUserWatching() async {
    var result = await FirebaseFirestore.instance
        .collection("users")
        .where("UUID", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (result.docs.length > 0) {
      _listenSubscription =
          result.docs.first.reference.snapshots().listen((event) {
        setUser(AppUser.fromJson(event.data()));
      });
    }
  }

  disableUserWatching() {
    if (_listenSubscription != null) {
      _listenSubscription.cancel();
      _listenSubscription = null;
    }
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
      if (!kIsWeb) {
      FirebaseMessaging.instance.unsubscribeFromTopic(this.user.uUID);
      }
      disableUserWatching();
    } catch (err) {}
    setState(() {
      _user = null;
      _idToken = null;
    });
  }
}
