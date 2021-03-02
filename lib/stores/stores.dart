import 'package:flutter/cupertino.dart';
import 'package:flutter_store/provider.dart';
import 'package:homeworkr/stores/user_store.dart';

class Stores {
  static final userStore = UserStore();
  static UserStore useUserStore(BuildContext context) {
    return Provider.of<UserStore>(context);
  }

}
