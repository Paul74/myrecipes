import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:myrecipes_app/db/recipes_db_worker.dart';
import 'package:myrecipes_app/models/recipes_model.dart';
import 'package:flutter/services.dart'; //for TextInputFormatter
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
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  initialValue: recipesModel.recipeBeingEdited == null ? null : (recipesModel.recipeBeingEdited.minutes ?? "").toString(),
                 /* validator: (String inValue){
                    if(!utils.isNumeric(inValue)){
                      return "Please enter only a number";
                    }
                    return null;
                  },*/
                  onChanged: (String inValue){
                    recipesModel.recipeBeingEdited.minutes = int.tryParse(inValue);
                  },
                ),
              )

            ]
          )
          ),

          /*Form(key: _formKey2,
            child: ListView(children: [
              ListTile(
                leading: Icon(Icons.people),
                title: TextFormField(
                  decoration: InputDecoration(hintText: "number of persons"),
                  initialValue: recipesModel.recipeBeingEdited == null ? null : (recipesModel.recipeBeingEdited.persons ?? "").toString(),
                  validator: (String inValue){
                    if(!utils.isNumeric(inValue)){
                      return "Please enter a number";
                    }
                    return null;
                  },
                  onChanged: (String inValue){
                    recipesModel.recipeBeingEdited.persons = int.parse(inValue);
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.content_paste),
                title: TextFormField(
                  decoration: InputDecoration(hintText: "ingredients"),
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  initialValue: recipesModel.recipeBeingEdited == null ? null : recipesModel.recipeBeingEdited.ingredients,
                  *//*validator: (String inValue){
                    if(inValue.length==0){
                      return "Please enter notes";
                    }
                    return null;
                  },*//*
                  onChanged: (String inValue){
                    recipesModel.recipeBeingEdited.ingredients = inValue;
                  },
                ),
              ),

            ]
            )
          ),
*/
          Form(key: _formKey2, child:Container()), //TODO
          Form(key: _formKey3, child:Container()) //TODO
      ])
    ),);
  }

  void _save(BuildContext context) async {

    if(!_formKey1.currentState.validate()){
      return;
    }
/*    if(!_formKey1.currentState.validate() && !_formKey2.currentState.validate() && !_formKey3.currentState.validate()  ){
      return;
    }*/



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