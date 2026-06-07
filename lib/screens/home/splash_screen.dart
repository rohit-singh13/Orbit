import 'package:flutter/material.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/services/auth_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthServices _auth = AuthServices();

  Future<void> checkUser() async {
    await Future.delayed(const Duration(seconds: 1));
    await _auth.currentUser?.reload();

    if (!mounted) return;

    if (_auth.isLoggedIn && _auth.isEmailVerified) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.intro,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/background/background_image.png",
            fit: BoxFit.cover,),
          ),
          Center(
            child: SizedBox(
              height: 500,
              width: 500,
              child: Image.asset("assets/logo/logo.png")
            ),
          )
        ],
      ),

    );
  }
}
