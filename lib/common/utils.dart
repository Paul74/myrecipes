
import 'dart:io';
import 'package:flutter/material.dart';

Directory docsDir = Directory('/data/user/0/com.example.myrecipes_app/app_flutter'); //just to avoid null

/*
bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return num.tryParse(s) != null;
}*/

// class for mantaining state between tabs for forms validation in recipes_entry
class KeepAliveWrapper extends StatefulWidget {
  final Widget? child;

  const KeepAliveWrapper({Key? key, this.child}) : super(key: key);

  @override
  __KeepAliveWrapperState createState() => __KeepAliveWrapperState();
}

class __KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child!;
  }

  @override
  bool get wantKeepAlive => true;
}