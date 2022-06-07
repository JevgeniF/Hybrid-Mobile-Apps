import 'package:flut_todo/components/floating_add_button.dart';
import 'package:flut_todo/crud/priorities_crud.dart';
import 'package:flut_todo/crud/tasks_crud.dart';
import 'package:flut_todo/models/category.dart';
import 'package:flut_todo/models/priority.dart';
import 'package:flut_todo/models/task.dart';
import 'package:flut_todo/screens/tasks/components/tasks_reorderable_list.dart';
import 'package:flutter/material.dart';

import 'childScreens/task_add_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key, this.categoryId, this.categories})
      : super(key: key);

  static const routeName = '/tasks-screen';

  final List<Category>? categories;
  final String? categoryId;

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final PrioritiesCrud _prioritiesCrud = PrioritiesCrud();
  List<Category> categories = [];
  List<Task> _tasks = [];
  String? categoryId;
  List<Priority> _priorities = [];
  late Future tasksFuture;
  final TasksCrud _tasksCrud = TasksCrud();

  @override
  void initState() {
    categories = widget.categories!;
    categoryId = widget.categoryId;
    tasksFuture = getData();
    _prioritiesCrud.getPriorities().then((value) => {
          setState(() {
            _priorities = value;
          })
        });
    super.initState();
  }

  getData() async {
    _tasks = await _tasksCrud.getTasks();
    return _tasks;
  }

  refreshData() {
    tasksFuture = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: tasksFuture,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(child: Text('No connection'));
              case ConnectionState.active:
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                _tasks = snapshot.data as List<Task>;
                if (categoryId != null) {
                  _tasks = _tasks
                      .where((task) => (task.todoCategoryId == categoryId))
                      .toList();
                }
                return TasksReorderableList(
                    tasks: _tasks,
                    categories: categories,
                    priorities: _priorities,
                    categoryId: categoryId);
            }
          }),
      floatingActionButton: FloatingAddButton(press: () {
        Navigator.of(context)
            .push(MaterialPageRoute<bool>(
                builder: (context) => TaskAddScreen(
                    categories: categories,
                    priorities: _priorities,
                    categoryId: categoryId)))
            .then((res) {
          setState(() {
            refreshData();
          });
        });
      }),
    );
  }
}
