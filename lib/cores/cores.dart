import 'package:flutter/material.dart';

class MyColors {
  static const MaterialColor primary = MaterialColor(_primaryValue, <int, Color>{
    50: Color(0xFFE3F2FD),
    100: Color(0xFFBBDEFB),
    200: Color(0xFF90CAF9),
    300: Color(0xFF64B5F6),
    400: Color(0xFF42A5F5),
    500: Color(_primaryValue),
    600: Color(0xFF1E88E5),
    700: Color(0xFF1976D2),
    800: Color(0xFF1565C0),
    900: Color(0xFF0D47A1),
  });
  static const int _primaryValue = 0xFF2196F3;

  static const MaterialColor accent =
      MaterialColor(_accentValue, <int, Color>{
    100: Color(0xFFE1F5FE),
    200: Color(_accentValue),
    400: Color(0xFF29B6F6),
    700: Color(0xFF0288D1),
  });
  static const int _accentValue = 0xFF81D4FA;

  static const MaterialColor green = MaterialColor(_greenValue, <int, Color>{
    50: Color(0xFFE8F5E9),
    100: Color(0xFFC8E6C9),
    200: Color(0xFFA5D6A7),
    300: Color(0xFF81C784),
    400: Color(0xFF66BB6A),
    500: Color(_greenValue),
    600: Color(0xFF43A047),
    700: Color(0xFF388E3C),
    800: Color(0xFF2E7D32),
    900: Color(0xFF1B5E20),
  });
  static const int _greenValue = 0xFF4CAF50;

  static const MaterialColor gray = MaterialColor(_grayValue, <int, Color>{
    50: Color(0xFFFAFAFA),
    100: Color(0xFFF5F5F5),
    200: Color(0xFFEEEEEE),
    300: Color(0xFFE0E0E0),
    400: Color(0xFFBDBDBD),
    500: Color(_grayValue),
    600: Color(0xFF757575),
    700: Color(0xFF616161),
    800: Color(0xFF424242),
    900: Color(0xFF212121),
  });
  static const int _grayValue = 0xFF9E9E9E;

  static const MaterialColor yellow = MaterialColor(_yellowValue, <int, Color>{
    50: Color(0xFFFFFDE7),
    100: Color(0xFFFFF9C4),
    200: Color(0xFFFFF59D),
    300: Color(0xFFFFF176),
    400: Color(0xFFFFEE58),
    500: Color(_yellowValue),
    600: Color(0xFFFDD835),
    700: Color(0xFFFBC02D),
    800: Color(0xFFF9A825),
    900: Color(0xFFF57F17),
  });
  static const int _yellowValue = 0xFFFFEB3B;

  static const MaterialColor yellowAccent =
      MaterialColor(_yellowAccentValue, <int, Color>{
    100: Color(0xFFFFFF8D),
    200: Color(_yellowAccentValue),
    400: Color(0xFFFFFF00),
    700: Color(0xFFFFEA00),
  });
  static const int _yellowAccentValue = 0xFFFFFF00;
}
