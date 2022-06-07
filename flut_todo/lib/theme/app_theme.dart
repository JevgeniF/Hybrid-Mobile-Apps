import 'package:flut_todo/theme/app_constants.dart';
import 'package:flutter/material.dart';

class AppTheme {
  get darkTheme => ThemeData(
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: cDarkPrimaryColor,
            primaryColorDark: cDarkPrimaryColorDark,
            accentColor: cDarkAccentColor,
            cardColor: cDarkCardColor,
            backgroundColor: cDarkBackgroundColor,
            errorColor: cDarkBackgroundColor,
            brightness: Brightness.dark),
        iconTheme: const IconThemeData(color: Colors.white),
      );

  get lightTheme => ThemeData(
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
            primaryColorDark: Colors.blue.shade900,
            accentColor: Colors.blueAccent,
            cardColor: Colors.grey.shade300,
            backgroundColor: Colors.white,
            errorColor: Colors.pink.shade900,
            brightness: Brightness.light),
        iconTheme: const IconThemeData(color: Colors.black),
      );
}
