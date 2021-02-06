import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myrecipes_app/db/recipes_db_worker.dart';
import 'package:myrecipes_app/models/recipes_model.dart';
import 'package:flutter/services.dart'; //for TextInputFormatter
import '../common/utils.dart' as utils;

class RecipesEntry extends StatelessWidget{
/*
  //questo codice è se metto Stateful
  @override
  _RecipesEntryState createState() => _RecipesEntryState();
}

class _RecipesEntryState extends State {
*/

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
                    recipesModel.selections = [false,false,false];
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
                trailing: GestureDetector(child: FavIcon(),
                  onTap: () {
                    recipesModel.recipeBeingEdited.fav == 1 ? recipesModel.recipeBeingEdited.fav = 0 : recipesModel.recipeBeingEdited.fav = 1;
                    recipesModel.setFav();
                  }
                ), //(Icons.favorite, color: Colors.red, size: 30),
                title: TextFormField(
                  decoration: InputDecoration(labelText: "title:", floatingLabelBehavior: FloatingLabelBehavior.always), //alignLabelWithHint: true,
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
               title: InputDecorator(decoration: InputDecoration(labelText: "category:", floatingLabelBehavior: FloatingLabelBehavior.always),
                 child: DropdownButtonHideUnderline(
                   child: DropdownButton(
                     isExpanded: true,
                     isDense: true,
                     icon: Icon(Icons.keyboard_arrow_down),
                     //hint: Text("select a category"),
                     value: recipesModel.recipeBeingEdited.idCat == null ? null : recipesModel.recipeBeingEdited.idCat, //per provare
                     items: [
                       DropdownMenuItem(
                         child: Text("First Item"),
                         value: 1,
                       ),
                       DropdownMenuItem(
                         child: Text("Second Item"),
                         value: 2,
                       ),
                       DropdownMenuItem(
                           child: Text("Third Item"),
                           value: 3
                       ),
                       DropdownMenuItem(
                           child: Text("Fourth Item"),
                           value: 4
                       )
                      ],
                       onChanged: (value) {
                            recipesModel.recipeBeingEdited.idCat = value;
                            recipesModel.setFav();
                         },
                     ),
                 ),
               ),

               ),




              Container(padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: ToggleButtons(
                        children: <Widget>[
                          Container(padding: EdgeInsets.all(16), child: Text('easy')),
                          Container(padding: EdgeInsets.all(8), child: Text('medium')),
                          Container(padding: EdgeInsets.all(16), child: Text('hard')),
                        ],
                        borderRadius: BorderRadius.circular(6),
                        onPressed: (int index) {

                          for (int buttonIndex = 0; buttonIndex < recipesModel.selections.length; buttonIndex++) {
                            if (buttonIndex == index) {
                              recipesModel.selections[buttonIndex] = !recipesModel.selections[buttonIndex];
                            } else {
                              recipesModel.selections[buttonIndex] = false;
                            }
                          }
                          recipesModel.setRecipeDifficulty(recipesModel.selections);
                        },
                        isSelected: recipesModel.selections,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "total minutes:", floatingLabelBehavior: FloatingLabelBehavior.always),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        initialValue: recipesModel.recipeBeingEdited == null ? null : (recipesModel.recipeBeingEdited.minutes ?? "").toString(),
                        //validator: (String inValue){return inValue.contains('@') ? 'Do not use the @ char.' : null;},
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
                    ),
                ],
                ),
              ),

              ListTile(
                title: TextFormField(
                  decoration: InputDecoration(labelText: "notes:", enabledBorder: OutlineInputBorder(), focusedBorder: OutlineInputBorder(), floatingLabelBehavior: FloatingLabelBehavior.always),
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  initialValue: recipesModel.recipeBeingEdited == null ? null : recipesModel.recipeBeingEdited.notes,
                  //validator: (String inValue){return inValue.contains('@') ? 'Do not use the @ char.' : null;},
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
              )
            ],

          )
          ),

          Form(key: _formKey2,
            child: ListView(children: [
              Container(padding: EdgeInsets.fromLTRB(0, 0, 220, 0),
                child: ListTile(
                  title: TextFormField(
                    decoration: InputDecoration(labelText: "number of persons:", floatingLabelBehavior: FloatingLabelBehavior.always),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    initialValue: recipesModel.recipeBeingEdited == null ? null : (recipesModel.recipeBeingEdited.persons ?? "").toString(),
                    //validator: (String inValue){return inValue.contains('@') ? 'Do not use the @ char.' : null;},
                    /*validator: (String inValue){
                      if(!utils.isNumeric(inValue)){
                        return "Please enter a number";
                      }
                      return null;
                    },*/
                    onChanged: (String inValue){
                      recipesModel.recipeBeingEdited.persons = int.tryParse(inValue);
                    },
                  ),
                ),
              ),
              ListTile(
                title: TextFormField(
                  decoration: InputDecoration(labelText: "ingredients:", floatingLabelBehavior: FloatingLabelBehavior.always, enabledBorder: OutlineInputBorder(), focusedBorder: OutlineInputBorder()),
                  keyboardType: TextInputType.multiline,
                  maxLines: 15,
                  initialValue: recipesModel.recipeBeingEdited == null ? null : recipesModel.recipeBeingEdited.ingredients,
                  //validator: (String inValue){return inValue.contains('@') ? 'Do not use the @ char.' : null;},
                  /*validator: (String inValue){
                    if(inValue.length==0){
                      return "Please enter ingredients";
                    }
                    return null;
                  },*/
                  onChanged: (String inValue){
                    recipesModel.recipeBeingEdited.ingredients = inValue;
                  },
                ),
              ),

            ]
            )
          ),

          Form(key: _formKey3,
              child: ListView(children: [
                ListTile(contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                  title: TextFormField(
                    decoration: InputDecoration(labelText: "preparation:", floatingLabelBehavior: FloatingLabelBehavior.always, enabledBorder: OutlineInputBorder(), focusedBorder: OutlineInputBorder()),
                    keyboardType: TextInputType.multiline,
                    maxLines: 18,
                    initialValue: recipesModel.recipeBeingEdited == null ? null : recipesModel.recipeBeingEdited.preparation,
                    //validator: (String inValue){return inValue.contains('@') ? 'Do not use the @ char.' : null;},
                    /*validator: (String inValue){
                    if(inValue.length==0){
                      return "Please enter ingredients";
                    }
                    return null;
                  },*/
                    onChanged: (String inValue){
                      recipesModel.recipeBeingEdited.preparation = inValue;
                    },
                  ),
                ),

              ]
              )
          )
      ])
    ),);
  }

  void _save(BuildContext context) async {
  //disabilito la validazione perché il currentState restituisce null se la form relativa non è nella tab visualizzata TODO
    /*
    print(_formKey1.currentState);
    print(_formKey2.currentState);
    print(_formKey3.currentState);
    */

/*    if(!_formKey1.currentState.validate()){
      print('enter 1 correct data');
      return;
    }
    if(!_formKey2.currentState.validate()){
      print('enter 2 correct data');
      return;
    }
    if(!_formKey3.currentState.validate()) {
      print('enter 3 correct data');
      return;
    }*/

/*    if(!_formKey1.currentState.validate() || !_formKey2.currentState.validate() || !_formKey3.currentState.validate()  ){
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

class FavIcon extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    if (recipesModel.recipeBeingEdited.fav == null || recipesModel.recipeBeingEdited.fav == 0) {
      return Icon(Icons.favorite_border, color: Colors.grey);
    } else {
      return Icon(Icons.favorite, color: Colors.red);
    }
  }
}