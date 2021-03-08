import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homeworkr/helpers/alerts_helpers.dart';
import 'package:homeworkr/models/homework.dart';
import 'package:homeworkr/models/user.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/pages/homework_detail/widgets/homework_info.dart';
import 'package:homeworkr/ui/pages/homeworks/homeworks.dart';
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

  onFetched() {
    bool amISelected = false;
    if (_homework.selectedAplication != null) {
      amISelected =
          _homework.selectedAplication.authorId == Stores.userStore.user.uUID;
    }
    if (Stores.userStore.userRole == UserRoles.mentor &&
        _homework.status == "confirmed" &&
        !amISelected) {
      AlertsHelpers.showAlert(
          context, "Error", "El acceso a esta orden esta restringido",
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
    return Stores.userStore.userRole == UserRoles.mentor &&
        _homework.status == "open";
  }

  bool get canPayJob {
    return Stores.userStore.userRole == UserRoles.student &&
        _homework.status == "confirmed";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: query.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return CustomPlaceholder(
              "Sin internet",
              Icons.error,
              actionTitle: "Reconectar",
              action: () {
                this.build(context);
              },
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadableContent(isLoading: true, child: Container());
          }
          _homework = Homework.fromJson(snapshot.data.data());
          onFetched();
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: ScrollableBody(
                        hasToolbar: false, child: HomeworkInfo(_homework))),
                SizedBox(
                  height: 9,
                ),

                //Apply button
                if (canApply)
                  CustomIconButton(
                    onPressed: () {
                      // completeProfile();
                    },
                    text: "Aplicar",
                    textColor: Colors.white,
                    backgroundColor: Colors.teal,
                  ),
                //Mark job as paid
                if (canPayJob)
                  CustomIconButton(
                    onPressed: () {
                      // completeProfile();
                    },
                    text: "Marcar como completada",
                    textColor: Colors.white,
                    backgroundColor: Colors.teal,
                  ),
                //go to room buttom
                if (_homework.status == "confirmed")
                  CustomIconButton(
                    onPressed: () {
                      // completeProfile();
                    },
                    text: "Ir a la sala",
                    textColor: Colors.white,
                    backgroundColor: Colors.teal,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
