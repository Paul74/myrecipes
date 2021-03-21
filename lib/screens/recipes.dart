import 'package:flutter/material.dart';
import 'package:myrecipes_app/db/recipes_db_worker.dart';
import 'package:myrecipes_app/models/categories_model.dart';
import 'package:provider/provider.dart';
import '../models/recipes_model.dart';
import 'recipes_list.dart';

class Recipes extends StatelessWidget {

  Recipes() {
    categoriesModel.loadData(RecipesDBworker.recipesDBworker); //era neil main ma meglio qui - devo caricare la lista delle categorie
    recipesModel.loadData(RecipesDBworker.recipesDBworker); //also in recipes_list  don't know if it's best practice
  }

//old one, with stack, working
  /*  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: recipesModel,
      child: Consumer<RecipesModel>(
        builder: (context, recipesModel, child){
          return IndexedStack(
            index: recipesModel.stackIndex,
            children: [RecipesList(), RecipesEntry()],
          );
        },
      ),
    );
  }*/

  //using routes
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: recipesModel,
      child: Consumer<RecipesModel>(
        builder: (context, recipesModel, child){
          return RecipesList();
        },
      ),
    );
  }

}