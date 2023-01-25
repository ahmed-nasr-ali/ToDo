// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:flutter_to_do_app/Services/Themes_services.dart';

import 'package:flutter_to_do_app/UI/Home_page.dart';
import 'package:flutter_to_do_app/UI/Theme.dart';

import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';

import 'db/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DBHelper.initDB(); //do (Database عشان ينشأ)
  await GetStorage.init(); //do (GetStorageعشان استخدمت ال)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Themes.ligth,
      darkTheme: Themes.dark,
      themeMode:
          ThemesServices().theme, //do (ThemesServices الي جواthemeهنا هنعمل ال)
      /* ThemeMode
          .dark, //do ( ThemeMode.dark عشان انت مخليdarkThemeهينادي علي )*/

      home: Homepage(),
    );
  }
}
