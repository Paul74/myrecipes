import 'package:flutter/material.dart';
import 'dart:io';
import 'package:myrecipes_app/app.dart';
import 'common/utils.dart' as utils;
import 'package:path_provider/path_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory docsDir = await getApplicationDocumentsDirectory();
  //var docsDir = new Directory('/data/user/0/com.example.myrecipes_app/app_flutter');
  utils.docsDir = docsDir;
  runApp(App());
}