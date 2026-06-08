import 'package:flutter/material.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/screens/home/bottom_navigation.dart';
import 'package:orbit/widgets/background_widget.dart';

class Signal extends StatefulWidget {
  const Signal({super.key});

  @override
  State<Signal> createState() => _SignalState();
}

class _SignalState extends State<Signal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
          child: Center(
              child: Text("Galaxy Signals coming soon")
          )
      ),
      bottomNavigationBar: BottomNavigation(
          currentIndex: 3,
          onTap: (index) {
            if(index == 3) return;
            switch(index) {
              case 0:
                Navigator.pushReplacementNamed(context, AppRoutes.home);
                break;

              case 1:
                Navigator.pushReplacementNamed(context, AppRoutes.chatList);
                break;

              case 2:
                Navigator.pushReplacementNamed(context, AppRoutes.profile);
                break;

              case 3:
                Navigator.pushReplacementNamed(context, AppRoutes.signal);
                break;

              case 4:
                Navigator.pushReplacementNamed(context, AppRoutes.explore);
                break;
            }
          }),
    );
  }
}
