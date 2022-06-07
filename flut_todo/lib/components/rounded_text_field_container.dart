import 'package:flut_todo/components/text_field_container.dart';
import 'package:flut_todo/theme/app_constants.dart';
import 'package:flutter/material.dart';

class RoundedTextFieldContainer extends StatelessWidget {
  const RoundedTextFieldContainer(
      {Key? key,
      this.controllerString,
      required this.changed,
      this.icon = Icons.list,
      this.hint = 'Enter list\'s name'})
      : super(key: key);

  final String? controllerString;
  final Function(String)? changed;
  final String hint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var color = _isDarkMode ? cDarkPrimaryColor : cLightPrimaryColor;
    return TextFieldContainer(
      child: TextField(
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
            icon: Icon(
              icon,
              color: color,
            ),
            hintText: hint,
            hintStyle: TextStyle(color: color),
            border: InputBorder.none),
        controller: TextEditingController(text: controllerString),
        onChanged: changed,
      ),
    );
  }
}
