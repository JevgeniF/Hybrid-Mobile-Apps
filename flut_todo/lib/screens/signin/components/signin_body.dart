import 'package:flut_todo/authentication/errors/authentication_exception.dart';
import 'package:flut_todo/authentication/provider/authentication.dart';
import 'package:flut_todo/components/have_account_question_row.dart';
import 'package:flut_todo/components/root.dart';
import 'package:flut_todo/components/rounded_button.dart';
import 'package:flut_todo/components/rounded_password_field_container.dart';
import 'package:flut_todo/components/rounded_text_form_field_container.dart';
import 'package:flut_todo/screens/signup/signup_screen.dart';
import 'package:flut_todo/theme/app_constants.dart';
import 'package:flut_todo/validators/input_validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInBody extends StatefulWidget {
  const SignInBody({Key? key}) : super(key: key);

  @override
  _SignInBodyState createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final Map<String, String> _authData = {'email': '', 'password': ''};

  Future _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    try {
      await Provider.of<Authentication>(context, listen: false)
          .signIn(_authData['email']!, _authData['password']!)
          .then((_) {
        Navigator.of(context).pushReplacementNamed('/');
      });
    } on AuthenticationException catch (e) {
      _errorDialog(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var buttonColor = _isDarkMode ? cDarkPrimaryColor : cLightPrimaryColor;
    Size size = MediaQuery.of(context).size;
    return Root(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/logo.png', height: size.height * 0.3),
              SizedBox(height: size.height * 0.05),
              RoundedTextFormFieldContainer(
                hintText: 'E-mail',
                icon: Icons.mail,
                validator: Validators.emailValidator,
                onSaved: (value) {
                  _authData['email'] = value!;
                },
              ),
              SizedBox(height: size.height * 0.02),
              RoundedPasswordFieldContainer(onSaved: (value) {
                _authData['password'] = value!;
              }),
              SizedBox(height: size.height * 0.02),
              RoundedButton(
                color: buttonColor,
                text: 'Sign In',
                press: () {
                  _submit();
                },
              ),
              SizedBox(height: size.height * 0.01),
              HaveAccountQuestion(press: () {
                Navigator.of(context).pushNamed(SignUpScreen.routeName);
              })
            ],
          ),
        ),
      ),
    );
  }

  void _errorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Error!',
          style: TextStyle(),
        ),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
