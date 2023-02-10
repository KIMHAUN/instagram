import 'package:flutter/material.dart';

var _var1; //다른 파일에서 쓸 수 없는 변수

var theme = ThemeData(
  iconTheme: IconThemeData( color: Colors.blue ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: Colors.blueAccent,
    )
  ),

  appBarTheme: AppBarTheme(
    color: Colors.white,
    elevation: 1, //그림자 크기
    actionsIconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
  ),
  textTheme: TextTheme(
      bodyText2: TextStyle(color: Colors.red)
  ),
);