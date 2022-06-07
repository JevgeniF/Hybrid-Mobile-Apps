import 'package:flut_todo/components/rounded_button.dart';
import 'package:flut_todo/components/rounded_text_field_container.dart';
import 'package:flut_todo/components/snackbars.dart';
import 'package:flut_todo/crud/tasks_crud.dart';
import 'package:flut_todo/models/category.dart';
import 'package:flut_todo/models/priority.dart';
import 'package:flut_todo/models/task.dart';
import 'package:flut_todo/theme/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:intl/intl.dart';

class CategoryModel {
  const CategoryModel(this.name, this.id, this.index);

  final String name;
  final String id;
  final int index;

  @override
  String toString() {
    return name;
  }
}

class PriorityModel {
  const PriorityModel(this.name, this.id, this.index);

  final String name;
  final String id;
  final int index;

  @override
  String toString() {
    return name;
  }
}

class TaskAdd extends StatefulWidget {
  const TaskAdd(
      {Key? key,
      required this.categories,
      required this.categoryId,
      required this.priorities})
      : super(key: key);

  final List<Category> categories;
  final List<Priority> priorities;
  final String? categoryId;

  @override
  _TaskAddState createState() => _TaskAddState();
}

class _TaskAddState extends State<TaskAdd> {
  final TasksCrud _tasksCrud = TasksCrud();

  final Task _task = Task(taskName: '', todoCategoryId: '', todoPriorityId: '');
  List<Category> _categories = [];
  List<Priority> _priorities = [];

  bool _isLoaded = false;

  static List<CategoryModel> categoryModels = [];
  CategoryModel selectedCategoryModel = const CategoryModel('', '', 0);

  static List<PriorityModel> priorityModels = [];
  PriorityModel selectedPriorityModel = const PriorityModel('', '', 0);

  DateTime parseUtcToLocal(String dueDate) {
    var dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    var utcDate = dateFormat.format(DateTime.parse(dueDate));
    return dateFormat.parse(utcDate, true).toLocal();
  }

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var buttonColor = _isDarkMode ? cDarkPrimaryColor : cLightPrimaryColor;
    var dataButtonColor =
        _isDarkMode ? cDarkPrimaryColorDark : cLightPrimaryColorDark;
    var errorColor = _isDarkMode ? cDarkErrorColor : cLightErrorColor;
    Size size = MediaQuery.of(context).size;
    if (_isLoaded == false) {
      setState(() {
        _categories = widget.categories;
        _priorities = widget.priorities;
        if (widget.categoryId != null) {
          _task.todoCategoryId = widget.categoryId!;
        }
        _task.todoPriorityId = _priorities[0].id!;
        _isLoaded = true;
        categoryModels = [];
        for (var i = 0; i < _categories.length; i++) {
          if (_categories[i].id == _task.todoCategoryId) {
            selectedCategoryModel = CategoryModel(
                _categories[i].categoryName, _categories[i].id!, i);
          }
          categoryModels.add(CategoryModel(
              _categories[i].categoryName, _categories[i].id!, i));
        }
        priorityModels = [];
        for (var i = 0; i < _priorities.length; i++) {
          if (_priorities[i].id == _task.todoPriorityId) {
            selectedPriorityModel = PriorityModel(
                _priorities[i].priorityName, _priorities[i].id!, i);
          }
          priorityModels.add(PriorityModel(
              _priorities[i].priorityName, _priorities[i].id!, i));
        }
      });
    }

    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          RoundedTextFieldContainer(
              icon: Icons.task_alt,
              changed: (value) {
                _task.taskName = value;
              },
              controllerString: _task.taskName,
              hint: 'Enter todo\'s name'),
          SizedBox(height: size.height * 0.03),
          RoundedButton(
            color: dataButtonColor,
            text: selectedCategoryModel.name != ''
                ? selectedCategoryModel.name
                : 'Select ToDo List',
            press: () async {
              await showMaterialScrollPicker<CategoryModel>(
                context: context,
                title: 'Select category',
                items: categoryModels,
                selectedItem: categoryModels[selectedCategoryModel.index],
                onChanged: (value) => setState(() {
                  selectedCategoryModel = value;
                  _task.todoCategoryId = value.id;
                }),
              );
            },
          ),
          SizedBox(height: size.height * 0.03),
          RoundedButton(
            color: dataButtonColor,
            text: selectedPriorityModel.name,
            press: () async {
              await showMaterialScrollPicker<PriorityModel>(
                context: context,
                title: 'Select priority',
                items: priorityModels,
                selectedItem: priorityModels[selectedPriorityModel.index],
                onChanged: (value) => setState(() {
                  selectedPriorityModel = value;
                  _task.todoPriorityId = value.id;
                }),
              );
            },
          ),
          SizedBox(height: size.height * 0.03),
          RoundedButton(
              color: dataButtonColor,
              text: _task.dueDt == null
                  ? 'Set due date'
                  : DateFormat('dd.MM.yyyy HH:mm')
                      .format(parseUtcToLocal(_task.dueDt!))
                      .toString(),
              //color: cPrimaryDarkColor,
              press: () {
                var currentTime = DateTime.now().toLocal();

                DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: currentTime,
                    maxTime: DateTime(currentTime.year + 2),
                    currentTime: currentTime,
                    onConfirm: (date) => setState(
                          () {
                            _task.dueDt = date.toUtc().toIso8601String();
                          },
                        ));
              }),
          SizedBox(height: size.height * 0.03),
          RoundedButton(
              color: buttonColor,
              text: 'Add',
              press: () async {
                if (_task.taskName.isEmpty) {
                  showWarningSnackBar(
                      'Name can\'t be empty', errorColor, 'OK', context);
                } else if (_task.todoCategoryId.isEmpty) {
                  showWarningSnackBar(
                      'Select category', errorColor, 'OK', context);
                } else {
                  await _tasksCrud.postTask(_task);
                  Navigator.pop(context);
                }
              }),
        ]));
  }
}
