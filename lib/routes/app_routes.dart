import 'package:flutter/material.dart';
import 'package:orbit/screens/auth/profile_setup.dart';
import 'package:orbit/screens/chat/chat_list_screen.dart';
import 'package:orbit/screens/chat/personal_chat_screen.dart';
import 'package:orbit/screens/friends/friend_request_screen.dart';
import 'package:orbit/screens/friends/friends_screen.dart';
import 'package:orbit/screens/home/home_screen.dart';
import 'package:orbit/screens/home/intro_screen.dart';
import 'package:orbit/screens/auth/login.dart';
import 'package:orbit/screens/auth/signup.dart';
import 'package:orbit/screens/auth/email_verification.dart';
import 'package:orbit/screens/auth/forgot_password.dart';
import 'package:orbit/screens/profile/edit_profile.dart';
import 'package:orbit/screens/profile/profile_screen.dart';
import 'package:orbit/screens/profile/user_profile_screen.dart';
import 'package:orbit/screens/search/explore.dart';
import 'package:orbit/screens/search/search_screen.dart';
import 'package:orbit/screens/settings/privacy.dart';
import 'package:orbit/screens/settings/settings.dart';
import 'package:orbit/screens/social/signal.dart';
import 'package:path/path.dart';

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
  static const explore = "/explore-screen"; // as exploration
  static const editProfile = "/edit-profile-screen";
  static const settings = "/settings";
  static const privacy = "/privacy";
  static const friendRequest = "/friend-request-screen";
  static const friendsList = "/friends-List-screen";
  static const search = "/search";
  static const userProfile = "/user-Profile";
  static const personalChat = "/personal-chat";

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
    editProfile: (context) => const EditProfile(),
    settings: (context) => const Settings(),
    privacy: (context) => const Privacy(),
    friendRequest: (context) => const FriendRequestScreen(),
    friendsList: (context) => const FriendsScreen(),
    search: (context) => const SearchScreen(),
    userProfile: (context) => const UserProfileScreen(),
    personalChat: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return PersonalChatScreen(receiverId: args['receiverId'], receiverName: args['receiverName'], receiverImageUrl: args['receiverImageUrl'],);
    },

  };
}