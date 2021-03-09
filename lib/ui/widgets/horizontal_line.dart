import 'package:flutter/material.dart';

class HorizontalLine extends StatelessWidget {
  double height;
  HorizontalLine({this.height = 0.2});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Container(
        color: Colors.grey,
      ),
    );
  }
}
