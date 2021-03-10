import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:homeworkr/helpers/alerts_helpers.dart';
import 'package:homeworkr/models/user.dart';
import 'package:homeworkr/repository/user_repository.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/widgets/rounded_image.dart';

class ProfilePage extends StatefulWidget {
  String userId;
  ProfilePage({userId});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;
  AppUser _user = null;

  setLoading(bool val) {
    setState(() {
      _isLoading = val;
    });
  }

  fetchUser() async {
    setLoading(true);
    try {
      var res = await UserRepository().getUser(widget.userId);
      setState(() {
        _user = res;
      });
    } catch (err) {
      AlertsHelpers.showSnackbar(context, "Falla al obtener el usuario");
    }

    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    var store = Stores.useUserStore(context);
    if (widget.userId == null) {
      _user = store.user;
    }

    double _initialRating = 0;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RoundedImage(
              size: 96,
              source: _user.avatar,
            ),
            SizedBox(
              height: 20,
            ),
            Text(_user.firstName, style: TextStyle(fontSize: 18)),
            SizedBox(
              height: 20,
            ),
            RatingBar.builder(
              initialRating: _initialRating,
              minRating: 0,
              direction: Axis.horizontal,
              itemCount: 5,
              itemSize: 30,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
                size: 8,
              ),
              ignoreGestures: true,
              onRatingUpdate: (rating) {},
            ),
            if (widget.userId == null)
              FlatButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Cerrar sesion"),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.logout)
                  ],
                ),
                onPressed: () {
                  store.logout();
                },
              ),
            Spacer()
          ],
        ),
      ),
    ));
  }
}
