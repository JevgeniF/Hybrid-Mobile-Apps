import 'package:flut_todo/theme/app_constants.dart';
import 'package:flutter/material.dart';

class HaveAccountQuestion extends StatelessWidget {
  const HaveAccountQuestion({
    Key? key,
    this.signin = true,
    required this.press,
  }) : super(key: key);

  final bool signin;
  final Function() press;

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var accentColor = _isDarkMode ? cDarkAccentColor : cLightAccentColor;
    var primaryColorDark =
        _isDarkMode ? cDarkPrimaryColorDark : cLightPrimaryColorDark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(signin ? 'Don\'t have an account? ' : 'Already registered? ',
            style: TextStyle(color: accentColor)),
        GestureDetector(
          onTap: press,
          child: Text(signin ? 'Sign Up' : 'Sign In',
              style: TextStyle(
                  color: primaryColorDark,
                  fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}
