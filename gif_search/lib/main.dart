import 'package:flutter/material.dart';
import 'package:gif_search/UI/home_page.dart';
import 'package:gif_search/UI/gif_page.dart';
void main(){
  runApp(MaterialApp(home:HomePage(),theme : ThemeData (
      inputDecorationTheme : InputDecorationTheme (
          enabledBorder : OutlineInputBorder ( borderSide : BorderSide ( color : Colors . white ))
      )
  )));
}