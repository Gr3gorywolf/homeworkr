import 'package:flutter/material.dart';

class CategoriesSelectorModal extends StatefulWidget {
  CategoriesSelectorModal({Key key}) : super(key: key);

  static show(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (ctx) {
          return CategoriesSelectorModal();
        });
  }

  @override
  _CategoriesSelectorModalState createState() =>
      _CategoriesSelectorModalState();
}

class _CategoriesSelectorModalState extends State<CategoriesSelectorModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.green, spreadRadius: 3),
        ],
      ),
      color: Colors.white,
      child: Container(),
    );
  }
}
