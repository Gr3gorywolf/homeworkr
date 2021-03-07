import 'package:flutter_store/store.dart';
import 'package:flutter/material.dart';
class AppStore extends Store {
  restartApp(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
