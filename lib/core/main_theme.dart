import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wings/core/main_config.dart';
import 'package:wings/core/main_function.dart';

mixin MainTheme {
  ThemeData lightTheme = ThemeData(
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.white,
    cardColor: Colors.white,
    dividerColor: Colors.black,
    shadowColor: Colors.grey,
    hintColor: Colors.grey,
    focusColor: Colors.black,
    highlightColor: Colors.black,
    splashColor: Colors.grey,
    disabledColor: Colors.grey,
  );

  ThemeData darkTheme = ThemeData(
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.grey[900],
    canvasColor: Colors.grey[800],
    cardColor: Colors.grey[800],
    dividerColor: Colors.white,
    shadowColor: Colors.grey,
    hintColor: Colors.grey,
    focusColor: Colors.white,
    highlightColor: Colors.white,
    splashColor: Colors.grey,
    disabledColor: Colors.grey,
  );

  Future<void> onThemeInit(BuildContext context) async {
    bool? theme = f.boxRead(key: MainConfig.boolTheme, dv: null);

    if (theme == null) {
      Brightness brightness = Theme.of(context).brightness;
      await f.boxWrite(key: MainConfig.boolTheme, value: brightness == Brightness.light);
    }
  }

  Future<void> onChangeTheme() async {
    bool theme = f.boxRead(key: MainConfig.boolTheme);
    Get.changeThemeMode(!theme ? ThemeMode.light : ThemeMode.dark);
    await f.boxWrite(key: MainConfig.boolTheme, value: !theme);
  }
}
