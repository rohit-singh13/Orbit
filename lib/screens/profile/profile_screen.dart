import 'package:flutter/material.dart';
import 'package:orbit/routes/app_routes.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/screens/home/bottom_navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
          child: Center(
            child: Text("Profile screen coming soon"),
          )),
      bottomNavigationBar: BottomNavigation(
          currentIndex: 2,
          onTap: (index) {

            if(index == 2) return;

            switch(index){
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
                break;;
            }
          }
          ),
    );
  }
}
