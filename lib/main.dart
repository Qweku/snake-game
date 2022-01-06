// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:snake/launcher.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'themes_setup.dart';


Future<void> main() async{
  await ThemeManager.initialise();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
       themes: getThemes(),
      defaultThemeMode: ThemeMode.system,
      builder: (context, regularTheme, darkTheme, themeMode) {
        return MaterialApp(
          title: 'Snake Game',
          debugShowCheckedModeBanner: false,
         theme: regularTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
          home: Launcher()
        );
      }
    );
  }
}

