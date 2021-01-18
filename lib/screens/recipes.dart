import 'package:flutter/material.dart';
import 'package:myrecipes_app/db/recipes_db_worker.dart';
import 'package:provider/provider.dart';
import '../models/recipes_model.dart';
import 'recipes_list.dart';
import 'recipes_entry.dart';

class Notes extends StatelessWidget {

  Notes() {
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
            children: [NotesList(), RecipesEntry()],
          );
        },
      ),
    );
  }
    
}