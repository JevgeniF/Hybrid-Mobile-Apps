import 'package:flut_todo/theme/app_constants.dart';
import 'package:flutter/material.dart';

import 'components/signup_body.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static const routeName = '/sign-up-screen';

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var appBarColor =
        _isDarkMode ? cDarkPrimaryColorLight : cLightPrimaryColorLight;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
        ),
        body: const SignUpBody());
  }
}
