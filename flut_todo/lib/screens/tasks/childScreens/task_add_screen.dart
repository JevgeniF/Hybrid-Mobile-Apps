import 'package:flut_todo/models/category.dart';
import 'package:flut_todo/models/priority.dart';
import 'package:flut_todo/screens/tasks/components/task_add.dart';
import 'package:flut_todo/theme/app_constants.dart';
import 'package:flutter/material.dart';

class TaskAddScreen extends StatefulWidget {
  const TaskAddScreen(
      {Key? key,
      required this.priorities,
      required this.categories,
      required this.categoryId})
      : super(key: key);

  final List<Category> categories;
  final List<Priority> priorities;
  final String? categoryId;

  @override
  _TaskAddScreenState createState() => _TaskAddScreenState();
}

class _TaskAddScreenState extends State<TaskAddScreen> {
  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var appBarColor = _isDarkMode ? cDarkPrimaryColor : cLightPrimaryColor;
    return Scaffold(
      appBar:
          AppBar(title: const Text('Add ToDo'), backgroundColor: appBarColor),
      body: TaskAdd(
          priorities: widget.priorities,
          categories: widget.categories,
          categoryId: widget.categoryId),
    );
  }
}
