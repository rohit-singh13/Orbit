import 'package:flutter/material.dart';
import 'package:orbit/screens/profile/profile_screen.dart';
import 'constants/app_theme.dart';

void main() {
  runApp(const DevApp());
}

class DevApp extends StatelessWidget {
  const DevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Dev Mode",

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      home: const ProfileScreen(), //  change screen here
    );
  }
}