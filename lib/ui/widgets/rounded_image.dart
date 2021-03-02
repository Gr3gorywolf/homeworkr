import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RoundedImage extends StatelessWidget {
  double size;
  String source;
  BoxBorder border;
  RoundedImage({@required this.size, @required this.source, this.border});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.all(Radius.circular(60)),
            image: DecorationImage(
                fit: BoxFit.fill, image: NetworkImage(this.source))));
  }
}
