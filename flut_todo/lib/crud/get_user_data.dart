import 'dart:convert';
import 'dart:developer';

import 'package:flut_todo/authentication/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<User> getUser() async {
  final preferences = await SharedPreferences.getInstance();
  if (!preferences.containsKey('@user')) {
    log('Providers. get_user_data. getUser: no data');
  }
  final restoredData = jsonDecode(preferences.getString('@user') as String);
  return User.fromJson(restoredData);
}
