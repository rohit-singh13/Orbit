import 'package:flutter/material.dart';

class AppTheme {
  static const LinearGradient lightGradient =
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xffF8FBFF),
      Color(0xffEEF6FF),
      Color(0xffE4F1FF),
    ],);

  static const LinearGradient darkGradient =
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff050816),
      Color(0xff0D1226),
      Color(0xff1A1F3A),
    ],);

  static LinearGradient backgroundGradient(BuildContext context)
  {
    return Theme.of(context).brightness == Brightness.dark? darkGradient : lightGradient;
  }

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xffFFFFFF ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xffB87333),
      secondary: Color(0xffD8A47F),
      surface: Color(0xffFFF8F3),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffB87333),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),

  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xff050816),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xffD4A44B),
        secondary: Color(0xffF0C36A),
        tertiary: Color(0xffFFE7A3),
        surface: Color(0xff0D1226),
      ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xffD4A44B),
        foregroundColor: Colors.white,
        elevation: 8
      )
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),

    cardTheme: CardThemeData(
      color: const Color(0xff151B34),
      elevation: 6
    )
  );
}