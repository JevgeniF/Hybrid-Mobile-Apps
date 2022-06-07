import 'package:flut_todo/crud/tasks_crud.dart';
import 'package:flut_todo/models/category.dart';
import 'package:flut_todo/models/task.dart';
import 'package:flut_todo/screens/tasks/components/task_edit.dart';
import 'package:flut_todo/theme/app_constants.dart';
import 'package:flutter/material.dart';

class TaskEditScreen extends StatefulWidget {
  const TaskEditScreen(
      {Key? key, required this.taskId, required this.categories})
      : super(key: key);

  final List<Category> categories;
  final String taskId;

  @override
  _TaskEditScreenState createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final TasksCrud _tasksCrud = TasksCrud();
  late Future taskFuture;
  Task _task = Task(taskName: '', todoCategoryId: '', todoPriorityId: '');

  @override
  initState() {
    taskFuture = getData();
    super.initState();
  }

  getData() async {
    _task = await _tasksCrud.getTaskById(widget.taskId);
    return _task;
  }

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var appBarColor = _isDarkMode ? cDarkPrimaryColor : cLightPrimaryColor;
    return Scaffold(
        appBar: AppBar(
            title: const Text('Edit ToDo'), backgroundColor: appBarColor),
        body: FutureBuilder(
            future: taskFuture,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Center(child: Text('No connection'));
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  return TaskEdit(
                      task: snapshot.data as Task,
                      categories: widget.categories);
              }
            }));
  }
}
