import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:homeworkr/helpers/alerts_helpers.dart';
import 'package:homeworkr/helpers/helper_functions.dart';
import 'package:homeworkr/models/application.dart';
import 'package:homeworkr/models/homework.dart';
import 'package:homeworkr/repository/homework_repository.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/widgets/custom_form_field.dart';
import 'package:homeworkr/ui/widgets/custom_icon_button.dart';

class HomeworkApplicationForm extends StatefulWidget {
  String homeworkId;
  HomeworkApplicationForm(this.homeworkId);
  @override
  _HomeworkApplicationFormState createState() =>
      _HomeworkApplicationFormState();
}

class _HomeworkApplicationFormState extends State<HomeworkApplicationForm> {
  var _formKey = GlobalKey<FormState>();
  var _application = Application();
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
    _application = Application(
        authorId: Stores.userStore.user.uUID,
        status: HelperFunctions.parseEnumVal(ApplicationStatus.pending));
  }

  submitForm() async {
    var isValid = _formKey.currentState.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        var ref = await HomeworkRepository()
            .applyToHomework(widget.homeworkId, _application);
        Navigator.of(context).pop();
        AlertsHelpers.showSnackbar(context, "Aplicacion enviada exitosamente",
            title: "Exito", icon: Icons.check);
      } catch (err) {
        AlertsHelpers.showSnackbar(context, "Error al enviar la aplicacion");
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _screen = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Nueva aplicación"),
        ),
        body: Form(
            key: _formKey,
            child: Center(
                child: Container(
                    width: _screen.width * 0.8,
                    padding: EdgeInsets.only(top: 25, bottom: 10),
                    child: Column(children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Enviar aplicación",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                              SizedBox(height: 22),
                              CustomFormField(
                                textInputAction: TextInputAction.done,
                                validator: ValidationBuilder()
                                    .required()
                                    .minLength(4)
                                    .maxLength(180)
                                    .build(),
                                label:
                                    "Por que debe ser seleccionado para realizar esta tarea",
                                maxLength: 180,
                                maxLines: 5,
                                minLines: 5,
                                onChanged: (text) => _application.reason = text,
                              ),
                              SizedBox(height: 22),
                            ],
                          ),
                        ),
                      ),
                      CustomIconButton(
                        isLoading: _isLoading,
                        onPressed: submitForm,
                        text: "Enviar aplicación",
                        textColor: Colors.white,
                        backgroundColor: Colors.teal,
                      )
                    ])))));
  }
}
