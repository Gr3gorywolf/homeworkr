import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  Function onPressed;
  Color backgroundColor;
  Color textColor;
  bool rounded;
  IconData icon;
  Widget customIcon;
  String text;
  bool isLoading;
  bool isIconLeftAligned;
  bool isDisabled;
  CustomIconButton(
      {@required this.onPressed,
      this.backgroundColor = Colors.white,
      this.textColor = Colors.black,
      this.rounded = false,
      this.isLoading = false,
      this.isIconLeftAligned = false,
      this.customIcon,
      this.icon,
      this.isDisabled = false,
      this.text});

  Widget getText() {
    if (text != null) {
      if (isIconLeftAligned) {
        return Expanded(
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: textColor),
            ),
          ),
        );
      } else {
        return Text(
          text,
          style: TextStyle(color: textColor),
        );
      }
    }
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    var shape = null;
    if (this.rounded) {
      shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0));
    }
    return RaisedButton(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          height: 50,
          child: Builder(
            builder: (ctx) {
              if (isLoading) {
                return CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: new AlwaysStoppedAnimation<Color>(textColor),
                );
              } else {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null)
                      Icon(
                        icon,
                        color: textColor,
                      ),
                    if (customIcon != null) customIcon,
                    SizedBox(
                      width: 10,
                    ),
                    getText()
                  ],
                );
              }
            },
          ),
        ),
      ),
      onPressed: isDisabled
          ? null
          : () {
              if (!isLoading) {
                onPressed();
              }
            },
      color: backgroundColor,
      shape: shape,
    );
  }
}
