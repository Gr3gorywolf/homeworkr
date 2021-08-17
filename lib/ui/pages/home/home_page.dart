import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store/flutter_store.dart';
import 'package:homeworkr/helpers/alerts_helpers.dart';
import 'package:homeworkr/models/user.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/pages/home/widgets/categories_selector_modal.dart';
import 'package:homeworkr/ui/pages/homeworks/homeworks_page.dart';
import 'package:homeworkr/ui/pages/payments/payments_page.dart';
import 'package:homeworkr/ui/pages/profile/profile_page.dart';
import 'package:homeworkr/ui/widgets/coins_widget.dart';
import 'package:homeworkr/ui/widgets/rounded_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentItem = 0;
  bool _isAppInitialized = false;
  Map<String, Widget> _pages = {
    "Tareas": HomeworksPage(),
    "Perfil": ProfilePage()
  };
  @override
  void initState() {
    super.initState();
  }

  init() async {
    Future.delayed(Duration(milliseconds: 200)).then((value) {
      if (Stores.userStore.userRole == UserRoles.mentor) {
        if (Stores.userStore.user.categories.length == 0) {
          CategoriesSelectorModal.show(context);
        }
      }
    });
    await Stores.userStore.enableUserWatching();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    if (!kIsWeb) {
      messaging.subscribeToTopic(Stores.userStore.user.uUID);
    }
    FirebaseMessaging.onMessage.listen((event) {
      AlertsHelpers.showSnackbar(context, event.notification.body,
          title: event.notification.title,
          position: FlushbarPosition.TOP,
          duration: 3,
          icon: Icons.notifications);
    });
    _isAppInitialized = true;
  }

  String get pageTitle {
    var title = _pages.keys.toList()[_currentItem];
    if (_currentItem == 0 && Stores.userStore.userRole == UserRoles.student) {
      return "Mis tareas";
    } else {
      return title;
    }
  }

  Map<String, IconData> get popupMenuActions {
    return {
      "Configuraciones": Icons.settings,
      "Cerrar sesion": Icons.logout,
    };
  }

  handlePopupMenuAction(String item) {
    var index = popupMenuActions.keys.toList().indexOf(item);
    switch (index) {
      case 0:
        break;
      case 1:
        Stores.userStore.logout();
        break;
    }
  }

  Widget get currentPage {
    return _pages.values.toList()[_currentItem];
  }

  @override
  void dispose() {
    super.dispose();
    Stores.userStore.disableUserWatching();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      store: Stores.userStore,
      child: Builder(
        builder: (ctx) {
          if (!_isAppInitialized) {
            init();
          }
          var _user = Stores.useUserStore(ctx);
          return Scaffold(
              appBar: AppBar(
                title: Text(pageTitle),
                centerTitle: true,
                actions: [
                  InkWell(
                    child: CoinsWidget(Colors.white),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => PaymentsPage()));
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: handlePopupMenuAction,
                    child: IconButton(
                        icon: RoundedImage(
                            size: 30,
                            source: _user.user.avatar,
                            border: Border.all(width: 2, color: Colors.white))),
                    itemBuilder: (BuildContext context) {
                      return popupMenuActions.keys.map((choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                popupMenuActions[choice],
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(choice)
                            ],
                          ),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
              body: Provider(
                store: Stores.userStore,
                child: currentPage,
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentItem,
                onTap: (item) {
                  setState(() {
                    _currentItem = item;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    label: "Tareas",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: "Perfil",
                  )
                ],
              ));
        },
      ),
    );
  }
}
