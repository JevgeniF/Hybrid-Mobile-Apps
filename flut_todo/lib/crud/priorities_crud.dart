// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:flut_todo/api/api.dart';
import 'package:flut_todo/authentication/models/user.dart';
import 'package:flut_todo/crud/get_user_data.dart';
import 'package:flut_todo/models/priority.dart';
import 'package:http/http.dart' as http;

class PrioritiesCrud {
  var PRIORITIES_URL = Api.PRIORITIES_URL;

  User _user = User();

  Future<List<Priority>> getPriorities() async {
    List<Priority> prioritiesList = [];

    _user = await getUser();

    try {
      final response = await http.get(Uri.parse(PRIORITIES_URL),
          headers: {'Authorization': 'Bearer ' + (_user.token as String)});
      final responseData = jsonDecode(response.body);

      if (response.statusCode != 200) {
        log('Provider.Priorities Crud. GetPriorities: statusCode: ' +
            response.statusCode.toString());
      } else {
        log('Provider.Priorities Crud. GetPriorities: OK');
        prioritiesList = await responseData.map<Priority>((json) {
          return Priority.fromJson(json);
        }).toList();
      }
    } catch (e) {
      log('Provider.Priorities Crud. GetPriorities error: ' + e.toString());
    }

    return prioritiesList;
  }

  Future<void> postPriority(Priority priority) async {
    _user = await getUser();

    try {
      final response = await http.post(Uri.parse(PRIORITIES_URL),
          headers: {
            'Authorization': 'Bearer ' + (_user.token!),
            "Content-Type": "application/json"
          },
          body: json.encode({
            'priorityName': priority.priorityName,
            'prioritySort': priority.prioritySort,
          }));

      if (response.statusCode == 201) {
        log('Provider.Priorities Crud. postPriority: OK');
      } else {
        log('Provider.Priorities Crud. postPriority: statusCode: ' +
            response.statusCode.toString());
      }
    } catch (e) {
      log('Provider.Priorities Crud. PostPriority: ' + e.toString());
    }
  }
}
