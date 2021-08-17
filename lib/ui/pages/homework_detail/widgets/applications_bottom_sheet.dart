import 'package:flutter/material.dart';
import 'package:flutter_store/flutter_store.dart';
import 'package:homeworkr/helpers/alerts_helpers.dart';
import 'package:homeworkr/helpers/helper_functions.dart';
import 'package:homeworkr/models/application.dart';
import 'package:homeworkr/models/homework.dart';
import 'package:homeworkr/models/user.dart';
import 'package:homeworkr/repository/homework_repository.dart';
import 'package:homeworkr/repository/notifications_repository.dart';
import 'package:homeworkr/repository/user_repository.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/pages/profile/profile_page.dart';
import 'package:homeworkr/ui/widgets/custom_icon_button.dart';
import 'package:homeworkr/ui/widgets/horizontal_line.dart';
import 'package:homeworkr/ui/widgets/loadable_content.dart';
import 'package:homeworkr/ui/widgets/rounded_image.dart';
import 'package:homeworkr/utils/notifications.dart';
import 'package:shimmer/shimmer.dart';

class ApplicationsBottomSheet extends StatefulWidget {
  Homework homework;
  ApplicationsBottomSheet(this.homework);
  static show(BuildContext context, Homework homework) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (ctx) {
          return ApplicationsBottomSheet(homework);
        });
  }

  @override
  _ApplicationsBottomSheetState createState() =>
      _ApplicationsBottomSheetState();
}

class _ApplicationsBottomSheetState extends State<ApplicationsBottomSheet> {
  bool _isLoading = false;
  setLoading(val) {
    setState(() {
      _isLoading = val;
    });
  }

  handleAcceptApplication(Application app) async {
    setLoading(true);
    try {
      await HomeworkRepository().acceptApplication(
          Stores.currentHomeworkStore.homeworkId, app.authorId);
        await NotificationsRepository().PostNotification(
          Notifications.CreateApplicantAcceptedNotification(app, Stores.currentHomeworkStore.homework)
        );
    } catch (err) {
      print(err);
      AlertsHelpers.showSnackbar(context, "Falla al aceptar la aplicacion");
    }

    setLoading(false);
  }

  handleDenyApplication(Application app) async {
    setLoading(true);
    try {
      await HomeworkRepository().setApplicationState(
          Stores.currentHomeworkStore.homeworkId,
          app.authorId,
          ApplicationStatus.denied);
    } catch (err) {
      print(err);
      AlertsHelpers.showSnackbar(context, "Falla al aceptar la aplicacion");
    }
    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      store: Stores.currentHomeworkStore,
      child: Builder(
        builder: (ctx) {
          var _homework = Stores.useCurrentHomeworkStore(ctx);
          print(_homework.applications);
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              child: Column(
                children: [
                  Text(
                    "Aplicaciones a la tarea",
                    style: TextStyle(fontSize: 19),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: LoadableContent(
                        isLoading: _isLoading,
                        child: ListView.separated(
                          separatorBuilder: (ctx, idx) {
                            return HorizontalLine();
                          },
                          itemBuilder: (ctx, idx) {
                            var item = _homework.applications[idx];
                            return _ApplicationListItem(
                              item,
                              onAccept: () {
                                handleAcceptApplication(item);
                              },
                              onDeny: () {
                                handleDenyApplication(item);
                              },
                            );
                          },
                          itemCount: _homework.applications.length,
                        ),
                      ),
                    ),
                  ),
                  CustomIconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: "Cerrar",
                    textColor: Colors.white,
                    backgroundColor: Colors.red,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ApplicationListItem extends StatefulWidget {
  Application application;
  Function onAccept;
  Function onDeny;
  _ApplicationListItem(this.application, {this.onAccept, this.onDeny});
  @override
  __ApplicationListItemState createState() => __ApplicationListItemState();
}

class __ApplicationListItemState extends State<_ApplicationListItem> {
  var _isLoading = false;
  var _homework = Stores.currentHomeworkStore;
  AppUser _user = null;
  fetchUser() async {
    print("fetched");
    setState(() {
      _isLoading = true;
    });
    print(_homework.applicants);
    var usr = _homework.applicants
        .where((element) => element.uUID == widget.application.authorId)
        .first;
    setState(() {
      _user = usr;
      _isLoading = false;
    });
  }

  String get avatar {
    if (_user == null) {
      return "";
    } else {
      return _user.avatar;
    }
  }

  String get userId {
    if (_user == null) {
      return null;
    } else {
      return _user.uUID;
    }
  }

  String get name {
    if (_user == null) {
      return "";
    } else {
      return _user.firstName;
    }
  }

  bool get canExecuteActions {
    return ['open', 'pending'].contains(_homework.homework.status) &&
        Stores.userStore.userRole == UserRoles.student &&
        widget.application.status ==
            HelperFunctions.parseEnumVal(ApplicationStatus.pending);
  }

  String get applicationStatus {
    switch (widget.application.status) {
      case "denied":
        return "negada";
      case "pending":
        return "pendiente";
      case "accepted":
        return "aceptada";
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.red,
        highlightColor: Colors.yellow,
        child: Container(),
        enabled: _isLoading,
      );
    } else {
      return ListTile(
        leading: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              child: RoundedImage(
                size: 50,
                source: avatar,
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return ProfilePage(
                    userId: userId,
                  );
                }));
              },
            ),
          ],
        ),
        trailing: canExecuteActions
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: widget.onDeny,
                  ),
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: widget.onAccept,
                  )
                ],
              )
            : null,
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Estado: ${applicationStatus}"),
            SizedBox(
              height: 3,
            ),
            Text(widget.application.reason),
          ],
        ),
      );
    }
  }
}
