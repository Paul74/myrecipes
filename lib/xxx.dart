import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'common/utils.dart' as utils;
import 'screens/recipes.dart';
import 'package:myrecipes_app/models/recipes_model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory docsDir = await getApplicationDocumentsDirectory();
  utils.docsDir = docsDir;
  runApp(Notebook());
}

class Notebook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Notebook"),
          actions: <Widget>[
            if (recipesModel.stackIndex==0) //da implementare il funzionamento, non si aggiorna la appbar
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                print("add recipe");
                recipesModel.recipeBeingEdited = Recipe();
                recipesModel.setStackIndex(1);
              },
            ),
          ],
        ),
        body: Recipes(),
      ),
    );

  }
}