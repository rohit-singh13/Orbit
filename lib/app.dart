import 'package:flutter/material.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/services/app_lifecycle_services.dart';
import 'constants/app_theme.dart';
import 'screens/home/splash_screen.dart';

class MyApp extends StatelessWidget{

  const MyApp ({
    super.key,
  });

  @override
  Widget build(BuildContext context){
    return AppLifecycleServices(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Orbit",
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.generateRoute,
        home: const SplashScreen(),
      ),
    );
  }
}