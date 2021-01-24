import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:myrecipes_app/db/recipes_db_worker.dart';
import 'package:myrecipes_app/models/recipes_model.dart';
import '../common/utils.dart' as utils;

class RecipesEntry extends StatelessWidget{

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3, child:
      Scaffold(
        appBar: AppBar(toolbarHeight : 48.0,
          bottom: TabBar(
            labelPadding: EdgeInsets.symmetric(horizontal: 0.0),
            tabs: [
              Tab(text: "DESCRIPTION"),
              Tab(text: "INGREDIENTS"),
              Tab(text: "PREPARATION"),
            ],
          ),
        ),
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

        body: TabBarView(children: [

          Form(key: _formKey1,
          child: ListView(children: [
              ListTile(
                leading: Icon(Icons.title),
                title: TextFormField(
                  decoration: InputDecoration(hintText: "title"),
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
                  decoration: InputDecoration(hintText: "notes"),
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  initialValue: recipesModel.recipeBeingEdited == null ? null : recipesModel.recipeBeingEdited.notes,
                  /*validator: (String inValue){
                    if(inValue.length==0){
                      return "Please enter notes";
                    }
                    return null;
                  },*/
                  onChanged: (String inValue){
                    recipesModel.recipeBeingEdited.notes = inValue;
                  },
                ),
              ),

              ListTile(
                leading: Icon(Icons.access_time),
                title: TextFormField(
                  decoration: InputDecoration(hintText: "total time needed"),
                  keyboardType: TextInputType.number,
                  initialValue: recipesModel.recipeBeingEdited == null ? null : (recipesModel.recipeBeingEdited.minutes ?? "").toString(),
                  validator: (String inValue){
                    if(!utils.isNumeric(inValue)){
                      return "Please enter only a number";
                    }
                    return null;
                  },
                  onChanged: (String inValue){
                    recipesModel.recipeBeingEdited.minutes = int.parse(inValue);
                  },
                ),
              )




          ],
          ),
          ),

          Form(key: _formKey2, child:Container()), //TODO

          Form(key: _formKey3, child:Container()) //TODO
      ])
    ),);
  }

  void _save(BuildContext context) async {

    if(!_formKey1.currentState.validate()){
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