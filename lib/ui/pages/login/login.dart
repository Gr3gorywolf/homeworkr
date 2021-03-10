import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:homeworkr/helpers/alerts_helpers.dart';
import 'package:homeworkr/helpers/auth_helpers.dart';
import 'package:homeworkr/models/user.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/pages/register/register.dart';
import 'package:homeworkr/ui/widgets/custom_icon_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _loading = false;
  setLoading(bool val) {
    setState(() {
      _loading = val;
    });
  }

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      init();
    }
  }

  init() async {
    setLoading(true);
    try {
      await Stores.userStore.login();
    } catch (err) {}
    setLoading(false);
  }

  login() async {
    setLoading(true);
    try {
      var result = await AuthHelpers.signInWithGoogle();
      var snapShot = await FirebaseFirestore.instance
          .collection("users")
          .where("UUID", isEqualTo: result.user.uid)
          .get();
      //no hay usuario
      if (snapShot.docs.length == 0) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => RegisterPage()));
      }
      //va al home
      else {
        await Stores.userStore.login();
      }
    } on StateError catch (err) {
      AlertsHelpers.showSnackbar(context, err.message);
    } on Exception catch (ex) {
       AlertsHelpers.showSnackbar(context, ex.toString());
    }
    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Iniciar Sesion"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FadeInUp(
              duration: Duration(milliseconds: 700),
              child: Container(
                height: 300,
                width: 300,
                child: Image.asset("assets/img/logo.png"),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(45),
            child: FadeInUp(
              delay: Duration(milliseconds: 800),
              duration: Duration(milliseconds: 700),
              child: CustomIconButton(
                onPressed: () {
                  login();
                },
                rounded: true,
                isLoading: _loading,
                text: "Iniciar sesion",
                textColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColorDark,
                isIconLeftAligned: true,
                icon: FontAwesomeIcons.google,
              ),
            ),
          )
        ],
      ),
    );
  }
}
