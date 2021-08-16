import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:homeworkr/helpers/alerts_helpers.dart';
import 'package:homeworkr/helpers/helper_functions.dart';
import 'package:homeworkr/models/homework.dart';
import 'package:homeworkr/repository/homework_repository.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/pages/homework_detail/homework_detail_page.dart';
import 'package:homeworkr/ui/widgets/custom_form_field.dart';
import 'package:homeworkr/ui/widgets/custom_icon_button.dart';

class HomeworkFormPage extends StatefulWidget {
  @override
  _HomeworkFormPageState createState() => _HomeworkFormPageState();
}

class _HomeworkFormPageState extends State<HomeworkFormPage> {
  var _formKey = GlobalKey<FormState>();
  var _homework = Homework();
  var _homeworkCategory = "";
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
    _homeworkCategory = Stores.subjectStore.subjects.first;
    _homework = Homework(
        categories: [Stores.subjectStore.subjects.first],
        authorId: Stores.userStore.user.uUID,
        status: HelperFunctions.parseEnumVal(HomeworkStatus.open));
  }

  submitForm() async {
    var isValid = _formKey.currentState.validate();
    if (isValid) {
      if (_homework.price > Stores.userStore.user.balance) {
        AlertsHelpers.showSnackbar(
            context, "No posee balance suficiente para publicar esta tarea");
        return;
      }
      setState(() {
        _isLoading = true;
      });
      _homework.categories = [_homeworkCategory];
      try {
       var ref =  await HomeworkRepository().createHomework(_homework);
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => HomeworkDetailPage(ref.id)));
      } catch (err) {
        AlertsHelpers.showSnackbar(context, "Error al crear la tarea");
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
          title: Text("Nueva tarea"),
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
                                "Crear nueva tarea",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                              SizedBox(height: 30),
                              CustomFormField(
                                textInputAction: TextInputAction.next,
                                validator: ValidationBuilder()
                                    .required()
                                    .minLength(4)
                                    .maxLength(45)
                                    .build(),
                                label: "Titulo",
                                maxLength: 45,
                                onChanged: (text) => _homework.title = text,
                              ),
                              SizedBox(height: 22),
                              CustomFormField(
                                textInputAction: TextInputAction.next,
                                initialValue: 0.toString(),
                                validator:
                                    ValidationBuilder().required().build(),
                                label: "Precio",
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: false, signed: false),
                                onChanged: (text) =>
                                    _homework.price = int.parse(text),
                              ),
                              SizedBox(height: 22),
                              InputDecorator(
                                decoration:
                                    CustomFormField.decorator("Materia"),
                                child: DropdownButton<String>(
                                    underline: Container(),
                                    isDense: true,
                                    isExpanded: true,
                                    value: _homeworkCategory,
                                    items: Stores.subjectStore.subjects
                                        .map((String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (_) {
                                      setState(() {
                                      _homeworkCategory = _;
                                      });
                                    }),
                              ),
                              SizedBox(height: 22),
                              CustomFormField(
                                textInputAction: TextInputAction.done,
                                validator: ValidationBuilder()
                                    .required()
                                    .minLength(4)
                                    .maxLength(180)
                                    .build(),
                                label: "Descripcion",
                                maxLength: 180,
                                maxLines: 5,
                                minLines: 5,
                                onChanged: (text) =>
                                    _homework.description = text,
                              ),
                              SizedBox(height: 22),
                            ],
                          ),
                        ),
                      ),
                      CustomIconButton(
                        isLoading: _isLoading,
                        onPressed: submitForm,
                        text: "Publicar tarea",
                        textColor: Colors.white,
                        backgroundColor: Colors.teal,
                      )
                    ])))));
  }
}
