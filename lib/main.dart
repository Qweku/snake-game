// ignore_for_file: prefer_const_constructors

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:snake/launcher.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'themes_setup.dart';


Future<void> main() async{
  await ThemeManager.initialise();
  //AssetsAudioPlayer.
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
   
   

    

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

