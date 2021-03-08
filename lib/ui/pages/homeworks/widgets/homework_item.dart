import 'package:flutter/material.dart';
import 'package:homeworkr/models/homework.dart';
import 'package:homeworkr/stores/stores.dart';

class HomeworkItem extends StatelessWidget {
  Homework homework;
  HomeworkItem(this.homework);
  Icon get categoryIcon {
    return Stores.subjectStore.getSubjectIcon(homework.categories.first);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: categoryIcon,
      title: Text(homework.title),
      subtitle: Text(homework.description),
    ));
  }
}
