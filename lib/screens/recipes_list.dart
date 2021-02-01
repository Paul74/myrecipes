import 'package:flutter/material.dart';
import 'package:myrecipes_app/db/recipes_db_worker.dart';
import 'package:myrecipes_app/models/recipes_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:io';

class RecipesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: (){
          recipesModel.recipeBeingEdited = Recipe();
          recipesModel.selections = [false,false,false];
          recipesModel.setStackIndex(1);
        },
      ),
      body: ListView.builder(
        itemCount: recipesModel.recipeList.length,
        itemExtent: 106.0,
        padding: EdgeInsets.all(4.0),
        itemBuilder: (BuildContext inBuildContext, int inIndex){
          Recipe recipe = recipesModel.recipeList[inIndex];
          /*Color color = Colors.white;
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
          }*/
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),),
            clipBehavior: Clip.hardEdge,
            color: Colors.brown.shade100,
            //padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
            margin: EdgeInsets.all(5.0),
            child: Slidable(
              actionPane: SlidableScrollActionPane(),
              actionExtentRatio: .25,
              secondaryActions: [
                IconSlideAction(
                  caption: "Delete",
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: (){
                    print("Card deleting");
                    _deleteRecipe(context, recipe);
                  },
                ),
              ],
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () async {
                  recipesModel.recipeBeingEdited = await RecipesDBworker.recipesDBworker.get(recipe.id);
                  recipesModel.selections = (recipesModel.recipeBeingEdited.difficulty=="easy")? recipesModel.selections=[true,false,false]:(recipesModel.recipeBeingEdited.difficulty=="medium")? recipesModel.selections=[false,true,false]:(recipesModel.recipeBeingEdited.difficulty=="hard")? recipesModel.selections=[false,false,true]: recipesModel.selections=[false,false,false];
                  //recipesModel.setRecipeColor(recipesModel.recipeBeingEdited.color);
                  recipesModel.setStackIndex(1);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: SizedBox.expand(child:
                        Image.file(File('storage/emulated/0/Download/catEU.jpg'),
                        fit: BoxFit.cover,
                      ),),
                    ),
                    Expanded(
                      flex: 3,
                      child: _RecipeDescription(
                        title: "${recipe.title}",
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _Details(
                        fav: "${recipe.fav}",
                        difficulty: "${recipe.difficulty}",
                        minutes: "${recipe.minutes}",
                      ),
                    ),
                    const Icon(
                      Icons.more_vert,
                      size: 16.0,
                    ),
                  ],
                ),
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

class _RecipeDescription extends StatelessWidget {
  const _RecipeDescription({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7.0, 0.0, 0.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({
    Key key,
    this.fav,
    this.difficulty,
    this.minutes,
  }) : super(key: key);

  final String fav;
  final String difficulty;
  final String minutes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[fav == '1' ?
          Icon(Icons.favorite, color: Colors.red, size: 18) : Icon(Icons.favorite_border, color: Colors.grey, size: 18),
          const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          Text(
            difficulty,
            style: const TextStyle(fontSize: 12.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          Text(
            //'$minutes\'',
            minutes == 'null' ? '' : ('$minutes\''),
            style: const TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}
