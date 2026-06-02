import 'package:flutter/material.dart';
import 'package:orbit/screens/home/introscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Introscreen()));
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(isDark? "assets/background/dark_theme.png" : "assets/background/light_theme.png",
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
