import 'package:flutter/material.dart';

class HomeworkFormPage extends StatefulWidget {
  @override
  _HomeworkFormPageState createState() => _HomeworkFormPageState();
}

class _HomeworkFormPageState extends State<HomeworkFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      centerTitle: true,
      title: Text("Nueva tarea"),
    ));
  }
}
