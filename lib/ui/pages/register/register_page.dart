import 'package:flutter/material.dart';
import 'package:homeworkr/helpers/alerts_helpers.dart';
import 'package:homeworkr/models/user.dart';
import 'package:homeworkr/repository/register_repository.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/widgets/custom_icon_button.dart';
import 'package:homeworkr/ui/widgets/loadable_content.dart';
import 'package:homeworkr/ui/widgets/scrollabe_body.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _isLoading = false;

  setLoading(bool val) {
    setState(() {
      _isLoading = val;
    });
  }

  registerWithRole(UserRoles role) async {
    var repo = new RegisterRepository();
    setLoading(true);
    try {
      await repo.registerCurrentUserWithRole(role);
      await Stores.userStore.login();
      Stores.appStore.restartApp(context);
    } catch (err) {
      AlertsHelpers.showErrorSnackbar(context, exception: err);
    }
    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Para que usara la aplicación"),
      ),
      body: ScrollableBody(
        child: Container(
          child: Center(
            child: LoadableContent(
              isLoading: _isLoading,
              progressColor: Colors.teal,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _RegisterItem(
                    icon: Icons.school,
                    subTitle:
                        "Deseo ayudar a estudiantes a completar sus tareas",
                    buttonText: "Soy un mentor",
                    action: () {
                      registerWithRole(UserRoles.mentor);
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  _RegisterItem(
                    icon: Icons.menu_book,
                    subTitle: "Deseo solicitar ayuda con mis tareas",
                    buttonText: "Soy un estudiante",
                    action: () {
                      registerWithRole(UserRoles.student);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterItem extends StatelessWidget {
  String subTitle;
  String buttonText;
  IconData icon;

  Function action;
  _RegisterItem(
      {this.subTitle, this.buttonText, this.icon, this.action, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Icon(
            icon,
            size: 45,
            color: Colors.grey,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              width: 240,
              child: Text(
                subTitle,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 300,
            child: CustomIconButton(
              onPressed: action,
              rounded: true,
              text: buttonText,
              textColor: Colors.white,
              isIconLeftAligned: true,
              hasRightArrow: true,
              backgroundColor: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }
}
