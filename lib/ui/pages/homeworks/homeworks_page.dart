import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homeworkr/helpers/helper_functions.dart';
import 'package:homeworkr/models/homework.dart';
import 'package:homeworkr/models/user.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/pages/homework_detail/homework_detail_page.dart';
import 'package:homeworkr/ui/pages/homework_form/homework_form_page.dart';
import 'package:homeworkr/ui/pages/homeworks/widgets/homework_filter.dart';
import 'package:homeworkr/ui/pages/homeworks/widgets/homework_item.dart';
import 'package:homeworkr/ui/widgets/loadable_content.dart';
import 'package:homeworkr/ui/widgets/placeholder.dart';

class HomeworksPage extends StatefulWidget {
  @override
  _HomeworksPageState createState() => _HomeworksPageState();
}

class _HomeworksPageState extends State<HomeworksPage> {
  String _selectedFilter = "Todas";
  goToHomeworkForm() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => HomeworkFormPage()));
  }

  List<String> get filters {
    List<String> vals = [];
    if (Stores.userStore.userRole == UserRoles.student) {
      vals = HomeworkStatus.values
          .map((a) => HelperFunctions.parseEnumVal(a))
          .toList();
    }

    if (Stores.userStore.userRole == UserRoles.mentor) {
      vals = ["Para ti"].toList();
    }
    return vals;
  }

  Query get query {
    Query qr = null;
    if (Stores.userStore.userRole == UserRoles.student) {
      qr = FirebaseFirestore.instance
          .collection('homeworks')
          .where('authorId', isEqualTo: Stores.userStore.user.uUID);
    } else {
      if (Stores.userStore.user.categories.length > 0) {
        qr = FirebaseFirestore.instance.collection('homeworks');
      }
    }
    return qr;
  }

  List<QueryDocumentSnapshot> filterDocs(List<QueryDocumentSnapshot> docs) {
    List<QueryDocumentSnapshot> returning = [];
    for (var doc in docs) {
      Homework data = Homework.fromJson(doc.data());
      //estudiante
      if (Stores.userStore.userRole == UserRoles.student) {
        if (_selectedFilter == 'Todas') {
          returning.add(doc);
        } else {
          if (data.status == _selectedFilter) {
            returning.add(doc);
          }
        }
      }
      //mentor
      else {
        var selectedApp = data.selectedAplication;
        if (selectedApp == null ||
            selectedApp?.authorId == Stores.userStore.user.uUID) {
          if (_selectedFilter == 'Todas') {
            returning.add(doc);
          } else {
            if (Stores.userStore.user.categories
                .contains(data.categories.first)) {
              returning.add(doc);
            }
          }
        }
      }
    }
    return returning;
  }

  List<Homework> getHomeworks(List<QueryDocumentSnapshot> docs) {
    List<Homework> _homeworks = [];
    for (var doc in docs) {
      _homeworks.add(Homework.fromJson(doc.data()));
    }
    return _homeworks;
  }

  @override
  Widget build(BuildContext context) {
    var _user = Stores.useUserStore(context);
    return Scaffold(
        body: query == null
            ? Container()
            : StreamBuilder<QuerySnapshot>(
                stream: query.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    child: Column(
                      children: [
                        HomeworkFilter(
                            categories: filters,
                            selectedItem: _selectedFilter,
                            onSelectionChanged: (sel) {
                              setState(() {
                                _selectedFilter = sel;
                              });
                            }),
                        Expanded(
                            child:
                                HomeworksList(filterDocs(snapshot.data.docs))),
                      ],
                    ),
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
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          return FadeIn(
              child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            HomeworkDetailPage(homeworks[index].id)));
                  },
                  child: HomeworkItem(
                      Homework.fromJson(homeworks[index].data()))));
        });
  }
}
