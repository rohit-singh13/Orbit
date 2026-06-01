import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context){
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(isDark? "assets/background/dark_theme.png" : "assets/background/light_theme.png", fit: BoxFit.cover,),
          ),
          Center(
              child: SizedBox(
                height: 200,
                  width: 200,
                  child: Image.asset("assets/logo/logo.png"),
              ),
          ),
        ],
      ),
    );
  }
}