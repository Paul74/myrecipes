/// Flutter code sample for ListTile

// Here is an example of a custom list item that resembles a Youtube related
// video list item created with [Expanded] and [Container] widgets.
//
// ![Custom list item a](https://flutter.github.io/assets-for-api-docs/assets/widgets/custom_list_item_a.png)

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path_provider/path_provider.dart';
import 'common/utils.dart' as utils;
import 'screens/recipes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory docsDir = await getApplicationDocumentsDirectory();
  utils.docsDir = docsDir;
  runApp(MyApp());
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'MyRecipes';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: MyStatelessWidget(),
      ),
    );
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    this.thumbnail,
    this.title,
    this.fav,
    this.difficulty,
    this.time
  });

  final Widget thumbnail;
  final String title;
  final String fav;
  final String difficulty;
  final int time;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),),
      clipBehavior: Clip.hardEdge,
      color: Colors.brown.shade100,
      //padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
      margin: EdgeInsets.all(5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: thumbnail,
          ),
          Expanded(
            flex: 4,
            child: _RecipeDescription(
              title: title,
            ),
          ),
          Expanded(
            flex: 1,
            child: _Details(
              fav: fav,
              difficulty: difficulty,
              time: time,
            ),
          ),
          const Icon(
            Icons.more_vert,
            size: 16.0,
          ),
        ],
      ),
    );
  }
}

class _RecipeDescription extends StatelessWidget {
  const _RecipeDescription({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7.0, 0.0, 0.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({
    Key key,
    this.fav,
    this.difficulty,
    this.time,
  }) : super(key: key);

  final String fav;
  final String difficulty;
  final int time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            fav,
            style: const TextStyle(fontSize: 12.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          Text(
            difficulty,
            style: const TextStyle(fontSize: 12.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          Text(
            '$time\'',
            style: const TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}



/// This is the stateless widget that the main application instantiates.
class MyStatelessWidget extends StatelessWidget {
  MyStatelessWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(4.0),
      itemExtent: 106.0,
      children: <CustomListItem>[
        CustomListItem(
          thumbnail:
          SizedBox.expand(child:
              Image.file(File('storage/emulated/0/Download/catEU.jpg'),
              fit: BoxFit.cover,
          ),),
          title: 'Risotto al gatto con linguine alla pescatora più noci',
          fav: 'fav',
          difficulty: 'hard',
          time: 10,
        ),
        CustomListItem(
          thumbnail:
          SizedBox.expand(child:
              Image.file(File('storage/emulated/0/Download/perfettoVeloce.jpg'),
              fit: BoxFit.cover,
          ),),
          title: 'Pasta alle sarde',
          fav: 'nfav',
          difficulty: 'easy',
          time: 8,
        ),
      ],
    );
  }
}
