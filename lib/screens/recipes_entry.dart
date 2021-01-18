import 'package:flutter/material.dart';
import 'package:myrecipes_app/db/recipes_db_worker.dart';
import 'package:myrecipes_app/models/recipes_model.dart';

class RecipesEntry extends StatelessWidget{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Row(
          children: [
            FlatButton(
                onPressed: (){
                  recipesModel.setStackIndex(0);
                },
                child: Text("Cancel"),
            ),
            Spacer(),
            FlatButton(
                onPressed: (){
                  _save(context);
                },
                child: Text("Save"),
            ),
          ],
        )
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.title),
              title: TextFormField(
                decoration: InputDecoration(hintText: "Title"),
                initialValue: recipesModel.recipeBeingEdited == null ? null : recipesModel.recipeBeingEdited.title,
                validator: (String inValue){
                  if(inValue.length==0){
                    return "Please enter a title";
                  }
                  return null;
                },
                onChanged: (String inValue){
                  recipesModel.recipeBeingEdited.title = inValue;
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.content_paste),
              title: TextFormField(
                decoration: InputDecoration(hintText: "Content"),
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                initialValue: recipesModel.recipeBeingEdited == null ? null : recipesModel.recipeBeingEdited.content,
                validator: (String inValue){
                  if(inValue.length==0){
                    return "Please enter content";
                  }
                  return null;
                },
                onChanged: (String inValue){
                  recipesModel.recipeBeingEdited.content = inValue;
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.color_lens),
              title: Row(
                children: [
                  GestureDetector(
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: Border.all(
                          color: Colors.red,
                          width: 18,
                        ) + Border.all(
                              width: 6,
                              color: recipesModel.color == "red" ? Colors.red : Theme.of(context).canvasColor,
                            )
                      ),
                    ),
                    onTap: (){
                      recipesModel.recipeBeingEdited.color = "red";
                      recipesModel.setRecipeColor("red");
                    },
                  ),
                  Spacer(),
                  GestureDetector(
                    child: Container(
                      decoration: ShapeDecoration(
                          shape: Border.all(
                            color: Colors.blue,
                            width: 18,
                          ) + Border.all(
                            width: 6,
                            color: recipesModel.color == "blue" ? Colors.blue : Theme.of(context).canvasColor,
                          )
                      ),
                    ),
                    onTap: (){
                      recipesModel.recipeBeingEdited.color = "blue";
                      recipesModel.setRecipeColor("blue");
                    },
                  ),
                  Spacer(),
                  GestureDetector(
                    child: Container(
                      decoration: ShapeDecoration(
                          shape: Border.all(
                            color: Colors.yellow,
                            width: 18,
                          ) + Border.all(
                            width: 6,
                            color: recipesModel.color == "yellow" ? Colors.yellow : Theme.of(context).canvasColor,
                          )
                      ),
                    ),
                    onTap: (){
                      recipesModel.recipeBeingEdited.color = "yellow";
                      recipesModel.setRecipeColor("yellow");
                    },
                  ),
                  Spacer(),
                  GestureDetector(
                    child: Container(
                      decoration: ShapeDecoration(
                          shape: Border.all(
                            color: Colors.grey,
                            width: 18,
                          ) + Border.all(
                            width: 6,
                            color: recipesModel.color == "grey" ? Colors.grey : Theme.of(context).canvasColor,
                          )
                      ),
                    ),
                    onTap: (){
                      recipesModel.recipeBeingEdited.color = "grey";
                      recipesModel.setRecipeColor("grey");
                    },
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

  void _save(BuildContext context) async {

    if(!_formKey.currentState.validate()){
      return;
    }

    //_formKey.currentState.save();

    if(recipesModel.recipeBeingEdited.id==null){
      await RecipesDBworker.recipesDBworker.create(recipesModel.recipeBeingEdited);
    } else {
      await RecipesDBworker.recipesDBworker.update(recipesModel.recipeBeingEdited);
    }

    recipesModel.loadData(RecipesDBworker.recipesDBworker);
    
    recipesModel.setStackIndex(0);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        content: Text("recipe saved"),
      ),
    );

  }

}