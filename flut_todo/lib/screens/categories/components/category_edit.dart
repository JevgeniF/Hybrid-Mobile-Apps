import 'package:flut_todo/components/rounded_button.dart';
import 'package:flut_todo/components/rounded_text_field_container.dart';
import 'package:flut_todo/components/snackbars.dart';
import 'package:flut_todo/crud/categories_crud.dart';
import 'package:flut_todo/models/category.dart';
import 'package:flut_todo/theme/app_constants.dart';
import 'package:flutter/material.dart';

class CategoryEdit extends StatefulWidget {
  const CategoryEdit({Key? key, required this.category, this.tasksCount = 0})
      : super(key: key);

  final int tasksCount;
  final Category category;

  @override
  _CategoryEditState createState() => _CategoryEditState();
}

class _CategoryEditState extends State<CategoryEdit> {
  final CategoriesCrud _categoriesCrud = CategoriesCrud();
  Category _category = Category(categoryName: '');
  bool _isLoaded = false;

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var buttonColor = _isDarkMode ? cDarkPrimaryColor : cLightPrimaryColor;
    var deleteButtonColor = _isDarkMode ? cDarkErrorColor : cLightErrorColor;
    Size size = MediaQuery.of(context).size;
    if (_isLoaded == false) {
      setState(() {
        _category = widget.category;
        _isLoaded = true;
      });
    }
    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          RoundedTextFieldContainer(
            changed: (value) {
              _category.categoryName = value;
            },
            controllerString: _category.categoryName,
          ),
          SizedBox(height: size.height * 0.03),
          RoundedButton(
              color: buttonColor,
              text: 'Update',
              press: () async {
                if (_category.categoryName.isNotEmpty) {
                  await _categoriesCrud.putCategory(_category);
                  Navigator.pop(context, false);
                } else {
                  showWarningSnackBar(
                      'Name can\'t be empty', deleteButtonColor, 'OK', context);
                }
              }),
          SizedBox(height: size.height * 0.03),
          widget.tasksCount != 0
              ? RoundedButton(
                  text: 'Delete',
                  press: () {
                    showWarningSnackBar(
                        'You can\'t delete list, as you have ${widget.tasksCount} todo(s) in it.',
                        deleteButtonColor,
                        'OK',
                        context);
                  },
                  color: Colors.grey,
                )
              : RoundedButton(
                  color: deleteButtonColor,
                  text: 'Delete',
                  press: () async {
                    await _categoriesCrud.deleteCategory(_category);
                    Navigator.pop(context, true);
                  },
                )
        ]));
  }
}
