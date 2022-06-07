// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:flut_todo/api/api.dart';
import 'package:flut_todo/authentication/errors/authentication_exception.dart';
import 'package:flut_todo/authentication/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Authentication with ChangeNotifier {
  var LOGIN_URL = Api.LOGIN_URL;
  var REGISTER_URL = Api.REGISTER_URL;

  User _user = User();

  bool get isAuth {
    return _user.token != null;
  }

  Future<void> signIn(String email, String password) async {
    try {
      final response = await http.post(Uri.parse(LOGIN_URL),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            'email': email,
            'password': password,
          }));

      final responseData = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw AuthenticationException(responseData['messages'].join('/n'));
      } else {
        _user = User.fromJson(responseData);
        _user.email = email;
        final preferences = await SharedPreferences.getInstance();
        final userJson = jsonEncode({
          'token': _user.token,
          'firstName': _user.firstName,
          'lastName': _user.lastName,
          'email': _user.email
        });
        preferences.setString('@user', userJson);

        log('Provider.Authenticaton: Signed In');
      }

      notifyListeners();
    } catch (e) {
      log('Provider.Authenticaton.Sign In Error: ' + e.toString());
      throw AuthenticationException(e.toString());
    }
  }

  Future<void> signUp(
      String email, String password, String firstName, String lastName) async {
    try {
      final response = await http.post(Uri.parse(REGISTER_URL),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            'email': email,
            'password': password,
            'firstName': firstName,
            'lastName': lastName,
          }));

      final responseData = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw AuthenticationException(responseData['messages'].join('/n'));
      } else {
        _user = User.fromJson(responseData);
        _user.email = email;

        final preferences = await SharedPreferences.getInstance();
        final userJson = jsonEncode({
          'token': _user.token,
          'firstName': _user.firstName,
          'lastName': _user.lastName,
          'email': _user.email
        });
        preferences.setString('@user', userJson);

        log('Provider.Authenticaton: Signed Up');
      }

      notifyListeners();
    } catch (e) {
      log('Authentication.SignUp: ' + e.toString());
      throw AuthenticationException(e.toString());
    }
  }

  Future<void> logout() async {
    _user = User();
    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    preferences.clear();

    log('Provider.Authenticaton: Logged Out');
  }

  Future<bool> reSignIn() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey('@user')) {
      log('Provider.Authenticaton: Not relogged in');
      return false;
    }
    final restoredData = jsonDecode(preferences.getString('@user') as String);
    _user = User.fromJson(restoredData);

    notifyListeners();

    log('Provider.Authenticaton: Relogged in');
    return true;
  }
}
