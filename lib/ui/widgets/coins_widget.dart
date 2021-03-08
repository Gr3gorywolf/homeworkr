import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store/flutter_store.dart';
import 'package:homeworkr/helpers/helper_functions.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:intl/intl.dart';

class CoinsWidget extends StatelessWidget {
  Color color;
  CoinsWidget(this.color);
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: Builder(builder: (ctx) {
        var _user = Stores.useUserStore(ctx);
        var _balance = HelperFunctions.formatNumber(_user.user.balance);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.money,
              color: color,
            ),
            SizedBox(
              width: 3,
            ),
            Text(
              "${_balance}",
              style: TextStyle(color: color),
            ),
            SizedBox(
              width: 5,
            ),
          ],
        );
      }),
      store: Stores.userStore,
    );
  }
}
