import 'package:flutter/material.dart';
import 'package:orbit/screens/auth/forgot_password.dart';
import 'package:orbit/screens/auth/login.dart';
import 'package:orbit/screens/auth/profile_setup.dart';
import 'package:orbit/screens/auth/signup.dart';
import 'package:orbit/screens/chat/chat_list_screen.dart';
import 'package:orbit/screens/home/home_screen.dart';
import 'package:orbit/screens/home/splash_screen.dart';
import 'constants/app_theme.dart';
import 'screens/home/intro_screen.dart'; // change to any screen you want

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

      home: const ChatList(), //  change screen here
    );
  }
}