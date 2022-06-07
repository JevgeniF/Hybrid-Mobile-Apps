// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:flut_todo/api/api.dart';
import 'package:flut_todo/authentication/models/user.dart';
import 'package:flut_todo/crud/get_user_data.dart';
import 'package:flut_todo/models/category.dart';
import 'package:http/http.dart' as http;

class CategoriesCrud {
  var CATEGORIES_URL = Api.CATEGORIES_URL;

  User _user = User();

  Future<List<Category>> getCategories() async {
    List<Category> categoriesList = [];

    _user = await getUser();

    try {
      final response = await http.get(Uri.parse(CATEGORIES_URL),
          headers: {'Authorization': 'Bearer ' + (_user.token!)});
      final responseData = jsonDecode(response.body);

      if (response.statusCode != 200) {
        log('Provider.Categories Crud. GetCategories: statusCode: ' +
            response.statusCode.toString());
      } else {
        log('Provider.Categories Crud. GetCategories: OK');
        categoriesList = await responseData.map<Category>((json) {
          return Category.fromJson(json);
        }).toList();
      }
    } catch (e) {
      log('Provider.Categories Crud. GetCategories error: ' + e.toString());
    }
    return categoriesList;
  }

  Future<Category> getCategoryById(String categoryId) async {
    Category category = Category(categoryName: '');

    _user = await getUser();

    try {
      final response = await http.get(Uri.parse(CATEGORIES_URL + categoryId),
          headers: {'Authorization': 'Bearer ' + (_user.token!)});
      final responseData = jsonDecode(response.body);

      if (response.statusCode != 200) {
        log('Provider.Categories Crud. GetCategoryById: statusCode: ' +
            response.statusCode.toString());
      } else {
        log('Provider.Categories Crud. GetCategoryById: OK');
        return category = Category.fromJson(responseData);
      }
    } catch (e) {
      log('Provider.Categories Crud. GetCategoryById error: ' + e.toString());
    }
    return category;
  }

  Future<void> postCategory(String categoryName) async {
    _user = await getUser();

    try {
      final response = await http.post(Uri.parse(CATEGORIES_URL),
          headers: {
            'Authorization': 'Bearer ' + (_user.token!),
            "Content-Type": "application/json"
          },
          body: json.encode({
            'categoryName': categoryName,
          }));

      if (response.statusCode == 201) {
        log('Provider.Categories Crud. postCategory: OK');
      } else {
        log('Provider.Categories Crud. postCategory: statusCode: ' +
            response.statusCode.toString());
      }
    } catch (e) {
      log('Provider.Categories Crud. postCategory error: ' + e.toString());
    }
  }

  Future<void> putCategory(Category category) async {
    _user = await getUser();

    try {
      final response = await http.put(Uri.parse(CATEGORIES_URL + category.id!),
          headers: {
            'Authorization': 'Bearer ' + (_user.token!),
            "Content-Type": "application/json"
          },
          body: json.encode({
            'id': category.id,
            'categoryName': category.categoryName,
          }));

      if (response.statusCode == 204) {
        log('Provider.Categories Crud. putCategory: OK');
      } else {
        log('Provider.Categories Crud. putCategory: statusCode: ' +
            response.statusCode.toString());
      }
    } catch (e) {
      log('Provider.Categories Crud. putCategory error: ' + e.toString());
    }
  }

  Future<void> deleteCategory(Category category) async {
    _user = await getUser();

    try {
      final response = await http.delete(
          Uri.parse(CATEGORIES_URL + category.id!),
          headers: {
            'Authorization': 'Bearer ' + (_user.token!),
            "Content-Type": "application/json"
          },
          body: json.encode({
            'id': category.id,
          }));

      if (response.statusCode == 204) {
        log('Provider.Categories Crud. deleteCategory: OK');
      } else {
        log('Provider.Categories Crud. deleteCategory: statusCode: ' +
            response.statusCode.toString());
      }
    } catch (e) {
      log('Provider.Categories Crud. deleteCategory error: ' + e.toString());
    }
  }
}
