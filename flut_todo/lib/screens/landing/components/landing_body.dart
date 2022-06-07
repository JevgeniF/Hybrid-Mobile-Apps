import 'package:flut_todo/components/root.dart';
import 'package:flut_todo/components/rounded_button.dart';
import 'package:flut_todo/screens/signin/signin_screen.dart';
import 'package:flut_todo/screens/signup/signup_screen.dart';
import 'package:flut_todo/theme/app_constants.dart';
import 'package:flutter/material.dart';

class LandingBody extends StatelessWidget {
  const LandingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var buttonColor = _isDarkMode ? cDarkPrimaryColor : cLightPrimaryColor;
    Size size = MediaQuery.of(context).size;
    return Root(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/logo.png', height: size.height * 0.3),
            SizedBox(height: size.height * 0.02),
            const Text('Flut-ToDo',
                style: TextStyle(
                  fontSize: 22,
                  //color: cPrimaryColor,
                )),
            const Text('Finish tasks before it is too late...',
                textAlign: TextAlign.center),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              color: buttonColor,
              text: 'Sign In',
              press: () {
                Navigator.of(context).pushNamed(SignInScreen.routeName);
              },
            ),
            SizedBox(height: size.height * 0.02),
            RoundedButton(
              color: buttonColor,
              text: 'Sign Up',
              //color: cPrimaryLightColor,
              press: () {
                Navigator.of(context).pushNamed(SignUpScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
