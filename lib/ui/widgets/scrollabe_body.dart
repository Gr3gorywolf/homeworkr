import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ScrollableBody extends StatelessWidget {
  Widget child;
  bool hasToolbar = true;
  ScrollableBody({@required this.child, this.hasToolbar = true});
  @override
  Widget build(BuildContext context) {
    double toolbarHeight = 0;
    if (hasToolbar) {
      toolbarHeight = kToolbarHeight;
    }
    return Container(
        child: SingleChildScrollView(
            child: SizedBox(
      height: MediaQuery.of(context).size.height -
          toolbarHeight, // or something simular :)
      child: child,
    )));
  }
}
