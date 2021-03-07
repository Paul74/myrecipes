import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Recipe {
  int id;
  int idCat;
  String image = ""; //path to image file
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
  int idcat = 0; //0 to set default all recipes on recipes list opening
  List recipeList = [];
  Recipe recipeBeingEdited;
  List<bool> selections; // = [false, false, false];
  String listOrder = "last";
  //File selectedImage; //for image picker
  //bool inProcess = false; //for image picker
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

  void setImage(){
    notifyListeners();
  }

  void setAppbarTitle(){
    notifyListeners();
  }

  Future<int> deleteImgFile(File file) async {
    try {
      await file.delete();
    } catch (e) {
      print(e);
      return 0;
    }
  }

  void loadData(dynamic inDatabaseWorker) async {
    recipeList = await inDatabaseWorker.getAll(recipesModel.idcat, recipesModel.listOrder);
    notifyListeners();
  }

}

RecipesModel recipesModel = RecipesModel();