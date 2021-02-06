import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Category {
  int id;
  String category = "";
}

class CategoriesModel extends ChangeNotifier {
  List categoryList = [];
  Category categoryBeingEdited;
  //List<bool> selections; // = [false, false, false];

/*  void setRecipeDifficulty(List<bool> value){
    if (listEquals(value, [true,false,false])) {
      recipesModel.recipeBeingEdited.difficulty = "easy";
    } else if (listEquals(value, [false,true,false])) {
      recipesModel.recipeBeingEdited.difficulty = "medium";
    } else if(listEquals(value, [false,false,true])) {
      recipesModel.recipeBeingEdited.difficulty = "hard";
    } else recipesModel.recipeBeingEdited.difficulty ="";
    notifyListeners();
  }*/

  void loadData(dynamic inDatabaseWorker) async {
    categoryList = await inDatabaseWorker.getAllcategories();
    //notifyListeners();
  }

}

CategoriesModel categoriesModel = CategoriesModel();