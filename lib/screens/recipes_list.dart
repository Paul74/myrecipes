import 'package:flutter/material.dart';
import 'package:myrecipes_app/db/recipes_db_worker.dart';
import 'package:myrecipes_app/models/recipes_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RecipesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: (){
          recipesModel.recipeBeingEdited = Recipe();
          recipesModel.setStackIndex(1);
        },
      ),
      body: ListView.builder(
        itemCount: recipesModel.recipeList.length,
        itemBuilder: (BuildContext inBuildContext, int inIndex){
          Recipe recipe = recipesModel.recipeList[inIndex];
          Color color = Colors.white;
          switch(recipe.color){
            case "red":
              color = Colors.red;
              break;
            case "blue":
              color = Colors.blue;
              break;
            case "yellow":
              color = Colors.yellow;
              break;
            case "grey":
              color = Colors.grey;
              break;
          }
          return Card(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            elevation: 6,
            child: Slidable(
              actionPane: SlidableScrollActionPane(),
              actionExtentRatio: .25,
              secondaryActions: [
                IconSlideAction(
                  caption: "Delete",
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: (){
                    _deleteRecipe(context, recipe);
                  },
                ),
              ],
              child: ListTile(
                title: Text("${recipe.title}"),
                subtitle: Text("${recipe.content}"),
                tileColor: color,
                leading: Icon(Icons.photo),
                trailing: Icon(Icons.arrow_right),
                onTap: () async {
                  recipesModel.recipeBeingEdited = await RecipesDBworker.recipesDBworker.get(recipe.id);
                  recipesModel.setRecipeColor(recipesModel.recipeBeingEdited.color);
                  recipesModel.setStackIndex(1);
                },
              ),
            ),
          );

        },
      ),
    );
  }

  Future _deleteRecipe(BuildContext context, Recipe recipe) async {
    return showDialog(
        context: context,
      barrierDismissible: false,
      builder: (BuildContext inAlertContext){
          return AlertDialog(
            title: Text("Delete recipe"),
            content: Text("Are you sure you want to delete ${recipe.title}"),
            actions: [
              FlatButton(
                  onPressed: (){
                    Navigator.of(inAlertContext).pop();
                  },
                  child: Text("Cancel"),
              ),
              FlatButton(
                  onPressed: () async {
                    await RecipesDBworker.recipesDBworker.delete(recipe.id);
                    Navigator.of(inAlertContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text("Recipe deleted"),
                      ),
                    );
                    recipesModel.loadData(RecipesDBworker.recipesDBworker);
                  },
                  child: Text("Delete"),
              ),
            ],
          );
      }
    );
  }

}