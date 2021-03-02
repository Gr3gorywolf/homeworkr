import 'package:flutter/material.dart';
import 'package:homeworkr/ui/widgets/custom_icon_button.dart';

class CustomPlaceholder extends StatelessWidget {
  Function action;
  String actionTitle;
  String title;
  IconData icon;
  CustomPlaceholder(this.title, this.icon, {this.action, this.actionTitle});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 80, color: Colors.grey),
        SizedBox(
          height: 5,
        ),
        Text(
          title,
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          width: 180,
          child: CustomIconButton(
            onPressed: action,
            text: actionTitle,
            rounded: true,
            backgroundColor: Colors.black,
            textColor: Colors.white,
          ),
        )
      ],
    )));
  }
}
