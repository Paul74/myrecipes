import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../common/utils.dart' as utils;
import '../models/recipes_model.dart';
import '../models/categories_model.dart';

class RecipesDBworker {

  RecipesDBworker._();
  static final RecipesDBworker recipesDBworker = RecipesDBworker._();

  Database _db;

  Future<Database> _getDB() async {
    if(_db==null){
      String path = join(utils.docsDir.path, "recipes.db");
      _db = await openDatabase(path, version: 1,
        onCreate: (Database inDB, int inVersion) async {
          await inDB.execute("CREATE TABLE IF NOT EXISTS recipes ("
          "id INTEGER PRIMARY KEY,"
          "idCat INTEGER,"
          "title TEXT,"
          "fav INTEGER,"
          "minutes INTEGER,"
          "difficulty TEXT,"
          "persons INTEGER,"
          "ingredients TEXT,"
          "preparation TEXT,"
          "notes TEXT)");
          //"color TEXT)");

          await inDB.execute("CREATE TABLE IF NOT EXISTS categories ("
          "id INTEGER PRIMARY KEY,"
          "category TEXT)");

          //procedura per creare delle categorie di default nella tabella categories
            int id1 = await inDB.rawInsert(
                'INSERT INTO categories (id, category) VALUES (1, "APPETIZERS")');
            print('inserted1: $id1'); //TODO debug only, remove
            int id2 = await inDB.rawInsert(
                'INSERT INTO categories (id, category) VALUES (2, "STARTERS")');
            print('inserted2: $id2'); //TODO debug only, remove
          //

        });
    }
    return _db;
  }

  Recipe recipeFromMap(Map inMap){
    Recipe recipe = Recipe();
    recipe.id = inMap["id"];
    recipe.idCat = inMap["idCat"];
    recipe.title = inMap["title"];
    recipe.fav = inMap["fav"];
    recipe.notes = inMap["notes"];
    recipe.minutes = inMap["minutes"];
    recipe.difficulty = inMap["difficulty"];
    recipe.persons = inMap["persons"];
    recipe.ingredients = inMap["ingredients"];
    recipe.preparation = inMap["preparation"];
    //recipe.color = inMap["color"];
    return recipe;
  }

  Map<String, dynamic> recipeToMap(Recipe inRecipe) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inRecipe.id;
    map["idCat"] = inRecipe.idCat;
    map["title"] = inRecipe.title;
    map["fav"] = inRecipe.fav;
    map["notes"] = inRecipe.notes;
    map["minutes"] = inRecipe.minutes;
    map["difficulty"] = inRecipe.difficulty;
    map["persons"] = inRecipe.persons;
    map["ingredients"] = inRecipe.ingredients;
    map["preparation"] = inRecipe.preparation;
    //map["color"] = inRecipe.color;
    return map;
  }

  Future create(Recipe inRecipe) async {
    Database db = await _getDB();
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM recipes");
    int id = val.first["id"];
    if (id==null){
      id = 1;
    }
    return await db.rawInsert(
      "INSERT INTO recipes (id, idCat, title, fav, notes, minutes, difficulty, persons, ingredients, preparation) "
      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
      [id, inRecipe.idCat, inRecipe.title, inRecipe.fav, inRecipe.notes, inRecipe.minutes, inRecipe.difficulty, inRecipe.persons, inRecipe.ingredients, inRecipe.preparation]//, inRecipe.color]
    );
  }

  Future<Recipe> get(int inID) async {
    Database db = await _getDB();
    var rec = await db.query("recipes", where: "id = ?", whereArgs: [inID]);
    return recipeFromMap(rec.first);
  }

  Future<List> getAll() async {
    Database db = await _getDB();
    var recs = await db.query("recipes");
    var list = recs.isEmpty ? [] : recs.map((m) => recipeFromMap(m)).toList();
    return list;
  }

  Future update(Recipe inRecipe) async {
    Database db = await _getDB();
    return await db.update("recipes", recipeToMap(inRecipe), where: "id = ?", whereArgs: [inRecipe.id]);
  }

  Future delete(int inID) async {
    Database db = await _getDB();
    return await db.delete("recipes", where: "id = ?", whereArgs: [inID]);
  }


 //// SEZIONE PER IL DB CATEGORIES

 Category categoryFromMap(Map inMap){
   Category category = Category();
   category.id = inMap["id"];
   category.category = inMap["category"];
   return category;
 }

 Map<String, dynamic> categoryToMap(Category inCategory) {
   Map<String, dynamic> map = Map<String, dynamic>();
   map["id"] = inCategory.id;
   map["category"] = inCategory.category;
   return map;
 }


 Future<List> getAllcategories() async {
   Database db = await _getDB();
   var categs = await db.query("categories");
   var list = categs.isEmpty ? [] : categs.map((m) => categoryFromMap(m)).toList();
   return list;
 }








}