import 'package:flutter/material.dart';
import 'package:orbit/screens/auth/forgot_password.dart';
import 'package:orbit/screens/auth/login.dart';
import 'package:orbit/screens/auth/signup.dart';
import 'constants/app_theme.dart';
import 'screens/home/introscreen.dart'; // change to any screen you want

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

      home: const Signup(), //  change screen here
    );
  }
}