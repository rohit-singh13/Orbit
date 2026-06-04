import 'package:flutter/material.dart';
import 'package:orbit/routes/app_routes.dart';
import 'constants/app_theme.dart';
import 'screens/home/splash_screen.dart';

class MyApp extends StatelessWidget{

  const MyApp ({
    super.key,
  });

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Orbit",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routes: AppRoutes.routes,
      home: const SplashScreen(),
    );
  }
}