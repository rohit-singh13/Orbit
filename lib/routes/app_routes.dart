import 'package:flutter/material.dart';
import 'package:orbit/screens/home/home.dart';
import 'package:orbit/screens/home/intro_screen.dart';
import '../screens/auth/login.dart';
import '../screens/auth/signup.dart';
import '../screens/auth/email_verification.dart';
import '../screens/auth/forgot_password.dart';

class AppRoutes {
  static const intro = "/intro";
  static const login = "/login";
  static const signup = "/signup";
  static const forgotPassword = "/forgot-password";
  static const emailVerification = "/email-verification";
  static const home = "/home";

  static Map<String, WidgetBuilder>
  routes = {
    intro: (context) => const IntroScreen(),
    login: (context) => const Login(),
    signup: (context) => const Signup(),
    forgotPassword: (context) => const ForgotPassword(),
    emailVerification: (context) => const EmailVerification(),
    home: (context) => const HomeScreen()
  };
}