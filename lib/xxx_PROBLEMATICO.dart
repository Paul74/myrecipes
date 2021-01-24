import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'common/utils.dart' as utils;
import 'screens/recipes.dart';
import 'package:myrecipes_app/models/recipes_model.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory docsDir = await getApplicationDocumentsDirectory();
  utils.docsDir = docsDir;
  print(docsDir);
  runApp(Notebook());
}

class Notebook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: recipesModel,
        child: Consumer<RecipesModel>(
          builder:(context,recipesModel,child) {return
            IndexedStack(textDirection: TextDirection.ltr,
              index: recipesModel.stackIndex,
                children:[

                MaterialApp(
                  home: Scaffold(
                    appBar: AppBar(
                      title: Text("Notebook list"),
                      actions: <Widget>[
                       IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          print("add recipe");
                          recipesModel.recipeBeingEdited = Recipe();
                          recipesModel.setStackIndex(2);
                        },
                       )
                      ]),
                    body: Recipes(),
                  ),
                ),

                MaterialApp(
                  home: Scaffold(
                    appBar: AppBar(
                      title: Text("recipe")
                        ),
                    body: Recipes(),
                  ),
                ),

                  MaterialApp(
                    home: Scaffold(
                      appBar: AppBar(
                          title: Text("new recipe")
                      ),
                      body: Recipes(),
                    ),
                  )

            ]);
          },
        ),
    );
}
}