import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../common/utils.dart' as utils;
import '../models/recipes_model.dart';

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
          "title TEXT,"
          "minutes INTEGER,"
          "difficulty TEXT,"
          "ingredients TEXT,"
          "preparation TEXT,"
          "notes TEXT)");
          //"color TEXT)");
        });
    }
    return _db;
  }

  Recipe recipeFromMap(Map inMap){
    Recipe recipe = Recipe();
    recipe.id = inMap["id"];
    recipe.title = inMap["title"];
    recipe.notes = inMap["notes"];
    recipe.minutes = inMap["minutes"];
    recipe.difficulty = inMap["difficulty"];
    recipe.ingredients = inMap["ingredients"];
    recipe.preparation = inMap["preparation"];
    //recipe.color = inMap["color"];
    return recipe;
  }

  Map<String, dynamic> recipeToMap(Recipe inRecipe) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inRecipe.id;
    map["title"] = inRecipe.title;
    map["notes"] = inRecipe.notes;
    map["minutes"] = inRecipe.minutes;
    map["difficulty"] = inRecipe.difficulty;
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
      "INSERT INTO recipes (id, title, notes, minutes, difficulty, ingredients, preparation) "
      "VALUES (?, ?, ?, ?, ?, ?, ?)",
      [id, inRecipe.title, inRecipe.notes, inRecipe.minutes, inRecipe.difficulty, inRecipe.ingredients, inRecipe.preparation]//, inRecipe.color]
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

}