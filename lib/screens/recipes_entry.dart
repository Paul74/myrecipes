import 'dart:ui';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:myrecipes_app/db/recipes_db_worker.dart';
import 'package:myrecipes_app/models/recipes_model.dart';
import 'package:myrecipes_app/models/categories_model.dart';
import 'package:flutter/services.dart'; //for TextInputFormatter
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../common/utils.dart' as utils;

File? _selectedImage;
//bool _inProcess = false; //for image picker
File? imgToDelete; //path of image to be deleted
bool _formChanged = false;


class RecipeLoad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: recipesModel,
      child: Consumer<RecipesModel>(
        builder: (context, recipesModel, child) {
          return RecipesEntry();
        },
      ),
    );
  }
}


class RecipesEntry extends StatelessWidget{

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(onWillPop:() {_save(context); return Future.value(false);},
      child: DefaultTabController(length: 3, child:
        Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: recipesModel.recipeBeingEdited.id==null ? Text("add recipe", style: TextStyle(fontSize: 20, height: 1.2)) : Text(recipesModel.recipeBeingEdited.title, style: TextStyle(fontSize: 20, height: 1.2)),//toolbarHeight : 48.0, //con 48 nascondo la appbar perchè ho già la app bar dalla home page
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                //Navigator.pop(context, '/list');
                //_selectedImage = null;
                //recipesModel.selections = [false,false,false];
                _save(context);
              },
            ),
            bottom: TabBar(
              labelPadding: EdgeInsets.symmetric(horizontal: 0.0),
              labelStyle: TextStyle(color: theme.primaryColorLight, fontFamily: 'Georgia', fontWeight: FontWeight.w700, letterSpacing: 0.3),
              tabs: [
                Tab(text: "DESCRIPTION"),
                Tab(text: "INGREDIENTS"),
                Tab(text: "PREPARATION"),
              ],
            ),
          ),
/*          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Row(
              children: <Widget>[
                FlatButton(
                    onPressed: (){
                      //recipesModel.setStackIndex(0);
                      Navigator.pop(context, '/list');
                      _selectedImage = null;
                      recipesModel.selections = [false,false,false];
                    },
                    child: Text("CANCEL"),
                ),
                Spacer(),
                FlatButton(
                    onPressed: (){
                      _save(context);
                    },
                    child: Text("SAVE"),
                ),
              ],
            )
          ),*/

          body: TabBarView(children: <Widget>[

            utils.KeepAliveWrapper(
              child: Form(key: _formKey1, onChanged: (){_formChanged = true;},
                child: ListView(children: [
                  ListTile(
                    trailing: GestureDetector(child: FavIcon(),
                      onTap: () {
                        _formChanged = true;
                        recipesModel.recipeBeingEdited.fav == 1 ? recipesModel.recipeBeingEdited.fav = 0 : recipesModel.recipeBeingEdited.fav = 1;
                        recipesModel.setFav();
                      }
                    ), //(Icons.favorite, color: Colors.red, size: 30),
                    title: TextFormField(maxLines: null,
                      decoration: InputDecoration(labelText: "title:", floatingLabelBehavior: FloatingLabelBehavior.always), //alignLabelWithHint: true,
                      initialValue: recipesModel.recipeBeingEdited.title,
                      //I prefer to skip this validation and allow for blank title recipe
                      /*validator: (String inValue){
                        if(inValue.length==0){
                          return "Please enter a title";
                        }
                        return null;
                      },*/
                      onChanged: (String inValue){
                        recipesModel.recipeBeingEdited.title = inValue;
                      },
                      onEditingComplete: (){recipesModel.setAppbarTitle();},
                    ),
                  ),

                  Container(padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                      child: Row(mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Column(children: <Widget>[
                            MaterialButton(child: Icon(Icons.camera_alt_rounded, size: 54),
                                minWidth: 12,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                elevation: 4,
                                highlightElevation: 0,
                                padding: EdgeInsets.fromLTRB(6, 5, 6, 0),
                                color: theme.accentColor,
                                onPressed: (){
                                  showDialog(context: context,
                                      builder: (inAlertContext) => AlertDialog(titlePadding: EdgeInsets.fromLTRB(24, 24, 0, 16),
                                        title: Text("recipe picture"),
                                        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            InkWell(child: Text("take a photo"), onTap: (){getImage(ImageSource.camera);Navigator.pop(inAlertContext);},),
                                            SizedBox(height: 22),
                                            InkWell(child: Text("load from gallery"), onTap: (){getImage(ImageSource.gallery);Navigator.pop(inAlertContext);},),
                                          ]
                                        ),
                                        actions: [TextButton(onPressed: (){Navigator.pop(inAlertContext);}, child: Text("CANCEL"))],
                                      ),
                                    );
                                  }
                                )
                          ],
                          ),
                          SizedBox(width: 12),
                          Stack(
                            children: <Widget>[
                              getImageWidget(),
                              if (recipesModel.recipeBeingEdited.image != "" || _selectedImage != null)
                              Positioned.fill(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(context: context,
                                          builder: (BuildContext inAlertContext) => AlertDialog(
                                            content: Container(
                                                child:
                                                  GestureDetector(child:
                                                    //Text("la mia immagine full"),
                                                    getImageFullWidget(),
                                                    onTap: (){Navigator.pop(inAlertContext);},
                                                  ),

                                            ),
                                            //actions: [TextButton(onPressed: (){Navigator.pop(context);}, child: Text("back"))],
                                          ),
                                        );
                                      },
                                      onLongPress: (){
                                        showDialog(context: context,
                                          builder: (BuildContext inAlertContext) => AlertDialog(
                                            //title: Text("delete picture"),
                                            content: //Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.end,
                                                //children: [
                                                  Text("Delete this picture?", textAlign: TextAlign.center),
                                                //]
                                            //),
                                            actions: [
                                              TextButton(onPressed: (){deleteImage(); Navigator.pop(inAlertContext);}, child: Text("YES, DELETE")),
                                              TextButton(onPressed: (){Navigator.pop(inAlertContext);}, child: Text("NO"))
                                            ],
                                          ),
                                        );
                                      }
                                    ),
                                  ),)
                            ]
                          ),


                        ]
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
                         value: recipesModel.recipeBeingEdited.idCat == null ? null : recipesModel.recipeBeingEdited.idCat,
                         items: [
                           for (Category categ in categoriesModel.categoryList)
                             if (categ.id != 0) DropdownMenuItem(child: Text(categ.category), value: categ.id)
                         ],
                         onChanged: (dynamic value) {
                            recipesModel.recipeBeingEdited.idCat = value;
                            recipesModel.setCategory();
                            _formChanged = true;
                         },
                       ),
                     ),
                   ),

                   ),



                  Container(padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: ToggleButtons(
                            fillColor: theme.primaryColorLight,
                            selectedColor: Colors.black,
                            color: Colors.black87,
                            selectedBorderColor: theme.accentColor,
                            borderColor: Colors.black38,
                            children: <Widget>[
                              Container(padding: EdgeInsets.all(16), child: Text('easy')),
                              Container(padding: EdgeInsets.all(8), child: Text('medium')),
                              Container(padding: EdgeInsets.all(16), child: Text('hard')),
                            ],
                            borderRadius: BorderRadius.circular(6),
                            onPressed: (int index) {
                              _formChanged = true;
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
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],
                            initialValue: (recipesModel.recipeBeingEdited.minutes ?? "").toString(),
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
                      decoration: InputDecoration(
                          labelText: "notes:",
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.primaryColorDark, width: 2)),
                          floatingLabelBehavior: FloatingLabelBehavior.always
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                      initialValue: recipesModel.recipeBeingEdited.notes,
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
            ),

            utils.KeepAliveWrapper(
              child: Form(key: _formKey2, onChanged: (){_formChanged = true;},
                child: ListView(children: [
                  Container(padding: EdgeInsets.fromLTRB(0, 0, 250, 10),
                    child: ListTile(
                      title: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(labelText: "servings for:", floatingLabelBehavior: FloatingLabelBehavior.always),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        initialValue: (recipesModel.recipeBeingEdited.persons ?? "").toString(),
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
                      decoration: InputDecoration(
                          labelText: "ingredients:",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.primaryColorDark, width: 2))
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 15,
                      initialValue: recipesModel.recipeBeingEdited.ingredients,
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
            ),

            utils.KeepAliveWrapper(
              child: Form(key: _formKey3, onChanged: (){_formChanged = true;},
                  child: ListView(children: [
                    ListTile(contentPadding: EdgeInsets.fromLTRB(16, 18, 16, 0),
                      title: TextFormField(
                        decoration: InputDecoration(
                            labelText: "preparation:",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.primaryColorDark, width: 2))
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 18,
                        initialValue: recipesModel.recipeBeingEdited.preparation,
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
              ),
            )
        ])
      ),),
    );
  }

  void _save(BuildContext context) async {

    if (_formChanged == false) {
      //add recipe but no data inserted,
      //don't need to save, just go back
      Navigator.pop(context, '/list');
    } else {
      if (_formKey1.currentState != null) {
        if (!_formKey1.currentState!.validate()) {
          return;
        }
      }

      if (_formKey2.currentState != null) {
        if (!_formKey2.currentState!.validate()) {
          return;
        }
      }

      if (_formKey3.currentState != null) {
        if (!_formKey3.currentState!.validate()) {
          return;
        }
      }

      //if the user shot or selected a new image, need to copy the file on device and get the path
      if (_selectedImage != null) {
        final String path = utils.docsDir.path;
        final String fileName = basename(_selectedImage!.path);
        final File localImage = await _selectedImage!.copy('$path/$fileName');
        recipesModel.recipeBeingEdited.image = localImage.path;
      }
      //if deleting I need also to delete the image file on the device
      if (imgToDelete != null) {
        //final File localImage = await imgToDelete.delete();
        recipesModel.deleteImgFile(imgToDelete!);
        //print("cancellato imgToDelete $imgToDelete");
        imgToDelete = null;
      }


      if (recipesModel.recipeBeingEdited.id == null) {
        await RecipesDBworker.recipesDBworker.create(
            recipesModel.recipeBeingEdited);
      } else {
        await RecipesDBworker.recipesDBworker.update(
            recipesModel.recipeBeingEdited);
      }

      recipesModel.loadData(RecipesDBworker.recipesDBworker);

      //recipesModel.setStackIndex(0);
      _selectedImage = null;
      recipesModel.selections = [false, false, false];
      _formChanged = false;
      Navigator.pop(context, '/list');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 1500),
          content: Text("RECIPE SAVED", textAlign: TextAlign.center),
        ),
      );
    }
  }
}

class FavIcon extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    if (recipesModel.recipeBeingEdited.fav == 0) {
      return Icon(Icons.favorite_border, color: Colors.grey);
    } else {
      return Icon(Icons.favorite, color: Colors.red);
    }
  }
}


//if deleting I need to delete the file. see above.
deleteImage() {
  _selectedImage = null;
  imgToDelete = File(recipesModel.recipeBeingEdited.image!);
  recipesModel.recipeBeingEdited.image = "";
  recipesModel.setImage();
  _formChanged = true;
}


getImage(ImageSource source) async {
  final _picker = ImagePicker();
  //_inProcess = true;
  //final pickedFile = await (_picker.getImage(source: source) as FutureOr<PickedFile>);
  var pickedFile = await _picker.getImage(source: source);
  final File image = File(pickedFile!.path);
  //if(image != null){
  File? cropped = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(
          ratioX: 1.33, ratioY: 1),
      compressQuality: 100,
      maxWidth: 930,
      maxHeight: 700,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Color(0xFF795548),
        toolbarWidgetColor: Colors.white,
        toolbarTitle: "",
        //statusBarColor: Colors.deepOrange.shade900,
        activeControlsWidgetColor: Color(0xFF5D4037),
        backgroundColor: Colors.white,
      )
  );

    if (cropped != null) { _formChanged = true; _selectedImage = cropped;}
    //_inProcess = false;

  //} else {
  //  _inProcess = false;
  //}
  recipesModel.setImage();
}


Widget getImageWidget() {
  //print(recipesModel.recipeBeingEdited.image);
  if(recipesModel.recipeBeingEdited.id==null)

  { //if new recipe
    if (_selectedImage != null) {
      return Image.file(
        _selectedImage!,
        width: 72,
        height: 54,
        fit: BoxFit.cover,
      );
    } else {
      return SizedBox(); /*Image.asset(
        "assets/images/dish-placeholder.png",
        width: 72,
        height: 54,
        fit: BoxFit.cover,
      );*/
    }
  } else

  { //if editing recipe
    if (recipesModel.recipeBeingEdited.image != "") { //if image exists on database
      //load image from database
      if (_selectedImage != null) {
        return Image.file(
          _selectedImage!,
          width: 72,
          height: 54,
          fit: BoxFit.cover,
        );
      } else {
        return Image.file(
          File(recipesModel.recipeBeingEdited.image!),
          width: 72,
          height: 54,
          fit: BoxFit.cover,
        );
      }

    } else { //if no image on database
      //print("editing and NO image on db");
      if (_selectedImage != null) {
        return Image.file(
          _selectedImage!,
          width: 72,
          height: 54,
          fit: BoxFit.cover,
        );
      } else {
        return SizedBox(); /*Image.asset(
          "assets/images/dish-placeholder.png",
          width: 72,
          height: 54,
          fit: BoxFit.cover,
        );*/
      }
    }
  }
}

Widget getImageFullWidget() {
  if (_selectedImage != null) {
    return Image.file(
      _selectedImage!,
      width: 373,
      height: 280,
      //fit: BoxFit.cover,
    );
  } else {
    return Image.file(
      File(recipesModel.recipeBeingEdited.image!),
      width: 373,
      height: 280,
      //fit: BoxFit.cover,
    );
  }
}