import 'package:flut_todo/components/floating_add_button.dart';
import 'package:flut_todo/models/category.dart';
import 'package:flut_todo/crud/categories_crud.dart';
import 'package:flut_todo/screens/categories/childScreens/category_add_screen.dart';
import 'package:flut_todo/screens/drawer/main_drawer.dart';
import 'package:flut_todo/theme/app_constants.dart';
import 'package:flutter/material.dart';

import 'components/categories_reorderable_list.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoriesCrud _categoriesCrud = CategoriesCrud();
  late Future catsFuture;
  List<Category> _categories = [];

  @override
  initState() {
    catsFuture = getData();
    super.initState();
  }

  getData() async {
    _categories = await _categoriesCrud.getCategories();
    return _categories;
  }

  refreshData() {
    catsFuture = getData();
  }

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var appBarColor = _isDarkMode ? cDarkPrimaryColor : cLightPrimaryColor;
    return Scaffold(
        drawer: const MainDrawer(),
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text('ToDo\'s Lists'),
        ),
        body: FutureBuilder(
            future: catsFuture,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const Center(child: Text('No connection'));
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  return CategoriesReorderableList(categories: _categories);
              }
            }),
        floatingActionButton: FloatingAddButton(press: () {
          Navigator.of(context)
              .push(MaterialPageRoute<bool>(
                  builder: (context) => const CategoryAddScreen()))
              .then((_) => setState(() {
                    refreshData();
                  }));
        }));
  }
}
