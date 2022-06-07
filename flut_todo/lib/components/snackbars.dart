import 'package:flutter/material.dart';

showWarningSnackBar(String text, Color color, String buttonLabel, context) {
  var scaffoldMessenger = ScaffoldMessenger.of(context);
  return scaffoldMessenger.showSnackBar(SnackBar(
    content: Text(
      text,
      style: TextStyle(color: color),
    ),
    action: SnackBarAction(
        label: buttonLabel, onPressed: scaffoldMessenger.hideCurrentSnackBar),
  ));
}
