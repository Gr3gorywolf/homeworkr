import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homeworkr/models/homework.dart';
import 'package:homeworkr/models/user.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/pages/homework_detail/homework_detail.dart';
import 'package:homeworkr/ui/pages/homework_form/homework_form.dart';
import 'package:homeworkr/ui/pages/homeworks/widgets/homework_item.dart';
import 'package:homeworkr/ui/widgets/loadable_content.dart';
import 'package:homeworkr/ui/widgets/placeholder.dart';

class HomeworksPage extends StatefulWidget {
  @override
  _HomeworksPageState createState() => _HomeworksPageState();
}

class _HomeworksPageState extends State<HomeworksPage> {
  goToHomeworkForm() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => HomeworkFormPage()));
  }

  Query get query {
    if (Stores.userStore.userRole == UserRoles.student) {
      return FirebaseFirestore.instance
          .collection('homeworks')
          .where('authorId', isEqualTo: Stores.userStore.user.uUID);
    } else {
      return FirebaseFirestore.instance.collection('homeworks').where(
          'categories',
          arrayContainsAny: Stores.userStore.user.categories);
    }
  }

  List<Homework> getHomeworks(List<QueryDocumentSnapshot> docs) {
    List<Homework> _homeworks = [];
    for (var doc in docs) {
      print(doc.data());
      _homeworks.add(Homework.fromJson(doc.data()));
    }
    return _homeworks;
  }

  @override
  Widget build(BuildContext context) {
    var _user = Stores.useUserStore(context);
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: query.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: HomeworksList(snapshot.data.docs),
            );
          },
        ),
        floatingActionButton: _user.userRole == UserRoles.student
            ? FloatingActionButton(
                backgroundColor: Colors.teal,
                child: Icon(Icons.add, color: Colors.white),
                onPressed: goToHomeworkForm,
              )
            : null);
  }
}

class HomeworksList extends StatelessWidget {
  List<QueryDocumentSnapshot> homeworks = [];
  HomeworksList(this.homeworks);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: homeworks.length,
        itemBuilder: (ctx, index) {
          return FadeIn(
              child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomeworkDetail(homeworks[index].id)));
                  },
                  child: HomeworkItem(
                      Homework.fromJson(homeworks[index].data()))));
        });
  }
}
