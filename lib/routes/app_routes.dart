import 'package:flutter/material.dart';
import 'package:orbit/screens/auth/profile_setup.dart';
import 'package:orbit/screens/chat/chat_list_screen.dart';
import 'package:orbit/screens/home/home_screen.dart';
import 'package:orbit/screens/home/intro_screen.dart';
import 'package:orbit/screens/auth/login.dart';
import 'package:orbit/screens/auth/signup.dart';
import 'package:orbit/screens/auth/email_verification.dart';
import 'package:orbit/screens/auth/forgot_password.dart';
import 'package:orbit/screens/profile/edit_profile.dart';
import 'package:orbit/screens/profile/profile_screen.dart';
import 'package:orbit/screens/search/explore.dart';
import 'package:orbit/screens/social/signal.dart';

class AppRoutes {
  static const intro = "/intro";
  static const login = "/login";
  static const signup = "/signup";
  static const forgotPassword = "/forgot-password";
  static const emailVerification = "/email-verification";
  static const home = "/home";
  static const profileSetup = "/profile-setup";
  static const profile = "/profile-screen";
  static const chatList = "/Chat-List-screen";
  static const signal = "/signal-video-screen";  // as reels
  static const moments = "/moments-screen"; // as story
  static const explore = "/explore-screen"; // as search
  static const editProfile = "/edit-profile-screen";

  static Map<String, WidgetBuilder>
  routes = {
    intro: (context) => const IntroScreen(),
    login: (context) => const Login(),
    signup: (context) => const Signup(),
    forgotPassword: (context) => const ForgotPassword(),
    emailVerification: (context) => const EmailVerification(),
    home: (context) => const HomeScreen(),
    profileSetup: (context) => const ProfileSetup(),
    profile: (context) => const ProfileScreen(),
    chatList: (context) => const ChatList(),
    signal: (context) => const Signal(),
    // moments: (context) => const Moments(),
    explore: (context) => const Explore(),
    editProfile: (context) => const EditProfile()
  };
}