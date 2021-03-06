import 'package:flutter/cupertino.dart';
import 'package:flutter_store/provider.dart';
import 'package:homeworkr/stores/app_store.dart';
import 'package:homeworkr/stores/current_homework_store.dart';
import 'package:homeworkr/stores/subject_store.dart';
import 'package:homeworkr/stores/user_store.dart';

class Stores {
  static final userStore = UserStore();
  static UserStore useUserStore(BuildContext context) {
    return Provider.of<UserStore>(context);
  }

  static final subjectStore = SubjectStore();
  static SubjectStore useSubjectStore(BuildContext context) {
    return Provider.of<SubjectStore>(context);
  }

  static final appStore = AppStore();
   static AppStore useAppStore(BuildContext context) {
    return Provider.of<AppStore>(context);
  }

  static final currentHomeworkStore = CurrentHomeworkStore();
   static CurrentHomeworkStore useCurrentHomeworkStore(BuildContext context) {
    return Provider.of<CurrentHomeworkStore>(context);
  }
}
