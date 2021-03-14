import 'package:flutter/material.dart';
import 'package:myrecipes_app/screens/recipes_entry.dart';
import 'screens/recipes.dart';


//preferisco gestire le pagine con il semplice navigator, così ho animazioni automatiche e appbar più facili da fare per ogni pagina.
// vedi https://github.com/flutter/samples/tree/master/provider_shopper
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
        primaryColorDark: Color(0xFF5D4037),
        primaryColor: Color(0xFF795548),
        primaryColorLight: Color(0xFFD7CCC8),
        accentColor: Color(0xFFFF9800),
        dividerColor: Color(0xFF8B8B8B),
        //primaryTextTheme: Typography.material2018().white,
        //textTheme: Typography.material2018().white,
        // Define the default font family.
        //fontFamily: 'Georgia',
        //canvasColor: Colors.white,
        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          //headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          //headline2: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          //headline3: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          //headline4: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          //headline5: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 20.0, fontFamily: 'Georgia', fontWeight: FontWeight.bold), //used

          //headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Georgia'), //used
          //bodyText1: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
          //caption: TextStyle(fontSize: 16.0,fontStyle: FontStyle.italic),
          //button: TextStyle(fontSize: 16.0,fontStyle: FontStyle.italic),
          subtitle1: TextStyle(fontSize: 16.0, fontFamily: 'Georgia'), //used
          //subtitle2: TextStyle(fontSize: 16.0,fontStyle: FontStyle.italic),
          //overline:  TextStyle(fontSize: 16.0,fontStyle: FontStyle.italic),

        ),
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            headline6: TextStyle(
              fontFamily: 'Georgia',
              fontWeight: FontWeight.bold,
              fontSize: 26,
              fontStyle: FontStyle.italic
            )
          )
        ),
              /*.text-primary-color    { color: #FFFFFF; }
              .primary-text-color    { color: #212121; }
              .secondary-text-color  { color: #757575; }*/

      ),

/*  WORKING ORIGINAL
      home: Scaffold(
        appBar: AppBar(
          title: Text("myrecipes"),
        ),
        body: Recipes(),
      ),
*/

      //ROUTES
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