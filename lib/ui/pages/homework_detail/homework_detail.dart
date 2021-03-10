import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homeworkr/helpers/alerts_helpers.dart';
import 'package:homeworkr/models/homework.dart';
import 'package:homeworkr/models/user.dart';
import 'package:homeworkr/repository/homework_repository.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/pages/homework_detail/widgets/applications_bottom_sheet.dart';
import 'package:homeworkr/ui/pages/homework_detail/widgets/homework_info.dart';
import 'package:homeworkr/ui/pages/homework_form/homework_application_form.dart';
import 'package:homeworkr/ui/pages/homeworks/homeworks.dart';
import 'package:homeworkr/ui/pages/workroom/workroom.dart';
import 'package:homeworkr/ui/widgets/custom_icon_button.dart';
import 'package:homeworkr/ui/widgets/loadable_content.dart';
import 'package:homeworkr/ui/widgets/placeholder.dart';
import 'package:homeworkr/ui/widgets/scrollabe_body.dart';

class HomeworkDetail extends StatefulWidget {
  String homeworkId;
  HomeworkDetail(this.homeworkId);
  @override
  _HomeworkDetailState createState() => _HomeworkDetailState();
}

class _HomeworkDetailState extends State<HomeworkDetail> {
  Homework _homework = null;
  bool isLoading = true;
  bool isAppling = false;
  bool hasErrors = false;
  StreamSubscription<DocumentSnapshot> listener;
  @override
  void initState() {
    super.initState();
    listenHomework();
  }

  @override
  void dispose() {
    super.dispose();
    Stores.currentHomeworkStore.clearCurentHomework();
    stopListeningHomework();
    Stores.currentHomeworkStore.stopListeningApplications();
  }

  listenHomework() {
    listener = query.snapshots().listen((event) {
      print(event.data());
      if (event.data() != null) {
        print(event.data());
        _homework = Homework.fromJson(event.data());
        setState(() {
          _homework;
        });
        Stores.currentHomeworkStore.setHomework(_homework, widget.homeworkId);
        Stores.currentHomeworkStore.listenApplications(() {
          onFetched();
        });
      } else {
        AlertsHelpers.showAlert(
            context, "Error", "No se ha encontrado la tarea");
        setState(() {
          hasErrors = true;
        });
      }
    }, onError: (err) {
      setState(() {
        hasErrors = true;
      });
    });
  }

  stopListeningHomework() {
    if (listener != null) {
      listener.cancel();
    }
  }

  onFetched() {
    setState(() {
      isLoading = false;
      hasErrors = false;
    });

    bool amISelected = false;
    if (_homework.selectedAplication != null) {
      amISelected =
          _homework.selectedAplication.authorId == Stores.userStore.user.uUID;
    }
    if (Stores.userStore.userRole == UserRoles.mentor &&
        _homework.status == "confirmed" &&
        !amISelected) {
      AlertsHelpers.showAlert(
          context, "Error", "El acceso a esta tarea esta restringido",
          cancelable: false, acceptTitle: "Salir", callback: () {
        Navigator.pop(context);
      });
    }
  }

  DocumentReference get query {
    return FirebaseFirestore.instance
        .collection("homeworks")
        .doc(widget.homeworkId);
  }

  String get title {
    if (_homework != null) {
      return _homework.title;
    } else {
      return "Detalles de la tarea";
    }
  }

  bool get canApply {
    if (_homework == null) {
      return false;
    }
    return Stores.userStore.userRole == UserRoles.mentor &&
        (["open", "pending"].contains(_homework.status));
  }
 

  bool get canGoToRoom {
    if (_homework == null) {
      return false;
    }
    return _homework.status == "confirmed";
  }

  handleShowApplications() async {
    ApplicationsBottomSheet.show(context, _homework);
  }

  handleSendApplication() async {
    setState(() {
      isAppling = true;
    });
    var collection = await query.collection("applications").get();
    bool canSendApplication = true;
    for (var doc in collection.docs) {
      if (doc.data()['authorId'] == Stores.userStore.user.uUID) {
        canSendApplication = false;
        break;
      }
    }
    if (canSendApplication) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              HomeworkApplicationForm(widget.homeworkId)));
    } else {
      AlertsHelpers.showAlert(
          context, "Error", "Ya usted ha enviado una aplicacion a esta tarea");
    }
    setState(() {
      isAppling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Builder(
        builder: (BuildContext context) {
          if (hasErrors) {
            return CustomPlaceholder(
              "Sin internet",
              Icons.error,
              actionTitle: "Reconectar",
              action: () {
                this.build(context);
              },
            );
          }
          if (isLoading) {
            return LoadableContent(isLoading: true, child: Container());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                          child: HomeworkInfo(
                    _homework,
                    onRequestShowApplications: handleShowApplications,
                  ))),
                  SizedBox(
                    height: 9,
                  ),
                  //Apply button
                  if (canApply)
                    CustomIconButton(
                      onPressed: () {
                        handleSendApplication();
                      },
                      isLoading: isLoading,
                      text: "Aplicar",
                      textColor: Colors.white,
                      backgroundColor: Colors.teal,
                    ),
                  //go to room buttom
                  if (canGoToRoom)
                    CustomIconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                WorkRoomPage(_homework.roomId)));
                      },
                      text: "Ir a la sala",
                      textColor: Colors.white,
                      backgroundColor: Colors.teal,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
