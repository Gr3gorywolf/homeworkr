import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_store/flutter_store.dart';
import 'package:homeworkr/models/application.dart';
import 'package:homeworkr/models/homework.dart';
import 'package:homeworkr/models/user.dart';
import 'package:homeworkr/repository/homework_repository.dart';
import 'package:homeworkr/repository/user_repository.dart';

class CurrentHomeworkStore extends Store {
  Homework _homework = null;
  String _homeworkId = null;
  StreamSubscription<QuerySnapshot> applicationsListener = null;
  List<Application> _applications = [];
  List<AppUser> _applicants = [];
  AppUser get acceptedApplicant=> _applicants.firstWhere(
      (element) => homework.selectedAplication?.authorId == element.uUID);
  Homework get homework => _homework;
  String get homeworkId => _homeworkId;
  List<Application> get applications => _applications;
  List<AppUser> get applicants => _applicants;
  setHomework(Homework homework, String homeworkId) {
    setState(() {
      _homework = homework;
      _homeworkId = homeworkId;
    });
  }

  clearCurentHomework() {
    setState(() {
      _homework = homework;
      _homeworkId = homeworkId;
      _applications = [];
      _applicants = [];
    });
  }

  listenApplications(Function callback) {
    bool isFirstTime = true;
    applicationsListener = HomeworkRepository()
        .reference
        .doc(_homeworkId)
        .collection("applications")
        .snapshots()
        .listen((event) async {
      List<Application> apps = [];
      List<String> userIds = [];
      List<AppUser> users = [];
      for (var doc in event.docs) {
        apps.add(Application.fromJson(doc.data()));
        userIds.add(doc.data()['authorId']);
      }
      if (apps.length != _applications.length) {
        users = await UserRepository().getUsers(userIds);
      } else {
        users = _applicants;
      }
      setState(() {
        _applications = apps;
        _applicants = users;
      });
      if (isFirstTime) {
        callback();
        isFirstTime = false;
      }
    }, onError: (err) {
      callback();
    });
  }

  stopListeningApplications() {
    if (applicationsListener != null) {
      applicationsListener.cancel();
    }
  }
}
