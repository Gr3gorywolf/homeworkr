import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store/flutter_store.dart';
import 'package:homeworkr/models/homework.dart';
import 'package:homeworkr/models/homework.dart';
import 'package:homeworkr/repository/homework_repository.dart';
import 'package:homeworkr/stores/stores.dart';

class HomeworkApplicantsCounter extends StatefulWidget {
  String homeworkId;
  HomeworkApplicantsCounter(this.homeworkId);

  @override
  _HomeworkApplicantsCounterState createState() =>
      _HomeworkApplicantsCounterState();
}

class _HomeworkApplicantsCounterState extends State<HomeworkApplicantsCounter> {
  CollectionReference get reference {
    HomeworkRepository()
        .reference
        .doc(widget.homeworkId)
        .collection("applications");
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      store: Stores.currentHomeworkStore,
      child: Builder(
        builder: (ctx) {
          var _homework = Stores.useCurrentHomeworkStore(ctx);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.supervisor_account_rounded),
              SizedBox(
                width: 3,
              ),
              Text(_homework.applications.length.toString())
            ],
          );
        },
      ),
    );
  }
}
