import 'package:flut_todo/theme/app_constants.dart';
import 'package:flutter/material.dart';

class FloatingAddButton extends StatelessWidget {
  const FloatingAddButton({
    Key? key,
    required this.press,
  }) : super(key: key);

  final Function()? press;

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var buttonColor = _isDarkMode ? cDarkErrorColor : cLightErrorColor;
    return FloatingActionButton(
      onPressed: press,
      child: const Icon(Icons.add),
      backgroundColor: buttonColor,
    );
  }
}
