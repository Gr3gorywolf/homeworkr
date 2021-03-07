import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/widgets/rounded_image.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var _user = Stores.useUserStore(context);
    double _initialRating = 0;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Mi perfil"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RoundedImage(
                  size: 96,
                  source: _user.user.avatar,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(_user.user.firstName, style: TextStyle(fontSize: 18)),
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
                    _user.logout();
                  },
                ),
                Spacer()
              ],
            ),
          ),
        ));
  }
}
