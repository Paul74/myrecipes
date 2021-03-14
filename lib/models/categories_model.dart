import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Category {
  int id = 0;
  String category = "";
}

class CategoriesModel extends ChangeNotifier {
  List<Category> categoryList = [];
  Category? categoryBeingEdited;
  //List<bool> selections; // = [false, false, false];

  void loadData(dynamic inDatabaseWorker) async {
    categoryList = await inDatabaseWorker.getAllcategories();
    notifyListeners();
  }

}

CategoriesModel categoriesModel = CategoriesModel();