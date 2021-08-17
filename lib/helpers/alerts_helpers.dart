import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertsHelpers {
  static showSnackbar(BuildContext ctx, String text,
      {String title = "Error",
      IconData icon = null,
      int duration = 3,
      FlushbarPosition position = FlushbarPosition.BOTTOM}) {
    if (icon == null) {
      icon = Icons.info;
    }
    Flushbar(
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      duration: Duration(seconds: duration),
      title: title,
      flushbarPosition: position,
      message: text,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
    ).show(ctx);
  }

  static showErrorSnackbar(BuildContext ctx,
      {Exception exception,
      FlushbarPosition position = FlushbarPosition.BOTTOM}) {
    var title = "Error";
    var text = "Wow, an unexpected error happened";
    if (exception != null) {
      text = exception.toString();
    }
    Flushbar(
      margin: EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      duration: Duration(seconds: 4),
      title: title,
      backgroundColor: Colors.red,
      flushbarPosition: position,
      message: text,
      icon: Icon(
        Icons.error,
        color: Colors.white,
      ),
    ).show(ctx);
  }

  static Future<String> showPrompt(BuildContext ctx, String title,
      {String message, TextInputType inputType = TextInputType.text}) {
    var completer = Completer<String>();
    var value = "";
    showDialog(
        context: ctx,
        builder: (cont) {
          return AlertDialog(
            title: Text(title),
            content: TextFormField(
              keyboardType: inputType,
              onChanged: (text) {
                value = text;
              },
            ),
            actions: [
              FlatButton(
                  textColor: Colors.red,
                  onPressed: () {
                    Navigator.pop(ctx);
                    completer.complete(null);
                  },
                  child: Text("Cancelar")),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    completer.complete(value);
                  },
                  child: Text("Ok"))
            ],
          );
        });

    return completer.future;
  }

  static showAlert(BuildContext ctx, String title, String text,
      {Function callback = null,
      bool cancelable = false,
      String acceptTitle = "Ok"}) {
    showDialog(
        context: ctx,
        builder: (cont) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              if (cancelable)
                FlatButton(
                    textColor: Colors.red,
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: Text("Cancelar")),
              SizedBox(
                width: 10,
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (callback != null) {
                      callback();
                    }
                  },
                  child: Text(acceptTitle))
            ],
          );
        });
  }
}
