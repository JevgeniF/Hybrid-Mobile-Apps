import 'package:flut_todo/components/list_item_container_with_row.dart';
import 'package:flut_todo/components/list_item_description.dart';
import 'package:flut_todo/components/list_item_name.dart';
import 'package:flut_todo/crud/priorities_crud.dart';
import 'package:flut_todo/crud/tasks_crud.dart';
import 'package:flut_todo/models/category.dart';
import 'package:flut_todo/models/priority.dart';
import 'package:flut_todo/models/task.dart';
import 'package:flut_todo/screens/tasks/childScreens/task_edit_screen.dart';
import 'package:flut_todo/screens/tasks/components/task_list_item_due_date_widget.dart';
import 'package:flut_todo/screens/tasks/components/tasks_list_slidable_action_complete.dart';
import 'package:flut_todo/screens/tasks/components/tasks_list_slidable_action_delete.dart';
import 'package:flut_todo/theme/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasksReorderableList extends StatefulWidget {
  const TasksReorderableList(
      {Key? key,
      required this.tasks,
      required this.categories,
      required this.categoryId,
      required this.priorities})
      : super(key: key);

  final List<Category> categories;
  final List<Priority> priorities;
  final String? categoryId;
  final List<Task> tasks;

  @override
  _TasksReorderableListState createState() => _TasksReorderableListState();
}

class _TasksReorderableListState extends State<TasksReorderableList> {
  List<Category> categories = [];
  final PrioritiesCrud _prioritiesCrud = PrioritiesCrud();
  String? categoryId;
  int sort = 0;
  String importantPriorityId = '';
  List<Task> tasks = [];
  List<Priority> _priorities = [];

  final TasksCrud _tasksCrud = TasksCrud();

  late bool _isDarkMode;

  @override
  void initState() {
    categoryId = widget.categoryId;
    tasks = widget.tasks;
    categories = widget.categories;
    _prioritiesCrud.getPriorities().then((value) => {
          setState(() {
            _priorities = value;
            getImportantPriorityId();
          })
        });
    getSort();

    super.initState();
  }

  void getImportantPriorityId() {
    for (var priority in _priorities) {
      if (priority.priorityName == 'Important') {
        importantPriorityId = priority.id!;
      }
    }
  }

  void updateCompletion(Task task) async {
    task.isCompleted = !task.isCompleted;
    await _tasksCrud.putTask(task);
  }

  void deleteTask(Task task) async {
    tasks.remove(task);
    await _tasksCrud.deleteTask(task);
  }

  void updatePriority(Task task) async {
    if (task.todoPriorityId != _priorities[0].id) {
      task.todoPriorityId = _priorities[0].id!;
    } else {
      task.todoPriorityId = _priorities[1].id!;
    }
    await _tasksCrud.putTask(task);
  }

  void updateDueDt(Task task, date) async {
    task.dueDt = date.toUtc().toIso8601String();
    await _tasksCrud.putTask(task);
  }

  void saveSort(sort) async {
    var preferences = await SharedPreferences.getInstance();
    preferences.setInt('@sort', sort);
  }

  void getSort() async {
    var preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('@sort')) {
      setState(() {
        sort = preferences.getInt('@sort')!;
      });
    }
    setState(() {
      sortTasks();
    });
  }

  Icon getItemPriority(Task task) {
    var iconColor = _isDarkMode ? Colors.white70 : Colors.black87;
    Icon icon = Icon(Icons.star_border_outlined, color: iconColor, size: 20);
    if (task.todoPriorityId == importantPriorityId) {
      icon = Icon(Icons.star, color: Colors.orange.shade900, size: 20);
    }
    return icon;
  }

  String getCategoryName(String? categoryId) {
    if (categoryId == null) {
      return 'All';
    }
    if (categories != []) {
      for (var category in categories) {
        if (categoryId == category.id) return category.categoryName;
      }
    }
    return '';
  }

  DateTime parseUtcToLocal(String dueDate) {
    var dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    var utcDate = dateFormat.format(DateTime.parse(dueDate));
    return dateFormat.parse(utcDate, true).toLocal();
  }

  Column appBarActionIcon() {
    switch (sort) {
      case 1:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.star, size: 25.0),
            ]);
      case 2:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.star_border_outlined, size: 25.0),
            ]);
      case 3:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.alarm, size: 25.0),
            ]);
      default:
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.sort_by_alpha, size: 25.0),
            ]);
    }
  }

  void sortTasks() {
    List<Task> notCompleted =
        tasks.where((task) => (!task.isCompleted)).toList();
    List<Task> completed = tasks.where((task) => (task.isCompleted)).toList();
    if (sort == 0) {
      notCompleted.sort((a, b) =>
          (a.taskName.toLowerCase()).compareTo(b.taskName.toLowerCase()));
      completed.sort((a, b) =>
          (a.taskName.toLowerCase()).compareTo(b.taskName.toLowerCase()));
      tasks = notCompleted + completed;
    }
    if (sort == 1) {
      notCompleted
          .sort((a, b) => (a.todoPriorityId).compareTo(b.todoPriorityId));
      completed.sort((a, b) => (a.todoPriorityId).compareTo(b.todoPriorityId));
      tasks = notCompleted + completed;
    }
    if (sort == 2) {
      notCompleted
          .sort((a, b) => (b.todoPriorityId).compareTo(a.todoPriorityId));
      completed.sort((a, b) => (b.todoPriorityId).compareTo(a.todoPriorityId));
      tasks = notCompleted + completed;
    }
    if (sort == 3) {
      List<Task> notCompletedNonNullDate =
          notCompleted.where((task) => (task.dueDt != null)).toList();
      List<Task> notCompletedNullDate =
          notCompleted.where((task) => (task.dueDt == null)).toList();
      List<Task> completedNonNullDate =
          completed.where((task) => (task.dueDt != null)).toList();
      List<Task> completedNullDate =
          completed.where((task) => (task.dueDt == null)).toList();
      notCompletedNonNullDate
          .sort((a, b) => (a.dueDt ?? '').compareTo(b.dueDt ?? ''));
      completedNonNullDate
          .sort((a, b) => (a.dueDt ?? '').compareTo(b.dueDt ?? ''));
      tasks = notCompletedNonNullDate +
          notCompletedNullDate +
          completedNonNullDate +
          completedNullDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var itemColor = _isDarkMode ? cDarkCardColor : cLightCardColor;
    var appBarColor = _isDarkMode ? cDarkPrimaryColor : cLightPrimaryColor;
    var descrColor = _isDarkMode ? cDarkPrimaryColorLight : Colors.black;
    return ReorderableListView.builder(
      header: AppBar(
          backgroundColor: appBarColor,
          title: Text(getCategoryName(categoryId) + ' ToDo\'s'),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                    onTap: () {
                      if (sort < 3) {
                        sort += 1;
                      } else {
                        sort = 0;
                      }
                      setState(() {
                        saveSort(sort);
                        sortTasks();
                      });
                    },
                    child: appBarActionIcon())),
          ]),
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        return Slidable(
          key: ValueKey('$index'),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableActionComplete(
                  task: tasks[index],
                  press: (context) {
                    setState(() {
                      updateCompletion(tasks[index]);
                    });
                  }),
              SlidableActionDelete(press: (context) {
                setState(() {
                  deleteTask(tasks[index]);
                });
              }),
            ],
          ),
          child: ListItemContainerWithRow(
            color: itemColor,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      updatePriority(tasks[index]);
                    });
                  },
                  icon: getItemPriority(tasks[index])),
              const SizedBox(width: 10),
              ListItemDescription(
                  children: [
                    tasks[index].isCompleted
                        ? ListItemName(
                            itemName: tasks[index].taskName,
                            decoration: TextDecoration.lineThrough)
                        : ListItemName(itemName: tasks[index].taskName),
                    Text(
                      'List: ' + getCategoryName(tasks[index].todoCategoryId),
                      style: TextStyle(color: descrColor),
                    )
                  ],
                  tap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute<bool>(
                            builder: (context) => TaskEditScreen(
                                taskId: tasks[index].id!,
                                categories: categories)))
                        .then((value) {
                      if (value == true) {
                        setState(() {
                          tasks.remove(tasks[index]);
                        });
                      }
                      if (value == false) {
                        _tasksCrud
                            .getTaskById(tasks[index].id!)
                            .then((value) => setState(() {
                                  tasks[index] = value;
                                }));
                      }
                    });
                  }),
              const Spacer(flex: 1),
              TaskListItemDueDate(
                  task: tasks[index],
                  tap: () {
                    var currentTime = DateTime.now().toLocal();
                    if (tasks[index].dueDt != null) {
                      currentTime = parseUtcToLocal(tasks[index].dueDt!);
                    }
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2023, 12, 31),
                        currentTime: currentTime, onConfirm: (date) {
                      setState(() {
                        updateDueDt(tasks[index], date);
                      });
                    });
                  })
            ],
          ),
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final Task task = tasks.removeAt(oldIndex);
          tasks.insert(newIndex, task);
        });
      },
    );
  }
}
