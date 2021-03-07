import 'package:flutter/material.dart';
import 'package:homeworkr/models/user.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/pages/homework_form/homework_form.dart';

class HomeworksPage extends StatefulWidget {
  @override
  _HomeworksPageState createState() => _HomeworksPageState();
}

class _HomeworksPageState extends State<HomeworksPage> {
  goToHomeworkForm() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => HomeworkFormPage()));
  }

  @override
  Widget build(BuildContext context) {
    var _user = Stores.useUserStore(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Tareas"),
        ),
        floatingActionButton: _user.userRole == UserRoles.student
            ? FloatingActionButton(
                backgroundColor: Colors.teal,
                child: Icon(Icons.add, color: Colors.white),
                onPressed: goToHomeworkForm,
              )
            : null);
  }
}
