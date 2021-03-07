import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store/flutter_store.dart';
import 'package:homeworkr/stores/stores.dart';

class CoinsWidget extends StatefulWidget {
  var coinsCount = 0;
  @override
  _CoinsWidgetState createState() => _CoinsWidgetState();
}

listenCoins() {}
class _CoinsWidgetState extends State<CoinsWidget> {
  @override
  Widget build(BuildContext context) {
    var ref = FirebaseFirestore.instance
        .collection("users")
        .where("UUID", isEqualTo: FirebaseAuth.instance.currentUser?.uid);
    return StreamBuilder<QuerySnapshot>(
      stream: ref.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return new ListView(
          children: snapshot.data.docs.map((DocumentSnapshot document) {
            return new ListTile(
              title: new Text(document.data()['full_name']),
              subtitle: new Text(document.data()['company']),
            );
          }).toList(),
        );
      },
    );
  }
}
