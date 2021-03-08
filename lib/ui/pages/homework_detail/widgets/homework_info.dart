import 'package:flutter/material.dart';
import 'package:homeworkr/helpers/helper_functions.dart';
import 'package:homeworkr/models/homework.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/widgets/homework_status.dart';

class HomeworkInfo extends StatelessWidget {
  Homework homework;
  HomeworkInfo(this.homework);
  Icon get icon {
    return Stores.subjectStore
        .getSubjectIcon(homework.categories.first, size: 45);
  }

  List<Chip> get categoriesChips {
    return homework.categories
        .map((e) => Chip(
              label: Text(e),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            SizedBox(
              height: 16,
            ),
            ListTile(
                title: Text("Estado"),
                subtitle: Row(
                  children: [
                    HomeworkStatusWidget(homework.status),
                  ],
                )),
            ListTile(
                title: Text("Descripcion"),
                subtitle: Text(homework.description)),
            ListTile(
                title: Text("Categorias"),
                subtitle: Row(children: categoriesChips)),
            ListTile(
                title: Text("Paga"),
                subtitle: Text(HelperFunctions.formatNumber(homework.price))),
            ListTile(
                title: Text("Aplicaciones"),
                subtitle: Text(HelperFunctions.formatNumber(
                    homework.applications.length))),
          ],
        ),
      ),
    );
  }
}
