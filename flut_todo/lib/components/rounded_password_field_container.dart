import 'package:flut_todo/theme/app_constants.dart';
import 'package:flut_todo/validators/input_validators.dart';
import 'package:flutter/material.dart';

import 'text_field_container.dart';

class RoundedPasswordFieldContainer extends StatefulWidget {
  const RoundedPasswordFieldContainer({
    Key? key,
    this.onSaved,
    this.hintText = 'Password',
  }) : super(key: key);

  final void Function(String?)? onSaved;
  final String hintText;

  @override
  _RoundedPasswordFieldContainerState createState() =>
      _RoundedPasswordFieldContainerState();
}

class _RoundedPasswordFieldContainerState
    extends State<RoundedPasswordFieldContainer> {
  _RoundedPasswordFieldContainerState({
    this.onSaved,
    this.hintText = 'Password',
  });

  void Function(String?)? onSaved;
  String hintText;
  bool isObscured = true;

  @override
  void initState() {
    onSaved = widget.onSaved;
    hintText = widget.hintText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var color = _isDarkMode ? cDarkPrimaryColor : cLightPrimaryColor;
    return TextFieldContainer(
        child: TextFormField(
        style: const TextStyle(color: Colors.black),
      obscureText: isObscured,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: color),
        border: InputBorder.none,
        icon: Icon(
          Icons.lock,
          color: color,
        ),
        suffixIcon: IconButton(
            icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off),
            color: color,
            onPressed: () {
              setState(() {
                isObscured = !isObscured;
              });
            }),
      ),
      validator: Validators.passwordValidator,
      onSaved: onSaved,
    ));
  }
}
