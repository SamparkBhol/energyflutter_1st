import 'package:flutter/material.dart';
import 'constants.dart';

ThemeData buildThemeData() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    primaryColor: Constants.primaryColor,
    accentColor: Constants.accentColor,
    scaffoldBackgroundColor: Colors.white,
    buttonTheme: ButtonThemeData(
      buttonColor: Constants.primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.grey[200],
    ),
    textTheme: _buildTextTheme(base.textTheme),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
    headline1: base.headline1?.copyWith(fontWeight: FontWeight.bold),
    bodyText1: base.bodyText1?.copyWith(fontSize: 16.0),
    button: base.button?.copyWith(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );
}

class AppThemes {
  static final ThemeData lightTheme = buildThemeData();
  static final ThemeData darkTheme = buildThemeData().copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.blueGrey,
    accentColor: Colors.tealAccent,
  );
}
