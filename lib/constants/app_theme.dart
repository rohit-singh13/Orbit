import 'package:flutter/material.dart';

class AppTheme {
  static const LinearGradient lightGradient =
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xffFAF9FF),
      Color(0xffF1ECFF),
      Color(0xffE8E1FF),
    ],);

  static const LinearGradient darkGradient =
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff0B1023),
      Color(0xff161B3A),
      Color(0xff24124D),
    ],);

  static LinearGradient backgroundGradient(BuildContext context)
  {
    return Theme.of(context).brightness == Brightness.dark? darkGradient : lightGradient;
  }

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xffFFFFFF ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xff7B61FF),
      secondary: Color(0xffB26CFE),
        surface: Color(0xffF6F2FF)
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff7B61FF),
          foregroundColor: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    )
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xff0B1023),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xff8B5CF6),
      secondary: Color(0xff06B6D4),
      surface: Color(0xff222C52),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff8B5CF6),
        foregroundColor: Colors.white,
      )
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    )
  );
}