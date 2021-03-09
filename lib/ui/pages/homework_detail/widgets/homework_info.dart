import 'package:flutter/material.dart';
import 'package:homeworkr/helpers/helper_functions.dart';
import 'package:homeworkr/models/homework.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/pages/homework_detail/widgets/homework_applicants_counter.dart';
import 'package:homeworkr/ui/pages/homework_detail/widgets/homework_status_stepper.dart';
import 'package:homeworkr/ui/widgets/horizontal_line.dart';

class HomeworkInfo extends StatelessWidget {
  Homework homework;
  Function onRequestShowApplications;
  HomeworkInfo(this.homework, {this.onRequestShowApplications});
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
    return Column(
      children: [
        icon,
        SizedBox(
          height: 16,
        ),
        ListTile(
            title: Text("Estado"),
            subtitle: HomeworkStatusStepper(
              homework,
              onRequestShowApplications: onRequestShowApplications,
            )),
        HorizontalLine(),
        ListTile(
            title: Text("Aplicaciones"),
            subtitle: Row(
              children: [
                HomeworkApplicantsCounter(
                  Stores.currentHomeworkStore.homeworkId,
                ),
                TextButton(
                    onPressed: onRequestShowApplications,
                    child: Text("Ver aplicaciones"))
              ],
            )),
        HorizontalLine(),
        ListTile(
            title: Text("Descripcion"), subtitle: Text(homework.description)),
        HorizontalLine(),
        ListTile(
            title: Text("Paga"),
            subtitle: Text(HelperFunctions.formatNumber(homework.price))),
        HorizontalLine(),
        ListTile(
            title: Text("Categorias"),
            subtitle: Row(children: categoriesChips)),
        HorizontalLine(),
      ],
    );
  }
}
