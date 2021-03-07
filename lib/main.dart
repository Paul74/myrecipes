/// Flutter code sample for ListTile

// Here is an example of a custom list item that resembles a Youtube related
// video list item created with [Expanded] and [Container] widgets.
//
// ![Custom list item a](https://flutter.github.io/assets-for-api-docs/assets/widgets/custom_list_item_a.png)

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myrecipes_app/app.dart';
import 'package:path_provider/path_provider.dart';
import 'common/utils.dart' as utils;
import 'db/recipes_db_worker.dart';
import 'screens/recipes.dart';
import 'package:myrecipes_app/models/recipes_model.dart';
import 'package:myrecipes_app/models/categories_model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory docsDir = await getApplicationDocumentsDirectory();
  //var docsDir = new Directory('/data/user/0/com.example.myrecipes_app/app_flutter'); //per l'ufficio
  utils.docsDir = docsDir;
  //categoriesModel.loadData(RecipesDBworker.recipesDBworker); //provo a metterlo in recipes.dat devo caricare la lista delle categorie
  runApp(app());
  print(docsDir);
  //runApp(MyApp());
}