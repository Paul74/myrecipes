import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myrecipes_app/db/recipes_db_worker.dart';
import 'package:myrecipes_app/models/recipes_model.dart';
import 'package:myrecipes_app/models/categories_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:io';

class RecipesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: Drawer(), //TODO to be implemented
      appBar: AppBar(
        title: Text("my Recipes"),
        actions: [
          IconButton(icon: Icon(Icons.add), iconSize: 36,
            onPressed: (){
              recipesModel.recipeBeingEdited = Recipe();
              recipesModel.selections = [false,false,false];
              //recipesModel.setStackIndex(1);
              Navigator.pushNamed(context, '/entry');
            })
        ],
        bottom: PreferredSize(preferredSize: Size.fromHeight(52.0),
            child: Container(//height: 62,
              padding: EdgeInsets.fromLTRB(0,0,0,6),
              child: Row(
                children: [SizedBox(width: 74),
                  Expanded(
                    /*1*/
                    child: Container(height: 50,
                      padding: EdgeInsets.fromLTRB(8,0,8,0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),

                      child:
                      InputDecorator(decoration: InputDecoration(labelText: "category:", border: InputBorder.none, isDense: true),
                        child: DropdownButton(
                          underline: SizedBox(), //no underline
                          //dropdownColor: Theme.of(context).primaryColorLight,
                          //style: TextStyle(color: Theme.of(context).primaryColorLight,),
                          isExpanded: true,
                          isDense: true,
                          icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
                          iconSize: 18,
                          //hint: Text("select a category"),
                          value: recipesModel.idcat,
                          items: [for (Category categ in categoriesModel.categoryList) DropdownMenuItem(
                              child: Text(categ.category),
                              value: categ.id
                          )],
                          onChanged: (value) {
                            recipesModel.idcat = value;
                            recipesModel.loadData(RecipesDBworker.recipesDBworker);
                            //recipesModel.setCategory();
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 24),
                  /*3*/
                  InkWell(onTap: (){
                    showDialog(context: context,
                      builder: (inAlertContext) => AlertDialog(
                        title: Text("list order by", textAlign: TextAlign.center,),
                        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(child: Text("title"), onTap: (){
                                recipesModel.listOrder == "AZ" ?
                                recipesModel.listOrder = "ZA":
                                recipesModel.listOrder = "AZ";
                                if (recipesModel.listOrder == "last") recipesModel.listOrder = "AZ";
                                recipesModel.loadData(RecipesDBworker.recipesDBworker);
                                Navigator.pop(inAlertContext);
                                },),
                              SizedBox(height: 18),
                              InkWell(child: Text("last added"), onTap: (){
                                recipesModel.listOrder = "last";
                                recipesModel.loadData(RecipesDBworker.recipesDBworker);
                                Navigator.pop(inAlertContext);
                                },),
                            ]
                        ),
                        //actions: [TextButton(onPressed: (){Navigator.pop(inAlertContext);}, child: Text("CANCEL"))],
                      ),
                    );
                  },

                  /*{
                    recipesModel.listOrder == "AZ" ?
                      recipesModel.listOrder = "ZA":
                      recipesModel.listOrder = "AZ";
                    recipesModel.loadData(RecipesDBworker.recipesDBworker);
                  },*/
                    child: Icon(
                      Icons.sort_by_alpha_rounded,
                      color: Theme.of(context).primaryColorLight,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).primaryColorLight,
                    size: 30,
                  ),
                  SizedBox(width: 10),
                ],
              ),


            )

        ),
      ),
/*      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: (){
          recipesModel.recipeBeingEdited = Recipe();
          recipesModel.selections = [false,false,false];
          //recipesModel.setStackIndex(1);
          Navigator.pushNamed(context, '/entry');
        },
      ),*/
      body: (recipesModel.idcat != 0 && recipesModel.recipeList.length == 0)
      ? Center(child: Text("No recipes for this category", style: TextStyle(fontSize: 18.0)))
      : (recipesModel.idcat == 0 && recipesModel.recipeList.length == 0)
      ? Center(heightFactor: 3,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget> [
            RichText(text: TextSpan(style: TextStyle(
              //fontWeight: FontWeight.w400,
              color: Colors.black,
              fontSize: 18.0,
              height: 1.8,
            ), children: <TextSpan> [
              TextSpan(text: "insert your recipes\n"),
              TextSpan(text: "hitting the"),
              TextSpan(text: " + ", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 32.0, height: 0.8)),
              TextSpan(text: "button"),
            ])),
            Image.asset("assets/images/arrow.png", fit: BoxFit.cover, scale: 2)
          ]
      )
      )
      :
      ListView.builder(
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
            color: Theme.of(context).primaryColorLight,
            //padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
            margin: EdgeInsets.all(5.0),
            child: Slidable(
              actionPane: SlidableScrollActionPane(),
              actionExtentRatio: .25,
              secondaryActions: [
                IconSlideAction(
                  caption: "DELETE",
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: (){
                    print("Card deleting");
                    _deleteRecipe(context, recipe, recipe.image);
                  },
                ),
              ],
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () async {
                  recipesModel.recipeBeingEdited = await RecipesDBworker.recipesDBworker.get(recipe.id);
                  recipesModel.selections = (recipesModel.recipeBeingEdited.difficulty=="easy")? recipesModel.selections=[true,false,false]:(recipesModel.recipeBeingEdited.difficulty=="medium")? recipesModel.selections=[false,true,false]:(recipesModel.recipeBeingEdited.difficulty=="hard")? recipesModel.selections=[false,false,true]: recipesModel.selections=[false,false,false];
                  //recipesModel.setStackIndex(1);
                  Navigator.pushNamed(context, '/entry');
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: SizedBox.expand(child:
                        recipe.image != "" ? Image.file(File("${recipe.image}"), fit: BoxFit.cover) : Image.asset("assets/images/dish-placeholder.png", fit: BoxFit.cover),
                        //fit: BoxFit.cover,
                      ),
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
                    Icon(
                      Icons.arrow_left_rounded,
                      size: 22.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          );

        },
      )

    );
  }

  Future _deleteRecipe(BuildContext context, Recipe recipe, String image) async {
    return showDialog(context: context, barrierDismissible: false,
      builder: (BuildContext inAlertContext){
          return AlertDialog(
            title: Text("Delete recipe"),
            content: Text("Are you sure you want to delete ${recipe.title}?"),
            actions: [
              TextButton(
                  onPressed: () async {
                    await RecipesDBworker.recipesDBworker.delete(recipe.id); //delete db entry
                    if (image != "") recipesModel.deleteImgFile(File(image)); //delete the image file from device
                    Navigator.of(inAlertContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text("RECIPE DELETED", textAlign: TextAlign.center),
                      ),
                    );
                    recipesModel.loadData(RecipesDBworker.recipesDBworker);
                  },
                  child: Text("YES, DELETE"),
              ),
              TextButton(
                onPressed: (){
                  Navigator.of(inAlertContext).pop();
                },
                child: Text("NO"),
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
