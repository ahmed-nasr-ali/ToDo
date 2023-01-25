// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemesServices {
  //do (dark and ligth mode دي كلها مسؤله عن class)
//do (myApp statlesswidget and  _appBar function تفعيله في ال )
  final _box = GetStorage();
  final key = 'isDarkMode';

  bool _loadingThemeFromBox() =>
      _box.read(key) ??
      false; //do ( ture or false  اول مره هو فاضي لان مافهوش false فاضي خليه ب keyلو ال )

  ThemeMode get theme => _loadingThemeFromBox()
      ? ThemeMode.dark
      : ThemeMode
          .light; //do ( بتاعي defeault هو ThemeMode.lightف هيبقا false اول مره هي ب_loadingThemeFromBoxهنا)

  saveThemetoBox(bool isDarkMode) => _box.write(key,
      isDarkMode); //do (theme from ligth to dark and from dark to ligth عشان لما اضغط علي الزرار يغير )

  void switchTheme() {
    Get.changeThemeMode(
        _loadingThemeFromBox() //do ( false اول مره هي ب _loadingThemeFromBox)
            ? ThemeMode.light
            : ThemeMode
                .dark); // do  ( ThemeMode.dark هنعمل false لو بتساوي ThemeMode.light هنعملtrue بتساوي _loadingThemeFromBoxهنا هنستخدم الداله دي لما اجي اضغط علي الزرار هنسال لو)
    //her ( themedark mode فلما هضغط علي الزار هيعمل false  بتساوي _loadingThemeFromBox)
    saveThemetoBox(
        !_loadingThemeFromBox()); //do the same comment in  saveThemetoBox
  }
}

//do (text الجزء جاخاص ب ال)
TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.grey[400] : Colors.grey,
  ));
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Get.isDarkMode ? Colors.white : Colors.black,
  ));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600],
  ));
}
