import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF083928);
  static const Color secondaryColor = Color(0xFFE5ECE5);
  static const Color tertiaryColor = Color(0xFFF7FFFA);

  static const Color primaryTextColor = Color(0xFFF7FFFA);
  static const Color secondaryTextColor = Color(0xFF788078);
  static const Color tertiaryTextColor = Color(0xFF083928);

  static const Color starColor = Color(0xFFFFC400);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: tertiaryColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}