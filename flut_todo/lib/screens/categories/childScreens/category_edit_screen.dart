import 'package:flut_todo/theme/app_constants.dart';
import 'package:flut_todo/models/category.dart';
import 'package:flut_todo/crud/categories_crud.dart';
import 'package:flut_todo/screens/categories/components/category_edit.dart';
import 'package:flutter/material.dart';

class CategoryEditScreen extends StatefulWidget {
  const CategoryEditScreen(
      {Key? key, required this.categoryId, this.tasksCount = 0})
      : super(key: key);

  final int tasksCount;
  final String categoryId;

  @override
  _CategoryEditScreenState createState() => _CategoryEditScreenState();
}

class _CategoryEditScreenState extends State<CategoryEditScreen> {
  final CategoriesCrud _categoriesCrud = CategoriesCrud();
  late Future catFuture;
  Category _category = Category(categoryName: '');

  @override
  initState() {
    catFuture = getData();
    super.initState();
  }

  getData() async {
    _category = await _categoriesCrud.getCategoryById(widget.categoryId);
    return _category;
  }

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var appBarColor = _isDarkMode ? cDarkPrimaryColor : cLightPrimaryColor;
    return Scaffold(
        appBar: AppBar(title: const Text('Edit List'),
        backgroundColor: appBarColor,),
        body: FutureBuilder(
              future: catFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Center(child: Text('No connection'));
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    return CategoryEdit(
                        category: snapshot.data as Category,
                        tasksCount: widget.tasksCount);
                }
              }),
        );
  }
}
