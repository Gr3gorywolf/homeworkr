import 'package:flutter/material.dart';

class LoadableContent extends StatelessWidget {
  bool isLoading;
  Widget child;
  Color progressColor;
  LoadableContent({@required this.isLoading, @required this.child,this.progressColor});
  @override
  Widget build(BuildContext context) {
    var valueCol = null;
    if (progressColor != null) {
      valueCol = progressColor;
    }
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(valueCol),
        ),
      );
    } else {
      return child;
    }
  }
}
