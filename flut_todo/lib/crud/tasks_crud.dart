// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:flut_todo/api/api.dart';
import 'package:flut_todo/authentication/models/user.dart';
import 'package:flut_todo/crud/get_user_data.dart';
import 'package:flut_todo/models/task.dart';
import 'package:http/http.dart' as http;

class TasksCrud {
  var TASKS_URL = Api.TASKS_URL;

  User _user = User();

  Future<List<Task>> getTasks() async {
    List<Task> tasksList = [];

    _user = await getUser();

    try {
      final response = await http.get(Uri.parse(TASKS_URL),
          headers: {'Authorization': 'Bearer ' + (_user.token as String)});
      final responseData = jsonDecode(response.body);

      if (response.statusCode != 200) {
        log('Provider. Tasks Crud. GetTasks: statusCode: ' +
            response.statusCode.toString());
      } else {
        log('Provider.Tasks Crud. GetTasks: OK');
        tasksList = await responseData.map<Task>((json) {
          return Task.fromJson(json);
        }).toList();
      }
    } catch (e) {
      log('Provider.Tasks Crud. GetTasks error: ' + e.toString());
    }

    return tasksList;
  }

  Future<Task> getTaskById(String taskId) async {
    Task task = Task(taskName: '', todoCategoryId: '', todoPriorityId: '');

    _user = await getUser();

    try {
      final response = await http.get(Uri.parse(TASKS_URL + taskId),
          headers: {'Authorization': 'Bearer ' + (_user.token!)});
      final responseData = jsonDecode(response.body);

      if (response.statusCode != 200) {
        log('Provider. Tasks Crud. GetTaskById: statusCode: ' +
            response.statusCode.toString());
      } else {
        log('Provider. Tasks Crud. GetTaskById: OK');
        return task = Task.fromJson(responseData);
      }
    } catch (e) {
      log('Provider. Tasks Crud. GetTaskById error: ' + e.toString());
    }
    return task;
  }

  Future<void> postTask(Task task) async {
    _user = await getUser();

    try {
      final response = await http.post(Uri.parse(TASKS_URL),
          headers: {
            'Authorization': 'Bearer ' + (_user.token!),
            "Content-Type": "application/json"
          },
          body: json.encode({
            'taskName': task.taskName,
            'dueDt': task.dueDt,
            'todoCategoryId': task.todoCategoryId,
            'todoPriorityId': task.todoPriorityId,
          }));

      if (response.statusCode == 201) {
        log('Provider. Tasks Crud. PostTask: OK');
      } else {
        log('Provider. Tasks Crud. PostTask: statusCode: ' +
            response.statusCode.toString());
      }
    } catch (e) {
      log('Provider. Tasks Crud. PostTask error: ' + e.toString());
    }
  }

  Future<void> putTask(Task task) async {
    _user = await getUser();

    try {
      final response = await http.put(Uri.parse(TASKS_URL + task.id!),
          headers: {
            'Authorization': 'Bearer ' + (_user.token!),
            "Content-Type": "application/json"
          },
          body: json.encode({
            'id': task.id,
            'taskName': task.taskName,
            'dueDt': task.dueDt,
            'isCompleted': task.isCompleted,
            'todoCategoryId': task.todoCategoryId,
            'todoPriorityId': task.todoPriorityId,
          }));

      if (response.statusCode == 204) {
        log('Provider. Tasks Crud. PutTask: OK');
      } else {
        log('Provider. Tasks Crud. PutTask: statusCode: ' +
            response.statusCode.toString());
      }
    } catch (e) {
      log('Provider. Tasks Crud. PutTask error: ' + e.toString());
    }
  }

  Future<void> deleteTask(Task task) async {
    _user = await getUser();

    try {
      final response = await http.delete(Uri.parse(TASKS_URL + task.id!),
          headers: {
            'Authorization': 'Bearer ' + (_user.token!),
            "Content-Type": "application/json"
          },
          body: json.encode({
            'id': task.id,
          }));

      if (response.statusCode == 204) {
        log('Provider. Tasks Crud. DeleteTask: OK');
      } else {
        log('Provider. Tasks Crud. DeleteTask: statusCode: ' +
            response.statusCode.toString());
      }
    } catch (e) {
      log('Provider. Tasks Crud. DeleteTask error: ' + e.toString());
    }
  }
}
