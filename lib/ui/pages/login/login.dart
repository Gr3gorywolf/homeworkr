import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:homeworkr/ui/widgets/custom_icon_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Iniciar Sesion"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(),
          ),
          CustomIconButton(
            onPressed: () {},
            text: "Iniciar sesion",
            textColor: Colors.black,
            backgroundColor: Colors.white,
            isIconLeftAligned: true,
            icon: FontAwesomeIcons.google,
          )
        ],
      ),
    );
  }
}
