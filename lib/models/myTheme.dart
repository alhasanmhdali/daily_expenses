import 'package:flutter/material.dart';

class MyTheme {
  final Color _primarySwatch = Colors.green;
  final Color _accentColor = Colors.orange;
  final Color _buttonTextColor = Colors.white;

  ThemeData getTheme() {
    return ThemeData(
      primarySwatch: _primarySwatch,
      accentColor: _accentColor,
      cardTheme: CardTheme(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
      textTheme: TextTheme(
        title: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _primarySwatch,
        ),
        button: TextStyle(
          color: _buttonTextColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
