import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myrecipes_app/screens/recipes_entry.dart';
import 'package:path_provider/path_provider.dart';
import 'common/utils.dart' as utils;
import 'screens/recipes.dart';
import 'package:myrecipes_app/models/recipes_model.dart';
import 'package:provider/provider.dart';


//TODO conviene gestire le pagine con il semplice navigator, così ho animazioni automatiche e appbar più facili da fare per ogni pagina.
// vedi https://github.com/flutter/samples/tree/master/provider_shopper
class Notebook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("myrecipes"),
        ),
        body: Recipes(),
      ),
    );
  }
}




//segue come avevo fatto io, soprattutto per mettere il + nella appbar. ma è troppo complicato e ci sono cose inutili.
/*
class Notebook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: recipesModel,
        child:
      MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("myapp"),
          actions: <Widget>[
            //if (recipesModel.stackIndex==0) //da implementare il funzionamento, non si aggiorna la appbar

            Consumer<RecipesModel>(
              builder:(context,recipesModel,child) {return
                IndexedStack(index: recipesModel.stackIndex,children:[
                 IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    print("add recipe");
                    recipesModel.recipeBeingEdited = Recipe();
                    recipesModel.setStackIndex(1);
                  },
                 ),
                 Container() //blanck container because I don't need buttons on recipe edit/new
                ]);
              },
            ),

          ],
        ),
        body: Recipes(),
      ),
    ),);
  }
}*/
