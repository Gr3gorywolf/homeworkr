import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_store/flutter_store.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/pages/home/home.dart';
import 'package:homeworkr/ui/pages/login/login.dart';
import 'package:homeworkr/ui/widgets/loadable_content.dart';
import 'package:homeworkr/ui/widgets/placeholder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Container(
          color: Colors.white,
          child: LoadableContent(isLoading: true, child: Container()));
    }
    if (_error) {
      return CustomPlaceholder(
        "Sin conexion",
        Icons.signal_cellular_connected_no_internet_4_bar_sharp,
        action: () {
          initializeFlutterFire();
        },
        actionTitle: "Reconectar",
      );
    }

    return Provider(
        store: Stores.userStore,
        child: Builder(
          builder: (ctx) {
            var _store = Stores.useUserStore(ctx);
            if (_store.userLogged) {
              return HomePage();
            } else {
              return LoginPage();
            }
          },
        ));
  }
}
