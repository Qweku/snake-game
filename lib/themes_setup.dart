// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

List<ThemeData> getThemes() {
  return [
  //Regular-Theme
    ThemeData(
        primaryColor: Colors.black,
        primaryColorLight: Color(0xFFFFFFFF),
        primaryColorDark: Color(0xFF263238),
        cardColor: Colors.red,
        textTheme: TextTheme(
            headline1: TextStyle(
                color: Colors.black, fontSize: 40, fontFamily: 'PipeDream'),
            headline2: TextStyle(
                color: Colors.white, fontSize: 40, fontFamily: 'PipeDream'),
            headline3: TextStyle(
                color: Colors.black, fontSize: 20, fontFamily: 'PipeDream'),
            headline4: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'PipeDream'),
            bodyText1: TextStyle(
                color: Colors.black, fontSize: 14, fontFamily: 'PipeDream'),
            bodyText2: TextStyle(
                color: Colors.white, fontSize: 14, fontFamily: 'PipeDream'),
            button: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'PipeDream')),
        iconTheme: IconThemeData(color: Color(0xFFFF9800))),
   
    ThemeData(
        primaryColor: Color(0xFFFFF176),
        primaryColorLight: Colors.black,
        primaryColorDark: Colors.yellow,
        cardColor: Colors.orange,
        textTheme: TextTheme(
            headline1: TextStyle(
                color: Colors.black, fontSize: 42, fontFamily: 'PipeDream'),
            headline2: TextStyle(
                color: Colors.white, fontSize: 42, fontFamily: 'PipeDream'),
            headline3: TextStyle(
                color: Colors.black, fontSize: 20, fontFamily: 'PipeDream'),
            headline4: TextStyle(
                color: Colors.black, fontSize: 20, fontFamily: 'PipeDream'),
            bodyText1: TextStyle(
                color: Colors.black, fontSize: 14, fontFamily: 'PipeDream'),
            bodyText2: TextStyle(
                color: Colors.black, fontSize: 14, fontFamily: 'PipeDream'),
            button: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'PipeDream')),
        iconTheme: IconThemeData(color: Color(0xFF212121))
        ),
   
    ThemeData(
        primaryColor: Color(0xFF64B5F6),
        primaryColorLight: Color(0xFF1B5E20),
        primaryColorDark: Colors.blue,
        cardColor: Colors.yellow,
        textTheme: TextTheme(
            headline1: TextStyle(
                color: Colors.black, fontSize: 42, fontFamily: 'PipeDream'),
            headline2: TextStyle(
                color: Colors.white, fontSize: 42, fontFamily: 'PipeDream'),
            headline3: TextStyle(
                color: Colors.black, fontSize: 20, fontFamily: 'PipeDream'),
            headline4: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'PipeDream'),
            bodyText1: TextStyle(
                color: Colors.black, fontSize: 14, fontFamily: 'PipeDream'),
            bodyText2: TextStyle(
                color: Colors.white, fontSize: 14, fontFamily: 'PipeDream'),
            button: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'PipeDream')),
        iconTheme: IconThemeData(color: Color(0xFF212121))
        ),
  
   ];
}
