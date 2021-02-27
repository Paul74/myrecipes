import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myrecipes_app/screens/recipes_entry.dart';
import 'package:myrecipes_app/screens/recipes_list.dart';
import 'package:path_provider/path_provider.dart';
import 'common/utils.dart' as utils;
import 'screens/recipes.dart';
import 'package:myrecipes_app/models/recipes_model.dart';
import 'package:provider/provider.dart';


//preferisco gestire le pagine con il semplice navigator, così ho animazioni automatiche e appbar più facili da fare per ogni pagina.
// vedi https://github.com/flutter/samples/tree/master/provider_shopper
class Notebook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      }),
        primaryColorDark: Color(0xFF5D4037),
        primaryColor: Color(0xFF795548),
        primaryColorLight: Color(0xFFD7CCC8),
        accentColor: Color(0xFFFF9800),
        dividerColor: Color(0xFFBDBDBD),
        //primaryTextTheme: Typography.material2018().white,
        //textTheme: Typography.material2018().white,
        //TODO da mettere i colori testo che sono in formato diverso
        // Define the default font family.
        //fontFamily: 'Georgia',
        //canvasColor: Colors.white,
        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          //headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          //headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          //bodyText2: TextStyle(fontSize: 14.0),
          //bodyText1: TextStyle(fontSize: 22.0),
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
              /*.text-primary-color    { color: #FFFFFF; }
              .primary-text-color    { color: #212121; }
              .secondary-text-color  { color: #757575; }*/

      ),

/*  ORIGINALE FUNZIONANTE
      home: Scaffold(
        appBar: AppBar(
          title: Text("myrecipes"),
        ),
        body: Recipes(),
      ),
*/

      // PROVO CON LE ROUTES
      initialRoute: '/list',
      routes: {
        // '/': (context) => MyLogin(),
        '/list': (context) => Recipes(),
        '/entry': (context) => RecipeLoad(),
      },
      //


    );
  }
}




//segue come avevo fatto io, soprattutto per mettere il + nella appbar. ma è troppo complicato e ci sono cose inutili.
/*
class Notebook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: recipesModel,
        child:
      MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("myapp"),
          actions: <Widget>[
            //if (recipesModel.stackIndex==0) //da implementare il funzionamento, non si aggiorna la appbar

            Consumer<RecipesModel>(
              builder:(context,recipesModel,child) {return
                IndexedStack(index: recipesModel.stackIndex,children:[
                 IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    print("add recipe");
                    recipesModel.recipeBeingEdited = Recipe();
                    recipesModel.setStackIndex(1);
                  },
                 ),
                 Container() //blanck container because I don't need buttons on recipe edit/new
                ]);
              },
            ),

          ],
        ),
        body: Recipes(),
      ),
    ),);
  }
}*/
