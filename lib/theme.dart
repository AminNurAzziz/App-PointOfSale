import 'package:flutter/material.dart';

final ThemeData myTheme = ThemeData(
  colorScheme:
      ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 255, 132)),
  useMaterial3: true,
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    headline2: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    headline3: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    headline4: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    headline5: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    headline6: TextStyle(
      color: Colors.white,
    ),
    subtitle1: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
    subtitle2: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
    bodyText1: TextStyle(fontSize: 16),
    bodyText2: TextStyle(fontSize: 14),
    button: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    caption: TextStyle(fontSize: 12),
    overline: TextStyle(fontSize: 10),
  ),
);
