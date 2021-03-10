import 'package:flutter/material.dart';
import 'package:homeworkr/helpers/alerts_helpers.dart';
import 'package:homeworkr/models/homework.dart';
import 'package:homeworkr/models/user.dart';
import 'package:homeworkr/repository/homework_repository.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/pages/homework_detail/widgets/homework_applicants_counter.dart';
import 'package:homeworkr/ui/widgets/custom_icon_button.dart';

class HomeworkStatusStepper extends StatefulWidget {
  Homework homework;
  Function onRequestShowApplications;
  HomeworkStatusStepper(this.homework, {this.onRequestShowApplications});

  @override
  _HomeworkStatusStepperState createState() => _HomeworkStatusStepperState();
}

class _HomeworkStatusStepperState extends State<HomeworkStatusStepper> {
  markAsCompleted() async {
    setState(() {
      _isLoading = true;
    });
    await HomeworkRepository()
        .markHomeworkAsCompleted(Stores.currentHomeworkStore.homeworkId);
    AlertsHelpers.showSnackbar(context, "Tarea completada y pagada!");
    setState(() {
      _isLoading = false;
    });
  }

  var _isLoading = false;
  int get _currentStep {
    return widget.homework.workProgress;
  }

  bool get canEdit {
    return Stores.userStore.userRole == UserRoles.student;
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(
        type: StepperType.vertical,
        physics: ScrollPhysics(),
        currentStep: _currentStep,
        controlsBuilder: (BuildContext context,
            {onStepContinue, onStepCancel}) {
          return Container();
        },
        steps: <Step>[
          Step(
            title: new Text('Abierta'),
            subtitle: Text("Esperando por mentores"),
            content: Container(),
            isActive: _currentStep >= 0,
            state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: new Text('Pendiente'),
            subtitle: Text("Hay mentores esperando por ser aceptados"),
            content: Container(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                        child: HomeworkApplicantsCounter(
                            Stores.currentHomeworkStore.homeworkId)),
                    TextButton(
                      onPressed: widget.onRequestShowApplications,
                      child: Text("Ver aplicaciones"),
                    )
                  ],
                ),
              ),
            ),
            isActive: _currentStep >= 1,
            state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: new Text('En proceso'),
            subtitle: Text("Se ha seleccionado un mentor"),
            content: canEdit
                ? Container(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconButton(
                            textColor: Colors.white,
                            backgroundColor: Colors.teal,
                            rounded: true,
                            isLoading: _isLoading,
                            icon: Icons.check,
                            isIconLeftAligned: true,
                            text: "Marcar como completada",
                            onPressed: () {
                              AlertsHelpers.showAlert(context, "Atención",
                                  "Una vez se marque esta tarea como completada se procesara el pago. Esta accion no puede deshacerse. \n Esta seguro?",
                                  cancelable: true,
                                  acceptTitle: "Si", callback: () {
                                markAsCompleted();
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
            isActive: _currentStep >= 2,
            state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
          ),
          Step(
            title: new Text('Completada'),
            subtitle: Text("La tarea ha sido completada y pagada"),
            content: Container(),
            isActive: _currentStep >= 3,
            state: _currentStep >= 3 ? StepState.complete : StepState.disabled,
          ),
        ]);
  }
}
