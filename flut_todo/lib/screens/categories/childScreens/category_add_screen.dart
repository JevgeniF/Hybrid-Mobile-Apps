import 'package:flut_todo/components/rounded_button.dart';
import 'package:flut_todo/components/rounded_text_field_container.dart';
import 'package:flut_todo/components/snackbars.dart';
import 'package:flut_todo/theme/app_constants.dart';
import 'package:flut_todo/crud/categories_crud.dart';
import 'package:flutter/material.dart';

class CategoryAddScreen extends StatefulWidget {
  const CategoryAddScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CategoryAddScreenState createState() => _CategoryAddScreenState();
}

class _CategoryAddScreenState extends State<CategoryAddScreen> {
  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var appBarColor = _isDarkMode ? cDarkPrimaryColor : cLightPrimaryColor;
    return Scaffold(
        appBar:
            AppBar(backgroundColor: appBarColor, title: const Text('Add List')),
        body: const CategoryAdd());
  }
}

class CategoryAdd extends StatefulWidget {
  const CategoryAdd({
    Key? key,
  }) : super(key: key);

  @override
  _CategoryAddState createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  final CategoriesCrud _categoriesCrud = CategoriesCrud();
  String categoryName = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var buttonColor = _isDarkMode ? cDarkPrimaryColor : cLightPrimaryColor;
    var errorColor = _isDarkMode ? cDarkErrorColor : cLightErrorColor;
    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          RoundedTextFieldContainer(changed: (value) {
            categoryName = value;
          }),
          SizedBox(height: size.height * 0.03),
          RoundedButton(
              color: buttonColor,
              text: 'Add',
              press: () async {
                if (categoryName.isNotEmpty) {
                  await _categoriesCrud.postCategory(categoryName);
                  Navigator.pop(context);
                } else {
                  showWarningSnackBar(
                      'Name can\'t be empty', errorColor, 'OK', context);
                }
              }),
        ]));
  }
}
