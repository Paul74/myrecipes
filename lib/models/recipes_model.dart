import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Recipe {
  int id;
  int idCat;
  String title = "";
  String notes = "";
  int fav;
  int minutes;
  String difficulty = "";
  int persons;
  String ingredients = "";
  String preparation = "";
  //String color;
}

class RecipesModel extends ChangeNotifier {
  int stackIndex = 0;
  int idcat = 1;
  List recipeList = [];
  Recipe recipeBeingEdited;
  List<bool> selections; // = [false, false, false];
  //String color;

  void setStackIndex(int inStackIndex){
    stackIndex = inStackIndex;
    notifyListeners();
  }


  void setRecipeDifficulty(List<bool> value){
    if (listEquals(value, [true,false,false])) {
      recipesModel.recipeBeingEdited.difficulty = "easy";
    } else if (listEquals(value, [false,true,false])) {
      recipesModel.recipeBeingEdited.difficulty = "medium";
    } else if(listEquals(value, [false,false,true])) {
      recipesModel.recipeBeingEdited.difficulty = "hard";
    } else recipesModel.recipeBeingEdited.difficulty ="";

      notifyListeners();
  }

  void setFav(){
    notifyListeners();
  }

  void setCategory(){
    notifyListeners();
  }


  void loadData(dynamic inDatabaseWorker) async {
    recipeList = await inDatabaseWorker.getAll(recipesModel.idcat);
    notifyListeners();
  }

}

RecipesModel recipesModel = RecipesModel();