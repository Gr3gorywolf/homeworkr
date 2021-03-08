import 'package:flutter/material.dart';
import 'package:homeworkr/helpers/helper_functions.dart';
import 'package:homeworkr/models/homework.dart';

class HomeworkStatusWidget extends StatelessWidget {
  String homeworkStatus;
  HomeworkStatusWidget(this.homeworkStatus);
  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;
    String text = "Abierta";
    switch (homeworkStatus) {
      case "pendiente":
        text = "Pendiente";
        break;
      case "confirmed":
        color = Colors.orange;
        text = "Confirmada";
        break;
      case "completed":
        color = Colors.green;
        text = "Completada";
        break;
    }
    return Chip(
      backgroundColor: color,
      label: Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}
