import 'package:flutter/material.dart';
import 'package:flutter_store/flutter_store.dart';
import 'package:homeworkr/models/user.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/pages/home/widgets/categories_selector_modal.dart';
import 'package:homeworkr/ui/pages/homeworks/homeworks.dart';
import 'package:homeworkr/ui/pages/profile/profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentItem = 0;
  List<Widget> _pages = [HomeworksPage(), ProfilePage()];
  @override
  void initState() {
    super.initState();
    /*if (Stores.userStore.userRole == UserRoles.mentor) {
      if (Stores.userStore.user.categories.length == 0) {
        CategoriesSelectorModal.show(context);
      }
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      store: Stores.userStore,
      child: Builder(
        builder: (ctx) {
          return Scaffold(
              body: Provider(
                  store: Stores.userStore, child: _pages[_currentItem]),
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
