import 'package:flut_todo/theme/app_constants.dart';
import 'package:flutter/material.dart';

import 'text_field_container.dart';

class RoundedTextFormFieldContainer extends StatelessWidget {
  const RoundedTextFormFieldContainer({
    Key? key,
    required this.hintText,
    required this.icon,
    this.onSaved,
    this.validator,
    this.controller,
  }) : super(key: key);

  final String hintText;
  final IconData icon;
  final void Function(String?)? onSaved;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var color =
        _isDarkMode ? cDarkPrimaryColor : cLightPrimaryColor;
    return TextFieldContainer(
        child: TextFormField(
        style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintStyle: TextStyle(color: color),
        icon: Icon(
          icon, color: color
        ),
        hintText: hintText,
        border: InputBorder.none,
      ),
      validator: validator,
      onSaved: onSaved,
      controller: controller,
    ));
  }
}
