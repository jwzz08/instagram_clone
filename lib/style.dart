import 'package:flutter/material.dart';

var _var1;

var theme = ThemeData(
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: Colors.grey
    )
  ),
  appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 1,
      titleTextStyle: TextStyle(fontSize: 25),
      actionsIconTheme: IconThemeData(color : Colors.grey[900],
          size: 30),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.black
  ),
  textTheme: TextTheme(
    bodyText2: TextStyle(color: Colors.red),
    bodyText1: TextStyle(color: Colors.blue),
  )
);