import 'package:flutter/material.dart';
import 'package:homeworkr/models/homework.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/pages/homework_detail/widgets/homework_applicants_counter.dart';

class HomeworkStatusStepper extends StatelessWidget {
  Homework homework;
  Function onRequestShowApplications;
  HomeworkStatusStepper(this.homework, {this.onRequestShowApplications});
  int get _currentStep {
    return homework.workProgress;
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
                    Center(child: HomeworkApplicantsCounter(Stores.currentHomeworkStore.homeworkId)),
                    TextButton(onPressed: onRequestShowApplications,child: Text("Ver aplicaciones"),)
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
            content: Container(),
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
