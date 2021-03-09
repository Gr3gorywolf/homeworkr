import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homeworkr/helpers/alerts_helpers.dart';
import 'package:homeworkr/models/work_room.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/pages/workroom/widgets/videocall.dart';
import 'package:homeworkr/ui/widgets/loadable_content.dart';
import 'package:homeworkr/ui/widgets/placeholder.dart';

class WorkRoomPage extends StatefulWidget {
  String workRoomId;
  WorkRoomPage(this.workRoomId);
  @override
  _WorkRoomPageState createState() => _WorkRoomPageState();
}

class _WorkRoomPageState extends State<WorkRoomPage> {
  WorkRoom _workRoom = null;
  bool isLoading = true;
  bool isAppling = false;
  bool hasErrors = false;
  StreamSubscription<DocumentSnapshot> listener;

  @override
  void initState() {
    super.initState();
    listenWorkRoom();
  }

  @override
  void dispose() {
    super.dispose();
    Stores.currentHomeworkStore.clearCurentHomework();
    stopListeningHomework();
    Stores.currentHomeworkStore.stopListeningApplications();
  }

  listenWorkRoom() {
    listener = query.snapshots().listen((event) {
      print(event.data());
      if (event.data() != null) {
        _workRoom = WorkRoom.fromJson(event.data());
        setState(() {
          _workRoom;
          isLoading = false;
        });
      } else {
        AlertsHelpers.showAlert(
            context, "Error", "No se ha encontrado la sala de tareas");
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
  }

  DocumentReference get query {
    return FirebaseFirestore.instance
        .collection("workrooms")
        .doc(widget.workRoomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sala de tareas"),
        ),
        body: Builder(builder: (BuildContext context) {
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
          return VideoCall(_workRoom.videoCallId);
        }));
  }
}
