import 'package:flutter/material.dart';
import 'package:myrecipes_app/db/recipes_db_worker.dart';
import 'package:provider/provider.dart';
import '../models/recipes_model.dart';
import 'recipes_list.dart';
import 'recipes_entry.dart';

class Recipes extends StatelessWidget {

  Recipes() {
    recipesModel.loadData(RecipesDBworker.recipesDBworker);
  }

  @override
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
  }

/*  @override
  Widget build(BuildContext context) {
    return IndexedStack(
            index: recipesModel.stackIndex,
            children: [RecipesList(), RecipesEntry()], // 0=list  1=edit  2=new
          );
        }*/

    
}