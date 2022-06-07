import 'package:flut_todo/components/list_item_container_with_row.dart';
import 'package:flut_todo/components/list_item_description.dart';
import 'package:flut_todo/components/list_item_name.dart';
import 'package:flut_todo/crud/categories_crud.dart';
import 'package:flut_todo/crud/tasks_crud.dart';
import 'package:flut_todo/models/category.dart';
import 'package:flut_todo/models/task.dart';
import 'package:flut_todo/screens/categories/childScreens/category_edit_screen.dart';
import 'package:flut_todo/screens/tasks/tasks_screen.dart';
import 'package:flut_todo/theme/app_constants.dart';
import 'package:flutter/material.dart';

import 'categories_list_item_tasks_counter.dart';
import 'category_icon.dart';

class CategoriesReorderableList extends StatefulWidget {
  const CategoriesReorderableList({
    Key? key,
    required this.categories,
  }) : super(key: key);

  final List<Category> categories;

  @override
  _CategoriesReorderableListState createState() =>
      _CategoriesReorderableListState();
}

class _CategoriesReorderableListState extends State<CategoriesReorderableList> {
  List<Category> categories = [];
  List<Task> tasks = [];

  final CategoriesCrud _categoriesCrud = CategoriesCrud();
  final TasksCrud _tasksCrud = TasksCrud();

  @override
  initState() {
    categories = widget.categories;
    refreshTasks();
    super.initState();
  }

  void refreshTasks() {
    setState(() {
      _tasksCrud.getTasks().then((value) => setState(() {
            tasks = value;
          }));
    });
  }

  int getTasksCountForCategory(String? categoryId) {
    if (categoryId == null) {
      return tasks.length;
    }
    int count = 0;
    for (var task in tasks) {
      if (categoryId == task.todoCategoryId) {
        count += 1;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    var itemColor = _isDarkMode ? cDarkCardColor : cLightCardColor;
    var headerColor =
        _isDarkMode ? cDarkPrimaryColorLight : cLightPrimaryColorLight;
    return ReorderableListView.builder(
      header: ListItemContainerWithRow(children: [
        const CategoryIcon(),
        const SizedBox(width: 10),
        ListItemDescription(
            children: const [ListItemName(itemName: 'All ToDo\'s')],
            tap: () {}),
        const Spacer(flex: 1),
        CategoriesListItemTasksCounter(
            tasksCount: getTasksCountForCategory(null),
            tap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => TasksScreen(
                          categoryId: null, categories: categories)))
                  .then((_) {
                refreshTasks();
              });
            })
      ], color: headerColor),
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        return ListItemContainerWithRow(
          key: ValueKey('$index'),
          color: itemColor,
          children: [
            const CategoryIcon(),
            const SizedBox(width: 15),
            ListItemDescription(
                children: [
                  ListItemName(itemName: categories[index].categoryName)
                ],
                tap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute<bool>(
                          builder: (context) => CategoryEditScreen(
                              categoryId: categories[index].id!,
                              tasksCount: getTasksCountForCategory(
                                  categories[index].id!))))
                      .then((value) {
                    if (value == true) {
                      setState(() {
                        categories.remove(categories[index]);
                      });
                    }
                    if (value == false) {
                      _categoriesCrud
                          .getCategoryById(categories[index].id!)
                          .then((value) => setState(() {
                                categories[index] = value;
                              }));
                    }
                  });
                }),
            const Spacer(flex: 1),
            CategoriesListItemTasksCounter(
                tasksCount: getTasksCountForCategory(categories[index].id),
                tap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => TasksScreen(
                                categoryId: categories[index].id,
                                categories: categories,
                              )))
                      .then((_) {
                    refreshTasks();
                  });
                }),
          ],
        );
      },
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final Category category = categories.removeAt(oldIndex);
          categories.insert(newIndex, category);
        });
      },
    );
  }
}
