import 'package:flut_todo/components/rounded_button.dart';
import 'package:flut_todo/components/rounded_text_field_container.dart';
import 'package:flut_todo/components/snackbars.dart';
import 'package:flut_todo/crud/tasks_crud.dart';
import 'package:flut_todo/models/category.dart';
import 'package:flut_todo/models/task.dart';
import 'package:flut_todo/theme/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

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

class TaskEdit extends StatefulWidget {
  const TaskEdit({Key? key, required this.task, required this.categories})
      : super(key: key);

  final Task task;
  final List<Category> categories;

  @override
  _TaskEditState createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  final TasksCrud _tasksCrud = TasksCrud();

  Task _task = Task(taskName: '', todoCategoryId: '', todoPriorityId: '');
  List<Category> _categories = [];

  bool _isLoaded = false;

  //String newName = '';

  static List<CategoryModel> categoryModels = [];
  CategoryModel selectedCategoryModel = const CategoryModel('', '', 0);

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var buttonColor = _isDarkMode ? cDarkPrimaryColor : cLightPrimaryColor;
    var dataButtonColor =
        _isDarkMode ? cDarkPrimaryColorDark : cLightPrimaryColorDark;
    var deleteButtonColor = _isDarkMode ? cDarkErrorColor : cLightErrorColor;
    Size size = MediaQuery.of(context).size;
    if (_isLoaded == false) {
      setState(() {
        _task = widget.task;
        _categories = widget.categories;
        _isLoaded = true;
        for (var i = 0; i < _categories.length; i++) {
          if (_categories[i].id == _task.todoCategoryId) {
            selectedCategoryModel = CategoryModel(
                _categories[i].categoryName, _categories[i].id!, i);
          }
          categoryModels.add(CategoryModel(
              _categories[i].categoryName, _categories[i].id!, i));
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
            text: selectedCategoryModel.name,
            press: () async {
              await showMaterialScrollPicker<CategoryModel>(
                context: context,
                title: 'Change category',
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
              color: buttonColor,
              text: 'Update',
              press: () async {
                if (_task.taskName.isNotEmpty) {
                  await _tasksCrud.putTask(_task);
                  Navigator.pop(context, false);
                } else {
                  showWarningSnackBar(
                      'Name can\'t be empty', deleteButtonColor, 'OK', context);
                }
              }),
          SizedBox(height: size.height * 0.03),
          RoundedButton(
              text: 'Delete',
              press: () async {
                await _tasksCrud.deleteTask(_task);
                Navigator.pop(context, true);
              },
              color: deleteButtonColor)
        ]));
  }
}
