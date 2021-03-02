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

  setUser(AppUser user) async {
    setState(() {
      _user = user;
    });
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
