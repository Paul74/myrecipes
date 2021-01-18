import 'package:flutter/material.dart';

class Recipe {
  int id;
  String title = "";
  String content = "";
  String color;
}

class RecipesModel extends ChangeNotifier {
  int stackIndex = 0;
  List recipeList = [];
  Recipe recipeBeingEdited;
  String color;

  void setStackIndex(int inStackIndex){
    stackIndex = inStackIndex;
    notifyListeners();
  }

  void setRecipeColor(String inColor){
    color = inColor;
    notifyListeners();
  }

  void loadData(dynamic inDatabaseWorker) async {
    recipeList = await inDatabaseWorker.getAll();
    notifyListeners();
  }

}

RecipesModel recipesModel = RecipesModel();