import 'package:flutter/material.dart';
import 'package:myrecipes_app/db/recipes_db_worker.dart';
import 'package:myrecipes_app/models/categories_model.dart';
import 'package:provider/provider.dart';
import '../models/recipes_model.dart';
import 'recipes_list.dart';
import 'recipes_entry.dart';

class Recipes extends StatelessWidget {

  Recipes() {
    recipesModel.loadData(RecipesDBworker.recipesDBworker); //also in recipes_list  don't know if it's best practice
    categoriesModel.loadData(RecipesDBworker.recipesDBworker); //era neil main ma meglio qui - devo caricare la lista delle categorie
  }

//quello buono
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

  //provo a usare le routes
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











//boh vecchio
/*  @override
  Widget build(BuildContext context) {
    return IndexedStack(
            index: recipesModel.stackIndex,
            children: [RecipesList(), RecipesEntry()], // 0=list  1=edit  2=new
          );
        }*/

    
}