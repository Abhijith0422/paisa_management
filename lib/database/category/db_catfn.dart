import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:paisa_management/main.dart';
import 'package:paisa_management/models/category/categorymodel.dart';

const categorydbname = 'category-database';

abstract class CategoryDB {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String id);
}

class CategoriesDB implements CategoryDB {
  CategoriesDB._internal();
  static CategoriesDB instance = CategoriesDB._internal();
  factory CategoriesDB() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategories = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategories = ValueNotifier([]);
  @override
  Future<void> insertCategory(CategoryModel value) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(categorydbname);
    await _categoryDB.put(value.id, value);
    refreshUi();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _categoryDB = await Hive.openBox<CategoryModel>(categorydbname);
    return _categoryDB.values.toList();
  }

  Future<void> refreshUi() async {
    final _allCategories = await getCategories();
    incomeCategories.value.clear();
    expenseCategories.value.clear();
    await Future.forEach(_allCategories, (CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomeCategories.value.add(category);
      } else {
        expenseCategories.value.add(category);
      }
    });
    incomeCategories.notifyListeners();
    expenseCategories.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String id) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(categorydbname);
    await _categoryDB.delete(id);
    refreshUi();
  }
}
