import 'package:flutter/material.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const Color primaryClr = bluishClr;
const Color darkGreyCLr = Color(0xFF121212);
Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final ligth = ThemeData(
    backgroundColor: Colors.white,
    primaryColor: primaryClr, //do (app barالون الخاص  ب )
    brightness: Brightness.light, //do (لون الشاشه )
  );

  static final dark = ThemeData(
    backgroundColor: darkGreyCLr,
    primaryColor: darkGreyCLr,
    brightness: Brightness.dark,
  );
}
