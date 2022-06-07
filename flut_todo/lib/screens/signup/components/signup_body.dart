import 'dart:developer';

import 'package:flut_todo/authentication/errors/authentication_exception.dart';
import 'package:flut_todo/authentication/provider/authentication.dart';
import 'package:flut_todo/components/have_account_question_row.dart';
import 'package:flut_todo/components/root.dart';
import 'package:flut_todo/components/rounded_button.dart';
import 'package:flut_todo/components/rounded_password_field_container.dart';
import 'package:flut_todo/components/rounded_text_form_field_container.dart';
import 'package:flut_todo/crud/categories_crud.dart';
import 'package:flut_todo/crud/priorities_crud.dart';
import 'package:flut_todo/models/priority.dart';
import 'package:flut_todo/screens/signin/signin_screen.dart';
import 'package:flut_todo/theme/app_constants.dart';
import 'package:flut_todo/validators/input_validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({Key? key}) : super(key: key);

  @override
  _SignUpBodyState createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final CategoriesCrud _categoriesCrud = CategoriesCrud();
  final PrioritiesCrud _prioritiesCrud = PrioritiesCrud();

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
    'firstName': '',
    'lastName': ''
  };

  Future _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    try {
      await Provider.of<Authentication>(context, listen: false)
          .signUp(_authData['email']!, _authData['password']!,
              _authData['firstName']!, _authData['lastName']!)
          .then((_) {
        _categoriesCrud.postCategory('Default');
        var normalPriority = Priority(priorityName: 'Normal');
        _prioritiesCrud.postPriority(normalPriority);
        var importantPriority =
            Priority(priorityName: 'Important', prioritySort: 1);
        _prioritiesCrud.postPriority(importantPriority);
      }).then((_) {
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
      //color: cPrimaryLightColor,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/logo.png', height: size.height * 0.3),
              SizedBox(height: size.height * 0.05),
              RoundedTextFormFieldContainer(
                hintText: 'Name (min 1 char)',
                icon: Icons.person,
                validator: Validators.genericNameValidator,
                onSaved: (value) {
                  _authData['firstName'] = value!;
                },
              ),
              SizedBox(height: size.height * 0.02),
              RoundedTextFormFieldContainer(
                hintText: 'Last name (min 1 char)',
                icon: Icons.person,
                validator: Validators.genericNameValidator,
                onSaved: (value) {
                  _authData['lastName'] = value!;
                },
              ),
              SizedBox(height: size.height * 0.02),
              RoundedTextFormFieldContainer(
                hintText: 'E-mail',
                icon: Icons.mail,
                validator: Validators.emailValidator,
                onSaved: (value) {
                  _authData['email'] = value!;
                },
              ),
              SizedBox(height: size.height * 0.02),
              RoundedPasswordFieldContainer(
                  hintText: 'Password (min 6 char)',
                  onSaved: (value) {
                    _authData['password'] = value!;
                  }),
              SizedBox(height: size.height * 0.02),
              RoundedButton(
                color: buttonColor,
                text: 'Sign Up',
                press: () {
                  _submit();
                },
              ),
              SizedBox(height: size.height * 0.01),
              HaveAccountQuestion(
                  signin: false,
                  press: () {
                    Navigator.of(context).pushNamed(SignInScreen.routeName);
                  })
            ],
          ),
        ),
      ),
    );
  }

  void _errorDialog(String message) {
    log(message);
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
